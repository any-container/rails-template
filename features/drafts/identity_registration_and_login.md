# Identity Registration and Login

Status: draft

Registration flow that creates a username and password in a new identity table, and a login that authenticates against that table.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Gems: `bcrypt`

## Identity table

Table `identities`, model `Identity`. The feature prefix is not applied.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| username | yes | yes | May or may not be an email. Unique case-insensitively (unique index on `lower(username)`). Login lookup is case-insensitive. |
| display_email | yes | yes | As supplied by the user. Never set by the backend. |
| normalized_email | yes | yes | Derived by the backend from `display_email`. Never supplied by the client. |
| password_digest | yes | no | bcrypt, per-password salt. Plaintext is never stored. |
| surname | no | no | |
| given_name | yes | no | |

The repo exposes a `full_name` helper combining given name and surname. Surname is optional, so the helper returns the given name alone when surname is blank.

## Registration

Inputs: username, display email, password, password confirmation, given name, surname (optional).

- All inputs except surname are required.
- The password must be entered twice. Registration fails if the two entries differ.
- The backend normalizes the display email to produce the normalized email. The client does not submit it.
- Username, display email, and normalized email must each be unique. Violations return field-level validation errors (for example "has already been taken"). This discloses that a username or email exists; accepted.
- Password must be at least 12 characters. No complexity rules. Maximum 72 bytes, the bcrypt input limit.
- Registration returns the created identity. It does not log the user in.

### Email normalization

All addresses are stripped and downcased. For Gmail addresses (`gmail.com`, `googlemail.com`), the normalized form also removes dots from the local part and drops any `+tag` suffix. Other providers keep dots and plus-tags.
- The password is hashed with bcrypt before persistence.

## Login

Inputs: username, password.

- Looks up the identity by username and verifies the password against the bcrypt digest.
- Failure returns one generic error for every failure cause (unknown username, wrong password). The response does not reveal whether the user exists. Response time should not distinguish the causes (run a dummy bcrypt comparison when the user is not found).
- Success establishes a signed session cookie carrying the identity id. The API template must have cookie and session middleware enabled.

## Out of scope
- Email verification after registration. Candidate for a separate feature.
- Login rate limiting and lockout. The host app handles throttling (for example Rack::Attack or Rails `rate_limit`).

## Open questions
None.
