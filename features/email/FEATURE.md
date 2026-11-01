# Email

Shared outbound email for every feature that sends mail. A feature that sends email builds its own mailer on `ApplicationMailer` and sends through `deliver_later` or from its own job. This feature owns no mailer, template or message content.

## Requirements
- Rails: 8.0 or later
- Database: none (Solid Queue's database is used for delivery jobs)
- Background jobs: Solid Queue, the default per `app/jobs/STANDARDS.md`
- Email infrastructure: a working Action Mailer delivery method and provider. This feature does not provide the provider.
- Sender address: `EMAIL_SENDER_ADDRESS`
- Gems: `letter_opener ~> 1.10` (development group)
- Spec framework: RSpec
- Features: `feature_registry` (inject it first)

## Injection
Run from the host app root:

    bin/rails app:template LOCATION=/path/to/features/email/template.rb

The template:
- Copies `app/mailers/application_mailer.rb`, `app/views/layouts/mailer.html.erb`, `app/views/layouts/mailer.text.erb`, `spec/support/email.rb`, `spec/email/*_spec.rb` and `features/email.md`.
- Appends `FEATURE_EMAIL: "false"` to `features/0-manifest.yml`.
- Uncomments `require "action_mailer/railtie"` in `config/application.rb` (the template apps comment it out).
- Adds `gem "letter_opener", "~> 1.10", group: :development` to the Gemfile.
- Adds to `config/environments/development.rb`:

      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.raise_delivery_errors = false
      config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

- Adds to `config/environments/test.rb`:

      ENV["EMAIL_SENDER_ADDRESS"] ||= "no-reply@example.com"
      config.action_mailer.delivery_method = :test
      config.action_mailer.default_url_options = { host: "www.example.com" }

- Adds `require Rails.root.join("spec/support/email").to_s` to `spec/rails_helper.rb`.
- Leaves production untouched: the host configures its delivery provider and `default_url_options`.
- Runs no migrations. Re-running changes nothing.

`letter_opener` writes each message to `tmp/letter_opener/` and then tries to open a browser. `raise_delivery_errors = false` keeps a headless machine from failing on that step.

## Configuration

| ENV variable | Default | Meaning |
|--------------|---------|---------|
| `EMAIL_SENDER_ADDRESS` | none, required (test environment: `no-reply@example.com`) | "From" address for all outbound mail. |

A mailer built on `ApplicationMailer` raises `ApplicationMailer::MissingSenderAddress` when the variable is unset or blank, and sends nothing.

## Interface
- `ApplicationMailer`: base class for every mailer in the app. Delivery jobs run on the `mailers` queue.
- Send with `SomeMailer.some_message(...).deliver_later`, or from a job. Never deliver in the request cycle.
- Delivery failures are retried by the job backend. A mailer must be safe to run twice.
- Spec helpers (`spec/support/email.rb`, included in every example, deliveries cleared before each):
  - `last_email`: the most recent delivery.
  - `email_links(mail)`: the links in the decoded body (`html_part`, else `text_part`, else the body), in order, without duplicates.
  - `first_email_link(mail)`: the first of those links.

## Out of scope
- Choosing or configuring the production delivery provider.
- Any specific message or mailer.
- Email verification, bounce handling, unsubscribe, and delivery tracking.

## Testing
`bundle exec rspec spec/email`
