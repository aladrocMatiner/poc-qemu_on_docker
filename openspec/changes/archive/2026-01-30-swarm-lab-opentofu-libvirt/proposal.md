## Why

We need a deterministic, repeatable way to provision the Phase 1 Swarm lab VMs with consistent networking and cloud-init configuration. Moving to OpenTofu + libvirt standardizes provisioning and aligns the lab workflow with declarative infrastructure.

## What Changes

- Introduce OpenTofu-based provisioning for local QEMU/KVM lab via libvirt (`qemu:///system`).
- Add cloud-init templates to configure VMs (install Docker, set hostnames, prepare Swarm roles).
- Update bootstrap and checks to install/verify OpenTofu, libvirt, and cloud-init tooling.
- Update Make targets and scripts to use OpenTofu as the control plane.
- Add new skills and runbooks for OpenTofu/libvirt and cloud-init.
- Add a new spec defining acceptance tests for the OpenTofu/libvirt lab.

## Capabilities

### New Capabilities
- `libvirt-host-setup`: Prepare the host for a libvirt-based VM lab with safe, non-destructive defaults.
- `cloudinit-baseline`: Define baseline cloud-init templates for lab VMs (SSH access, hostname, Docker install).
- `tofu-inventory-access`: Provide reliable inventory and SSH access derived from OpenTofu outputs and libvirt leases.

### Modified Capabilities
- (none)

## Impact

- New `infra/` layout and OpenTofu module for VM provisioning.
- Updates to `.env.example`, `Makefile`, and `scripts/` to use OpenTofu.
- New runbooks and skill documentation for libvirt, cloud-init, and tofu integration.
