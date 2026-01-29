# qemu_tap_bridge_networking

## Goal
Attach VMs to the LAN via TAP devices bridged to `br0`, with stable MACs for DHCP reservations.

## Non-goals
- macvlan/ipvlan setup for containers.
- Overlay networking for VMs.

## Prerequisites
- `br0` exists on each node.
- DHCP reservations by MAC defined.

## Inputs/Variables (env vars, paths, configs)
- `TAP_NAME` (e.g., `tap_vm01`)
- `BRIDGE=br0`
- `VM_MAC`
- `MTU`

## Steps (numbered procedure)
1. **Preferred:** Pre-create TAP devices on the host and attach them to `br0`.
2. If TAP must be created inside the container, add `CAP_NET_ADMIN` and mount `/dev/net/tun`.
3. Set a stable MAC in QEMU to match DHCP reservation.
4. Enable vhost (`vhost=on`) when available.
5. Clean up TAP devices on service stop (host-side script or systemd unit).

## Commands (short snippets)
```bash
# Host-side TAP creation
$ ip tuntap add dev ${TAP_NAME} mode tap user 1000
$ ip link set ${TAP_NAME} master ${BRIDGE}
$ ip link set ${TAP_NAME} up

# QEMU netdev
$ qemu-system-x86_64 -netdev tap,id=net0,ifname=${TAP_NAME},script=no,downscript=no,vhost=on \
  -device virtio-net-pci,netdev=net0,mac=${VM_MAC}
```

## Security considerations
- Prefer host-precreated TAP to avoid extra caps.
- Document any need for `CAP_NET_ADMIN` in the service definition.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: VM has no LAN connectivity
  Cause: TAP not bridged to `br0`
  Fix: `ip link set ${TAP_NAME} master br0`
- Symptom: DHCP lease not assigned
  Cause: MAC mismatch
  Fix: Verify QEMU `mac=` matches reservation

## Acceptance criteria (DoD)
- VM receives DHCP lease on LAN via `br0` + TAP.
- TAP lifecycle documented (create/cleanup).

## Artifacts produced
- TAP creation/cleanup guidance
- QEMU netdev configuration

## Related skills / docs
- `../host_bridge_vlan_setup/skill.md`
- `../dhcp_dns_reservations/skill.md`
