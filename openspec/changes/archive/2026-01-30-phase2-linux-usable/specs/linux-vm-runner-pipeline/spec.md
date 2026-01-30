## ADDED Requirements

### Requirement: Reproducible Linux VM runner inputs
The system SHALL define a reproducible Linux VM runner input set (base qcow2 + cloud-init seed + deterministic MAC).

#### Scenario: Base image and seed paths are defined
- **WHEN** a VM runner task is created
- **THEN** it MUST reference a base qcow2 image and a cloud-init seed defined by configuration.

### Requirement: DHCP reservation compatibility
The VM runner SHALL use deterministic MAC addressing compatible with DHCP reservations.

#### Scenario: MAC enables stable IP assignment
- **WHEN** a VM boots on the L2 network
- **THEN** it MUST receive the reserved DHCP IP for its MAC.
