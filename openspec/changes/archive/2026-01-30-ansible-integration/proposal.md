## Why

Cloud-init should stay minimal to keep VM boot reliable and fast, while Ansible provides the repeatable, idempotent configuration for Docker, Swarm, and optional hardening. This separation improves maintainability and testability.

## What Changes

- Introduce an Ansible subsystem with inventories, roles, and playbooks.
- Generate Ansible inventory from the lab inventory contract.
- Move full configuration to Ansible (packages, Docker, Swarm prerequisites).
- Update Make targets and runbooks to include Ansible workflows.
- Update cloud-init baseline requirements to minimal bootstrap only.

## Capabilities

### New Capabilities
- `ansible-vm-configuration`: Configure lab VMs via Ansible playbooks and roles using generated inventory.

### Modified Capabilities
- `cloudinit-baseline`: Reduce cloud-init to minimal bootstrap (SSH user/keys/hostname) and defer configuration to Ansible.

## Impact

- New `ansible/` directory with inventory, roles, and playbooks.
- Updates to scripts, Make targets, and runbooks.
- Updated specs for cloud-init baseline scope.
