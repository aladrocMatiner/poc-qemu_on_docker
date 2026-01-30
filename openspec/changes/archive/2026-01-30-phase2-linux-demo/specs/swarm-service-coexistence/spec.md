## ADDED Requirements

### Requirement: Normal Swarm service runs alongside VM runner
The system SHALL run a standard Swarm service concurrently with the VM runner service.

#### Scenario: Coexistence without placement conflict
- **WHEN** both services are deployed
- **THEN** they MUST schedule successfully without node constraint conflicts.

### Requirement: Service isolation
The normal service SHALL use Swarm overlay networking for internal communication, separate from VM L2 networking.

#### Scenario: Normal service uses overlay network
- **WHEN** the service is started
- **THEN** it MUST attach to the designated overlay network.
