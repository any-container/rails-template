# Identity Registration and Login

Status: draft

Registration flow that creates a username and password in a new identity table, and a login that authenticates against that table.

## Requirements
- Rails: TBD
- Database: PostgreSQL (Active Record)
- Gems: `bcrypt`

## Identity table

Table name carries the feature prefix. Table name TBD (see open questions).

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| username | yes | yes | May or may not be an email. |
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
- Username, display email, and normalized email must each be unique. Violations return a validation error.
- The password is hashed with bcrypt before persistence.

## Login

Inputs: username, password.

- Looks up the identity by username and verifies the password against the bcrypt digest.
- Failure returns one generic error for every failure cause (unknown username, wrong password). The response does not reveal whether the user exists. Response time should not distinguish the causes (run a dummy bcrypt comparison when the user is not found).
- Success result (session, token, or other) TBD. See open questions.

## Open questions
- Table and model name: `identities`, with the feature prefix?
- Email normalization rules: downcase and strip only, or also strip plus-tags and dots?
- Username normalization and case sensitivity for uniqueness.
- Password policy: minimum length, complexity.
- Email verification after registration: in scope?
- Rate limiting and lockout on login failures.
- What does a successful login return or establish: session cookie, token, other?
- Does registration log the user in, or does the user log in afterward?
- Account enumeration on registration: uniqueness errors reveal that a username or email exists. Accept, or mask?
