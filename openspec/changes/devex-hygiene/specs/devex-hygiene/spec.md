## ADDED Requirements

### Requirement: Makefile UX targets
The system SHALL provide developer experience targets for diagnostics, cleanup, and snapshot/restore.

#### Scenario: Doctor target
- **WHEN** `make doctor` is executed
- **THEN** it runs env/tools checks, tofu validate, and best-effort connectivity checks

#### Scenario: Clean and reset targets
- **WHEN** `make clean` is executed
- **THEN** it removes safe local artifacts without destroying VMs

### Requirement: Standards documentation
The system SHALL document naming conventions, MAC derivation, and inventory schema versioning.

#### Scenario: Standards doc exists
- **WHEN** a developer checks documentation
- **THEN** `docs/standards.md` describes naming and schema rules

### Requirement: CI hygiene workflow
The system SHALL include a minimal CI workflow that runs lint/format checks without requiring libvirt.

#### Scenario: CI checks
- **WHEN** CI runs
- **THEN** shellcheck and tofu fmt/validate execute without provisioning

### Requirement: Placeholder specs
The system SHALL include placeholder specs for future work (Phase 2 and snapshot/restore).

#### Scenario: Placeholder specs exist
- **WHEN** specs are listed
- **THEN** phase2 and snapshot/restore specs are present and marked draft
