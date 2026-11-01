# Jobs

## Rules

- Thin. `perform` loads what it needs and calls a service in `app/services`. No logic in the job.
- Idempotent. A retry must not duplicate effects.
- Arguments are IDs (or GlobalIDs), never objects or attribute hashes.
- Declare `retry_on` and `discard_on` explicitly for each job. Set the queue explicitly.

## Uniqueness

When creating a job, ask the user whether it should enforce uniqueness on its params. Do not decide alone.

## Scheduling and running

- Solid Queue is the default backend for running jobs and for scheduling recurring jobs. Do not add another queue backend or an external scheduler without asking the user.
- Recurring jobs are declared in `config/recurring.yml`. Do not schedule with cron, `sleep` loops, or in-process timers.
- A recurring job follows every rule above. It takes no arguments or only literals, and it is safe to run twice.
- Solid Queue stores its state in a database. In an app without Active Record, give it its own database; do not route job data through the app's ROM relations.
