# Ansible

This folder contains playbooks and roles to configure lab VMs after provisioning.

## Quick usage
```bash
$ make ansible-inventory
$ make ansible-ping
$ make ansible-baseline
$ make ansible-docker
$ make ansible-swarm
$ make ansible-verify
```

## Phase 2 PoC playbooks
Playbooks for the QEMU-in-container PoC live under `ansible/anisble-poc_qemu/`.
```bash
$ make ansible-swarm-poc-qemu-demo
$ make ansible-swarm-poc-qemu-linux
$ make ansible-swarm-poc-qemu-windows
```

Case-based shortcuts (up/down):

Case 00: vanilla services (two normal containers on different nodes). Goal: validate overlay connectivity between services.
```bash
$ make ansible-swarm-poc-qemu-case00-up
$ make ansible-swarm-poc-qemu-case00-test
$ make ansible-swarm-poc-qemu-case00-exec-list
$ make ansible-swarm-poc-qemu-case00-exec <container_name>
$ make ansible-swarm-poc-qemu-case00-down
```

Case 01: Linux VM runner (usable pipeline). Goal: same base overlay validation as Case 00, plus a Linux VM runner service.
```bash
$ make ansible-swarm-poc-qemu-case01-up
$ make ansible-swarm-poc-qemu-case01-test
$ make ansible-swarm-poc-qemu-case01-exec-list
$ make ansible-swarm-poc-qemu-case01-exec <container_name>
$ make ansible-swarm-poc-qemu-case01-down
```
Note: case01-test expects a VM SSH key at `/var/lib/vmrunner/keys/id_ed25519` on the host.
Note: `make ansible-swarm` auto-labels nodes with `vm-capable=true` when `/dev/kvm` is present.

Case 02: Windows VM runner
```bash
$ make ansible-swarm-poc-qemu-case02-up
$ make ansible-swarm-poc-qemu-case02-down
```

Roles used by Phase 2 playbooks:
- `roles/swarm_stack`
- `roles/swarm_stack_status`
- `roles/phase2_demo`
- `roles/vm_runner_linux`
- `roles/vm_runner_windows`

## Inventory
Generated inventory is written to `ansible/inventories/generated/inventory.ini`.
