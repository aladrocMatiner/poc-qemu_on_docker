# Definition of Done (DoD)

## Universal DoD (any spec/skill implementation)
- [ ] Reproducible steps documented (host setup, Swarm labels, network).
- [ ] Smoke tests and acceptance checks documented and runnable.
- [ ] Rollback steps documented.
- [ ] Security review completed (caps, exposure, secrets).
- [ ] Logging/metrics considerations noted.
- [ ] Cross-links updated: spec ⇄ skill ⇄ runbook ⇄ ADR.
- [ ] No secrets or ISOs committed.

## Skill completion DoD
- [ ] Skill steps complete, ordered, and actionable.
- [ ] Inputs/variables and prerequisites explicit.
- [ ] Security considerations and troubleshooting included.
- [ ] Acceptance criteria measurable.
- [ ] Related spec IDs listed from `specs/index.yaml`.

## PoC-specific checks
- [ ] Swarm constraints/labels used for VM runner placement.
- [ ] `br0` + TAP/vhost networking documented and verified.
- [ ] DHCP reservations by MAC documented and testable.
- [ ] Overlay networks used only for internal service traffic.
