# dhcp_dns_reservations

## Goal
Provide stable IPs via DHCP reservations by MAC, replacing static IP assignment per Swarm task.

## Non-goals
- Full IPAM or enterprise DNS hosting.
- Public DNS exposure.

## Prerequisites
- DHCP server selected (dnsmasq or Kea).
- L2 reachability on `br0` to DHCP server.

## Inputs/Variables (env vars, paths, configs)
- `DHCP_SERVER` (dnsmasq|kea)
- `SUBNET_CIDR`
- `RESERVED_IP`
- `MAC_ADDRESS`
- `HOSTNAME` (optional DNS)

## Steps (numbered procedure)
1. Add DHCP reservation entries by MAC.
2. Optionally add DNS hostnames for reserved leases.
3. Restart DHCP service and verify lease assignment.
4. Ensure QEMU uses the reserved MAC address.

## Commands (short snippets)
```bash
# dnsmasq example
$ echo "dhcp-host=52:54:00:aa:bb:cc,192.168.1.50,vm01" >> /etc/dnsmasq.d/poc.conf
$ systemctl restart dnsmasq

# verify lease
$ grep 52:54:00:aa:bb:cc /var/lib/misc/dnsmasq.leases
```

## Security considerations
- Restrict DHCP admin access.
- Do not store secrets in DHCP configs.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: VM gets random IP
  Cause: MAC mismatch or missing reservation
  Fix: Verify QEMU MAC and DHCP entry
- Symptom: No DHCP lease
  Cause: DHCP server not reachable on `br0`
  Fix: Verify bridge, VLAN, and firewall rules

## Acceptance criteria (DoD)
- VM receives reserved IP by MAC.
- Optional DNS name resolves correctly.

## Artifacts produced
- DHCP reservation entries
- DNS entries (optional)

## Related skills / docs
- `../qemu_tap_bridge_networking/skill.md`
- `../lan_l2_macvlan_ipvlan/skill.md`
