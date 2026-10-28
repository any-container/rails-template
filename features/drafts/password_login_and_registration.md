# Password Login and Registration

Status: draft

Registration with a username and password in the email identity table, and a login that authenticates against that table.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Depends on: `session`
- Gems: `bcrypt`

## Email identity table

Table `email_identities`, model `EmailIdentity`. The feature prefix is not applied. `email_link_login` also uses this table. Each feature creates it if it does not exist and adds only the columns it needs, so either feature may be injected first or alone.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| username | yes | yes | May or may not be an email. Unique case-insensitively (unique index on `lower(username)`). Login lookup is case-insensitive. |
| display_email | yes | yes | As supplied by the user. Never set by the backend. |
| normalized_email | yes | yes | Derived by the backend from `display_email`. Never supplied by the client. |
| password_digest | no at the database level | no | bcrypt, per-password salt. Plaintext is never stored. Added by this feature. Nullable so identities created through `email_link_login` need no password. Registration requires a password. |
| surname | no | no | |
| given_name | yes | no | |

The repo exposes a `full_name` helper combining given name and surname. Surname is optional, so the helper returns the given name alone when surname is blank.

### Email normalization

All addresses are stripped and downcased. For Gmail addresses (`gmail.com`, `googlemail.com`), the normalized form also removes dots from the local part and drops any `+tag` suffix. Other providers keep dots and plus-tags.

## Registration

Inputs: username, display email, password, password confirmation, given name, surname (optional).

- All inputs except surname are required.
- The password must be entered twice. Registration fails if the two entries differ.
- The backend normalizes the display email to produce the normalized email. The client does not submit it.
- Username, display email, and normalized email must each be unique. Violations return field-level validation errors (for example "has already been taken"). This discloses that a username or email exists; accepted.
- Password must be at least 12 characters. No complexity rules. Maximum 72 bytes, the bcrypt input limit.
- The password is hashed with bcrypt before persistence.
- Registration returns the created identity. It does not log the user in.

## Login

Inputs: username, password.

- Looks up the email identity by username and verifies the password against the bcrypt digest.
- Failure returns one generic error for every failure cause (unknown username, wrong password, identity with no password). The response does not reveal whether the user exists. Response time should not distinguish the causes (run a dummy bcrypt comparison when the user is not found or has no password).
- Success starts the session through `session`.

## Out of scope
- Social identities. See `social_login`.
- Email verification after registration. Candidate for a separate feature.
- Login rate limiting and lockout. The host app handles throttling (for example Rack::Attack or Rails `rate_limit`).

## Open questions
- `EmailIdentity` and its migration are defined in both this draft and `email_link_login`. Both would copy the same model file to the same path. How are the shared files kept identical, or does the second injection skip them?
- Can an email identity without a password set one later? Through what flow, given that there is no email verification?
