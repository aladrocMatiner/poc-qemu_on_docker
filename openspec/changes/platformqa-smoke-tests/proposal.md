## Why

We need a stable, reproducible smoke-test suite that validates the full Phase 1 workflow across MGMT_MODE variants and ensures specs remain verifiable.

## What Changes

- Define a canonical smoke-test matrix and acceptance sequence.
- Add Make targets for smoke and idempotency checks.
- Add runbook for failure triage and artifacts collection.
- Add a spec for Phase 1 smoke tests.

## Capabilities

### New Capabilities
- `phase1-smoke-tests`: Define and execute the canonical Phase 1 smoke-test suite.

### Modified Capabilities
- (none)

## Impact

- New spec and runbook.
- New Make targets for smoke/test matrix.
- Updates to README and testing guidance.
