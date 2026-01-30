## ADDED Requirements

### Requirement: Case01 deploys services plus Linux VM runner
The Phase 2 Case01 workflow SHALL deploy two normal services and a Linux VM runner service in a single stack.

#### Scenario: Stack deployed
- **WHEN** the Case01 Ansible up playbook runs
- **THEN** the web service, ping service, and vm-runner service are all running

### Requirement: Case01 validates L2 connectivity
The Case01 workflow SHALL validate connectivity between normal services and the Linux guest on the L2 network.

#### Scenario: Connectivity checks
- **WHEN** the Case01 test playbook runs after deployment
- **THEN** connectivity checks between services and the guest succeed

### Requirement: Case01 teardown removes the stack
The Case01 workflow SHALL remove the stack and associated services cleanly.

#### Scenario: Stack removed
- **WHEN** the Case01 down playbook runs
- **THEN** the stack and services are removed from the swarm
