## ADDED Requirements

### Requirement: Guest attaches to L2 bridge
The VM runner service SHALL attach the guest NIC to a real L2 bridge (br0) so the guest participates on the same subnet as other services.

#### Scenario: Bridge attachment
- **WHEN** the vm-runner service starts with L2 networking enabled
- **THEN** the guest NIC is connected to br0 via a TAP device

### Requirement: Deterministic MAC enables DHCP reservation
The VM runner service SHALL apply a deterministic MAC address to the guest NIC based on the configured VM_MAC value.

#### Scenario: MAC applied
- **WHEN** VM_MAC is provided in the service environment
- **THEN** the guest NIC uses that MAC address

### Requirement: Guest obtains a DHCP lease on L2
The guest SHALL obtain a DHCP lease on the L2 network using its deterministic MAC.

#### Scenario: Lease assignment
- **WHEN** the guest boots on the L2 bridge
- **THEN** the DHCP server assigns the reserved IP for the guest MAC

### Requirement: L2 reachability from other services
Services on the same L2 segment SHALL be able to reach the guest by IP and port.

#### Scenario: Service-to-guest connectivity
- **WHEN** a normal Swarm service on the L2 segment sends TCP traffic to the guest IP
- **THEN** the connection succeeds
