# Specs

RSpec only. Pick the spec type by what is being verified.

## Rules

- NEVER use `expect_any_instance_of`. It is not recommended and can hide failures. Inject the dependency and pass a double instead.
- Controller specs: ONLY for verifying parameters.
- Request specs: headers and integration tests (request in, response out).
- Do not use Capybara.
- Doubles: always `instance_double`. Never a plain `double`.
- Never stub the class under test.
- External HTTP: VCR.
- No minimum coverage is enforced.

## By layer

- Services: integration specs against a real database. Do not mock repos.
- Jobs: test only that the job calls its service, and that the arguments passed are scalars.
- Views (Jbuilder): no view specs. Cover them through request specs.

## Open

Not yet defined. Ask the user before choosing a strategy:

- Repos and relations
- Test data (factories or builders)
- Any other part of Rails not listed above
