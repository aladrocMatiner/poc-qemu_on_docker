# poc-qemu_on_docker

PoC: Docker Swarm + QEMU/KVM lab with OpenTofu/libvirt provisioning.

## Phase 1 Quickstart

1. Copy env and edit:

```bash
$ cp .env.example .env
$ ${EDITOR:-nano} .env
```

Notes:
- `SWARM_BRIDGE` must exist on the host (default `br0`).
- If you do not have a bridge yet, create one with:
  `HOST_NETWORK_ASSUME_YES=1 make host-network-setup`
  (this creates the bridge only; it does not attach a NIC or assign IPs).
- Lab domains disable AppArmor confinement via libvirt `seclabel` injection
  (`infra/modules/swarm_lab/domain-seclabel-none.xslt`) to avoid disk access
  denials.

2. Bootstrap host tools:

```bash
$ make bootstrap
```

If bootstrap adds you to `libvirt`, `kvm`, or `docker` groups, log out/in to apply.

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
$ make ansible-bootstrap  # install required Ansible collections
$ make ansible-inventory  # generate inventory.ini from lab outputs
$ make ansible-ping       # verify SSH connectivity to all nodes
$ make ansible-baseline   # apply baseline OS configuration
$ make ansible-docker     # install and enable Docker
$ make ansible-swarm      # initialize/join Docker Swarm
$ make ansible-verify     # verify Docker + Swarm state
```

6. Optional smoke tests:

```bash
$ make smoke
```

7. Developer diagnostics:

```bash
$ make doctor
```

`make doctor` runs `tofu validate`, so ensure `make lab-init` has been run at least once.

## Management Modes

- `MGMT_MODE=user` (default): uses libvirt NAT network and DHCP lease discovery.
- `MGMT_MODE=bridge`: attaches mgmt NIC to `MGMT_BRIDGE` (must exist).

## Docs

- `docs/runbooks/opentofu-libvirt.md`
- `docs/runbooks/network-modes.md`
- `docs/standards.md`
