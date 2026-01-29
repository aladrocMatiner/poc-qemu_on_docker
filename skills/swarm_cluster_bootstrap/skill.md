# swarm_cluster_bootstrap

## Goal
Initialize a Docker Swarm cluster, join managers/workers, label VM-capable nodes, and create a baseline overlay network.

## Non-goals
- HA hardening or production-grade security.
- Automating OS install or host provisioning.

## Prerequisites
- Docker Engine installed on all nodes.
- Network reachability between nodes.
- NTP or time sync enabled.

## Inputs/Variables (env vars, paths, configs)
- `MANAGER_IP` (advertise address)
- `SWARM_TOKEN_MANAGER` / `SWARM_TOKEN_WORKER`
- `VM_LABEL=vm-capable=true`
- `OVERLAY_NET_NAME=internal-net`
- Firewall rules for Swarm ports

## Steps (numbered procedure)
1. On the first manager, initialize Swarm with an explicit advertise address.
2. Record join tokens for managers and workers (store out-of-band).
3. Join additional manager nodes (if any).
4. Join worker nodes.
5. Apply node labels for VM-capable nodes (e.g., `vm-capable=true`).
6. Create a baseline attachable overlay network for internal services.
7. Verify node status and overlay network existence.

## Commands (short snippets)
```bash
$ docker swarm init --advertise-addr ${MANAGER_IP}
$ docker swarm join-token manager
$ docker swarm join-token worker
$ docker node ls
$ docker node update --label-add ${VM_LABEL} <node-id>
$ docker network create -d overlay --attachable ${OVERLAY_NET_NAME}
```

## Security considerations
- Open only required ports: 2377/tcp, 7946/tcp+udp, 4789/udp.
- Rotate join tokens after cluster formation.
- Restrict manager access to trusted IPs.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: `join` times out
  Cause: Swarm ports blocked
  Fix: Open 2377/tcp, 7946/tcp+udp, 4789/udp between nodes
- Symptom: Node shows `Down`
  Cause: Clock skew or connectivity loss
  Fix: Sync time and verify L3 connectivity

## Acceptance criteria (DoD)
- All nodes show `Ready` in `docker node ls`.
- VM-capable nodes are labeled.
- Baseline overlay network exists and is attachable.

## Artifacts produced
- Swarm cluster state
- Node labels
- Overlay network

## Related specs / docs
- Spec ID: `swarm-bootstrap` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/TBD`
- ADRs: `docs/adr/TBD`
