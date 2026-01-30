## 1. Inventory contract

- [x] 1.1 Add docs/inventory-schema.md and schema versioning notes
- [x] 1.2 Add specs/inventory-contract.yaml and register in specs/index.yaml
- [x] 1.3 Add inventory validation hook in lab-status or doctor

## 2. Host network setup helper

- [x] 2.1 Add scripts/host/network_setup.sh with opt-in confirmation
- [x] 2.2 Add skills/host_network_setup/skill.md
- [x] 2.3 Add specs/host-network-setup.yaml and Make target host-network-setup

## 3. Secrets handling policy

- [x] 3.1 Add docs/runbooks/secrets-policy.md
- [x] 3.2 Update .codex/GUARDRAILS.md with secrets handling section
- [x] 3.3 Add gitignore entries for secrets/ and *.key

## 4. Failure artifact collection

- [x] 4.1 Add scripts/diag/collect_logs.sh and Make target collect-logs
- [x] 4.2 Add docs/runbooks/collect-logs.md
- [x] 4.3 Wire inventory/tofu/virsh/cloud-init log collection (best-effort)

## 5. Windows baseline placeholder

- [x] 5.1 Add specs/windows-vm-baseline.yaml with TBD acceptance tests
- [x] 5.2 Register spec in specs/index.yaml and link runbook placeholders
