## Why
We need a clear Phase 2 proof that Swarm can run normal services alongside VM runner services (QEMU/KVM) without privileged containers. This validates the core PoC direction and unblocks deeper Linux/Windows work.

## What Changes
- Add a minimal Linux VM runner Swarm service template (no privileged, /dev/kvm only).
- Add a normal Swarm service template used for coexistence validation.
- Add Ansible-first smoke tests to validate both services and basic VM reachability.
- Document networking and access paths (TAP/br0 + DHCP reservations).

## Capabilities

### New Capabilities
- `swarm-vm-runner-linux-demo`: Run a Linux VM inside a Swarm service container using QEMU/KVM.
- `swarm-service-coexistence`: Validate normal services and VM runner services running together.
- `phase2-ansible-smoke`: Ansible-based smoke checks for Phase 2 demo.

### Modified Capabilities
- (none)

## Impact
- New playbooks under `ansible/anisble-poc_qemu/`.
- Swarm service examples and docs updates.
- New OpenSpec specs/tasks for Phase 2 demo.
