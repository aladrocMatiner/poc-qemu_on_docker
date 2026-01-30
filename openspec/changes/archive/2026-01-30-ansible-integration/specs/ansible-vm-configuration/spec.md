## ADDED Requirements

### Requirement: Ansible inventory generation
The system SHALL generate an Ansible inventory from `work/inventory.json` that defines swarm manager and worker groups.

#### Scenario: Generated inventory
- **WHEN** `make ansible-inventory` is executed
- **THEN** `ansible/inventories/generated/inventory.ini` is created with managers and workers

### Requirement: Baseline configuration playbook
The system SHALL provide a baseline Ansible playbook to configure common packages and SSH settings.

#### Scenario: Baseline applied
- **WHEN** `make ansible-baseline` runs
- **THEN** all nodes converge without error and can be re-run idempotently

### Requirement: Docker configuration playbook
The system SHALL provide a Docker playbook to install and enable Docker on all nodes.

#### Scenario: Docker installed
- **WHEN** `make ansible-docker` runs
- **THEN** Docker is installed and running on all nodes

### Requirement: Swarm configuration playbook
The system SHALL provide a Swarm playbook that initializes the manager and joins workers idempotently.

#### Scenario: Swarm formed
- **WHEN** `make ansible-swarm` runs
- **THEN** the Swarm is initialized and workers join successfully
