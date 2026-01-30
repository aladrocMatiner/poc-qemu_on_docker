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
  `HOST_NETWORK_ASSUME_YES=1 make host-network-setup`  # create bridges only (no NIC attach)
  (this creates the bridge only; it does not attach a NIC or assign IPs).
- Libvirt `seclabel` handling is controlled by `LIBVIRT_SECLABEL_MODE`
  (default `auto`).
- If you see libvirt permission errors on qcow2 files, set `POOL_PATH` to a
  system path like `/var/lib/libvirt/images/<lab>-pool`.

2. Bootstrap host tools:

```bash
$ make bootstrap    # install prerequisites
```

If bootstrap adds you to `libvirt`, `kvm`, or `docker` groups, log out/in to apply.

3. Initialize and apply lab:

```bash
$ make lab-init     # init OpenTofu
$ make image-fetch   # download base cloud image
$ make lab-up        # provision VMs via OpenTofu/libvirt
```

4. Generate inventory and inspect status:

```bash
$ make lab-status   # generate inventory + show status
```

If SSH access is not ready yet, you can use the serial console:

```bash
$ make lab-ssh NODE=1       # SSH via inventory (if IP known)
$ make lab-console NODE=1   # serial console access
```

5. Configure with Ansible:

```bash
$ make ansible-all        # run full Ansible flow end-to-end
# or:
$ make ansible-bootstrap  # install required Ansible collections
$ make ansible-inventory  # generate inventory.ini from lab outputs
$ make ansible-ping       # verify SSH connectivity to all nodes
$ make ansible-baseline   # apply baseline OS configuration
$ make ansible-docker     # install and enable Docker
$ make ansible-swarm      # initialize/join Docker Swarm
$ make ansible-verify     # verify Docker + Swarm state
$ make ansible-swarm-status  # show swarm status from manager
```

6. Optional smoke tests:

```bash
$ make smoke        # full end-to-end smoke
```

7. Developer diagnostics:

```bash
$ make doctor       # environment + toolchain checks
```

`make doctor` runs `tofu validate`, so ensure `make lab-init` has been run at least once.

## Management Modes

- `MGMT_MODE=user` (default): uses libvirt NAT network and DHCP lease discovery. If `MGMT_NETWORK_CIDR` is set, the lab creates the network and reserves fixed IPs starting at `MGMT_IP_START` (use a non-default `MGMT_NETWORK` name).
- `MGMT_MODE=bridge`: attaches mgmt NIC to `MGMT_BRIDGE` (must exist).

## Phase 2 (QEMU-in-Container PoC)

Phase 2 runs Swarm services that include VM runner containers (Linux first, then Windows).

Case 00: demo stack (normal services + Linux VM runner)
```bash
$ make ansible-swarm-poc-qemu-case00-up
$ make ansible-swarm-poc-qemu-case00-down
```

Case 01: Linux VM runner (usable pipeline)
```bash
$ make ansible-swarm-poc-qemu-case01-up
$ make ansible-swarm-poc-qemu-case01-down
```

Case 02: Windows VM runner
```bash
$ make ansible-swarm-poc-qemu-case02-up
$ make ansible-swarm-poc-qemu-case02-down
```

## Docs

- `docs/runbooks/opentofu-libvirt.md`
- `docs/runbooks/network-modes.md`
- `docs/standards.md`
- `docs/phase2.md`
