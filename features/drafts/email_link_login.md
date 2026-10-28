# Email Link Login

Status: draft

Passwordless login. The user enters a username and receives an email containing a secure link. The link goes to a new endpoint that creates a session.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Depends on: `session`
- Mailer: Action Mailer with a delivery method configured by the host

## Email identity table

Table `email_identities`, model `EmailIdentity`. The feature prefix is not applied. `password_login_and_registration` also uses this table. Each feature creates it if it does not exist and adds only the columns it needs, so either feature may be injected first or alone.

This feature needs these columns. Definitions match `password_login_and_registration`.

| Column | Required | Unique |
|--------|----------|--------|
| username | yes | yes (case-insensitive) |
| display_email | yes | yes |
| normalized_email | yes | yes |
| given_name | yes | no |
| surname | no | no |

This feature does not add `password_digest`.

## Registration

Registration has no password.

Inputs: username, display email, given name, surname (optional).

- All inputs except surname are required.
- The backend normalizes the display email to produce the normalized email, using the rule in `password_login_and_registration`. The client does not submit it.
- Username, display email, and normalized email must each be unique. Violations return field-level validation errors. This discloses that a username or email exists; accepted.
- On success the identity is created and the login link email is sent immediately (see Flow). Registration does not log the user in.

## Flow
1. The user submits a username to a request endpoint.
2. If an email identity exists, the app emails a login link to that identity's display email.
3. The user opens the link. The link targets a new endpoint, which validates the token and creates the session.
4. The session is started through `session`.

## Request endpoint
- Input: username.
- The response is identical whether or not the username exists, matching the login rule that existence is never revealed. Response time should not distinguish the cases (for example, deliver mail in a background job).

## Link endpoint
- Input: token carried in the link.
- Valid token: creates the session for the token's identity.
- Invalid, expired, or already used token: one generic error.

## Token
- Unguessable and signed or random with a stored digest.
- Short expiry.
- Single use.
- Bound to the identity. Requesting a new link invalidates earlier links.

## Open questions
- Token mechanism: Rails 8 `generates_token_for` (stateless, signed) or a stored token table with a digest? Single use is easy with a table, harder with stateless tokens.
- Expiry duration (for example 10 or 15 minutes).
- Link click via email scanners: a GET that consumes the token can be burned by link-preview bots. Use a GET landing page that confirms with a POST?
- Same browser requirement: must the link be opened in the browser that requested it?
- `EmailIdentity` and its migration are defined in both this draft and `password_login_and_registration`. Both would copy the same model file to the same path. How are the shared files kept identical, or does the second injection skip them?
- Rate limiting on the request endpoint to prevent email flooding. Login rate limiting is out of scope in the other drafts; is it in scope here?
- Email identities without a password use this flow. The `password_digest` column is absent or nullable when only this feature is injected. Confirm.
- Mailer template and sender address ownership: feature or host?
- Is username entry the only input, or may the user enter an email?
- Revisit the `email_identities` table (deferred by the user to later in this session).
