## 1. OpenTofu infra scaffold

- [x] 1.1 Create `infra/` layout with versions, providers, and root module wiring
- [x] 1.2 Add `modules/swarm_lab` with libvirt resources (pool, volumes, domains, cloud-init disk)
- [x] 1.3 Define variables/outputs for lab name, node count, MACs, and access info

## 2. Cloud-init baseline

- [x] 2.1 Add cloud-init templates for user-data and meta-data
- [x] 2.2 Wire templatefile rendering into module inputs

## 3. Inventory outputs

- [x] 3.1 Implement OpenTofu outputs for node names, MACs, and mgmt access hints
- [x] 3.2 Document output schema in infra/README.md

## 4. Tooling integration

- [x] 4.1 Update Makefile tofu targets and lab lifecycle wiring
- [x] 4.2 Add scripts/tofu wrapper and inventory extraction utilities
- [x] 4.3 Update bootstrap/check scripts for tofu/libvirt dependencies

## 5. Documentation

- [x] 5.1 Update README Phase 1 quickstart for tofu/libvirt flow
- [x] 5.2 Add runbook for OpenTofu + libvirt usage and troubleshooting
