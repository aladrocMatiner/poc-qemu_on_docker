## 1. VM runner container and networking

- [x] 1.1 Ensure vm-runner Linux image/entrypoint supports TAP + bridge wiring to br0 with deterministic MAC
- [x] 1.2 Wire vm-runner service environment for VM name, disk, seed, MAC, and L2 mode

## 2. Swarm stack and assets

- [x] 2.1 Add or update the Phase2 case01 stack definition with vm-runner service and required mounts/caps
- [x] 2.2 Implement Ansible role/tasks to prepare VM runner assets (image, seed, keys) on vm-capable nodes

## 3. Ansible workflows and validation

- [x] 3.1 Add Ansible playbooks/targets for Case01 up/test/down flows
- [x] 3.2 Implement validation that services can reach the guest over L2 by IP/port

## 4. Documentation

- [x] 4.1 Document Linux vm-runner prerequisites and runbook steps
- [x] 4.2 Document phase2 case01 workflow in phase2 docs
