## MODIFIED Requirements

### Requirement: Baseline cloud-init templates
The system SHALL provide minimal cloud-init templates that set hostname and SSH access only.

#### Scenario: Hostname set per node
- **WHEN** a VM boots from the baseline cloud-init templates
- **THEN** its hostname matches the lab naming convention (e.g., `${LAB_NAME}-node1`)

#### Scenario: SSH access enabled
- **WHEN** a VM boots from the baseline cloud-init templates
- **THEN** the configured SSH user can authenticate using the provided public key

### Requirement: No full configuration in cloud-init
The system SHALL defer full configuration (packages, Docker, Swarm) to Ansible.

#### Scenario: Docker not installed by cloud-init
- **WHEN** a VM completes cloud-init
- **THEN** Docker installation is performed by Ansible playbooks, not by cloud-init
