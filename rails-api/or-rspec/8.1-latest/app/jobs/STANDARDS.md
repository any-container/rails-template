# Jobs

## Rules

- Thin. `perform` loads what it needs and calls a service in `app/services`. No logic in the job.
- Idempotent. A retry must not duplicate effects.
- Arguments are IDs (or GlobalIDs), never objects or attribute hashes.
- Declare `retry_on` and `discard_on` explicitly for each job. Set the queue explicitly.

## Uniqueness

When creating a job, ask the user whether it should enforce uniqueness on its params. Do not decide alone.
