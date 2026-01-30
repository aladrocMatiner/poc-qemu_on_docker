# Goal
Configure and validate a Windows VM runner via Ansible for Phase 2, using Ansible-only interaction (WinRM/RDP checks).

# Non-goals
- Building the Windows image pipeline or ISO acquisition.
- Defining enterprise hardening policies.

# Prerequisites
- Windows ISO + virtio ISO available on host (not in git).
- Swarm lab up and Ansible inventory generated.
- Windows VM runner service defined with deterministic MAC.

# Inputs/Variables (.env vars)
- `ANSIBLE_INVENTORY`
- `ANSIBLE_SSH_USER` (for Linux hosts)
- Windows vars in Ansible extra vars:
  - `windows_admin_user`, `windows_admin_password` (use vault)
  - `winrm_transport`, `winrm_port`
  - `virtio_iso_path`, `windows_iso_path`

# Steps
1. Generate/refresh inventory (`make lab-status`, `make ansible-inventory`).
2. Run the Windows VM runner playbook (Phase 2 playbooks live under `ansible/anisble-poc_qemu`).
3. Validate Windows VM boot and WinRM/RDP reachability.
4. Record VM status in logs/artifacts.

# Commands
```bash
make lab-status
make ansible-inventory
make ansible-run PLAYBOOK=ansible/anisble-poc_qemu/windows_vm_runner.yml
```

# Security considerations
- Use Ansible Vault for any Windows credentials.
- Restrict RDP/WinRM exposure to trusted networks.
- Keep VM runner container caps minimal.

# Troubleshooting (symptom -> cause -> fix)
- WinRM unreachable -> firewall or service disabled -> enable WinRM in unattend.
- RDP connection fails -> NAT/port publish mismatch -> verify host publish mode.
- Drivers missing -> virtio ISO not mounted -> check ISO paths.

# Acceptance criteria (DoD)
- Windows VM boots successfully.
- WinRM or RDP connectivity verified.
- VM runner logs show stable operation.

# Artifacts produced
- Playbook logs
- Validation output

# Related specs / docs
- Specs: `windows-vm-baseline`, `qemu-runner-container`, `ansible-vm-configuration`
- Docs: `docs/runbooks/ansible-operations.md`
