# Social Login

Status: draft

Base identity feature. Login with Google or Facebook. A first successful social login registers the user by creating an identity. This feature owns the `identities` table and the session. Every other login feature depends on it.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Gems: TBD (see open questions)

## Feature order

1. `social_login` (this draft): identity table, session, social registration and login.
2. `password_login_and_registration` and/or `email_link_login`: each depends on this feature. Either or both may be injected.

## Providers
- Google
- Facebook

## Identity table

Table `identities`, model `Identity`. The feature prefix is not applied.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| username | yes | yes | May or may not be an email. Unique case-insensitively (unique index on `lower(username)`). Login lookup is case-insensitive. |
| display_email | yes | yes | The email as supplied by the user or provider. Never set by the backend. |
| normalized_email | yes | yes | Derived by the backend from `display_email`. Never supplied by the client. |
| surname | no | no | |
| given_name | yes | no | |

The repo exposes a `full_name` helper combining given name and surname. Surname is optional, so the helper returns the given name alone when surname is blank.

### Email normalization

All addresses are stripped and downcased. For Gmail addresses (`gmail.com`, `googlemail.com`), the normalized form also removes dots from the local part and drops any `+tag` suffix. Other providers keep dots and plus-tags.

## Provider link table

One row per linked provider account:

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| identity_id | yes | no | References `identities`. |
| provider | yes | with `uid` | `google` or `facebook`. |
| uid | yes | with `provider` | The provider's stable user id. |

Unique index on `(provider, uid)`.

## Behavior
- The user chooses a provider. The app redirects to the provider, the user authenticates there, and the provider redirects back with an authorization result.
- The app validates the result and reads the provider's user id (`uid`) and profile (email, given name, surname).
- If an identity is already linked to the provider `uid`, the user is logged in as that identity.
- If none is linked, an identity is created from the provider profile and linked to the provider `uid`, then the user is logged in. This is registration.
- Username, display email, and normalized email must be unique. A collision on first login follows the account-linking decision (see open questions).

## Session
- A successful login of any kind establishes a signed session cookie carrying the identity id.
- The API template must have cookie and session middleware enabled.
- Later login features create the session through this feature's session interface rather than their own.

## Out of scope
- Passwords. See `password_login_and_registration`.
- Email link login. See `email_link_login`.
- Email verification by this app.
- Login rate limiting. The host app handles throttling.

## Open questions
- Social identities have no chosen username, but `username` is required. Derive it from the provider email, or generate one? How are collisions resolved?
- Provider email matches an existing identity's normalized email: auto-link, require the user to log in first, or reject? Auto-linking is an account takeover risk unless the provider asserts a verified email.
- Facebook may return no email, or an unverified one, but `display_email` is required. Reject, or ask the user for one?
- Surname is optional but given name is required. Providers may omit either.
- Library: `omniauth` with `omniauth-google-oauth2` and `omniauth-facebook`, or hand-built OAuth 2.0 / OIDC client?
- Can a logged-in user link or unlink a provider? What if it is their only login method?
- Does the API-only template support the redirect flow, or is a browser front end assumed?
- Credentials (client id and secret per provider) configuration, for example Rails credentials or env vars.
- Logout endpoint: in this feature?
