## 1. Spec-aligned validation

- [ ] 1.1 Add env validation for MGMT_MODE, MGMT_BRIDGE, SWARM_BRIDGE
- [ ] 1.2 Add deterministic MAC derivation helpers for mgmt and swarm NICs

## 2. Infra wiring

- [ ] 2.1 Implement mgmt NIC wiring for MGMT_MODE=user (libvirt NAT)
- [ ] 2.2 Implement mgmt NIC wiring for MGMT_MODE=bridge (host bridge)
- [ ] 2.3 Ensure swarm NIC attaches to SWARM_BRIDGE with deterministic MAC

## 3. Access tooling

- [ ] 3.1 Update inventory generation to discover mgmt IPs via libvirt leases
- [ ] 3.2 Add actionable guidance when IP discovery fails

## 4. Documentation

- [ ] 4.1 Update runbook: network-modes.md
- [ ] 4.2 Update README quickstart to mention MGMT_MODE behavior
