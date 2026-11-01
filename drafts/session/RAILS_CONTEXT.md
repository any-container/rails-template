# Session: Rails Context

Rails and Ruby specifics for [session.md](session.md).

## Requirements
- Rails: 8.0 or later
- Cookie middleware enabled in the API template
- Database: PostgreSQL (Active Record)
- Gems: `solid_queue`

## Models
- `sessions` is modelled by `Session`.
- Resolving the current identity returns a `SocialIdentity` or an `EmailIdentity`.

## Cleanup
- The recurring job is scheduled with Solid Queue (`config/recurring.yml`), the default scheduler per `app/jobs/STANDARDS.md`.
- Requires Solid Queue.
