# Feature Workflow

Status: draft. Tracked in [#90](https://github.com/any-container/rails-template/issues/90).

## Lifecycle

A feature moves from a draft to an indexed feature in five stages: draft, build, inject, verify, index.

```mermaid
flowchart TD
    Issue["Feature request issue<br/>label: needs-triage"] --> Triage{Triage}
    Triage -->|needs more detail| NeedsInfo["needs-info"]
    NeedsInfo --> Triage
    Triage -->|rejected| Wontfix["wontfix"]
    Triage -->|human builds| ReadyHuman["ready-for-human"]
    Triage -->|agent builds| ReadyAgent["ready-for-agent"]

    Draft["Draft<br/>features/drafts/&lt;feature_name&gt;.md"]
    Triage -->|describe first| Draft
    Draft --> ReadyAgent
    Draft --> ReadyHuman

    ReadyAgent --> Build
    ReadyHuman --> Build

    subgraph Build["Build (new-feature skill)"]
        direction TB
        B1["Check features/CONTEXT.md for overlap"] --> B2["Create features/&lt;feature_name&gt;/<br/>FEATURE.md, template.rb, files/"]
        B2 --> B3["Write code and RSpec specs in files/"]
        B3 --> B4["Write registry description<br/>files/features/&lt;feature_name&gt;.md"]
    end

    Build --> Inject["Inject<br/>bin/rails app:template into a scratch copy<br/>of a rails-api/ template app"]
    Inject --> Verify{"Verify<br/>db:migrate, rspec,<br/>second run changes nothing"}
    Verify -->|fail| Build
    Verify -->|pass| Index["Index<br/>add row to features/CONTEXT.md"]
    Index --> Cleanup["Delete the draft file"]
    Cleanup --> Done(["Feature done"])
```

## Stages

| Stage | Input | Output | Gate to move on |
|-------|-------|--------|-----------------|
| Draft | Issue | `features/drafts/<feature_name>.md` | Issue labelled `ready-for-agent` or `ready-for-human`. |
| Build | Draft, `new-feature` skill | `features/<feature_name>/` with `FEATURE.md`, `template.rb`, `files/` | `FEATURE.md` complete. |
| Inject | `template.rb`, scratch copy of a `rails-api/` app | App with the feature applied | Template runs without error. |
| Verify | Injected app | Passing `db:migrate` and `rspec`; idempotent second run | All checks pass. A failure returns to Build. |
| Index | Verified feature | Row in `features/CONTEXT.md`; draft deleted | Row exists. |

## Open items

Remaining diagrams and sections from #90 are not yet drafted:
- Injection flow, including dependency order (`feature_registry` first).
- Relationships between `features/`, `rails-api/`, `.github/` workflows and `.claude/` skills.
- Per-variant verification (`postgres-rspec`, `or-rspec`).
- Feature validation in GitHub Actions.
