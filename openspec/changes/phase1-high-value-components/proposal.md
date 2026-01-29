## Why

Phase 1 needs a few core operational components (inventory contract, opt-in host network setup, secrets policy, diagnostics, and Windows baseline placeholders) to make the lab reproducible, safe, and debuggable.

## What Changes

- Define an explicit inventory schema contract and spec.
- Add an opt-in host network setup helper with safe defaults.
- Document secrets handling policy and update guardrails.
- Add failure artifact collection tooling and runbook.
- Add a Windows VM baseline placeholder spec for future work.

## Capabilities

### New Capabilities
- `inventory-contract`: Define and validate the `work/inventory.json` schema contract.
- `host-network-setup`: Provide an explicit, opt-in host bridge creation helper.
- `failure-artifact-collection`: Capture diagnostic artifacts for failures.
- `windows-vm-baseline`: Placeholder spec for Windows VM baseline requirements.

### Modified Capabilities
- (none)

## Impact

- New specs, skills, scripts, and runbooks.
- Updates to guardrails and Make targets.
