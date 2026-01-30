## Context
Phase 2 demo proves coexistence; this change makes the Linux VM runner repeatable and usable by standardizing qcow2/cloud-init inputs, DHCP reservations, and Ansible validations. All checks remain Ansible-driven.

## Goals / Non-Goals

**Goals:**
- Define a reproducible Linux VM runner pipeline (qcow2 + cloud-init + deterministic MAC/IP).
- Provide Ansible validation for VM boot, IP assignment, and access.
- Document storage layout and troubleshooting for Linux VM runners.

**Non-Goals:**
- Windows VM support (handled in a separate change).
- Performance tuning or benchmarking.
- Non-Ansible validation.

## Decisions

1) **Reuse existing cloud-init and qcow2 layout**
- Keep base image in `work/downloads` and per-VM qcow2 in libvirt pool or VM runner volume layout.
- Rationale: aligns with Phase 1 pipeline and avoids rework.
- Alternative: custom image builder pipeline (deferred).

2) **Ansible-driven validation**
- Use playbooks under `ansible/anisble-poc_qemu` for VM boot and SSH checks.
- Rationale: consistent with project standard and enables repeatable tests.

3) **DHCP reservations by MAC**
- VM runner uses deterministic MAC and DHCP reservations for stable IPs.
- Rationale: avoids static IPs in Swarm; meets constraints.

## Risks / Trade-offs
- **DHCP dependency** → Mitigation: document DHCP reservation requirements and fallback to manual IP vars.
- **Cloud-init variability** → Mitigation: keep minimal, deterministic config; verify `cloud-init status`.
- **Storage permissions** → Mitigation: default pool path in system directory and document overrides.
