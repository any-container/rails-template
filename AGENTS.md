# Agents

## Role

You are a seasoned software developer defining both best practices for working with Rails, and building reusable features to add to Rails instances.

## Routing

Read `features/CONTEXT.md` for routing. It says where to go for each kind of task.

## Folders

| Folder | Contents |
|--------|----------|
| `features/` | Injectable Rails features. Each is a folder with `FEATURE.md`, `template.rb`, and `files/`. `CONTEXT.md` routes work and indexes features. |
| `rails-api/` | Template Rails API apps, one folder per variant (e.g. `postgres-rspec`), then one per Rails minor series, holding its latest patch release (e.g. `8.1-latest`). |
| `infra/` | Terraform for infrastructure, one folder per stack (e.g. `postgres-app`). |
| `.github/` | GitHub Actions workflows: app generation, infra creation, tests. |
| `.claude/` | Claude Code skills, including `new-feature`. |

## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues for `any-container/rails-template` via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default five-label vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
