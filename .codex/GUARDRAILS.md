# Guardrails

## Scope
- Build a **Docker Swarm PoC** where normal containers and **QEMU/KVM VM runner containers** coexist.
- Provide **L2 LAN presence** for selected workloads via **host bridge `br0` + TAP/vhost**.
- Use **DHCP reservations by MAC** for stable VM/container addresses.
- Use **Swarm overlay** for internal service-to-service traffic.

## Non-goals
- No production-grade HA guarantees, billing, or multi-tenant isolation.
- No vendor-specific network stack (e.g., NSX, Calico, Cilium).
- No embedded secrets, certificates, or license keys.

## Safety principles
- **Least privilege:** only required Linux capabilities; avoid `--privileged`.
- **No destructive defaults:** never `rm -rf` host paths; avoid forced reformatting.
- **No secrets in repo:** use Swarm `secrets`/`configs` or external secret stores.

## Swarm constraints
- **No `--privileged` services.** Design with `/dev/kvm` bind-mounts and minimal caps.
- Prefer **node labels/constraints** for VM runners and storage locality.
- Publish VM consoles **`mode=host` only when needed** (VNC/SPICE/RDP) to avoid overlay pathing.

## Networking guardrails
- Host bridge **must be named `br0`** for L2 bridging to LAN.
- **VLANs optional:** document tag ID and MTU impact if used.
- **MTU:** align `br0`, TAP, and physical NIC MTU; note 1500 vs 9000 and overlay headroom.
- **macvlan/ipvlan:** use only where L2 adjacency is required; note host↔container reachability constraints.
- **Port conventions:** reserve ranges per service class (e.g., VM consoles 5900–5999, monitoring 9100/9200); document in runbooks.

## Storage guardrails
- VM disks are **qcow2**; support snapshots where needed.
- **Do not commit ISOs/virtio ISOs** to git; reference external paths.
- Suggested host paths: `/var/lib/poc-qemu/{isos,images,instances,logs}`.

## Security guardrails
- **Minimal caps** (e.g., `CAP_NET_ADMIN` only where required for TAP).
- **/dev/kvm** bind-mount with read/write; no other device passthrough by default.
- Use **seccomp/apparmor** profiles where supported; document deviations.
- Use Swarm **secrets/configs** for credentials; never in env files.

## Documentation rules
- **ADR required** for major architecture decisions (networking mode, DHCP design, storage layout, security posture).

## Pre-merge checklist
- [ ] No secrets or ISOs added to repo.
- [ ] Least-privilege caps reviewed for new services.
- [ ] Swarm constraints/labels documented and applied.
- [ ] `br0`/TAP/MTU notes updated if networking changes.
- [ ] Storage layout and paths documented for any VM changes.
- [ ] ADR added/updated for major decisions.
- [ ] Smoke tests updated or documented.
