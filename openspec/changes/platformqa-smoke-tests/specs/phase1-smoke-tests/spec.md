## ADDED Requirements

### Requirement: Smoke test matrix
The system SHALL define a minimal smoke-test matrix that covers MGMT_MODE=user and optionally MGMT_MODE=bridge.

#### Scenario: User-mode required
- **WHEN** smoke tests are run
- **THEN** MGMT_MODE=user is included by default

#### Scenario: Bridge-mode optional
- **WHEN** bridge mode is configured
- **THEN** MGMT_MODE=bridge smoke tests are included if requested

### Requirement: End-to-end smoke sequence
The system SHALL provide a canonical make-driven smoke sequence for Phase 1.

#### Scenario: Happy path
- **WHEN** `make smoke` is executed
- **THEN** it runs bootstrap, lab-up, inventory, Ansible configuration, verify, and lab-destroy

### Requirement: Idempotency checks
The system SHALL provide an idempotency smoke run that replays key steps.

#### Scenario: Re-run without changes
- **WHEN** `make smoke-idempotent` is executed
- **THEN** it re-runs core steps without failure

### Requirement: Failure diagnostics
The system SHALL document how to collect failure artifacts and logs.

#### Scenario: Failure triage guidance
- **WHEN** a smoke test fails
- **THEN** a runbook describes artifact collection and triage
