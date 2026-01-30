## ADDED Requirements

### Requirement: Windows VM runner service
The system SHALL provide a Swarm service definition for a Windows VM runner container using QEMU/KVM and virtio drivers.

#### Scenario: Service uses external ISOs
- **WHEN** the Windows VM runner is configured
- **THEN** it MUST reference Windows and virtio ISO paths from configuration (not in git).

### Requirement: Deterministic VM identity
The Windows VM runner SHALL use deterministic MAC addressing for DHCP reservations.

#### Scenario: MAC enables stable IP assignment
- **WHEN** the Windows VM boots
- **THEN** it MUST receive the reserved DHCP IP for its MAC.
