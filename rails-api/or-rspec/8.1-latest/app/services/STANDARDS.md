# Services

One service per use case. Controllers and jobs call services; services call repos.

## Rules

- One public method: `.call` (class-level, delegating to an instance `#call`).
- Return a Result object (success or failure). Do not raise for expected failures.
- Verb-named classes, namespaced by domain, e.g. `Orders::Place`.
- Inject dependencies (repos, other services) through `initialize`, with defaults.

## Repo overlap

ROM repos often map to many services. If a service's name resembles a repo's (e.g. `Orders::Place` and `OrderRepo`), ask the user whether they are the same thing before creating it.
