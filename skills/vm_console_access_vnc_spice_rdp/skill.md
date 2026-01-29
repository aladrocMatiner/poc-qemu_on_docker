# vm_console_access_vnc_spice_rdp

## Goal
Expose VM consoles safely using VNC/SPICE/noVNC or guest-level RDP.

## Non-goals
- Public internet exposure of consoles.
- Full remote desktop gateway setup.

## Prerequisites
- VM runner service defined and placed on correct node.
- Port range reserved for consoles.

## Inputs/Variables (env vars, paths, configs)
- `CONSOLE_TYPE` (vnc|spice|novnc|rdp)
- `CONSOLE_PORT`
- `PUBLISH_MODE=host`
- `CONSOLE_PORT_RANGE=5900-5999`

## Steps (numbered procedure)
1. Choose console type based on guest OS and access needs.
2. Configure QEMU to bind to a specific port (prefer localhost or internal IP).
3. Publish the port with `mode=host` and constrain to the VM node.
4. Add firewall rules or SSH tunnel guidance.
5. Verify connectivity from a trusted client.

## Commands (short snippets)
```bash
# VNC example
$ qemu-system-x86_64 -vnc 127.0.0.1:1

# Swarm publish (host mode)
$ docker service create --publish published=5901,target=5900,mode=host ...
```

## Security considerations
- Avoid `0.0.0.0` bindings unless firewall-restricted.
- Require authentication for SPICE/VNC where supported.
- Prefer RDP/WinRM over VNC for Windows after install.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Console connects to wrong VM
  Cause: Routing mesh used
  Fix: Use `mode=host` and placement constraint
- Symptom: Port already in use
  Cause: Collision in console range
  Fix: Allocate a unique port from reserved range

## Acceptance criteria (DoD)
- Console access works from trusted clients only.
- Port allocation documented and conflict-free.

## Artifacts produced
- Console port map
- Service publish configuration

## Related specs / docs
- Spec ID: `console-access` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/TBD`
- ADRs: `docs/adr/TBD`
