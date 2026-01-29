## ADDED Requirements

### Requirement: Failure artifact collection
The system SHALL collect diagnostic artifacts into a timestamped archive under `work/artifacts/`.

#### Scenario: Artifact bundle created
- **WHEN** `make collect-logs` runs
- **THEN** it creates a tar.gz archive containing inventory, tofu outputs, and libvirt diagnostics

### Requirement: Best-effort remote log collection
The system SHALL attempt to collect cloud-init and Ansible logs from nodes when reachable.

#### Scenario: Remote logs best-effort
- **WHEN** SSH access is available
- **THEN** cloud-init and Ansible logs are included in the archive if present
