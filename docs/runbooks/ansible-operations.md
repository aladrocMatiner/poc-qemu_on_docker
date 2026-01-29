# Ansible Operations

## Purpose
Configure lab VMs using Ansible playbooks and generated inventory.

## Inventory generation
```bash
$ make lab-status
$ make ansible-inventory
```

## Run playbooks
```bash
$ make ansible-ping
$ make ansible-baseline
$ make ansible-docker
$ make ansible-swarm
$ make ansible-verify
```

## Common failures
- SSH auth: verify `ANSIBLE_SSH_PRIVATE_KEY` and `SSH_USER`.
- Missing inventory: run `make lab-status` then `make ansible-inventory`.
- Python missing on guest: install via baseline playbook.
