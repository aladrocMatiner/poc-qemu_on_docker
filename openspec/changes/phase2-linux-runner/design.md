## Context

Phase 1 provisions a Swarm lab on libvirt. Phase 2 adds a Linux VM runner that executes QEMU/KVM inside a Swarm service container. The goal is L2 connectivity: the guest NIC should attach to a real bridge (br0) so it receives a DHCP lease by deterministic MAC and is reachable by other services via normal IP/ports.

## Goals / Non-Goals

**Goals:**
- Run a Linux VM inside a Swarm service container with KVM acceleration where available.
- Attach the VM NIC to a real L2 segment (br0) using a deterministic MAC for DHCP reservations.
- Provide an Ansible-driven workflow to prepare assets, deploy the service, and validate connectivity.
- Keep container privileges minimal (avoid `--privileged`) while still enabling TAP/bridge wiring.

**Non-Goals:**
- Windows VM runner (separate change).
- Automating host bridge creation or DHCP server configuration outside the lab scope.
- Production hardening or multi-tenant isolation guarantees.

## Decisions

- **TAP + bridge wiring inside the container.**
  Use a TAP device (`/dev/net/tun`) created by the vm-runner entrypoint, and attach it to the host bridge (br0) before launching QEMU. This keeps L2 semantics while avoiding host-level scripts. Requires `CAP_NET_ADMIN` and access to `/dev/net/tun` plus `/dev/kvm`.

- **Deterministic MAC from env.**
  The VM MAC is provided via `VM_MAC` env var (deterministic across runs), enabling DHCP reservations on the L2 network. This avoids reliance on guest agent IP reporting.

- **Assets prepared by Ansible.**
  Ansible roles prepare VM runner assets (base image, qcow2, cloud-init seed, SSH keys) on all candidate nodes and label nodes with `vm-capable=true` when `/dev/kvm` is present.

- **Swarm overlay remains for service containers.**
  The vm-runner container still joins the overlay network for control/observability, but guest networking uses the L2 bridge path.

- **Validation via SSH and connectivity checks.**
  Ansible verifies that the guest receives a DHCP lease and is reachable from other services over L2 (ping/HTTP/SSH depending on the test case).

## Risks / Trade-offs

- **Host network dependency** → Requires a working L2 bridge and DHCP reservations; mitigate with clear runbook steps and troubleshooting checks.
- **Security surface from NET_ADMIN** → Limit capabilities to NET_ADMIN, mount only required devices, and avoid `--privileged`.
- **Nested virtualization availability** → KVM may be unavailable in some environments; mitigate by detecting `/dev/kvm` and labeling nodes accordingly.
- **MAC/IP collisions** → Deterministic MACs must not conflict with existing leases; document MAC range usage and reservation requirements.

## Migration Plan

- Update vm-runner image/entrypoint and stack to enable TAP + bridge mode (L2).
- Run Ansible role to prepare assets and deploy the stack.
- Roll back by switching the stack to user-mode networking and removing the TAP/bridge wiring if needed.

## Open Questions

- Should L2 attach use macvlan instead of TAP+bridge for simpler configuration?
- How will DHCP reservations be managed in non-libvirt environments?
- Do we need optional fallback to user-mode networking for hosts without bridge access?
