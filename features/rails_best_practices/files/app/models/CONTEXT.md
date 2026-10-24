# Models

Do not use ActiveRecord. Persistence is ROM (`rom-rb` with `rom-sql`).

`app/models` holds the ROM structs/entities returned by repos. Relations live in `app/relations`; repos live in `app/repos`.

## Rules

- No `ApplicationRecord`, no `ActiveRecord::Base` subclasses, no `ActiveSupport::Concern` for persistence.
- Entities carry data and small derived values. No persistence calls, no business workflows (those are services).
- Enum-like values use explicit values, not implicit ordering.
- There is no `models/concerns` folder.

## Related

- `app/relations/CONTEXT.md`
- `app/repos/CONTEXT.md`
