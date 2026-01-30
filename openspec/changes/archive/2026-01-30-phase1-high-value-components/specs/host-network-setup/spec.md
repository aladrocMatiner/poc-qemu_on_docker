## ADDED Requirements

### Requirement: Opt-in host bridge creation
The system SHALL provide an explicit, opt-in helper to create required host bridges without altering existing networking by default.

#### Scenario: Confirmation required
- **WHEN** `host-network-setup` is invoked without confirmation
- **THEN** it refuses to run and prints an actionable message

#### Scenario: Bridges created on opt-in
- **WHEN** `HOST_NETWORK_ASSUME_YES=1` is set and the helper is invoked
- **THEN** it creates `SWARM_BRIDGE` and `MGMT_BRIDGE` if missing

### Requirement: Rollback guidance
The system SHALL document how to revert host bridge creation.

#### Scenario: Rollback documented
- **WHEN** the runbook is consulted
- **THEN** it includes commands to remove created bridges
