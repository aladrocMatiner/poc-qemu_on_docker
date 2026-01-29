## ADDED Requirements

### Requirement: Inventory schema contract
The system SHALL produce a stable `work/inventory.json` that follows a documented schema contract.

#### Scenario: Inventory fields present
- **WHEN** `make lab-status` is executed after provisioning
- **THEN** the inventory includes `lab_name`, `schema_version`, and `nodes[]` entries with required fields

### Requirement: Inventory validation
The system SHALL provide a way to validate the inventory schema fields for consistency.

#### Scenario: Schema validation
- **WHEN** the inventory is validated
- **THEN** missing required fields are reported as errors
