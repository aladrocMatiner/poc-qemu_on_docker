# Inventory Schema

The lab inventory is written to `work/inventory.json` and consumed by SSH and Ansible tooling.

## Schema versioning
- `schema_version` is required.
- Any breaking change MUST bump `schema_version` and update dependent tooling.

## Schema (v1)
```json
{
  "lab_name": "swarm-lab",
  "schema_version": "1",
  "mgmt_mode": "user",
  "mgmt_network": "default",
  "nodes": [
    {
      "index": 1,
      "name": "swarm-lab-node1",
      "mgmt_mac": "52:54:00:ab:cd:11",
      "swarm_mac": "52:54:00:ab:cd:21",
      "mgmt_ip": "192.168.122.101",
      "ssh_target": "ssh ubuntu@192.168.122.101"
    }
  ]
}
```

## Stability rules
- `lab_name`, `schema_version`, and `nodes` MUST exist.
- Each node MUST include `index`, `name`, `mgmt_mac`, `swarm_mac`, and `ssh_target`.
- `mgmt_ip` is optional; if missing, `ssh_target` MUST explain how to set it.
