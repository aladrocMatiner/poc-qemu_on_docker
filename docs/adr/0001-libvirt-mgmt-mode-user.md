# ADR 0001: MGMT_MODE=user behavior under libvirt

## Date
2026-01-29

## Status
Proposed

## Context
The Phase 1 lab uses libvirt for VM provisioning. We need a predictable meaning for MGMT_MODE=user that works across distros and avoids unsafe host networking changes. Historically, user-mode QEMU implied hostfwd SSH ports, but libvirt does not expose simple hostfwd by default.

## Decision
MGMT_MODE=user maps to a libvirt NAT network and relies on DHCP lease discovery to obtain VM management IPs. If `MGMT_NETWORK_CIDR` is set, the lab creates/manages the network and reserves fixed IPs starting at `MGMT_IP_START`. Inventory generation matches leases by deterministic MACs. If IPs are not discoverable, users can supply explicit IPs in `.env` as a fallback.

## Consequences
- SSH access uses VM IPs from libvirt DHCP leases (or reserved IPs when `MGMT_NETWORK_CIDR` is set), not hostfwd ports.
- Inventory generation must query `virsh net-dhcp-leases` and match MACs.
- Simpler, safer behavior but requires a libvirt network to be active and DHCP leases visible.

## Alternatives considered
- Hostfwd port mappings per VM
  - Rejected: libvirt does not provide a clean, portable hostfwd interface without custom network XML or manual iptables.

## Links
- Spec: `specs/tofu-inventory-access.yaml`
- Spec: `specs/libvirt-host-setup.yaml`
- Runbook: `docs/runbooks/opentofu-libvirt.md`
