# Rails Best Practices

Per-folder `CONTEXT.md` files under `app/` that record how code is written in an API-only Rails app using RSpec, ROM (`rom-rb` + `rom-sql`) instead of ActiveRecord, service objects, and Jbuilder views.

## Requirements
- Rails: 8.1 (API only)
- Database: any supported by `rom-sql`
- Gems: none installed by this feature. The conventions assume `rom-rb`, `rom-sql`, `jbuilder`.

## Injection
Run from the host app root:

    bin/rails app:template LOCATION=/path/to/features/rails_best_practices/template.rb

The template:
- Copies `CONTEXT.md` into `app/controllers`, `app/controllers/concerns`, `app/jobs`, `app/models`, `app/services`, `app/relations`, `app/repos`, `app/views`.
- Makes no host edits (no gems, routes, initializers).
- Runs no migrations.

## Host follow-up (not done by the template)
The conventions conflict with the stock template app. The template never deletes host code, so these are manual:
- Remove `app/models/application_record.rb` and `app/models/concerns/`.
- Add `rom-rb`, `rom-sql`, and `jbuilder` to the Gemfile.

## Configuration
None.

## Interface
Documentation only. Agents read the `CONTEXT.md` in the folder they are editing.

## Testing
No code, so no specs. Verify by injecting into a scratch copy of a template app and confirming each `CONTEXT.md` lands.
