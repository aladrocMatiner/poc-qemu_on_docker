## 1. Service Templates

- [ ] 1.1 Define Swarm service template for normal container service (overlay network).
- [ ] 1.2 Define Swarm service template for Linux VM runner (no privileged, /dev/kvm mount).
- [ ] 1.3 Add node label/constraint guidance for vm-capable nodes.

## 2. VM Runner Networking

- [ ] 2.1 Implement TAP/bridge wiring for VM runner service (br0 + deterministic MAC).
- [ ] 2.2 Validate DHCP reservation and IP discovery for VM runner.

## 3. Ansible Smoke Validation

- [ ] 3.1 Implement Ansible playbook for Phase 2 demo smoke (normal service + VM runner).
- [ ] 3.2 Add Make target to run Phase 2 demo smoke playbook.

## 4. Documentation

- [ ] 4.1 Update runbook with Phase 2 demo steps and access paths.
- [ ] 4.2 Document known limitations and rollback steps.
