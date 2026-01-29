# host_bridge_vlan_setup

## Goal
Create a persistent host bridge `br0` with optional VLAN subinterfaces and minimal firewall considerations.

## Non-goals
- Full host hardening or OS provisioning.
- VLAN trunk configuration on upstream switches.

## Prerequisites
- Root access on each node.
- A physical NIC to bridge (e.g., `eth0`).

## Inputs/Variables (env vars, paths, configs)
- `PHYS_NIC=eth0`
- `BRIDGE=br0`
- `VLAN_ID` (optional)
- `MTU` (e.g., 1500 or 9000)

## Steps (numbered procedure)
1. Create `br0` and attach the physical NIC.
2. Move the host IP from the NIC to `br0`.
3. If VLAN is required, create `PHYS_NIC.VLAN_ID` and bridge that.
4. Align MTU on NIC, bridge, and TAP devices.
5. Review `bridge-nf` sysctl behavior and document filtering policy.

## Commands (short snippets)
```bash
$ ip link add ${BRIDGE} type bridge
$ ip link set ${PHYS_NIC} master ${BRIDGE}
$ ip link set ${BRIDGE} up
$ ip link set ${PHYS_NIC} up
```

**Ubuntu (netplan/systemd-networkd hint)**
```yaml
network:
  version: 2
  renderer: networkd
  bridges:
    br0:
      interfaces: [eth0]
      addresses: [192.168.1.10/24]
      gateway4: 192.168.1.1
```

**RHEL-style hint (NetworkManager)**
```bash
$ nmcli con add type bridge ifname br0
$ nmcli con add type ethernet ifname eth0 master br0
```

## Security considerations
- Decide whether `net.bridge.bridge-nf-call-iptables` should be on/off and document it.
- Keep firewall rules minimal and explicit (DHCP, ARP, console ports as needed).

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Host loses network after bridge change
  Cause: IP not assigned to `br0`
  Fix: Move IP config from NIC to bridge
- Symptom: DHCP not working on bridged VMs
  Cause: VLAN mismatch or firewall filtering
  Fix: Verify VLAN tags and bridge-nf settings

## Acceptance criteria (DoD)
- `br0` is persistent after reboot.
- Host and VMs can reach gateway and DHCP server.

## Artifacts produced
- Host bridge configuration files

## Related specs / docs
- Spec ID: `lan-bridge-br0` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/TBD`
- ADRs: `docs/adr/TBD`
