## 1. Spec-aligned validation

- [x] 1.1 Add env validation for MGMT_MODE, MGMT_BRIDGE, SWARM_BRIDGE
- [x] 1.2 Add deterministic MAC derivation helpers for mgmt and swarm NICs

## 2. Infra wiring

- [x] 2.1 Implement mgmt NIC wiring for MGMT_MODE=user (libvirt NAT)
- [x] 2.2 Implement mgmt NIC wiring for MGMT_MODE=bridge (host bridge)
- [x] 2.3 Ensure swarm NIC attaches to SWARM_BRIDGE with deterministic MAC

## 3. Access tooling

- [x] 3.1 Update inventory generation to discover mgmt IPs via libvirt leases
- [x] 3.2 Add actionable guidance when IP discovery fails

## 4. Documentation

- [x] 4.1 Update runbook: network-modes.md
- [x] 4.2 Update README quickstart to mention MGMT_MODE behavior
