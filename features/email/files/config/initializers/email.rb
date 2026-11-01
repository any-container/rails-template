# Email delivery settings per environment. See features/email.md.
# Production delivery (provider, credentials, default_url_options) is the host's to configure.
Rails.application.configure do
  if Rails.env.development?
    # Write messages to tmp/letter_opener/ instead of sending them.
    config.action_mailer.delivery_method = :letter_opener
    # letter_opener writes the file, then tries to open a browser, which raises on a headless machine.
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  elsif Rails.env.test?
    # Collect messages in ActionMailer::Base.deliveries. Specs need no ENV setup.
    ENV["EMAIL_SENDER_ADDRESS"] ||= "no-reply@example.com"
    config.action_mailer.delivery_method = :test
    config.action_mailer.default_url_options = { host: "www.example.com" }
  end
end
