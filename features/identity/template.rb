# Identity injection. See FEATURE.md.
source_paths.unshift(File.expand_path("files", __dir__))

# 1. Copy the feature's files onto the app root. Thor prompts on conflicts.
directory ".", "."

# 2. Host edits. Every action is safe to run twice.
gemfile = File.read("Gemfile")
unless gemfile.match?(/^\s*gem ["']bcrypt["']/)
  gem "bcrypt", "~> 3.1"
  run "bundle install"
end

unless File.read("config/routes.rb").match?(/^\s*draw :identities/)
  route "draw :identities"
end

# 3. Follow-up steps.
rails_command "db:migrate"
