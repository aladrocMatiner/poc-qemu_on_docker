## ADDED Requirements

### Requirement: Linux VM runner validation
The system SHALL provide an Ansible playbook to validate Linux VM runner boot and access.

#### Scenario: VM boots and is reachable
- **WHEN** the validation playbook runs
- **THEN** it MUST confirm the VM is running and reachable via SSH or console.

### Requirement: Cloud-init completion
The validation SHALL verify that cloud-init completes successfully.

#### Scenario: Cloud-init status is done
- **WHEN** validation runs
- **THEN** it MUST report cloud-init status as done.
