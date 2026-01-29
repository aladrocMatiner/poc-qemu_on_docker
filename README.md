# poc-qemu_on_docker

PoC: Docker Swarm + QEMU/KVM lab with OpenTofu/libvirt provisioning.

## Phase 1 Quickstart

1. Copy env and edit:

```bash
$ cp .env.example .env
$ ${EDITOR:-nano} .env
```

2. Bootstrap host tools:

```bash
$ make bootstrap
```

3. Initialize and apply lab:

```bash
$ make lab-init
$ make lab-up
```

4. Generate inventory and inspect status:

```bash
$ make lab-status
```

5. Configure with Ansible:

```bash
$ make ansible-bootstrap
$ make ansible-inventory
$ make ansible-ping
$ make ansible-baseline
$ make ansible-docker
$ make ansible-swarm
$ make ansible-verify
```

6. Optional smoke tests:

```bash
$ make smoke
```

7. Developer diagnostics:

```bash
$ make doctor
```

## Management Modes

- `MGMT_MODE=user` (default): uses libvirt NAT network and DHCP lease discovery.
- `MGMT_MODE=bridge`: attaches mgmt NIC to `MGMT_BRIDGE` (must exist).

## Docs

- `docs/runbooks/opentofu-libvirt.md`
- `docs/runbooks/network-modes.md`
- `docs/standards.md`
