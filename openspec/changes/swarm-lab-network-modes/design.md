## Context

The lab requires two management networking modes to support different host environments. We must keep defaults safe and portable, while always attaching a swarm NIC to `SWARM_BRIDGE` for L2 connectivity. Decisions are constrained by libvirt behavior and the need for deterministic access tooling.

## Goals / Non-Goals

**Goals:**
- Support `MGMT_MODE=user` via libvirt NAT network with DHCP lease discovery.
- Support `MGMT_MODE=bridge` via host bridge attachment.
- Keep deterministic MAC addressing and stable SSH access behavior.

**Non-Goals:**
- Creating or modifying host bridges automatically.
- Implementing complex L2/L3 automation beyond required connectivity.

## Decisions

- Map `MGMT_MODE=user` to libvirt NAT network and DHCP lease discovery (ADR 0001).
- Require `MGMT_BRIDGE` to exist for bridge mode; fail fast if missing.
- Always attach swarm NIC to `SWARM_BRIDGE` with deterministic MACs.
- Provide access guidance through inventory output and runbook updates.

## Risks / Trade-offs

- [DHCP leases unavailable] → Provide manual IP override and clear error messaging.
- [Bridge mismatch] → Fail fast and document required setup steps.
- [MAC collisions] → Use deterministic MAC scheme with clear offsets.

## Migration Plan

1. Define env validation for MGMT_MODE and bridges.
2. Implement NIC wiring based on MGMT_MODE in infra module.
3. Update inventory/SSH tooling for IP discovery and fallback guidance.
4. Update runbooks and quickstart documentation.

## Open Questions

- Should we allow explicit mgmt network name override for libvirt NAT networks?
- Do we need to record mgmt network name in inventory schema versioning?
