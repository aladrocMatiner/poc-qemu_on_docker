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

## Inventory
Generated inventory is written to `ansible/inventories/generated/inventory.ini`.
