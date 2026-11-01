# Password Login and Registration: Rails Context

Rails and Ruby specifics for [password_login_and_registration.md](password_login_and_registration.md).

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Gems: `bcrypt`

## Models
- `email_identities` is modelled by `EmailIdentity`. The injection rule also applies to the `EmailIdentity` model file.
- `email_identity_passwords` is modelled by `EmailIdentityPassword`.

## Out of scope
- Login throttling is left to the host app, for example Rack::Attack or Rails `rate_limit`.
