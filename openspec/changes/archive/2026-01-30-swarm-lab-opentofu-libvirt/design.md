## Context

The Phase 1 lab is moving to OpenTofu + libvirt for VM provisioning. We need reproducible VM creation, deterministic naming/MACs, and a stable inventory contract that downstream tooling (SSH, Ansible, smoke tests) can rely on. Constraints include no destructive defaults, no privileged Swarm services, and support for two management access modes (user/bridge).

## Goals / Non-Goals

**Goals:**
- Provision N lab VMs via libvirt with OpenTofu and deterministic naming.
- Produce stable outputs and inventory inputs for access tooling.
- Support MGMT_MODE=user (libvirt NAT + DHCP lease discovery) and MGMT_MODE=bridge (host bridge).

**Non-Goals:**
- Building a production-grade provisioning platform.
- Auto-creating host bridges or modifying host network state.

## Decisions

- Use OpenTofu with `dmacvicar/libvirt` provider and `qemu:///system` URI.
  - Rationale: stable provider, widely used for local libvirt labs.
- Represent MGMT_MODE=user as libvirt NAT network with DHCP discovery (ADR 0001).
  - Rationale: safer defaults and portable across distros.
- Define a stable inventory schema for downstream tools (ADR 0002).
  - Rationale: multiple subsystems need consistent fields.
- Split configuration responsibilities:
  - cloud-init: minimal bootstrap (SSH user/keys, hostname)
  - Ansible: full configuration (Docker, Swarm, optional hardening)

## Risks / Trade-offs

- [DHCP lease discovery may fail] → Provide explicit IP overrides and clear error messages.
- [State drift in libvirt] → Encourage `tofu plan` checks and clean destroy/reapply flow.
- [Bridge availability differs by host] → Validate and fail fast when required bridges are missing.

## Migration Plan

1. Add OpenTofu infra layout and provider configuration.
2. Implement inventory outputs and access tooling.
3. Update Make targets to use tofu for lab lifecycle.
4. Document workflows and runbooks.

## Open Questions

- Should inventory schema include explicit schema_version and mgmt_network name?
- Do we need a dedicated libvirt network for MGMT_MODE=user beyond `default`?
