# Goal
Configure and validate a Linux VM runner via Ansible for Phase 2 (QEMU-in-container), using Ansible-only interaction.

# Non-goals
- Building the QEMU container image itself.
- Designing Swarm networking/placement policies.

# Prerequisites
- Swarm lab is up and reachable via Ansible inventory.
- VM runner service spec exists (Swarm service or standalone host service).
- QEMU/KVM access and TAP/bridge wiring are already validated at the host level.

# Inputs/Variables (.env vars)
- `ANSIBLE_INVENTORY`
- `ANSIBLE_SSH_USER`
- `ANSIBLE_SSH_PRIVATE_KEY`
- `LAB_NAME`, `LAB_NODES`
- `SWARM_BRIDGE`, `MGMT_MODE`
- VM runner vars (path, qcow2, MACs) as Ansible extra vars

# Steps
1. Generate/refresh Ansible inventory (`make lab-status`, `make ansible-inventory`).
2. Run the Linux VM runner baseline playbook (Phase 2 playbooks live under `ansible/anisble-poc_qemu`).
3. Validate Linux VM boot, DHCP/IP, and SSH or console access.
4. Record VM status in logs/artifacts.

# Commands
```bash
make lab-status
make ansible-inventory
make ansible-run PLAYBOOK=ansible/anisble-poc_qemu/linux_vm_runner.yml
```

# Security considerations
- Use key-based SSH only; no passwords.
- Minimal capabilities for VM runner containers.
- Do not expose VM consoles publicly; use host publish with firewall rules.

# Troubleshooting (symptom -> cause -> fix)
- VM does not get DHCP IP -> TAP/bridge miswired -> check `br0` and DHCP reservations.
- SSH fails -> inventory stale -> rerun `make lab-status` and `make ansible-inventory`.
- QEMU permissions denied -> missing /dev/kvm or seclabel mismatch -> validate host setup.

# Acceptance criteria (DoD)
- Ansible playbook runs successfully against all nodes.
- Linux VM boots and obtains a stable IP.
- SSH or console access to the Linux VM works.

# Artifacts produced
- Playbook logs
- Optional inventory updates in `work/inventory.json`

# Related specs / docs
- Specs: `qemu-runner-container`, `qemu-tap-bridge`, `vm-linux-cloudinit`, `ansible-vm-configuration`
- Docs: `docs/runbooks/ansible-operations.md`, `docs/runbooks/network-modes.md`
