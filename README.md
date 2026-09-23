# Rocky Linux Homelab Automation

Ansible automation for a physical Rocky Linux homelab server. The project manages the web tier, host firewall, monitoring stack, DNS service, scheduled backups, and system health checks using native Linux services and Podman Quadlets.

## What this project manages

- Nginx with a health endpoint and request rate limiting
- firewalld services and application ports
- Prometheus Node Exporter as a native systemd service
- Prometheus and Grafana as Podman Quadlets
- Pi-hole as a Podman Quadlet
- Daily Nginx backups with 14-day retention
- A five-minute systemd health check timer
- End-of-run health verification for all managed services

WireGuard configuration and credentials are intentionally outside the scope of this repository. The existing UDP 51820 firewall allowance is retained for the host's separately managed WireGuard service.

## Repository layout

```text
.
├── ansible.cfg
├── .env.example
├── inventory/
│   ├── group_vars/
│   │   └── rocky_servers.yml
│   └── hosts.yml
├── requirements.yml
├── roles/
│   ├── firewall/
│   ├── health_checks/
│   ├── monitoring/
│   ├── nginx/
│   ├── nginx_backup/
│   └── node_exporter/
└── site.yml
```

Each role keeps its tasks, handlers, defaults, and deployed files or templates together. `site.yml` defines the role order and performs service verification after configuration completes.

## Prerequisites

- Ansible installed on the control machine
- SSH access to the Rocky Linux host
- A remote user with passwordless sudo access
- An SSH private key for the managed server

Install the required collection:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Usage

Create a local environment file and replace the example values with your Rocky Linux server address and SSH private-key path:

```bash
cp .env.example .env
```

Load the variables into your current shell:

```bash
set -a
source .env
set +a
```

The local `.env` is ignored by Git and must be loaded in each new shell before running Ansible. Review the remaining connection variables under `inventory/`, then test connectivity:

```bash
ansible all -m ping
```

Run the playbook:

```bash
ansible-playbook site.yml
```

Preview changes where supported by the underlying modules:

```bash
ansible-playbook site.yml --check --diff
```

## Configuration

Role defaults expose the small set of values that are useful to change, including image tags, Node Exporter version, health-check interval, backup retention, and Nginx rate limits. Override them in inventory variables when needed; service definitions remain in their owning roles.
