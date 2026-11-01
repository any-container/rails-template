# Email Link Login: Rails Context

Rails and Ruby specifics for [email_link_login.md](email_link_login.md).

## Requirements
- Rails: 8.0 or later
- Background jobs: Solid Queue, the default per `app/jobs/STANDARDS.md` (installed by `session`)

## Models
- `email_identities` is modelled by `EmailIdentity`. The injection rule also applies to the `EmailIdentity` model file.
- `sign_in_tokens` is modelled by `SignInToken`.

## Mailer
- The login link mailer inherits from `ApplicationMailer` (provided by `email`).

## Job
- Per `app/jobs/STANDARDS.md`, job arguments are ids.
