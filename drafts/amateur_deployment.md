# Amateur Deployment

Status: draft

Ticket: [#96](https://github.com/any-container/rails-template/issues/96)

Deploys a Rails app to a single DigitalOcean Droplet with Kamal. The Droplet is provisioned by the `digitalocean_infrastructure` feature. Postgres is DigitalOcean Managed Databases, not run on the Droplet.

## Motivation
Side projects need low hosting cost with a simple, repeatable deploy. One small Droplet (about $5/month) running the app, plus the smallest DigitalOcean Managed Postgres plan, is cheaper than Heroku or AWS managed stacks, and keeps app and database on one provider and private network. Verify current plan prices before building. Kamal is the Rails default deployer and needs only SSH and Docker. Managed Postgres removes backup, patching, and restore work from the owner.

## Requirements
- Rails: 8.0+ (Kamal is bundled with the Rails 8 generator)
- Database: PostgreSQL, DigitalOcean Managed Databases, reached via `DATABASE_URL`
- Gems: `kamal`, `~> 2.0`
- Features: `digitalocean_infrastructure` (draft, not yet written) provisions the Droplet, SSH key, firewall, and managed Postgres cluster, and owns Terraform state, Droplet size, region, and OS updates. This feature takes the Droplet's address, SSH access, and `DATABASE_URL` as inputs.
- Accounts: DigitalOcean account and API token, container registry (e.g. GitHub Container Registry), a domain name for TLS

## Scope
Included:
- `config/deploy.yml` for Kamal: app server, Let's Encrypt TLS via kamal-proxy, secrets from environment including `DATABASE_URL`
- `.kamal/secrets` wired to environment variables, with no secrets committed
- `.github/` app generation step that verifies `config/deploy.yml` renders (e.g. `kamal config`)
- Documentation of setup, deploy, rollback, and host patching
- Compatibility with both `postgres-rspec` and `or-rspec` template variants (`or-rspec` uses Postgres only for Solid Queue)

Excluded:
- High availability, multiple hosts, load balancers
- Self-managed Postgres on the host, and Postgres backups (the managed provider owns them)
- Staging/production environment splits
- Monitoring and alerting beyond container health checks
- CI-driven deploys (candidate follow-up feature)
- Droplet and database provisioning, Terraform, and Terraform state (see `digitalocean_infrastructure`)
- Non-DigitalOcean hosting providers

## Open questions
- What does `digitalocean_infrastructure` hand to this feature (host address, SSH user, key path, `DATABASE_URL`), and in what form?
- Use the Droplet and database private network (VPC) address in `DATABASE_URL`, with the database trusted-sources list limited to the Droplet?
