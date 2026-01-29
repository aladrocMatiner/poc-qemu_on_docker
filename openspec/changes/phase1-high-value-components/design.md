## Context

Phase 1 lab operations now rely on multiple subsystems (OpenTofu, libvirt, cloud-init, Ansible). To keep the workflow reliable and debuggable, we need explicit contracts, opt-in host helpers, diagnostics collection, and placeholder specs for future Windows support.

## Goals / Non-Goals

**Goals:**
- Define a stable inventory schema and validation.
- Provide a safe, opt-in host network setup helper.
- Add failure artifact collection for debugging.
- Add a Windows baseline placeholder spec for future work.

**Non-Goals:**
- Automating destructive host networking changes without explicit opt-in.
- Implementing full Windows provisioning now.

## Decisions

- Inventory contract will be documented and validated via a dedicated spec and doc.
- Host network setup helper will require `HOST_NETWORK_ASSUME_YES=1` and never run automatically.
- Log collection will be best-effort and non-destructive.
- Windows baseline spec will remain draft with TBD acceptance tests.

## Risks / Trade-offs

- [Inventory schema drift] → Define schema versioning and acceptance tests.
- [Host helper misuse] → Require explicit confirmation and document rollback.
- [Incomplete diagnostics] → Make log collection best-effort with clear scope.

## Migration Plan

1. Add inventory schema doc/spec and validation hooks.
2. Add opt-in host network setup helper and runbook.
3. Add failure artifact collection script and runbook.
4. Add Windows baseline placeholder spec.

## Open Questions

- Should inventory schema validation be a standalone script or part of `make doctor`?
