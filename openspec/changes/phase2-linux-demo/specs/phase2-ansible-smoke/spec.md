## ADDED Requirements

### Requirement: Ansible smoke validation for Phase 2 demo
The system SHALL provide an Ansible playbook that validates the Phase 2 demo scenario.

#### Scenario: Playbook validates coexistence
- **WHEN** the playbook is executed
- **THEN** it MUST verify that a normal Swarm service and a Linux VM runner are both running.

### Requirement: Ansible-only interaction
All acceptance validation SHALL be executed via Ansible without manual SSH.

#### Scenario: Smoke uses Ansible playbooks only
- **WHEN** tests are run
- **THEN** they MUST be invoked through Ansible (or Make targets that call Ansible).
