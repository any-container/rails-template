# Draft Features

Descriptions of features not yet built. One folder per feature: `drafts/<feature_name>/` (snake_case), holding two files:

| File | Contents |
|------|----------|
| `<feature_name>.md` | The framework-neutral draft: behavior, data, scope, open questions. No Rails or Ruby specifics. |
| `RAILS_CONTEXT.md` | Rails and Ruby specifics for the draft: Rails versions, gems, Active Record models, Action Mailer, Solid Queue, config and spec file paths. |

Every draft has a GitHub issue, linked on the `Ticket:` line and labelled per `docs/agents/triage-labels.md` (`ready-for-agent` when the draft has no open questions, otherwise `needs-info`). See [workflows/features.md](../workflows/features.md).

A draft's `Status:` line is `draft` until its feature is injected into every template app, then `INJECTED`. Injected drafts are kept.

Drafts are not listed in the feature index in `features/CONTEXT.md`. They have no `template.rb` or `files/`.

## Draft template

`drafts/<feature_name>/<feature_name>.md`:

```markdown
# <Feature Name>

Status: draft

Ticket: [#<number>](https://github.com/any-container/rails-template/issues/<number>)

<One or two sentences: what it does.>

## Motivation
<Why it is needed.>

## Requirements
- Database: <e.g. PostgreSQL>
- Depends on: <other features>

## Scope
<What is included. What is explicitly excluded.>

## Open questions
- <Unresolved decisions.>
```

Link the draft to its Rails file with the line `See [RAILS_CONTEXT.md](RAILS_CONTEXT.md) for Rails and Ruby specifics.` above `## Requirements`.

## RAILS_CONTEXT.md template

`drafts/<feature_name>/RAILS_CONTEXT.md`:

```markdown
# <Feature Name>: Rails Context

Rails and Ruby specifics for [<feature_name>.md](<feature_name>.md).

## Requirements
- Rails: <versions>
- Gems: <gem, version constraint>

## Models
- <table> is modelled by <Model>.

## Implementation
- <Rails-specific mechanisms, config and spec file paths.>
```

Omit any section that does not apply. Everything that names a Rails or Ruby construct goes here, not in the draft.
