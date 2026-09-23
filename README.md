# Rocky Linux Homelab

This project documents my physical Rocky Linux homelab, which I use to practice Linux administration, networking, monitoring, security, containers, troubleshooting, and infrastructure automation.

I originally built and configured the server manually so I could understand how each service worked. Once the environment was stable, I moved the persistent configuration into Ansible so the server could be maintained and rebuilt in a more repeatable way.

The broader homelab includes more than what is stored in this repository. **The contents of this repository are specifically the Ansible code used to manage and reproduce the persistent server configuration.** This README describes the larger server project for context.

## Hardware

The lab runs on a physical Dell OptiPlex 3050:

- Intel Core i5-6500
- 8 GB RAM
- 1.5 TB HDD
- Rocky Linux 9.8

## Services

The server currently runs:

- **Nginx** for web serving, health checks, and request rate limiting
- **Pi-hole** for local DNS and network-wide filtering
- **WireGuard** for remote access to the homelab
- **Node Exporter** for host metrics
- **Prometheus** for metrics collection
- **Grafana** for dashboards and monitoring
- **Podman + Quadlets** for containerized services
- **firewalld** for host firewalling
- **systemd services and timers** for automation and service management

The server also includes automated Nginx backups with 14-day retention, recurring health checks, log rotation, and service verification.

## Security and Networking

A large part of this project has been learning how Linux services interact with the network and operating system.

The server uses:

- SSH key-only authentication
- Disabled root SSH login
- firewalld rules for exposed services
- SELinux in enforcing mode
- Nginx request rate limiting
- Fail2ban for SSH protection
- WireGuard for remote access
- Pi-hole for DNS
- Podman for containerized services

Working with SELinux was especially useful for understanding how Linux permissions go beyond traditional file ownership and modes. I worked through issues involving incorrect security contexts for Nginx content and systemd-managed scripts rather than disabling SELinux.

## Monitoring and Operations

Node Exporter runs directly on the host and exposes system metrics to Prometheus. Grafana provides dashboards for CPU, memory, disk usage, uptime, and network activity.

Prometheus, Grafana, and Pi-hole run as Podman Quadlets, allowing the containers to be managed through systemd alongside native services.

The server also includes:

- Automated health checks for Nginx, HTTP availability, disk usage, and memory usage
- Daily Nginx configuration and website backups
- 14-day backup retention
- Log rotation
- Grafana monitoring and alerts
- systemd timers for recurring tasks

## Security Testing

I also use a Kali Linux VM as a controlled client for testing and observing my own server.

This has included:

- Nmap service discovery
- Web enumeration with Gobuster
- Testing Nginx rate limiting
- Observing firewall and Fail2ban behavior
- Capturing traffic with tcpdump and Wireshark
- Comparing normal LAN traffic with traffic passing through WireGuard

The goal is to understand network behavior and security controls from both the client and server side.

## Ansible Automation

After configuring the server manually, I moved the persistent configuration into Ansible.

The Ansible code in this repository currently manages:

- Nginx
- firewalld
- Node Exporter
- Prometheus
- Grafana
- Pi-hole
- systemd health checks
- Nginx backups and retention
- End-of-play service verification

The playbook is organized into focused roles rather than one large configuration file.

My general workflow for the homelab is to experiment with and configure services manually first, understand how they work, and then move the final persistent configuration into Ansible.

## Repository Structure

This repository contains the Ansible portion of the homelab project.

`site.yml` applies the server roles and runs verification checks at the end.

```text
.
├── inventory/
├── roles/
├── site.yml
├── ansible.cfg
├── requirements.yml
├── .env.example
└── README.md
```

Each role keeps its related tasks, handlers, defaults, and deployed files together.

## Running the Playbook

Install the required Ansible collection:

```bash
ansible-galaxy collection install -r requirements.yml
```

Create a local environment file:

```bash
cp .env.example .env
```

Update `.env` with the Rocky server address and the path to your SSH private key.

Load the variables into the current shell:

```bash
set -a
source .env
set +a
```

Then run the playbook:

```bash
ansible-playbook site.yml
```

`.env` is intentionally excluded from Git. Only the safe `.env.example` template is committed.

## WireGuard

WireGuard is part of the homelab, but it is intentionally not managed by this Ansible repository.

I keep the VPN configuration and private-key material separate from the public project. Ansible could manage it, but I chose to keep it outside the scope of this repository.

The firewall configuration still preserves the UDP port required by WireGuard.

## Project Scope


The goal is to build practical experience operating a real Linux server: configuring services, troubleshooting issues, working with networking and security controls, monitoring the system, and gradually turning manual configuration into reproducible infrastructure.