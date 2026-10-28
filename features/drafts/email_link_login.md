# Email Link Login

Status: draft

Passwordless login. The user enters a username and receives an email containing a secure link. The link goes to a new endpoint that creates a session.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Depends on: `social_login` (the `identities` table and the session)
- Mailer: Action Mailer with a delivery method configured by the host

## Flow
1. The user submits a username to a request endpoint.
2. If an identity exists, the app emails a login link to that identity's display email.
3. The user opens the link. The link targets a new endpoint, which validates the token and creates the session.
4. The session is established through `social_login`, the same signed session cookie as every other login.

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
- Social identities have a provider email, possibly unverified. Is it a trusted destination for login links?
- Rate limiting on the request endpoint to prevent email flooding. Login rate limiting is out of scope in the other drafts; is it in scope here?
- Independent of `password_login_and_registration`. Can an identity created only through this feature's dependency (social login) use this flow without ever setting a password? Assumed yes.
- Mailer template and sender address ownership: feature or host?
- Is username entry the only input, or may the user enter an email?
