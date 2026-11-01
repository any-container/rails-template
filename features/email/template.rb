# Email injection. See FEATURE.md.
source_paths.unshift(File.expand_path("files", __dir__))

# 1. Copy the base mailer, mailer layouts, delivery config initializer, spec support, specs, and the registry description.
#    Thor prompts on conflicts.
directory ".", "."

# 2. Register the feature (off by default, like every feature).
manifest = "features/0-manifest.yml"
append_to_file manifest, %(FEATURE_EMAIL: "false"\n) unless File.read(manifest).include?("FEATURE_EMAIL:")

# 3. Load Action Mailer. The template apps comment its railtie out.
uncomment_lines "config/application.rb", %r{require "action_mailer/railtie"}

# 4. Development: letter_opener writes messages to tmp/letter_opener/ (configured in config/initializers/email.rb).
gem "letter_opener", "~> 1.10", group: :development unless File.read("Gemfile").match?(/^\s*gem ["']letter_opener["']/)

# 5. Load the spec helpers from rails_helper.
unless File.read("spec/rails_helper.rb").include?("support/email")
  inject_into_file "spec/rails_helper.rb", after: /^require ['"]rspec\/rails['"]\n/ do
    %(require Rails.root.join("spec/support/email").to_s\n)
  end
end
