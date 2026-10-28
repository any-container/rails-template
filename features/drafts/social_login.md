# Social Login

Status: draft

Login with Google or Facebook. A successful social login creates an identity when none exists for the provider account.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Depends on: `identity_registration_and_login` (the `identities` table and the session cookie)
- Gems: TBD (see open questions)

## Providers
- Google
- Facebook

## Behavior
- The user chooses a provider. The app redirects to the provider, the user authenticates there, and the provider redirects back with an authorization result.
- The app validates the result and reads the provider's user id (`uid`) and profile (email, given name, surname).
- If an identity is already linked to the provider `uid`, the user is logged in as that identity.
- If none is linked, an identity is created from the provider profile and linked to the provider `uid`, then the user is logged in.
- A successful login establishes the same signed session cookie as password login.

## Data
A provider link table, one row per linked provider account:

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| identity_id | yes | no | References `identities`. |
| provider | yes | with `uid` | `google` or `facebook`. |
| uid | yes | with `provider` | The provider's stable user id. |

Unique index on `(provider, uid)`.

## Open questions
- Social identities have no password and no chosen username, but `identities` requires both. Options: make `password_digest` nullable, and derive the username from the email or a generated value. Which?
- Provider email matches an existing identity's normalized email: auto-link, require the user to log in first, or reject? Auto-linking is an account takeover risk unless the provider asserts a verified email.
- Facebook may return no email, or an unverified one. Reject, or ask the user for one?
- Provider email is already unique-constrained in `identities`. Does a provider email get stored as `display_email` unchanged?
- Surname is optional but given name is required. Providers may omit either.
- Library: `omniauth` with `omniauth-google-oauth2` and `omniauth-facebook`, or hand-built OAuth 2.0 / OIDC client?
- Can a logged-in user link or unlink a provider?
- Can a social identity later set a password?
- Does the API-only template support the redirect flow, or is a browser front end assumed?
- Credentials (client id and secret per provider) configuration, e.g. Rails credentials or env vars.
