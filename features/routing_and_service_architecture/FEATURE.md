# Routing and Service Architecture

V2 of the routing and service architecture feature. Agentic routing for an API-only Rails app using RSpec, ROM (`rom-rb` + `rom-sql`) instead of ActiveRecord, service objects, and Jbuilder views. An `AGENTS.md` at the app root tells agents to read the `STANDARDS.md` in each `app/` folder before changing code there.

## Requirements
- Rails: 8.1 (API only)
- Database: any supported by `rom-sql`
- Gems: none installed by this feature. The conventions assume `rom-rb`, `rom-sql`, `jbuilder`.

## Injection
Run from the host app root:

    bin/rails app:template LOCATION=/path/to/features/routing_and_service_architecture/template.rb

The template:
- Copies `AGENTS.md` to the app root.
- Copies `STANDARDS.md` into `app/controllers`, `app/controllers/concerns`, `app/jobs`, `app/models`, `app/services`, `app/relations`, `app/repos`, `app/views`, `db/rom`, `spec`.
- Symlinks these to `AGENTS.md`: `CLAUDE.md`, `GEMINI.md`, `CONVENTIONS.md` (Aider), `.cursorrules`, `.windsurfrules`, `.clinerules`, `.rules` (Zed), `.github/copilot-instructions.md`. Any that already exist are left untouched.
- Copies `spec/architecture/standards_spec.rb`, which checks that the 10 `STANDARDS.md` files exist and that `AGENTS.md` mentions each, and that no Ruby file in `app/` or `spec/` writes a symbol key with a hash rocket.
- Enables `Style/HashSyntax` in `.rubocop.yml` (appended, or the file is created). Left untouched if the file already mentions the cop.
- Makes no gem, route, or initializer edits. Runs no migrations.

The symlinks are also present in `files/`, but Thor copies symlinks as regular files, so the template excludes them from the copy and recreates them with `create_link`.

## V2 changes
Standards extracted from the users and accounts build (`3b0ea62`, `3c352cf`):
- New `db/rom/STANDARDS.md`: ROM migration rules and column formats (UUID v4 ids, `timestamptz`, foreign keys, `lower(email)` unique index). It assumes Active Record is installed only for Solid Queue, as in the `or-rspec` variant.
- `app/models`: entities, one `ROM::Struct` per table.
- `app/relations`: typed attributes, `primary_key`, role-named associations, case-insensitive lookups.
- `app/repos`: `<Aggregate>Repo` naming, CRUD method set, ordering, `Timestamped` module, foreign key errors.
- `AGENTS.md` routes `db/rom`; the injected spec checks it.

V1 is archived in the `any-catalog` repo at `v1/features/routing_and_service_architecture/`.

## Hash syntax
`AGENTS.md` requires symbolized keys (`key: value`). ENV keys must be strings; convert at the ENV boundary with `.to_s`. The injected spec flags symbol-key rockets. Rubocop's `Style/HashSyntax`, enabled by the template, enforces the same rule in the host app.

## Host follow-up (not done by the template)
The conventions conflict with the stock template app. The template never deletes host code, so these are manual:
- Remove `app/models/application_record.rb` and `app/models/concerns/`.
- Add `rom-rb`, `rom-sql`, and `jbuilder` to the Gemfile.

## Configuration
None.

## Interface
Documentation only. Agents read `AGENTS.md`, then the `STANDARDS.md` in the folder they are editing.

## Testing
The injected spec `spec/architecture/standards_spec.rb` runs with the host app's suite (`bundle exec rspec`). Verify by injecting into a scratch copy of a template app, confirming every `STANDARDS.md` and agent-file symlink lands, and that a second run changes nothing.
