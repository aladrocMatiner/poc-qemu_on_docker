# Guardrails

## Scope
- PoC for **Docker Swarm** with normal containers plus **QEMU/KVM VM runners**.
- L2 LAN presence for selected workloads via **host bridge `br0` + TAP/vhost**.
- **DHCP reservations by MAC** for stable VM/container addressing.
- **Overlay networks** for internal service-to-service traffic.

## Non-goals
- Production-grade HA, multi-tenant isolation, or SLA guarantees.
- Vendor-specific SDN or hyperconverged storage.
- Secrets management beyond Swarm `secrets`/`configs`.

## Safety defaults
- **No destructive actions by default** (no forced reformat, no host-wide wipes).
- **No secrets in repo** (no credentials, tokens, license keys).
- **Least privilege**: minimal caps, minimal devices, explicit mounts only.

## Swarm constraints
- **No `--privileged`** in services.
- **Use labels/constraints** to place VM runners (e.g., `vm-capable=true`).
- **Publish `mode=host`** for VM consoles when required (VNC/SPICE/RDP).

## Networking guardrails
- Bridge name **must be `br0`** across nodes.
- **VLAN optional**; document VLAN ID, trunk/access, and MTU impact.
- **MTU** aligned across NIC ↔ `br0` ↔ TAP; document overlay headroom.
- **macvlan/ipvlan** only when L2 adjacency is required; note host↔container limitations.
- **Port conventions**: reserve ranges (e.g., consoles 5900–5999) and document.

## Storage guardrails
- VM disks use **qcow2**; base images read-only; overlays per VM.
- **Do not commit ISOs/virtio ISOs**; reference external paths.
- Default host layout: `/var/lib/poc-qemu/{images,instances,isos,seeds,logs}`.
- **Corruption avoidance**: no snapshot/compaction while VM is running; document safe shutdown steps.

## Security guardrails
- **Minimal caps**; add `CAP_NET_ADMIN` only if TAP created inside container.
- **/dev/kvm** bind-mount required; no other device passthrough by default.
- Note **seccomp/apparmor** profile usage and exceptions.
- Use **Swarm secrets/configs**; never env vars or git for sensitive data.

## Secrets handling
- Do not commit secrets, credentials, or private keys.
- Ignore `secrets/` and `*.key` in git.
- Prefer Swarm `secrets`/`configs` or external secret stores.

## Documentation guardrails
- **ADR required** for major architectural decisions.
- **Runbook required** for operational changes (deploy, rollback, recovery).

## Pre-merge checklist
- [ ] No secrets or ISOs added to repo.
- [ ] Least-privilege caps and devices reviewed.
- [ ] Swarm constraints/labels documented and applied.
- [ ] `br0`/TAP/MTU notes updated for network changes.
- [ ] Storage layout and corruption-avoidance notes updated.
- [ ] ADR added/updated for major decisions.
- [ ] Runbook added/updated for operational changes.
- [ ] Smoke tests updated or documented.
