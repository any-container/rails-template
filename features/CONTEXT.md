# Features

Whole features for a Rails app, built to be injected into an existing service.

## Routing

| Task | Action |
|------|--------|
| Add a new feature | Use the `new-feature-V2` skill (`.claude/skills/new-feature-V2/SKILL.md`). |
| Describe a feature not yet built | Add `drafts/<feature_name>/<feature_name>.md` and `drafts/<feature_name>/RAILS_CONTEXT.md` (repo root) and a GitHub ticket linked on its `Ticket:` line. See [../drafts/README.md](../drafts/README.md). |
| Pick up the next feature to build | Take the oldest open issue labelled `ready-for-agent` and build its draft with the `new-feature` skill. |
| Understand the draft-to-injected lifecycle | [../workflows/features.md](../workflows/features.md). |

## Feature index

One row per feature in `features/`. The `new-feature` skill adds a row when it creates a feature.

| Feature | Summary | Docs |
|---------|---------|------|
| feature_registry | Per-deployment feature toggles. `features/<name>.md` descriptions (dependencies, gems), `features/0-manifest.yml` loaded into ENV at boot, `Features.enabled?`. Inject before every other feature. | [feature_registry/FEATURE.md](feature_registry/FEATURE.md) |
| routing_and_service_architecture | V2. `AGENTS.md` routing (plus symlinks for other agent tools) and per-folder `STANDARDS.md` coding conventions for `app/` and `db/rom` (ROM, services, Jbuilder). | [routing_and_service_architecture/FEATURE.md](routing_and_service_architecture/FEATURE.md) |

## Versioning

- The current version of each feature or skill lives in `rails-template`. Superseded versions live in the `any-catalog` repo. `any-catalog` mounts `rails-template` as the git submodule `rails-template/`, pinned to a commit that holds the version being archived.
- Archive layout in `any-catalog`: `v<N>/<original path>`, for example `v1/.claude/skills/new-feature/SKILL.md`.
- Each versioned `FEATURE.md` or `SKILL.md` states its version in its first sentence.

To supersede version N with N+1:
1. Copy the current files into `any-catalog` under `v<N>/`. Open a PR there.
2. In `any-catalog`, move the `rails-template/` submodule pointer to the `rails-template` commit that still holds version N, in the same PR.
3. After that PR merges, replace the current version in `rails-template` in a separate PR.

Never push to `any-catalog` or change its submodule pointer without the user's confirmation.
