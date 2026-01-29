## ADDED Requirements

### Requirement: Management networking modes
The system SHALL support two management networking modes for the lab VMs, selectable via `MGMT_MODE`.

#### Scenario: MGMT_MODE=user
- **WHEN** `MGMT_MODE` is set to `user`
- **THEN** the management NIC uses a libvirt NAT network and management IPs are discovered via DHCP leases

#### Scenario: MGMT_MODE=bridge
- **WHEN** `MGMT_MODE` is set to `bridge`
- **THEN** the management NIC attaches to `MGMT_BRIDGE` and requires that bridge to exist

### Requirement: Swarm NIC attachment
The system SHALL attach the swarm NIC of every VM to `SWARM_BRIDGE` for L2 LAN connectivity.

#### Scenario: Swarm NIC on br0
- **WHEN** a VM is created
- **THEN** its second NIC is attached to `SWARM_BRIDGE` and uses a deterministic MAC

### Requirement: Deterministic MACs per node
The system SHALL derive deterministic MAC addresses for management and swarm NICs per node.

#### Scenario: MAC derivation
- **WHEN** a node index is provided
- **THEN** the system produces distinct management and swarm MACs based on `MAC_PREFIX`

### Requirement: Access guidance and documentation
The system SHALL document access behavior for both modes and provide actionable guidance when discovery fails.

#### Scenario: Unknown management IP
- **WHEN** management IP discovery fails
- **THEN** the system emits actionable instructions to locate or set the IP
