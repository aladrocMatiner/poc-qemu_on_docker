# Goal
Provide an Ansible-driven Phase 2 smoke test suite to validate coexistence of normal Swarm services and VM runner services (Linux/Windows).

# Non-goals
- Full performance benchmarking.
- Production-grade hardening validation.

# Prerequisites
- Swarm cluster healthy.
- Ansible inventory generated.
- VM runner services defined for Linux (and optionally Windows).

# Inputs/Variables (.env vars)
- `ANSIBLE_INVENTORY`
- `ANSIBLE_SSH_USER`
- `ANSIBLE_SSH_PRIVATE_KEY`
- `ANSIBLE_LIMIT` (optional)
- `ANSIBLE_TAGS` (optional)

# Steps
1. Run inventory generation.
2. Run Phase 2 smoke playbook (Ansible-only checks).
3. Review output and log artifacts.

# Commands
```bash
make lab-status
make ansible-inventory
make ansible-run PLAYBOOK=ansible/anisble-poc_qemu/phase2_smoke.yml
```

# Security considerations
- Do not expose VM consoles to WAN.
- Avoid storing secrets in playbooks; use Vault.

# Troubleshooting (symptom -> cause -> fix)
- Only subset of hosts tested -> check `ANSIBLE_LIMIT` and inventory.
- Swarm service not scheduled -> check node labels/constraints.
- VM runner not booting -> verify /dev/kvm access and volumes.

# Acceptance criteria (DoD)
- Normal Swarm service is running and reachable.
- Linux VM runner service starts and VM boots.
- (Optional) Windows VM runner service starts and VM boots.

# Artifacts produced
- Playbook logs
- Optional smoke report in `work/` (if implemented)

# Related specs / docs
- Specs: `ansible-vm-configuration`; `phase2-qemu-in-container` (TBD in specs/index.yaml)
- Docs: `docs/runbooks/ansible-operations.md`
