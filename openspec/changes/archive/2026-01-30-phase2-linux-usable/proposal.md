## Why
The Phase 2 demo needs a reproducible, repeatable Linux VM runner pipeline so we can validate networking, access, and lifecycle without manual steps. This improves confidence before adding Windows.

## What Changes
- Define a Linux VM runner pipeline (qcow2 + cloud-init + DHCP reservation by MAC).
- Add Ansible playbooks to validate Linux VM boot, IP assignment, and access.
- Document storage layout and troubleshooting for the Linux VM runner.

## Capabilities

### New Capabilities
- `linux-vm-runner-pipeline`: Reproducible Linux VM runner images and cloud-init seeds.
- `linux-vm-runner-validate`: Ansible validation of Linux VM boot, IP, and access.

### Modified Capabilities
- (none)

## Impact
- New/updated playbooks under `ansible/anisble-poc_qemu/`.
- Storage/runbook documentation updates.
- New OpenSpec specs/tasks for Linux VM runner usability.
