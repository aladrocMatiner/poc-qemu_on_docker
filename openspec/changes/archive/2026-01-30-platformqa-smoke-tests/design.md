## Context

Phase 1 relies on multiple systems (OpenTofu/libvirt, inventory generation, Ansible configuration). We need a consistent smoke suite that validates the workflow and enforces a test contract across specs.

## Goals / Non-Goals

**Goals:**
- Define a canonical smoke sequence using Make targets.
- Provide idempotency checks and failure diagnostics guidance.
- Ensure tests are non-interactive and reproducible.

**Non-Goals:**
- Full integration testing or performance benchmarks.
- Running libvirt-dependent tests in CI.

## Decisions

- Smoke tests will use Make targets to keep execution consistent.
- MGMT_MODE=user is the default required path; bridge mode is optional.
- Failure diagnostics will point to log collection tooling and inventory artifacts.

## Risks / Trade-offs

- [Bridge mode variability] → Treat as optional but recommended.
- [Non-deterministic SSH] → Require inventory contract and Ansible ping checks.
- [CI environment limits] → Keep CI to lint/format only.

## Migration Plan

1. Add smoke targets and idempotency target.
2. Add runbook for smoke tests and failure artifacts.
3. Update specs to reference smoke suite.

## Open Questions

- Should smoke-idempotent skip lab-destroy to preserve state for debugging?
