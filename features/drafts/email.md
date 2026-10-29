# Email

Status: draft

Shared outbound email for every feature that sends mail. A feature that sends email builds its own mailer on this feature's base mailer and sends through this feature's delivery path.

## Requirements
- Rails: 8.0 or later
- Email infrastructure: a working email delivery setup (Action Mailer delivery method and provider) is required. This feature does not provide the provider.
- Sender address: required, supplied as the ENV variable `EMAIL_SENDER_ADDRESS`.
- Background jobs: Solid Queue, the default per `app/jobs/STANDARDS.md`

## Feature order

1. `email` (this draft).
2. `email_link_login`: depends on this feature.

## Behavior
- Provides `ApplicationMailer`, the base class for every mailer in the app. Its "from" address is read from `EMAIL_SENDER_ADDRESS`.
- `EMAIL_SENDER_ADDRESS` has no default. Mailers built on `ApplicationMailer` do not send without it.
- Mail is delivered asynchronously, never in the request cycle. Features send with `deliver_later` or from their own job.
- Delivery failures are retried by the job backend. Mailers must be safe to retry.
- Each feature owns its mailers, templates, and the content of its messages. This feature owns none.

## Configuration

| ENV variable | Default | Meaning |
|--------------|---------|---------|
| `EMAIL_SENDER_ADDRESS` | none, required | "From" address for all outbound mail. |

## Out of scope
- Choosing or configuring the delivery provider.
- Any specific message or mailer.
- Email verification, bounce handling, unsubscribe, and delivery tracking.

## Open questions
- Does the feature ship a test-mode delivery setup (for example `:test` delivery method in the test environment), or leave it to the host?
