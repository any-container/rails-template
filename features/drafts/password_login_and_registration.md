# Password Login and Registration

Status: draft

Registration with a username and password, and a login that authenticates against the identity table. Adds password support to the identity table owned by `social_login`.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Depends on: `social_login` (the `identities` table, email normalization, and the session)
- Gems: `bcrypt`

## Identity table change

Adds one column to `identities`:

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| password_digest | no at the database level | no | bcrypt, per-password salt. Plaintext is never stored. Nullable because social identities have no password. |

Password presence is required by the registration flow, not by the table.

## Registration

Inputs: username, display email, password, password confirmation, given name, surname (optional).

- All inputs except surname are required.
- The password must be entered twice. Registration fails if the two entries differ.
- The backend normalizes the display email to produce the normalized email, using the rule in `social_login`. The client does not submit it.
- Username, display email, and normalized email must each be unique. Violations return field-level validation errors (for example "has already been taken"). This discloses that a username or email exists; accepted.
- Password must be at least 12 characters. No complexity rules. Maximum 72 bytes, the bcrypt input limit.
- The password is hashed with bcrypt before persistence.
- Registration returns the created identity. It does not log the user in.

## Login

Inputs: username, password.

- Looks up the identity by username and verifies the password against the bcrypt digest.
- Failure returns one generic error for every failure cause (unknown username, wrong password, identity with no password). The response does not reveal whether the user exists. Response time should not distinguish the causes (run a dummy bcrypt comparison when the user is not found or has no password).
- Success establishes the session through `social_login`.

## Out of scope
- Email verification after registration. Candidate for a separate feature.
- Login rate limiting and lockout. The host app handles throttling (for example Rack::Attack or Rails `rate_limit`).

## Open questions
- Can a social identity later set a password? If so, through what flow, given that there is no email verification?
- Can a password registration collide with an existing social identity's email? The uniqueness error would disclose that the email exists.
