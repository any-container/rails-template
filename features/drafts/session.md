# Session

Status: draft

Shared session for every login feature. A successful login of any kind creates the session through this feature. It is keyed by identity type and identity id because identities live in separate tables.

## Requirements
- Rails: 8.0 or later
- Database: none (cookie session)
- Gems: none

## Feature order

1. `session` (this draft).
2. `social_login`, `password_login_and_registration`, `email_link_login`: each depends on this feature. Any combination may be injected.

## Behavior
- Establishes a signed session cookie carrying the identity type (`social` or `email`) and the identity id.
- Interface for login features: start a session for an identity, end the session, and resolve the current identity.
- Logout endpoint ends the session.
- The API template must have cookie and session middleware enabled.

## Out of scope
- Any login mechanism. See the login drafts.
- Login rate limiting. The host app handles throttling.

## Open questions
- Rails 8 ships an authentication generator with a database-backed `Session` model. Use the cookie only, or a stored session table that allows server-side revocation?
- Session lifetime, idle timeout, and "remember me".
- Resolved identity: return the record (a `SocialIdentity` or an `EmailIdentity`), or a common wrapper?
- Does the API-only template carry CSRF protection for the cookie session?
