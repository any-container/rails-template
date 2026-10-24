# Controller Concerns

## Rule of three

Extract a concern only when three or more controllers need the same behavior. Fewer than three examples is too small a sample; the abstraction will be wrong. Duplicate until the third use appears, then extract from all three.

## Rules

- Cross-cutting behavior only (authentication, pagination, error mapping). No domain logic.
- One concern, one purpose, named for that purpose.
- A concern used by fewer than three controllers is a candidate for inlining.
