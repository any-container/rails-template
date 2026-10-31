# Password Login and Registration

Status: draft

Ticket: [#94](https://github.com/any-container/rails-template/issues/94)

Registration with a username and password, and a login that authenticates against them. Identities live in `email_identities`. Passwords live in a separate table.

## Requirements
- Rails: 8.0 or later
- Database: PostgreSQL (Active Record)
- Depends on: `session`
- Gems: `bcrypt`

## Email identity table

Table `email_identities`, model `EmailIdentity`. The feature prefix is not applied. `email_link_login` also uses this table, with the identical definition, so either feature may be injected first or alone.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| username | yes | yes | May or may not be an email. Unique case-insensitively (unique index on `lower(username)`). Login lookup is case-insensitive. |
| display_email | yes | yes | As supplied by the user. Never set by the backend. |
| normalized_email | yes | yes | Derived by the backend from `display_email`. Never supplied by the client. |
| surname | no | no | |
| given_name | yes | no | |

The repo exposes a `full_name` helper combining given name and surname. Surname is optional, so the helper returns the given name alone when surname is blank.

Injection rule, shared with `email_link_login`:
- If `email_identities` does not exist, the template creates it.
- If it exists and matches the definition exactly, the template skips creating it.
- If it exists and does not match exactly, the template fails with an error and changes nothing.
- The same rule applies to the `EmailIdentity` model file.

### Email normalization

All addresses are stripped and downcased. For Gmail addresses (`gmail.com`, `googlemail.com`), the normalized form also removes dots from the local part and drops any `+tag` suffix. Other providers keep dots and plus-tags.

## Email identity password table

Table `email_identity_passwords`, model `EmailIdentityPassword`. The feature prefix is not applied. Created by this feature only.

| Column | Required | Unique | Notes |
|--------|----------|--------|-------|
| email_identity_id | yes | yes | Foreign key to `email_identities`. One password per identity. |
| password_digest | yes | no | bcrypt, per-password salt. Plaintext is never stored. |
| created_at | yes | no | |
| updated_at | yes | no | |

An email identity created through `email_link_login` has no row here.

## Registration

Inputs: username, display email, password, password confirmation, given name, surname (optional).

- All inputs except surname are required.
- The password must be entered twice. Registration fails if the two entries differ.
- The backend normalizes the display email to produce the normalized email. The client does not submit it.
- Username, display email, and normalized email must each be unique. Violations return field-level validation errors (for example "has already been taken"). This discloses that a username or email exists; accepted.
- Password must be at least 12 characters. No complexity rules. Maximum 72 bytes, the bcrypt input limit.
- The password is hashed with bcrypt before persistence.
- The identity row and the password row are created in one transaction.
- Registration returns the created identity. It does not log the user in.

## Login

Inputs: username, password.

- Looks up the email identity by username, then its password row, and verifies the password against the bcrypt digest.
- Failure returns one generic error for every failure cause (unknown username, wrong password, identity with no password row). The response does not reveal whether the user exists. Response time should not distinguish the causes (run a dummy bcrypt comparison when the user or the password row is not found).
- Success starts the session through `session`.

## Out of scope
- Social identities. See `social_login`.
- Email verification after registration. Candidate for a separate feature.
- Login rate limiting and lockout. The host app handles throttling (for example Rack::Attack or Rails `rate_limit`).

## Open questions
- Revisit the `email_identities` table (deferred by the user to later in this session).
- Can an email identity without a password set one later? Through what flow, given that there is no email verification?
