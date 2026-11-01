# Email: Rails Context

Rails and Ruby specifics for [email.md](email.md).

## Requirements
- Rails: 8.0 or later
- Email infrastructure: an Action Mailer delivery method and provider.
- Background jobs: Solid Queue, the default per `app/jobs/STANDARDS.md`
- Gems: `letter_opener` (development group)
- Spec framework: RSpec

## Behavior
- The base mailer is `ApplicationMailer`.
- Features send with `deliver_later` or from their own job.

## Test environment
- `config/environments/test.rb` sets `delivery_method` to `:test`, `default_url_options` to a fixed host, and a default `EMAIL_SENDER_ADDRESS`.
- Spec support lives in `spec/support/email.rb`, required from `rails_helper`:
  - Clears `ActionMailer::Base.deliveries` before each example.
  - `last_email`, `email_links(mail)`, `first_email_link(mail)` as described in [email.md](email.md). `email_links` reads `mail.html_part` or `mail.text_part`, falling back to `mail.body`.

## Development environment
- The `letter_opener` gem is added to the development group. `config/environments/development.rb` sets `delivery_method` to `:letter_opener`, so messages are written to `tmp/letter_opener/`.
