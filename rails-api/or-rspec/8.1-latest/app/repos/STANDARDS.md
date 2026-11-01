# Repos

ROM repositories. The persistence boundary for the app.

## Rules

- One `ROM::Repository::Root` per aggregate, rooted on its relation.
- Only services call repos. Controllers and jobs never do.
- Return structs (`app/models`), never hashes.
- Wrap multi-write operations in a transaction inside the repo method.
- Name repos `<Aggregate>Repo` and set `struct_namespace Object` so rows map to the structs in `app/models`.
- CRUD methods: `find` (nil when missing), `find!` (raises), `all`, `create`, `update`, `delete`. `update` and `delete` return the record, or nil when the id does not exist.
- Always order `all` and list queries.
- Set `created_at` and `updated_at` by including `Timestamped` (`app/repos/timestamped.rb`). Use `with_create_timestamps` and `with_update_timestamps` on every write. Callers cannot set `id`, `created_at`, or `updated_at`.
- Shared repo code is an `ActiveSupport::Concern` unless directed otherwise (e.g. `Timestamped`). Prefer composition over inheritance: include concerns, do not build a base repo class.
- Keep repo concerns in `app/repos` beside the repos. Do not add a `concerns` folder.
- Referential rules rely on foreign keys, not check-then-insert. Rescue `ROM::SQL::ForeignKeyConstraintError` and raise a repo-level error (e.g. `AccountRepo::OwnerNotFound`).
