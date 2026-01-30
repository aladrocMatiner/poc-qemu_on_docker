## Why

We need to prove that a Swarm service can run a Windows VM (via QEMU/KVM in a container) alongside normal services, with a repeatable workflow for boot media, drivers, and access validation.

## What Changes

- Define a Phase 2 Windows VM runner service that boots from a Windows ISO plus virtio drivers, using deterministic VM settings and minimal container privileges.
- Add Ansible automation to prepare Windows VM assets on nodes, deploy the runner stack, and validate access (RDP/WinRM) and basic connectivity.
- Provide docs and runbooks describing required ISO paths, driver media, and troubleshooting.

## Capabilities

### New Capabilities
- `vm-runner-windows-service`: Run a Windows VM inside a Swarm service container using QEMU/KVM with external ISO/virtio media and deterministic VM configuration.
- `vm-runner-windows-assets`: Prepare and distribute Windows VM assets (ISO, virtio ISO, base disk, seed/keys) on all vm-capable nodes.
- `phase2-case02-windows-vm`: Ansible-driven deployment and validation of the Windows VM runner stack.

### Modified Capabilities
- (none)

## Impact

- New/updated Ansible roles and playbooks for Windows VM runner provisioning and validation.
- Swarm stack definition for the Windows VM runner service and required environment variables for ISO paths.
- Documentation and runbooks covering ISO handling, driver media, and access validation.
