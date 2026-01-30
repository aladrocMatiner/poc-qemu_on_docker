# Standards

## Naming conventions
- VMs: `${LAB_NAME}-node<N>` (e.g., `swarm-lab-node1`)
- Bridges: `SWARM_BRIDGE` (default `br0`), `MGMT_BRIDGE` (optional)
- Inventory: `work/inventory.json`
- Stacks: `phase2-<name>` (e.g., `phase2-linux-demo`)

## MAC derivation
- Deterministic per node and NIC.
- Management MAC: `MAC_PREFIX` + offset + node index (default offset 0x10).
- Swarm MAC: `MAC_PREFIX` + offset + node index (default offset 0x20).

## Inventory schema versioning
- `schema_version` is required.
- Breaking changes must bump the version and update dependent tooling.

## Port conventions
- If forwarded ports are used, keep a documented reserved range and avoid collisions.

## Language
- Project documentation, specs, and code comments MUST be written in English, even if discussion happens in Spanish.
