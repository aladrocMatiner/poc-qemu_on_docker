## Context
We already have a Phase 1 Swarm lab (libvirt VMs) with Ansible-driven configuration. Phase 2 aims to prove Swarm can schedule both normal container services and VM runner services (QEMU/KVM) without using privileged containers. Networking requires L2 access for VMs via br0 and deterministic MAC-based DHCP reservations. All validation should run through Ansible playbooks.

## Goals / Non-Goals

**Goals:**
- Run a Linux VM inside a Swarm service container using QEMU/KVM.
- Run a normal Swarm service alongside the VM runner service.
- Use br0 + TAP (or equivalent) for VM L2 connectivity with DHCP reservations.
- Validate via Ansible playbooks (no manual SSH outside Ansible).

**Non-Goals:**
- Full Windows support (handled in a later change).
- Production-grade hardening/performance tuning.
- High availability guarantees beyond Swarm placement.

## Decisions

1) **VM runner as Swarm service (no privileged)**
- Use Swarm services with `/dev/kvm` bind mount and minimal `cap_add` (e.g., `NET_ADMIN` only if required for TAP). Avoid `--privileged`.
- Rationale: aligns with Swarm constraints and security guardrails.
- Alternatives considered: privileged containers (rejected), external host-side QEMU (rejected for PoC objective).

2) **L2 networking via br0 + TAP/vhost**
- VM NIC attaches to a TAP interface bridged to br0; MAC is deterministic to enable DHCP reservations.
- Rationale: matches PoC requirement for VMs on the same L2 as selected containers.
- Alternatives: macvlan/ipvlan (not chosen for the demo, but may be explored later).

3) **Ansible-first validation**
- All tests and verification run through Ansible playbooks under `ansible/anisble-poc_qemu`.
- Rationale: consistent, repeatable testing across nodes; aligns with team direction.

4) **Service placement and labeling**
- Swarm nodes that can run VMs are labeled `vm-capable=true` and constrained accordingly.
- Rationale: prevents accidental scheduling on non-KVM nodes.

## Risks / Trade-offs
- **Host permissions / AppArmor** → Ensure seclabel handling is compatible; document `LIBVIRT_SECLABEL_MODE` and pool path.
- **TAP creation requires NET_ADMIN** → Use minimal capabilities and document requirement; consider host helper if needed.
- **DHCP/IP discovery** → Use deterministic MAC + DHCP reservations; expose IPs via inventory.

## Migration Plan
1) Add Swarm service template for Linux VM runner (no privileged).
2) Add normal service template for coexistence test.
3) Add Ansible smoke playbook and Make target.
4) Validate end-to-end; rollback by removing services and cleaning artifacts.

## Open Questions
- Do we need a host-level helper to create TAP devices if CAP_NET_ADMIN is insufficient?
- Should we pin QEMU image/runtime versions for reproducibility?
- What is the minimal VM console exposure for the demo (serial vs VNC)?
