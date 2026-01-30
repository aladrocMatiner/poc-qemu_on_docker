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
Roles used by Phase 2 playbooks:
- `roles/swarm_stack`
- `roles/swarm_stack_status`
- `roles/vm_runner_linux`
- `roles/vm_runner_windows`

## Inventory
Generated inventory is written to `ansible/inventories/generated/inventory.ini`.
