## 1. OpenTofu infra scaffold

- [ ] 1.1 Create `infra/` layout with versions, providers, and root module wiring
- [ ] 1.2 Add `modules/swarm_lab` with libvirt resources (pool, volumes, domains, cloud-init disk)
- [ ] 1.3 Define variables/outputs for lab name, node count, MACs, and access info

## 2. Cloud-init baseline

- [ ] 2.1 Add cloud-init templates for user-data and meta-data
- [ ] 2.2 Wire templatefile rendering into module inputs

## 3. Inventory outputs

- [ ] 3.1 Implement OpenTofu outputs for node names, MACs, and mgmt access hints
- [ ] 3.2 Document output schema in infra/README.md

## 4. Tooling integration

- [ ] 4.1 Update Makefile tofu targets and lab lifecycle wiring
- [ ] 4.2 Add scripts/tofu wrapper and inventory extraction utilities
- [ ] 4.3 Update bootstrap/check scripts for tofu/libvirt dependencies

## 5. Documentation

- [ ] 5.1 Update README Phase 1 quickstart for tofu/libvirt flow
- [ ] 5.2 Add runbook for OpenTofu + libvirt usage and troubleshooting
