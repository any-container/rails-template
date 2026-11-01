# Email

Status: draft

Ticket: [#91](https://github.com/any-container/rails-template/issues/91)

Shared outbound email for every feature that sends mail. A feature that sends email builds its own mailer on this feature's base mailer and sends through this feature's delivery path.

See [RAILS_CONTEXT.md](RAILS_CONTEXT.md) for Rails and Ruby specifics.

## Requirements
- Email infrastructure: a working email delivery setup (delivery method and provider) is required. This feature does not provide the provider.
- Sender address: required, supplied as the ENV variable `EMAIL_SENDER_ADDRESS`.
- Background jobs: required

## Behavior
- Provides a base mailer, the base class for every mailer in the app. Its "from" address is read from `EMAIL_SENDER_ADDRESS`.
- `EMAIL_SENDER_ADDRESS` has no default in development and production. Mailers built on the base mailer do not send without it. The test environment sets a default (see Test environment).
- Mail is delivered asynchronously, never in the request cycle. Features send through the job backend or from their own job.
- Delivery failures are retried by the job backend. Mailers must be safe to retry.
- Each feature owns its mailers, templates, and the content of its messages. This feature owns none.

## Test environment
- The delivery method records messages instead of sending them, the default host for generated links is fixed, and a default `EMAIL_SENDER_ADDRESS` is set so specs need no ENV setup. The default applies to the test environment only.
- Spec support:
  - Clears recorded deliveries before each example.
  - `last_email`: the most recent delivery.
  - `email_links(mail)`: the links found in the decoded body of a message (HTML part, text part, falling back to the body), so specs do not deal with quoted-printable encoding.
  - `first_email_link(mail)`: the first of those links. Features such as `email_link_login` use it to read the token link.

## Development environment
- Optional: messages are written to a local directory and not sent. The browser launch is not relied on.
- Production delivery is untouched. The host configures its provider.

## Configuration

| ENV variable | Default | Meaning |
|--------------|---------|---------|
| `EMAIL_SENDER_ADDRESS` | none, required | "From" address for all outbound mail. |

## Out of scope
- Choosing or configuring the production delivery provider.
- Any specific message or mailer.
- Email verification, bounce handling, unsubscribe, and delivery tracking.
