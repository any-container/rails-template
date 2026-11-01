# Email

Status: draft

Ticket: [#91](https://github.com/any-container/rails-template/issues/91)

Shared outbound email for every feature that sends mail. A feature that sends email builds its own mailer on this feature's base mailer and sends through this feature's delivery path.

## Requirements
- Rails: 8.0 or later
- Email infrastructure: a working email delivery setup (Action Mailer delivery method and provider) is required. This feature does not provide the provider.
- Sender address: required, supplied as the ENV variable `EMAIL_SENDER_ADDRESS`.
- Background jobs: Solid Queue, the default per `app/jobs/STANDARDS.md`
- Gems: `letter_opener` (development group)
- Spec framework: RSpec

## Feature order

1. `email` (this draft).
2. `email_link_login`: depends on this feature.

## Behavior
- Provides `ApplicationMailer`, the base class for every mailer in the app. Its "from" address is read from `EMAIL_SENDER_ADDRESS`.
- `EMAIL_SENDER_ADDRESS` has no default in development and production. Mailers built on `ApplicationMailer` do not send without it. The test environment sets a default (see Test environment).
- Mail is delivered asynchronously, never in the request cycle. Features send with `deliver_later` or from their own job.
- Delivery failures are retried by the job backend. Mailers must be safe to retry.
- Each feature owns its mailers, templates, and the content of its messages. This feature owns none.

## Test environment
- `config/environments/test.rb` sets `delivery_method` to `:test`, `default_url_options` to a fixed host, and a default `EMAIL_SENDER_ADDRESS` so specs need no ENV setup. The default applies to the test environment only.
- Spec support (`spec/support/email.rb`), required from `rails_helper`:
  - Clears `ActionMailer::Base.deliveries` before each example.
  - `last_email`: the most recent delivery.
  - `email_links(mail)`: the links found in the decoded body of a message (`mail.html_part` or `mail.text_part`, falling back to `mail.body`), so specs do not deal with quoted-printable encoding.
  - `first_email_link(mail)`: the first of those links. Features such as `email_link_login` use it to read the token link.

## Development environment
- The `letter_opener` gem is added to the development group. `config/environments/development.rb` sets `delivery_method` to `:letter_opener`, so messages are written to `tmp/letter_opener/` and not sent. The browser launch is not relied on.
- Production delivery is untouched. The host configures its provider.

## Configuration

| ENV variable | Default | Meaning |
|--------------|---------|---------|
| `EMAIL_SENDER_ADDRESS` | none, required | "From" address for all outbound mail. |

## Out of scope
- Choosing or configuring the production delivery provider.
- Any specific message or mailer.
- Email verification, bounce handling, unsubscribe, and delivery tracking.
