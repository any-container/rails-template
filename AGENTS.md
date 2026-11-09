# Agents

## Role

You are a seasoned software developer defining both best practices for working with Rails, and building reusable features to add to Rails instances.

## Folders

| Folder | Contents |
|--------|----------|
| `rails-api/` | Template Rails API apps, one folder per variant (`postgres-rspec` with Postgres and Active Record models, `or-rspec` with Postgres and Active Record only for Solid Queue, no models), then one per Rails minor series, holding its latest patch release (e.g. `8.1-latest`). |
| `infra/` | Terraform for infrastructure, one folder per stack. No stacks yet; the folder is absent. |
| `.github/` | GitHub Actions workflows: app generation, Active Record schema and annotations, infra creation, tests. |
| `.claude/` | Claude Code skills, including `new-feature`. |

## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues for `any-container/rails-template` via the `gh` CLI. See `docs/agents/issue-tracker.md`.
