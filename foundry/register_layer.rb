#!/usr/bin/env ruby
# Registers the layer introduced by one git commit in foundry/foundry.sqlite3.
#
#   ruby foundry/register_layer.rb [SHA ...]   (default: HEAD; SHAs are registered in the order given)
#
# Reads YAML front matter from every file the commit touches under features/.
# Keys: name (required), parents (names), siblings (names). Names resolve to the
# newest registered layer with that name. A commit with no front matter is skipped.
# Already-registered commits are skipped. Exit 0 = all registered or skipped, 1 = first failure
# (later SHAs are not processed). Prints one result line per commit.
require "yaml"
require "json"
require "open3"
require "sqlite3"

DB_PATH = File.expand_path("foundry.sqlite3", __dir__)
SCHEMA = File.expand_path("schema.sql", __dir__)

def git(*args)
  out, err, st = Open3.capture3("git", *args)
  raise "git #{args.join(' ')}: #{err.strip}" unless st.success?
  out
end

def front_matter(text)
  m = text.match(/\A---\s*\n(.*?)\n---\s*(\n|\z)/m) or return nil
  data = YAML.safe_load(m[1], permitted_classes: [], aliases: false)
  data.is_a?(Hash) ? data : nil
end

class Failure < StandardError; end

def fail!(msg)
  raise Failure, msg
end

def register(db, sha)
  sha = git("rev-parse", sha).strip
  files = git("diff-tree", "--no-commit-id", "--name-only", "-r", "--root", sha).split("\n")
                .select { |f| f.start_with?("features/") }

  metas = files.filter_map do |f|
    text = git("show", "#{sha}:#{f}") rescue next
    fm = front_matter(text)
    [f, fm] if fm && fm.key?("name")
  end

  return "SKIPPED: #{sha[0, 7]} has no features/ file with front matter `name`" if metas.empty?
  return "SKIPPED: #{sha[0, 7]} already registered" if db.get_first_value("SELECT 1 FROM layers WHERE id = ?", sha)

  names = metas.map { |_, fm| fm["name"].to_s }.uniq
  fail!("#{sha[0, 7]}: conflicting layer names #{names.inspect} in one commit") if names.size > 1

  wanted = ->(key) { metas.flat_map { |_, fm| Array(fm[key]).map(&:to_s) }.uniq }

  resolve = lambda do |list, kind|
    list.map do |n|
      id = db.get_first_value("SELECT id FROM layers WHERE name = ? ORDER BY rowid DESC LIMIT 1", n)
      fail!("#{sha[0, 7]}: #{kind} layer '#{n}' is not registered") unless id
      id
    end
  end

  parents = resolve.call(wanted.call("parents"), "parent")
  siblings = resolve.call(wanted.call("siblings"), "sibling")

  db.transaction do
    db.execute("INSERT INTO layers (id, name, parents, siblings) VALUES (?, ?, ?, ?)",
               [sha, names.first, parents.to_json, siblings.to_json])
    parents.each do |pid|
      kids = JSON.parse(db.get_first_value("SELECT children FROM layers WHERE id = ?", pid))
      db.execute("UPDATE layers SET children = ? WHERE id = ?", [(kids | [sha]).to_json, pid])
    end
  end

  "REGISTERED: #{names.first} #{sha[0, 7]} (#{parents.size} parents, #{siblings.size} siblings)"
end

db = SQLite3::Database.new(DB_PATH)
db.execute_batch(File.read(SCHEMA))

begin
  (ARGV.empty? ? ["HEAD"] : ARGV).each { |sha| puts register(db, sha) }
rescue Failure, RuntimeError => e
  puts "FAILED: #{e.message}"
  exit 1
end
