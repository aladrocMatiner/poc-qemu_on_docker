## ADDED Requirements

### Requirement: Baseline cloud-init templates
The system SHALL provide baseline cloud-init templates (user-data and meta-data) used for all lab VMs.

#### Scenario: Hostname set per node
- **WHEN** a VM boots from the baseline cloud-init templates
- **THEN** its hostname matches the lab naming convention (e.g., `${LAB_NAME}-node1`)

#### Scenario: SSH access enabled
- **WHEN** a VM boots from the baseline cloud-init templates
- **THEN** the configured SSH user can authenticate using the provided public key

### Requirement: Docker installation via cloud-init
The system SHALL install Docker on each VM during cloud-init execution.

#### Scenario: Docker is available after boot
- **WHEN** cloud-init finishes on a lab VM
- **THEN** Docker is installed and the Docker service is running
