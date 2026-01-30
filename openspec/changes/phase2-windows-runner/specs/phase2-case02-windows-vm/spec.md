## ADDED Requirements

### Requirement: Case02 deploys Windows VM runner stack
The Phase 2 Case02 workflow SHALL deploy the Windows VM runner service on a vm-capable node.

#### Scenario: Stack deployed
- **WHEN** the Case02 Ansible up playbook runs
- **THEN** the vm-runner-windows service is running on a vm-capable node

### Requirement: Case02 validates Windows VM readiness
The Case02 workflow SHALL validate that the Windows VM is reachable via the chosen access method (RDP or WinRM).

#### Scenario: Access validation
- **WHEN** the Case02 test step runs after deployment
- **THEN** the Windows VM responds to the configured access check

### Requirement: Case02 teardown removes the stack
The Case02 workflow SHALL remove the Windows VM runner stack cleanly.

#### Scenario: Stack removed
- **WHEN** the Case02 down playbook runs
- **THEN** the stack and service are removed from the swarm
