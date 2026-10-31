# Social Login

Status: draft

Ticket: [#95](https://github.com/any-container/rails-template/issues/95)

Login with Google or Facebook. A first successful social login registers the user by creating a social identity. Social identities are separate from email identities, because Facebook users may have no email.

## Requirements
- Rails: 8.0 or later
- Database: required
- Depends on: `session`
- Gems: `omniauth`, `omniauth-google-oauth2`, `omniauth-facebook`
- A Google app and a Facebook app, each registered with its provider, with the client id and client secret supplied as ENV variables:

| ENV variable | Value |
|--------------|-------|
| `GOOGLE_CLIENT_ID` | Google app client id. |
| `GOOGLE_CLIENT_SECRET` | Google app client secret. |
| `FACEBOOK_CLIENT_ID` | Facebook app id. |
| `FACEBOOK_CLIENT_SECRET` | Facebook app secret. |

## Providers
- Google
- Facebook

## Social identity table

Table `social_identities`, model `SocialIdentity`. The feature prefix is not applied. One row per provider account.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| provider | yes | with `uid` | `google` or `facebook`. |
| uid | yes | with `provider` | The provider's stable user id. |
| email | no | no | As supplied by the provider. May be absent. Not unique, not normalized, not used to match other identities. |
| given_name | no | no | As supplied by the provider. May be absent. |
| surname | no | no | As supplied by the provider. May be absent. |

Unique index on `(provider, uid)`.

The repo exposes a `full_name` helper combining given name and surname, skipping blanks. It returns an empty string when both are absent.

There is no username and no password.

## Behavior
- The user chooses a provider. The app redirects to the provider, the user authenticates there, and the provider redirects back with an authorization result.
- The app validates the result and reads the provider's user id (`uid`) and profile (email, given name, surname).
- If a social identity exists for `(provider, uid)`, the user is logged in as that identity.
- If none exists, a social identity is created from the provider profile, then the user is logged in. This is registration.
- On every successful login, the stored `email`, `given_name`, and `surname` are overwritten with the provider's current values, including when the provider returns none.
- The session is started through `session`.
- Social identities are never matched or merged with email identities.
- A user who logs in with both Google and Facebook has two unrelated social identities, one per provider. This is accepted. The two are never linked, even when the provider emails match.

## Open questions
- Does the API-only template support the redirect flow, or is a browser front end assumed?
