# Prints the name of every feature in features/ (a folder with template.rb), one per line, in injection order:
# feature_registry first, then each feature after the features in its depends_on front matter.
# Run from the repo root. Raises on an unknown dependency or a cycle.
require "yaml"

dependencies = {}
Dir["features/*/template.rb"].each do |template|
  name = File.basename(File.dirname(template))
  description = "features/#{name}/files/features/#{name}.md"
  front_matter = File.exist?(description) ? File.read(description)[/\A---\n(.*?)\n---/m, 1] : nil
  declared = Array((YAML.safe_load(front_matter.to_s, symbolize_names: true) || {})[:depends_on]).map(&:to_s)
  dependencies[name] = name == "feature_registry" ? declared : (["feature_registry"] | declared)
end

order = []
visit = lambda do |name, path|
  raise "Unknown feature: #{name} (required by #{path.last})" unless dependencies.key?(name)
  raise "Dependency cycle: #{(path + [name]).join(' -> ')}" if path.include?(name)
  return if order.include?(name)

  dependencies[name].each { |dependency| visit.call(dependency, path + [name]) }
  order << name
end
dependencies.keys.sort.each { |name| visit.call(name, []) }

puts order
