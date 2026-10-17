---
name: new-feature
description: Build a new injectable Rails feature in the features/ folder. Use when adding a new feature to features/, as routed by features/CONTEXT.md.
---

# New Feature

A feature is a self-contained, whole slice of behaviour (models, migrations, controllers, routes, jobs, specs) that can be injected into any Rails service.

## Layout

```
features/<feature_name>/
  FEATURE.md        # contract: what it does, requirements, injection steps
  files/            # source files; paths mirror the target Rails app root
    app/...
    config/...
    db/migrate/...
    spec/...
```

- `<feature_name>` is snake_case.
- Everything under `files/` copies directly onto the target app root without renaming.

## Steps

1. Read `features/CONTEXT.md` and list `features/` to check for an existing or overlapping feature. Extend rather than duplicate.
2. Confirm the feature name and scope with the user if either is ambiguous.
3. Create `features/<feature_name>/` with `FEATURE.md` and `files/`.
4. Write the code in `files/`:
   - Namespace all classes under a module named after the feature to avoid collisions with host code.
   - Do not edit host-owned files. Where the host must change (routes, initializers, Gemfile), put it in the `FEATURE.md` injection steps, not in `files/`.
   - Migrations: use timestamped names and `ActiveRecord::Migration[<target version>]`. Prefix table names with the feature name.
   - Assume only what `FEATURE.md` lists as requirements (Rails version, database, gems).
5. Write RSpec specs in `files/spec/` covering the feature's behaviour.
6. Verify by injecting into a template app under `rails-api/` in a scratch copy (never in place): copy `files/` over it, apply the injection steps, run migrations and `bundle exec rspec`. Report failures; do not mark the feature done on a failing run.
7. Complete `FEATURE.md` (below). Add a row for the feature to `features/CONTEXT.md` if a feature index exists.

## FEATURE.md template

```markdown
# <Feature Name>

<One or two sentences: what it does.>

## Requirements
- Rails: <versions>
- Database: <e.g. PostgreSQL>
- Gems: <gem, version constraint>

## Injection
1. Copy `files/` onto the app root.
2. <Host changes: routes line, initializer, Gemfile entry, etc., as exact snippets.>
3. `bin/rails db:migrate`

## Configuration
<Env vars / config options, defaults.>

## Interface
<Routes, public classes/methods, events the host can use.>

## Testing
`bundle exec rspec spec/<feature_name>`
```
