# Email Link Login

Status: draft

Ticket: [#93](https://github.com/any-container/rails-template/issues/93)

Passwordless login. The user enters a username and receives an email containing a secure link. The link goes to a new endpoint that creates a session.

## Requirements
- Rails: 8.0 or later
- Database: required
- Depends on: `session`, `email`
- Email infrastructure, sender address (`EMAIL_SENDER_ADDRESS`), and the base mailer: provided by `email`.
- Background jobs: Solid Queue, the default per `app/jobs/STANDARDS.md` (installed by `session`)

## Email identity table

Table `email_identities`, model `EmailIdentity`. The feature prefix is not applied. `password_login_and_registration` also uses this table, with the identical definition, so either feature may be injected first or alone.

| Column | Required | Unique |
|--------|----------|--------|
| username | yes | yes (case-insensitive) |
| display_email | yes | yes |
| normalized_email | yes | yes |
| given_name | yes | no |
| surname | no | no |

Definitions of each column match `password_login_and_registration`. Passwords are not stored on this table.

Injection rule, shared with `password_login_and_registration`:
- If `email_identities` does not exist, the template creates it.
- If it exists and matches the definition exactly, the template skips creating it.
- If it exists and does not match exactly, the template fails with an error and changes nothing.
- The same rule applies to the `EmailIdentity` model file.

## Sign-in token table

Table `sign_in_tokens`, model `SignInToken`. The feature prefix is not applied.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| email_identity_id | yes | no | Foreign key to `email_identities`. |
| token_digest | yes | yes | Digest of the token in the link. The token itself is never stored. |
| expires_at | yes | no | Creation time plus 10 minutes. |
| used_at | no | no | Set when the token is consumed. Null means unused. |
| created_at | yes | no | |

## Registration

Registration has no password.

Inputs: username, display email, given name, surname (optional).

- All inputs except surname are required.
- The backend normalizes the display email to produce the normalized email, using the rule in `password_login_and_registration`. The client does not submit it.
- Username, display email, and normalized email must each be unique. Violations return field-level validation errors. This discloses that a username or email exists; accepted.
- On success the identity is created and the login link job is enqueued (see Flow). Registration does not log the user in.

## Flow
1. The user submits a username to the request endpoint. Lookup is by username only, case-insensitive. An email address is never accepted as input.
2. If an email identity exists, the app enqueues a job. The job creates the sign-in token and sends the login link to that identity's display email. The email is sent asynchronously, never in the request.
3. The user opens the link in any browser or device. It does not have to be the browser that requested it.
4. The link is a GET to a landing page. The GET never consumes the token, so email scanners and link-preview bots that fetch the link cannot burn it. The landing page confirms with a POST.
5. The POST validates and consumes the token and creates the session.
6. The session is started through `session`.

## Mailer
- This feature owns the login link mailer and its email template. The mailer inherits from `ApplicationMailer` (provided by `email`).
- The "from" address and the requirement that it be set come from `email` (`EMAIL_SENDER_ADDRESS`).

## Request endpoint
- Input: username.
- The response is identical whether or not the username exists, matching the login rule that existence is never revealed. Response time does not distinguish the cases because the lookup, token creation, and mail delivery happen in the job.

## Job
- Takes the email identity id. Per `app/jobs/STANDARDS.md`, arguments are ids.
- Creates the sign-in token inside the job, so the plaintext token is never passed through the queue.
- Invalidates the identity's earlier unused tokens.
- Sends the email containing the link.
- Safe to retry: a retry issues a new token and invalidates the previous one, so only the latest link works.

## Landing page and consume endpoints
- GET (landing): input is the token from the link. Does not change any state.
- POST (consume): input is the token.
  - Valid token: unused and not expired. Sets `used_at` atomically (a single conditional update, so concurrent requests cannot both succeed), then creates the session for the token's identity.
  - Invalid, expired, or already used token: one generic error.

## Token
- Unguessable random value. Only its digest is stored.
- Expires 10 minutes after creation, stored as `expires_at` on the table.
- Single use, recorded in `used_at`.
- Bound to the identity. Requesting a new link invalidates earlier links.

## Out of scope
- Rate limiting on the request endpoint. Tracked in [#82](https://github.com/any-container/rails-template/issues/82).

## Open questions
- The landing page in an API-only app: is it a front end route that posts to the consume endpoint, or does the app render it?
