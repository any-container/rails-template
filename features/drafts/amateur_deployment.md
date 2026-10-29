# Amateur Deployment

Status: draft

Deploys a Rails app to a single Hetzner Cloud server with Kamal. Terraform provisions the server; Postgres runs on the same host as a Kamal accessory, managed by the owner.

## Motivation
Side projects need the lowest possible hosting cost with a simple, repeatable deploy. One small Hetzner VPS (about $5/month) running the app and Postgres is cheaper than Heroku, Render, or AWS managed services. Kamal is the Rails default deployer and needs only SSH and Docker.

## Requirements
- Rails: 8.0+ (Kamal is bundled with the Rails 8 generator)
- Database: PostgreSQL, run as a Kamal accessory on the app host
- Gems: `kamal`, `~> 2.0`
- Infra: Terraform `>= 1.2`, `hetznercloud/hcloud` provider
- Accounts: Hetzner Cloud project and API token, container registry (e.g. GitHub Container Registry), a domain name for TLS

## Scope
Included:
- `infra/hetzner-single-host/` Terraform stack: one server, SSH key, firewall (22, 80, 443 only), optional volume for Postgres data
- `config/deploy.yml` for Kamal: app server, Postgres accessory, Let's Encrypt TLS via kamal-proxy, secrets from environment
- `.kamal/secrets` wired to environment variables, with no secrets committed
- Postgres backups: scheduled `pg_dump` to Hetzner Object Storage or other S3-compatible storage
- Documentation of setup, deploy, rollback, restore from backup, and host patching
- Compatibility with both `postgres-rspec` and `or-rspec` template variants (`or-rspec` uses Postgres only for Solid Queue)

Excluded:
- High availability, multiple hosts, load balancers
- Managed Postgres
- Staging/production environment splits
- Monitoring and alerting beyond container health checks
- CI-driven deploys (candidate follow-up feature)
- Non-Hetzner providers (the AWS `infra/postgres-app` stub is unrelated)

## Open questions
- Does `.github/` app generation need a step to verify `config/deploy.yml` renders?
- Terraform state: local, or a remote backend (e.g. S3-compatible bucket)?
- Postgres data on the root disk or a separate attached volume (survives server rebuilds, costs more)?
- Backup retention and schedule defaults?
- Server type default (`cx22`/`cpx11` class) and region?
- Unattended OS security updates: enable via cloud-init?
- Should this replace or sit beside `infra/postgres-app`?
