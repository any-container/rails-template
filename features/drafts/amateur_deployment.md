# Amateur Deployment

Status: draft

Deploys a Rails app to a single Hetzner Cloud server with Kamal. Terraform provisions the server. Postgres is an external managed service, not run on the host.

## Motivation
Side projects need low hosting cost with a simple, repeatable deploy. One small Hetzner VPS (about $5/month) running the app, plus a managed Postgres free or entry tier, is cheaper than Heroku, Render, or AWS managed stacks. Kamal is the Rails default deployer and needs only SSH and Docker. Managed Postgres removes backup, patching, and restore work from the owner.

## Requirements
- Rails: 8.0+ (Kamal is bundled with the Rails 8 generator)
- Database: PostgreSQL, managed service reached via `DATABASE_URL`
- Gems: `kamal`, `~> 2.0`
- Infra: Terraform `>= 1.2`, `hetznercloud/hcloud` provider
- Accounts: Hetzner Cloud project and API token, managed Postgres provider account, container registry (e.g. GitHub Container Registry), a domain name for TLS

## Scope
Included:
- Terraform stack in `infra/`: one server, SSH key, firewall (22, 80, 443 only)
- `config/deploy.yml` for Kamal: app server, Let's Encrypt TLS via kamal-proxy, secrets from environment including `DATABASE_URL`
- `.kamal/secrets` wired to environment variables, with no secrets committed
- `.github/` app generation step that verifies `config/deploy.yml` renders (e.g. `kamal config`)
- Documentation of setup, deploy, rollback, and host patching
- Compatibility with both `postgres-rspec` and `or-rspec` template variants (`or-rspec` uses Postgres only for Solid Queue)

Excluded:
- High availability, multiple hosts, load balancers
- Self-managed Postgres on the host, and Postgres backups (the managed provider owns them)
- Provisioning the managed Postgres via Terraform (the owner creates it and supplies `DATABASE_URL`)
- Staging/production environment splits
- Monitoring and alerting beyond container health checks
- CI-driven deploys (candidate follow-up feature)
- Non-Hetzner hosting providers

## Open questions
- Managed Postgres provider? Hetzner has no managed Postgres. Candidates: Neon, Supabase, DigitalOcean Managed Postgres, AWS RDS. Latency between a Hetzner region and the provider region matters.
- Terraform state: local, or a remote backend (e.g. S3-compatible bucket)? Under discussion.
- Server type default (`cx22`/`cpx11` class) and region?
- Unattended OS security updates: enable via cloud-init?
- Where the stack lives in `infra/` (`infra/postgres-app` was deleted; name the new folder at build time).
