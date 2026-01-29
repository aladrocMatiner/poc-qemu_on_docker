# ADR 0001: MGMT_MODE=user behavior under libvirt

## Date
2026-01-29

## Status
Proposed

## Context
The Phase 1 lab uses libvirt for VM provisioning. We need a predictable meaning for MGMT_MODE=user that works across distros and avoids unsafe host networking changes. Historically, user-mode QEMU implied hostfwd SSH ports, but libvirt does not expose simple hostfwd by default.

## Decision
MGMT_MODE=user will map to libvirt's default NAT network (typically `default`) and rely on DHCP lease discovery to obtain VM management IPs. Inventory generation will match leases by deterministic MACs. If IPs are not discoverable, users can supply explicit IPs in `.env` as a fallback.

## Consequences
- SSH access uses VM IPs from libvirt DHCP leases (or user-supplied IPs), not hostfwd ports.
- Inventory generation must query `virsh net-dhcp-leases` and match MACs.
- Simpler, safer behavior but requires libvirt network to be active and DHCP leases visible.

## Alternatives considered
- Hostfwd port mappings per VM
  - Rejected: libvirt does not provide a clean, portable hostfwd interface without custom network XML or manual iptables.

## Links
- Spec: `specs/tofu-inventory-access.yaml`
- Spec: `specs/libvirt-host-setup.yaml`
- Runbook: `docs/runbooks/opentofu-libvirt.md`
