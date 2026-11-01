# Amateur Deployment

Status: draft

Ticket: [#96](https://github.com/any-container/rails-template/issues/96)

Deploys an app to a single host with Kamal. Postgres is a managed database, not run on the host.

## Motivation
Side projects need low hosting cost with a simple, repeatable deploy. One small host running the app, plus the smallest managed Postgres plan, is cheaper than Heroku or AWS managed stacks. Kamal needs only SSH and Docker. Managed Postgres removes backup, patching, and restore work from the owner.

See [RAILS_CONTEXT.md](RAILS_CONTEXT.md) for Rails and Ruby specifics.

## Requirements
- Database: PostgreSQL, reached via `DATABASE_URL`
- Deployer: Kamal 2.x

## Scope
Included:
- `config/deploy.yml` for Kamal: app server, Let's Encrypt TLS via kamal-proxy, secrets from environment including `DATABASE_URL`
- `.kamal/secrets` wired to environment variables, with no secrets committed
- `.github/` app generation step that verifies `config/deploy.yml` renders (e.g. `kamal config`)
- Documentation of setup, deploy, rollback, and host patching

Excluded:
- High availability, multiple hosts, load balancers
- Self-managed Postgres on the host, and Postgres backups (the managed provider owns them)
- Staging/production environment splits
- Monitoring and alerting beyond container health checks
- CI-driven deploys (candidate follow-up feature)
- Host and database provisioning, Terraform, and Terraform state
