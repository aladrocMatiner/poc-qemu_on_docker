## ADDED Requirements

### Requirement: Swarm VM runner Linux service
The system SHALL provide a Swarm service definition for a Linux VM runner container using QEMU/KVM without privileged mode.

#### Scenario: Service definition uses minimal privileges
- **WHEN** the VM runner service is defined
- **THEN** it MUST avoid `--privileged` and only bind-mount `/dev/kvm` with minimal capabilities.

### Requirement: Deterministic VM identity
The VM runner service SHALL assign deterministic VM name and MAC address to enable DHCP reservations.

#### Scenario: MAC derived from MAC_PREFIX
- **WHEN** a VM runner task is created
- **THEN** its MAC MUST be derived from `MAC_PREFIX` and node index.

### Requirement: L2 connectivity on br0
The VM runner SHALL attach the VM NIC to `br0` via TAP/vhost (or equivalent), enabling L2 connectivity.

#### Scenario: VM obtains DHCP lease on br0 network
- **WHEN** the VM boots
- **THEN** it MUST obtain an IP from the L2 DHCP network using its MAC reservation.
