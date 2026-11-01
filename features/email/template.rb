# Email injection. See FEATURE.md.
source_paths.unshift(File.expand_path("files", __dir__))

# 1. Copy the base mailer, mailer layouts, spec support, specs, and the registry description.
#    Thor prompts on conflicts.
directory ".", "."

# 2. Register the feature (off by default, like every feature).
manifest = "features/0-manifest.yml"
append_to_file manifest, %(FEATURE_EMAIL: "false"\n) unless File.read(manifest).include?("FEATURE_EMAIL:")

# 3. Load Action Mailer. The template apps comment its railtie out.
uncomment_lines "config/application.rb", %r{require "action_mailer/railtie"}

# 4. Development: write messages to tmp/letter_opener/ instead of sending them.
gem "letter_opener", "~> 1.10", group: :development unless File.read("Gemfile").match?(/^\s*gem ["']letter_opener["']/)

unless File.read("config/environments/development.rb").include?("letter_opener")
  environment <<~RUBY, env: "development"
    # Email: write messages to tmp/letter_opener/. See features/email.md.
    config.action_mailer.delivery_method = :letter_opener
    # letter_opener writes the file, then tries to open a browser, which raises on a headless machine.
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  RUBY
end

# 5. Test: collect messages in memory, with a fixed host and a default sender address.
unless File.read("config/environments/test.rb").include?("EMAIL_SENDER_ADDRESS")
  environment <<~RUBY, env: "test"
    # Email: collect messages in ActionMailer::Base.deliveries. See features/email.md.
    ENV["EMAIL_SENDER_ADDRESS"] ||= "no-reply@example.com"
    config.action_mailer.delivery_method = :test
    config.action_mailer.default_url_options = { host: "www.example.com" }
  RUBY
end

# 6. Load the spec helpers from rails_helper.
unless File.read("spec/rails_helper.rb").include?("support/email")
  inject_into_file "spec/rails_helper.rb", after: /^require ['"]rspec\/rails['"]\n/ do
    %(require Rails.root.join("spec/support/email").to_s\n)
  end
end
