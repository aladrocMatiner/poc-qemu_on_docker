# lan_l2_macvlan_ipvlan

## Goal
Provide L2 LAN attachment for containers using macvlan/ipvlan with consistent naming across Swarm nodes.

## Non-goals
- Replacing the `br0` + TAP model for VMs.
- Providing overlay network connectivity.

## Prerequisites
- `br0` bridge exists on each node.
- Subnet, gateway, and VLAN plan defined.

## Inputs/Variables (env vars, paths, configs)
- `LAN_SUBNET`
- `LAN_GATEWAY`
- `LAN_PARENT=br0`
- `LAN_NET_NAME=lan-l2`

## Steps (numbered procedure)
1. Create a macvlan or ipvlan network **on each node** with identical settings.
2. Mark the network as `external` in Swarm stacks.
3. Note host↔container reachability limitations and document workarounds.
4. Validate L2 connectivity to gateway and DHCP server.

## Commands (short snippets)
```bash
$ docker network create -d macvlan \
  --subnet ${LAN_SUBNET} --gateway ${LAN_GATEWAY} \
  -o parent=${LAN_PARENT} ${LAN_NET_NAME}
```

## Security considerations
- macvlan/ipvlan bypasses host firewall rules; document exposure.
- Use DHCP reservations by MAC for stable addressing.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Host cannot reach macvlan container
  Cause: macvlan hairpin limitation
  Fix: Create a macvlan subinterface on host or use ipvlan L2
- Symptom: ARP flapping or duplicate IPs
  Cause: DHCP reservation mismatch
  Fix: Verify MACs and DHCP config

## Acceptance criteria (DoD)
- Containers receive correct DHCP leases on LAN.
- Network exists with consistent name on all nodes.

## Artifacts produced
- Local macvlan/ipvlan networks per node

## Related skills / docs
- `../host_bridge_vlan_setup/skill.md`
- `../dhcp_dns_reservations/skill.md`
