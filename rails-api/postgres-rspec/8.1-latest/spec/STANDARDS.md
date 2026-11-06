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
- Test data: `rom-factory`. Define factories in `spec/support/factories/<name>.rb` and use them as `Factory[:user]` (creates and returns the record), `Factory[:user, first_name: "Ada"]` (override attributes), and `Factory.build(:user)` (not persisted). Unique values use `f.sequence`. Related records use `f.association`. Do not use FactoryBot or fixtures.
- Do not write specs for factories.
- Set up data with factories. Call a repo's `create` only in the spec for that repo method.
- Each example runs in a transaction that is rolled back (`spec/support/rom.rb`). Pending ROM migrations run once before the suite.

## By layer

- Services: integration specs against a real database. Do not mock repos.
- Jobs: test only that the job calls its service, and that the arguments passed are scalars.
- Repos and relations: integration specs against a real database. Do not stub the ROM gateway.
- Views (Jbuilder): no view specs. Cover them through request specs.

## Open

Not yet defined. Ask the user before choosing a strategy:

- Any other part of Rails not listed above
