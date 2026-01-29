# Definition of Done (DoD)

## Universal DoD (any change/PR)
- [ ] Requirements met; scope and non-goals respected.
- [ ] Reproducible steps documented (host setup, Swarm labels, network).
- [ ] Smoke tests updated and runnable on a fresh node.
- [ ] Rollback notes included (how to stop services, remove volumes, revert configs).
- [ ] Security review completed (caps, devices, secrets/configs, exposure).
- [ ] Logging/metrics impact assessed and documented.
- [ ] No secrets or ISOs committed.
- [ ] ADR added/updated for major architectural decisions.

## Skill completion DoD
- [ ] Skill steps are complete, ordered, and runnable.
- [ ] Inputs/variables and prerequisites are explicit.
- [ ] Security considerations and troubleshooting included.
- [ ] Acceptance criteria are measurable.
- [ ] Artifacts produced listed.
- [ ] Related skills/docs linked.

## PoC-specific checks
- [ ] Swarm constraints/labels used for VM runner placement.
- [ ] `br0` + TAP/vhost networking documented and verified.
- [ ] DHCP reservations by MAC documented and testable.
- [ ] Overlay networks used only for internal service traffic.
