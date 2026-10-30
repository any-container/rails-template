# Agents

## Standards

Every folder in `app/`, and `spec/`, has a `STANDARDS.md` with the best practices for that part of the codebase.

Read those files before making changes in that part of the codebase.

| Folder | Standards |
|--------|-----------|
| `app/controllers` | `app/controllers/STANDARDS.md` |
| `app/controllers/concerns` | `app/controllers/concerns/STANDARDS.md` |
| `app/jobs` | `app/jobs/STANDARDS.md` |
| `app/models` | `app/models/STANDARDS.md` |
| `app/relations` | `app/relations/STANDARDS.md` |
| `app/repos` | `app/repos/STANDARDS.md` |
| `app/services` | `app/services/STANDARDS.md` |
| `app/views` | `app/views/STANDARDS.md` |
| `spec` | `spec/STANDARDS.md` |

Where a standard says to ask the user, ask before proceeding.

## Ruby style

- Hash keys: use symbols (`key: value`), not hash rockets (`:key => value`).
- Exception: ENV keys must be strings. Keep symbols in app code and convert at the ENV boundary with `.to_s`, e.g. `ENV[name.to_s]`.
