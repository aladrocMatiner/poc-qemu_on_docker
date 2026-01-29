## Context

Phase 1 lab VMs are provisioned via OpenTofu/libvirt. To keep VM boot fast and reliable, cloud-init should only bootstrap access, while Ansible applies the full configuration (packages, Docker, Swarm). We need a stable inventory pipeline and Make targets that drive Ansible consistently.

## Goals / Non-Goals

**Goals:**
- Provide an Ansible subsystem with inventories, roles, and playbooks.
- Generate inventory from `work/inventory.json`.
- Ensure idempotent playbooks and a consistent Make interface.

**Non-Goals:**
- Full production hardening or advanced secrets management.
- Multi-tenant Ansible automation.

## Decisions

- Keep cloud-init minimal (SSH user/keys, hostname only).
- Use Ansible for packages, Docker, Swarm, and verification.
- Inventory generation is derived from `work/inventory.json` to keep contracts stable.
- Provide Make targets for baseline, docker, swarm, verify, and generic run.

## Risks / Trade-offs

- [SSH connectivity issues] → Provide `ansible-ping` and clear inventory errors.
- [Idempotency drift] → Include verify playbook and re-run smoke checks.
- [Inventory contract changes] → Require ADR and schema version bump.

## Migration Plan

1. Add `ansible/` layout, playbooks, and roles.
2. Add inventory generation scripts from `work/inventory.json`.
3. Update Make targets and runbooks.
4. Update cloud-init spec to minimal bootstrap.

## Open Questions

- Should we pin specific Ansible collections for Docker modules or use shell tasks only?
