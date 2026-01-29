# troubleshooting_networking_mtu_arp

## Goal
Diagnose MTU, ARP, and DHCP issues affecting L2 connectivity on `br0` and TAP devices.

## Non-goals
- Deep kernel debugging.
- Overlay routing diagnostics beyond MTU.

## Prerequisites
- Shell access to nodes.
- `ip`, `bridge`, `tcpdump`, `ethtool` available.

## Inputs/Variables (env vars, paths, configs)
- `BRIDGE=br0`
- `TAP_NAME`
- `TARGET_IP`
- `VLAN_ID` (if used)

## Steps (numbered procedure)
1. Check MTU on NIC, `br0`, TAP, and overlay interfaces.
2. Inspect ARP/neighbor tables on host and VM.
3. Capture DHCP/ARP traffic on `br0` and TAP.
4. Verify `rp_filter` and bridge-nf settings.
5. Test MTU with `ping -M do` to detect blackholing.

## Commands (short snippets)
```bash
$ ip link show ${BRIDGE}
$ ip neigh show
$ sysctl net.ipv4.conf.all.rp_filter
$ tcpdump -i ${BRIDGE} arp or port 67
$ ping -M do -s 1472 ${TARGET_IP}
```

## Security considerations
- Use tcpdump only on trusted interfaces.
- Avoid capturing sensitive traffic.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: VM gets no DHCP lease
  Cause: DHCP server unreachable or blocked
  Fix: Verify VLAN tagging, bridge-nf, and firewall rules
- Symptom: ARP entries stuck `INCOMPLETE`
  Cause: MAC mismatch or duplicate IP
  Fix: Verify DHCP reservations and VM MAC
- Symptom: Connectivity drops on overlay
  Cause: MTU/VXLAN mismatch
  Fix: Reduce MTU or align across NIC/bridge/overlay
- Symptom: Host cannot reach VM on macvlan
  Cause: Hairpin limitation
  Fix: Use ipvlan L2 or host macvlan subinterface
- Symptom: Asymmetric traffic dropped
  Cause: `rp_filter` strict mode
  Fix: Set `rp_filter=2` or adjust routing

## Acceptance criteria (DoD)
- MTU consistent across L2 path and overlay.
- ARP entries stable and correct.
- DHCP lease acquisition verified.

## Artifacts produced
- Troubleshooting notes and command outputs summary

## Related skills / docs
- `../host_bridge_vlan_setup/skill.md`
- `../qemu_tap_bridge_networking/skill.md`
