# Specs

RSpec only. Pick the spec type by what is being verified.

## Rules

- NEVER use `expect_any_instance_of`. It is not recommended and can hide failures. Inject the dependency and pass a double instead.
- Controller specs: ONLY for verifying parameters.
- Request specs: headers and integration tests (request in, response out).
- Do not use Capybara.

## Open

Testing strategies for other parts of Rails (services, repos, relations, jobs, views, ...) are not yet defined. Ask the user before choosing one.
