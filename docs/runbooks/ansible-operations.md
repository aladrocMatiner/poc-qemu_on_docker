# Ansible Operations

## Purpose
Configure lab VMs using Ansible playbooks and generated inventory.

## Inventory generation
```bash
$ make lab-status
$ make ansible-inventory  # generate inventory.ini from lab outputs
```

## Run playbooks
```bash
$ make ansible-ping       # verify SSH connectivity to all nodes
$ make ansible-baseline   # apply baseline OS configuration
$ make ansible-docker     # install and enable Docker
$ make ansible-swarm      # initialize/join Docker Swarm
$ make ansible-verify     # verify Docker + Swarm state
```

## Common failures
- SSH auth: verify `ANSIBLE_SSH_PRIVATE_KEY` and `SSH_USER`.
- Missing inventory: run `make lab-status` then `make ansible-inventory`.
- Python missing on guest: install via baseline playbook.
