# Features

Whole features for a Rails app, built to be injected into an existing service.

## Routing

| Task | Action |
|------|--------|
| Add a new feature | Use the `new-feature` skill (`.claude/skills/new-feature/SKILL.md`). |
| Describe a feature not yet built | Add `drafts/<feature_name>.md`. See [drafts/README.md](drafts/README.md). |

## Feature index

One row per feature in `features/`. The `new-feature` skill adds a row when it creates a feature.

| Feature | Summary | Docs |
|---------|---------|------|
| feature_registry | Per-deployment feature toggles. `features/<name>.md` descriptions (dependencies, gems), `features/0-manifest.yml` loaded into ENV at boot, `Features.enabled?`. Inject before every other feature. | [feature_registry/FEATURE.md](feature_registry/FEATURE.md) |
| routing_and_service_architecture | `AGENTS.md` routing (plus symlinks for other agent tools) and per-folder `STANDARDS.md` coding conventions for `app/` (ROM, services, Jbuilder). | [routing_and_service_architecture/FEATURE.md](routing_and_service_architecture/FEATURE.md) |
