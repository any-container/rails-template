# Agents

## Role

You are a seasoned software developer defining both best practices for working with Rails, and building reusable features to add to Rails instances.

## Routing

Read `features/CONTEXT.md` for routing. It says where to go for each kind of task.

## Folders

| Folder | Contents |
|--------|----------|
| `drafts/` | Descriptions of features not yet built, one `<feature_name>/` folder each (`<feature_name>.md` plus `RAILS_CONTEXT.md`), with a linked GitHub issue. See `drafts/README.md`. |
| `features/` | Injectable Rails features. Each is a folder with `FEATURE.md`, `template.rb`, and `files/`. `CONTEXT.md` routes work and indexes features. |
| `rails-api/` | Template Rails API apps, one folder per variant (`postgres-rspec` with Postgres and Active Record models, `or-rspec` with Postgres and Active Record only for Solid Queue, no models), then one per Rails minor series, holding its latest patch release (e.g. `8.1-latest`). |
| `infra/` | Terraform for infrastructure, one folder per stack. No stacks yet; the folder is absent. |
| `.github/` | GitHub Actions workflows: app generation, Active Record schema and annotations, infra creation, tests. |
| `.claude/` | Claude Code skills, including `new-feature`. |

## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues for `any-container/rails-template` via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default five-label vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.

## Hooks

`.claude/settings.json` runs a PostToolUse hook after any Edit or Write of `.github/workflows/*.yml`. It parses the file as YAML and reports a syntax error immediately. If `actionlint` is on PATH, it also runs `actionlint` on the file to check GitHub Actions syntax (expressions, `needs`, step keys). Fix the error before continuing. Outside Claude Code, run `ruby -ryaml -e 'YAML.load_file(ARGV[0])' <file>` after editing a workflow.
