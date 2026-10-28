# Session

Status: draft

Shared session for every login feature. A successful login of any kind creates the session through this feature. It is keyed by identity type and identity id because identities live in separate tables.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Gems: `solid_queue`

## Feature order

1. `session` (this draft).
2. `social_login`, `password_login_and_registration`, `email_link_login`: each depends on this feature. Any combination may be injected.

## Behavior
- The session is stored on the backend in a `sessions` table. The cookie carries only an opaque session token. Only a digest of the token is stored.
- Interface for login features: start a session for an identity, end the session, and resolve the current identity. Resolving returns the identity record itself (a `SocialIdentity` or an `EmailIdentity`).
- One concurrent session per identity. Starting a session deletes every other session of that identity, so a login elsewhere ends earlier sessions.
- Logout endpoint deletes the session row.
- The API template must have cookie middleware enabled.

## Sessions table

Table `sessions`, model `Session`. The feature prefix is not applied.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| identity_type | yes | with `identity_id` | `social` or `email`. |
| identity_id | yes | with `identity_type` | Id in `social_identities` or `email_identities`. Polymorphic, no database foreign key. |

Unique index on `(identity_type, identity_id)` enforces one session per identity.
| token_digest | yes | yes | Digest of the cookie token. |
| last_active_at | yes | no | Updated by authenticated traffic, at most once per 5 minutes. |
| created_at | yes | no | Login time. Anchors the absolute maximum age. |
| expires_at | yes | no | The earlier of `last_active_at` plus the lifetime and `created_at` plus the maximum age. |

## Lifetime
- Idle lifetime defaults to 4 hours.
- Absolute maximum age defaults to 24 hours, counted from login. Activity never extends a session past it.
- Any authenticated request keeps the session alive: it moves `last_active_at` and `expires_at` forward by the lifetime (sliding expiry).
- The extension is throttled. A request updates the row only when `last_active_at` is at least 5 minutes old. Idle expiry is therefore between the lifetime minus 5 minutes and the lifetime.
- An expired session is rejected.

## Configuration

| ENV variable | Default | Meaning |
|--------------|---------|---------|
| `SESSION_LIFETIME_SECONDS` | `14400` (4 hours) | Idle lifetime, extended by authenticated traffic. |
| `SESSION_MAX_AGE_SECONDS` | `86400` (24 hours) | Absolute maximum age from login. |

Variable names and the seconds format are proposed, not yet confirmed.

## Cleanup
- A recurring job runs every 5 minutes and deletes expired session rows. It is scheduled with Solid Queue (`config/recurring.yml`), the default scheduler per `app/jobs/STANDARDS.md`.
- Requires Solid Queue (see Requirements).

## Out of scope
- Any login mechanism. See the login drafts.
- Login rate limiting. The host app handles throttling.

## Open questions
- CSRF protection for the cookie session. Open.
- Confirm the ENV variable names and the seconds format.
- Solid Queue needs a database. Confirm the queue database setup for the template apps.
- "Remember me".
