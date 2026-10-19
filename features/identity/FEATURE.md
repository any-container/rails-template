# Identity

A person's identity (name, unique email, unique user name, encrypted password) created through a two-step API registration flow: register, then confirm a token to produce the Identity.

## Requirements
- Rails: 8.1+ (API mode)
- Database: PostgreSQL (functional index on `lower(user_name)`)
- Gems: bcrypt `~> 3.1` (added by the template)
- RSpec (`rspec-rails`) to run the specs

## Injection
Run from the host app root:

    bin/rails app:template LOCATION=/path/to/features/identity/template.rb

The template:
- Copies `files/` onto the app root: `Identity` and `IdentityRegistration` models, `Identities::RegistrationsController`, `config/routes/identities.rb`, `config/initializers/identities.rb`, two migrations, specs.
- Adds `gem "bcrypt", "~> 3.1"` (when no active bcrypt line exists) and runs `bundle install`.
- Adds `draw :identities` to `config/routes.rb`.
- Runs `bin/rails db:migrate`.

## Configuration
In `config/initializers/identities.rb`:
- `config.x.identities.confirmation_ttl` - token lifetime. Default `24.hours`.
- `config.x.identities.expose_confirmation_token` - include the token in the create response. Default `true` in development/test, `false` elsewhere. Never enable in production: it removes the email-ownership proof.

## Interface
Flow: `POST /identities/registrations` -> pending `IdentityRegistration` -> `POST /identities/registrations/confirmation` -> `Identity`.

| Request | Success | Failure |
|---------|---------|---------|
| `POST /identities/registrations` `{registration: {given_name, surname, user_email, user_name, password, password_confirmation}}` | 202 `{id, status, expires_at}` (+ `confirmation_token` when exposed) | 422 `{errors}` (invalid, or email/user name already taken) |
| `POST /identities/registrations/confirmation` `{token}` | 201 `{id, given_name, surname, user_email, user_name, created_at}` | 422 `{errors}` (bad/expired/used token, or email/user name taken since) |

- Passwords: minimum 8 characters, stored as a bcrypt digest (`has_secure_password`); the registration's digest carries over to the Identity. `Identity#authenticate(password)` is available.
- Email uniqueness is case-insensitive via `normalized_email` (strip + downcase). User name uniqueness is case-insensitive.
- Tokens are stored only as SHA-256 digests, single use, and expire.
- The host delivers the token (the feature sends no mail). Subscribe to `ActiveSupport::Notifications` event `registration_created.identities` (payload `registration:`, `token:`) and email a link.
- Create responds 422 for a taken email, which reveals account existence. Add rate limiting in the host if that matters.

## Testing
`bundle exec rspec spec/models/identity_spec.rb spec/models/identity_registration_spec.rb spec/requests/identities_registrations_spec.rb`
