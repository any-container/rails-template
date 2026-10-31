# Draft Features

Descriptions of features not yet built. One file per feature: `features/drafts/<feature_name>.md` (snake_case).

Every draft has a GitHub issue, linked on the `Ticket:` line and labelled per `docs/agents/triage-labels.md` (`ready-for-agent` when the draft has no open questions, otherwise `needs-info`). See [workflows/features.md](../../workflows/features.md).

Drafts are not listed in the feature index in `features/CONTEXT.md`. They have no `template.rb` or `files/`.

## Draft template

```markdown
# <Feature Name>

Status: draft

Ticket: [#<number>](https://github.com/any-container/rails-template/issues/<number>)

<One or two sentences: what it does.>

## Motivation
<Why it is needed.>

## Requirements
- Rails: <versions>
- Database: <e.g. PostgreSQL>
- Gems: <gem, version constraint>

## Scope
<What is included. What is explicitly excluded.>

## Open questions
- <Unresolved decisions.>
```

## Promotion

To build a draft, use the `new-feature` skill with the draft as input. After the feature is built and indexed in `features/CONTEXT.md`, the ticket review workflow opens a PR that deletes the draft and closes its ticket once the feature is injected into the template apps.
