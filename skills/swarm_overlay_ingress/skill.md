# swarm_overlay_ingress

## Goal
Choose between routing mesh and publish mode=host for Swarm services, with focus on VM console access.

## Non-goals
- Implementing L7 ingress controllers.
- Public internet exposure policies.

## Prerequisites
- Swarm cluster running.
- Overlay network created.

## Inputs/Variables (env vars, paths, configs)
- `PUBLISH_MODE` (`ingress` or `host`)
- `CONSOLE_PORT_RANGE` (e.g., 5900-5999)
- Firewall rules for exposed ports

## Steps (numbered procedure)
1. Use **routing mesh** (`ingress`) for stateless HTTP services.
2. Use **publish mode=host** for VNC/SPICE/RDP to avoid routing mesh ambiguity.
3. Allocate ports to avoid collisions across nodes.
4. Document per-node console port mappings and firewall rules.
5. Verify connectivity from a client host.

## Commands (short snippets)
```bash
$ docker service create --publish published=8080,target=80,mode=ingress ...
$ docker service create --publish published=5901,target=5900,mode=host ...
$ docker service ps <service>
$ nc -zv <node-ip> 5901
```

## Security considerations
- Restrict console ports to trusted IPs.
- Avoid publishing consoles on 0.0.0.0 without firewalling.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Console connects to wrong VM
  Cause: Routing mesh used for stateful console
  Fix: Switch to `mode=host` and pin service to node
- Symptom: Port in use
  Cause: Collision with other services
  Fix: Allocate from reserved console port range

## Acceptance criteria (DoD)
- Console services reachable via host ports when required.
- No port collisions across nodes.
- Documented ingress/host choice per service.

## Artifacts produced
- Port allocation map
- Service publish configuration

## Related skills / docs
- `../swarm_stack_patterns/skill.md`
- `../vm_console_access_vnc_spice_rdp/skill.md`
