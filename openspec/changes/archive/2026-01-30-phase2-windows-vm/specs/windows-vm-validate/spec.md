## ADDED Requirements

### Requirement: Windows VM validation
The system SHALL provide an Ansible playbook to validate Windows VM boot and access.

#### Scenario: WinRM or RDP reachable
- **WHEN** the validation playbook runs
- **THEN** it MUST confirm WinRM or RDP connectivity to the Windows VM.

### Requirement: Driver availability
The validation SHALL verify that virtio drivers are installed or the VM is otherwise usable.

#### Scenario: Virtio devices present
- **WHEN** validation runs
- **THEN** it MUST report virtio storage/network devices as available.
