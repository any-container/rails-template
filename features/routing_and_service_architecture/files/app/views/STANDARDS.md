# Views

Jbuilder templates. They shape the JSON response.

## Rules

- No logic and no queries. Views only shape data the service already loaded.
- List every attribute explicitly. Never dump a whole struct.
- One partial per resource (`_order.json.jbuilder`), reused by `index` and `show`.
- Versioned folders mirroring controllers, e.g. `app/views/api/v1/orders/`.
- Hash keys: symbols (`key: value`), not hash rockets. Use `=>` only for non-symbol or computed keys. ENV keys are strings: convert at the ENV boundary (`.to_s`). See `AGENTS.md`.
