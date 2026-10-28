# Models

Do not use ActiveRecord for models. Persistence is ROM (`rom-rb` with `rom-sql`).

Active Record may be installed only to back Solid Queue, Solid Cache, and Solid Cable. Never add models, migrations, or `ApplicationRecord` for it.

`app/models` holds the ROM structs/entities returned by repos. Relations live in `app/relations`; repos live in `app/repos`.

## Rules

- No `ApplicationRecord`, no `ActiveRecord::Base` subclasses, no `ActiveSupport::Concern` for persistence.
- Entities carry data and small derived values. No persistence calls, no business workflows (those are services).
- Enum-like values use explicit values, not implicit ordering.
- There is no `models/concerns` folder.

## Related

- `app/relations/STANDARDS.md`
- `app/repos/STANDARDS.md`
