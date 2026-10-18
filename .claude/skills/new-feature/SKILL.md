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
  template.rb       # Rails application template that performs the injection
  files/            # source files; paths mirror the target Rails app root
    app/...
    config/...
    db/migrate/...
    spec/...
```

- `<feature_name>` is snake_case.
- Everything under `files/` copies directly onto the target app root without renaming.
- `template.rb` is the single injection entry point. It copies `files/` and makes every host edit (gems, routes, initializers) with Rails template actions.

## Steps

1. Read `features/CONTEXT.md` and list `features/` to check for an existing or overlapping feature. Extend rather than duplicate.
2. Confirm the feature name and scope with the user if either is ambiguous.
3. Create `features/<feature_name>/` with `FEATURE.md` and `files/`.
4. Write the code in `files/`:
   - Do not put host-owned files in `files/`. Host changes (routes, initializers, Gemfile) belong in `template.rb`.
   - Migrations: use timestamped names and `ActiveRecord::Migration[<target version>]`. Prefix table names with the feature name.
   - Assume only what `FEATURE.md` lists as requirements (Rails version, database, gems).
5. Write RSpec specs in `files/spec/` covering the feature's behaviour.
6. Write `template.rb` (see below).
7. Verify by injecting into a scratch copy of a template app under `rails-api/` (never in place): run `bin/rails app:template LOCATION=<path>/features/<feature_name>/template.rb`, then `bin/rails db:migrate` and `bundle exec rspec`. Run the template a second time to confirm it is safe to re-run. Report failures; do not mark the feature done on a failing run.
8. Complete `FEATURE.md` (below).
9. Add a row to the "Feature index" table in `features/CONTEXT.md`: feature name, one-line summary, and a link to `<feature_name>/FEATURE.md`. If the feature changes the routing (a new kind of task), update the routing table too. The feature is not done until this row exists.

## template.rb

Run from the host app root:

```
bin/rails app:template LOCATION=/path/to/features/<feature_name>/template.rb
```

Skeleton:

```ruby
# <Feature Name> injection. See FEATURE.md.
source_paths.unshift(File.expand_path("files", __dir__))

# 1. Copy the feature's files onto the app root. Thor prompts on conflicts.
directory ".", "."

# 2. Host edits. Every action must be safe to run twice.
gem "some_gem", "~> 1.0" unless File.read("Gemfile").include?('gem "some_gem"')
route "mount_feature_routes" unless File.read("config/routes.rb").include?("mount_feature_routes")

# 3. Follow-up steps.
after_bundle do
  rails_command "db:migrate"
end
```

Rules:
- Use Rails template actions (`gem`, `route`, `initializer`, `environment`, `inject_into_file`, `generate`) rather than editing files with raw string handling.
- Guard every host edit so a second run changes nothing.
- Never delete or overwrite host code.
- Reference files only through `source_paths`; do not hard-code absolute paths.

## FEATURE.md template

```markdown
# <Feature Name>

<One or two sentences: what it does.>

## Requirements
- Rails: <versions>
- Database: <e.g. PostgreSQL>
- Gems: <gem, version constraint>

## Injection
Run from the host app root:

    bin/rails app:template LOCATION=/path/to/features/<feature_name>/template.rb

The template:
- <Files copied.>
- <Host changes: gem, route, initializer, as exact snippets.>
- <Migrations run.>

## Configuration
<Env vars / config options, defaults.>

## Interface
<Routes, public classes/methods, events the host can use.>

## Testing
`bundle exec rspec spec/<feature_name>`
```
