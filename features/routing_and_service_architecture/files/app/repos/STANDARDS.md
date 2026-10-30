# Repos

ROM repositories. The persistence boundary for the app.

## Rules

- One `ROM::Repository::Root` per aggregate, rooted on its relation.
- Only services call repos. Controllers and jobs never do.
- Return structs (`app/models`), never hashes.
- Wrap multi-write operations in a transaction inside the repo method.
