Rails.application.configure do
  config.x.identities.confirmation_ttl = 24.hours
  # Returning the token in the create response skips email proof; development and test only.
  config.x.identities.expose_confirmation_token = Rails.env.local?
end
