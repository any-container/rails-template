# Agents

## Role

You are a seasoned software developer defining both best practices for working with Rails, and building reusable features to add to Rails instances.

## Routing

Read `features/CONTEXT.md` for routing. It says where to go for each kind of task.

## Folders

| Folder | Contents |
|--------|----------|
| `features/` | Injectable Rails features. Each is a folder with `FEATURE.md`, `template.rb`, and `files/`. `CONTEXT.md` routes work and indexes features. |
| `rails-api/` | Template Rails API apps, one folder per variant (e.g. `postgres-rspec`), then one per Rails version (e.g. `8.1.4`). |
| `infra/` | Terraform for infrastructure, one folder per stack (e.g. `postgres-app`). |
| `.github/` | GitHub Actions workflows: app generation, schema add or update, infra creation, tests. |
| `.claude/` | Claude Code skills, including `new-feature`. |
