## Context
Phase 2 Windows support extends the Linux VM runner demo to a Windows VM inside a Swarm-managed container. This requires external ISO artifacts, virtio drivers, and reliable access (RDP/WinRM). All validation remains Ansible-driven.

## Goals / Non-Goals

**Goals:**
- Run a Windows VM inside a Swarm VM runner container.
- Integrate virtio drivers via ISO.
- Validate boot and access via Ansible (WinRM/RDP checks).

**Non-Goals:**
- Full Windows hardening/patch management.
- Automated image building beyond unattended install basics.
- Production-grade security posture.

## Decisions

1) **External ISO artifacts**
- Windows ISO and virtio ISO are provided via paths in `.env` and never committed.
- Rationale: licensing and size constraints.

2) **Ansible validation**
- Use Ansible playbooks in `ansible/anisble-poc_qemu` for Windows checks.
- Rationale: consistent testing approach and repeatability.

3) **Access method**
- Prefer WinRM for automation; RDP for human access when needed.
- Rationale: enables non-interactive validation and aligns with Ansible.

## Risks / Trade-offs
- **Windows licensing/ISO availability** → Mitigation: document required artifacts and paths.
- **Driver availability** → Mitigation: require virtio ISO and validate device discovery.
- **WinRM configuration** → Mitigation: include setup in unattended or post-boot steps.
