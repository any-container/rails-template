# Session

Status: draft

Shared session for every login feature. A successful login of any kind creates the session through this feature. It is keyed by identity type and identity id because identities live in separate tables.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Gems: none

## Feature order

1. `session` (this draft).
2. `social_login`, `password_login_and_registration`, `email_link_login`: each depends on this feature. Any combination may be injected.

## Behavior
- The session is stored on the backend in a `sessions` table. The cookie carries only an opaque session token. Only a digest of the token is stored.
- Interface for login features: start a session for an identity, end the session, and resolve the current identity.
- Logout endpoint deletes the session row.
- The API template must have cookie middleware enabled.

## Sessions table

Table `sessions`, model `Session`. The feature prefix is not applied.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| identity_type | yes | no | `social` or `email`. |
| identity_id | yes | no | Id in `social_identities` or `email_identities`. Polymorphic, no database foreign key. |
| token_digest | yes | yes | Digest of the cookie token. |
| last_active_at | yes | no | Updated by authenticated traffic. |
| expires_at | yes | no | `last_active_at` plus the lifetime. |

## Lifetime
- Default lifetime is 4 hours, configurable.
- Any authenticated request keeps the session alive: it moves `last_active_at` and `expires_at` forward by the lifetime (sliding expiry).
- An expired session is rejected and its row is removed.
- Writes on every request add database load. Whether to throttle the extension is an open question.

## Out of scope
- Any login mechanism. See the login drafts.
- Login rate limiting. The host app handles throttling.

## Open questions
- CSRF protection for the cookie session. Open.
- Cleanup of expired session rows: scheduled job, or on access only?
- Throttle the sliding extension (for example update at most once per minute), or write on every authenticated request?
- Is there an absolute maximum session age regardless of activity?
- Resolved identity: return the record (a `SocialIdentity` or an `EmailIdentity`), or a common wrapper?
- "Remember me" and multiple concurrent sessions per identity.
