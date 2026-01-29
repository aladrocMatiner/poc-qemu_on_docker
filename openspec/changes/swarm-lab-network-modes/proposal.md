## Why

We need a reliable, repeatable way to manage Phase 1 lab access across hosts with varying network setups. Supporting both user-mode and bridge-mode management networks improves safety and realism while keeping defaults robust.

## What Changes

- Add selectable management networking modes via `.env` (user-mode vs bridge-mode).
- Implement mode-aware VM NIC wiring in lab scripts without changing top-level commands.
- Add helper functions for consistent node naming, MAC assignment, and SSH access.
- Document both modes, host requirements, and troubleshooting.
- Add a spec and acceptance tests for the two networking modes.

## Capabilities

### New Capabilities
- `swarm-lab-network-modes`: Provide selectable management networking modes for the local Swarm QEMU lab (user-mode with hostfwd SSH, or bridge-mode with a management bridge), while always attaching the swarm NIC to `br0`.

### Modified Capabilities
- (none)

## Impact

- New/updated scripts in `scripts/` (env validation, VM create/up, SSH helper).
- Updates to `.env.example`, `Makefile`, and `docs/runbooks/network-modes.md`.
- New spec in `specs/` and index registration.
