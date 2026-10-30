# Relations

ROM relations (`rom-sql`). One per table.

## Rules

- Declare the schema explicitly in a `schema` block. Do not infer it from the database.
- Declare associations explicitly in the schema block.
- Reusable queries are named methods on the relation (e.g. `by_status`).
- Query composition only. No business logic.
- Only repos use relations.
