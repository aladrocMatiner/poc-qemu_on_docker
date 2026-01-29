## ADDED Requirements

### Requirement: Inventory output from OpenTofu
The system SHALL produce a machine-readable inventory derived from `tofu output -json`.

#### Scenario: Inventory file generated
- **WHEN** `make lab-status` runs after `tofu apply`
- **THEN** it writes `work/inventory.json` containing node names and management access details

### Requirement: Management access discovery
The system SHALL provide management access information based on MGMT_MODE.

#### Scenario: MGMT_MODE=bridge discovery
- **WHEN** MGMT_MODE is `bridge`
- **THEN** management IPs are discovered via libvirt DHCP leases or specified explicitly in `.env`

#### Scenario: MGMT_MODE=user discovery
- **WHEN** MGMT_MODE is `user`
- **THEN** management access uses libvirt default NAT DHCP leases or defined forwarded ports
