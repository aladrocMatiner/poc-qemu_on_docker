# ADR 0002: Inventory contract for Phase 1 lab

## Date
2026-01-29

## Status
Proposed

## Context
Multiple subsystems (Make targets, SSH access, Ansible inventory generation) rely on a consistent `work/inventory.json`. Without a stable contract, automation breaks when fields change.

## Decision
Define a minimal, versioned inventory schema with stable fields:
- `lab_name`
- `schema_version`
- `nodes[]` entries with `index`, `name`, `mgmt_mac`, `swarm_mac`, optional `mgmt_ip`, and `ssh_target`.

Inventory generation is responsible for best-effort IP discovery and MUST emit actionable `ssh_target` guidance if IPs are unknown.

## Consequences
- Inventory changes require version bumps and updates to dependent tooling.
- PlatformQA owns acceptance tests that validate schema and key fields.

## Alternatives considered
- Ansible-only inventory without a JSON contract
  - Rejected: multiple tools need a shared, stable format.

## Links
- Spec: `specs/tofu-inventory-access.yaml`
- Spec: `specs/inventory-contract.yaml`
- Runbook: `docs/inventory-schema.md`
