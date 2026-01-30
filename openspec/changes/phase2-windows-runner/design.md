## Context

Phase 2 extends the Swarm lab to validate QEMU-in-container runners. After the Linux runner, we need a Windows VM runner that boots from external ISO media with virtio drivers and provides a repeatable validation workflow. Constraints include nested virtualization availability and handling large ISO assets outside the repo.

## Goals / Non-Goals

**Goals:**
- Run a Windows VM in a Swarm service container using QEMU/KVM with ISO + virtio media.
- Provide deterministic VM configuration (name, MAC, disk, ISO paths) via environment variables.
- Automate asset preparation and validation via Ansible playbooks.

**Non-Goals:**
- Fully automated Windows installation beyond initial boot media usage.
- Production-grade security hardening or multi-tenant isolation.
- Managing Windows licensing or ISO distribution policies.

## Decisions

- **Host-mounted ISO assets.**
  Windows and virtio ISOs are mounted into the container from host paths, avoiding large files in the repo and enabling user-managed media.

- **Minimal privileges, no --privileged.**
  Use /dev/kvm, /dev/net/tun, and NET_ADMIN capability for TAP/bridge wiring while avoiding full privileges.

- **Deterministic configuration via env.**
  VM name, MAC, disk, and ISO paths are provided through environment variables so Ansible can template stacks consistently.

- **Validation via RDP/WinRM readiness checks.**
  Ansible validation focuses on basic reachability and service readiness, not full Windows configuration management.

## Risks / Trade-offs

- **ISO availability and licensing** → Users must provide ISOs locally; mitigate with clear runbook instructions.
- **Nested KVM limitations** → Hosts without /dev/kvm cannot run the VM runner; mitigate with node labeling and scheduling constraints.
- **Windows boot times** → Provisioning may be slow; mitigate with timeouts and retry logic in validation.

## Migration Plan

- Add Windows VM runner stack and Ansible roles for asset prep and validation.
- Deploy case02 via Ansible and validate access.
- Roll back by removing the stack and cleaning runner assets.

## Open Questions

- Should the Windows runner use host networking or bridged TAP with a dedicated bridge?
- Do we need optional unattended install support (autounattend.xml) for repeatable setup?
- What is the minimum validation signal for Windows readiness (WinRM vs RDP)?
