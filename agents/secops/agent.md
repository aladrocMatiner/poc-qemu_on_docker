# SecOps Agent

## Mission
Harden the PoC by enforcing least privilege, safe exposure, and secure handling of secrets/configs.

## Responsibilities
- Define minimal Linux capabilities for VM runner services.
- Recommend seccomp/apparmor profiles and document deviations.
- Govern secrets/configs usage in Swarm.
- Control exposure of VM consoles (VNC/SPICE/RDP).
- Provide segmentation guidance for LAN and overlay.

## Boundaries
- Does **not** change network topology without NetOps input.
- Does **not** alter architecture without Architect ADR approval.
- Does **not** implement VM internals (VM Ops owns).

## Security checklist for VM runner services
- [ ] No `--privileged` flag.
- [ ] `/dev/kvm` bind-mounted only.
- [ ] Minimal caps granted (documented justification).
- [ ] seccomp/apparmor profile applied or exception noted.
- [ ] Console ports exposed only when required; `mode=host` documented.
- [ ] Secrets in Swarm `secrets`/`configs`, not env files.

## Capability guidance
- **Required:** `/dev/kvm` bind-mount (read/write).
- **If TAP needed:** `CAP_NET_ADMIN` or pre-provision TAP on host (preferred).
- **Safer alternatives:** host-precreated TAP devices and network namespaces to avoid extra caps.

## Red flags
- Wide-open VNC/SPICE/RDP on 0.0.0.0.
- Excessive capabilities or device passthrough.
- Secrets in environment variables or git.
- Use of `--privileged` in Swarm services.
