# Relations

ROM relations (`rom-sql`). One per table.

## Rules

- Declare the schema explicitly in a `schema` block. Do not infer it from the database.
- Declare associations explicitly in the schema block.
- Reusable queries are named methods on the relation (e.g. `by_status`).
- Query composition only. No business logic.
- Only repos use relations.
- Name the relation class for the table, plural (`Users` for `users`). Declare every column as an `attribute` with a `ROM::SQL::Types` type. UUID columns use `Types::PG::UUID`, timestamps use `Types::Time`.
- Shared code goes in `app/relations/concerns`.
- Declare `primary_key`.
- Declare the foreign key side with `belongs_to ... foreign_key:` and the other side with `has_many ... foreign_key:`. Name the association for the role (`as: :owner`).
- Case-insensitive lookups use the same expression as the index (`lower(email)`).
