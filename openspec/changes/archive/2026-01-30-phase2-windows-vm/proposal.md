## Why
To complete the Phase 2 PoC, we must demonstrate that a Windows VM can run inside a Swarm-managed VM runner container, with reliable access and drivers. This validates the multi-OS promise.

## What Changes
- Add a Windows VM runner service definition (QEMU + virtio drivers).
- Add Ansible playbooks for Windows VM validation (WinRM/RDP reachability).
- Document external artifacts (Windows ISO, virtio ISO) and required variables.

## Capabilities

### New Capabilities
- `windows-vm-runner-baseline`: Windows VM runner service with virtio drivers.
- `windows-vm-validate`: Ansible validation for Windows VM boot and access.

### Modified Capabilities
- (none)

## Impact
- New playbooks under `ansible/anisble-poc_qemu/`.
- Documentation updates for Windows artifacts and access.
- New OpenSpec specs/tasks for Windows VM runner support.
