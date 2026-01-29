## ADDED Requirements

### Requirement: Host readiness checks for libvirt lab
The system SHALL validate host readiness for a libvirt-based lab without modifying existing networking by default.

#### Scenario: Verify virtualization support
- **WHEN** the host readiness check is executed
- **THEN** it reports whether CPU virtualization flags (vmx/svm) are present

#### Scenario: Verify KVM device access
- **WHEN** the host readiness check is executed
- **THEN** it verifies `/dev/kvm` exists and is readable/writable by the current user

#### Scenario: Verify libvirt connectivity
- **WHEN** the host readiness check is executed
- **THEN** it verifies `virsh -c qemu:///system list` succeeds

#### Scenario: Verify required bridges
- **WHEN** MGMT_MODE is `bridge`
- **THEN** the readiness check requires both `SWARM_BRIDGE` and `MGMT_BRIDGE` to exist

#### Scenario: Verify required bridges (user mode)
- **WHEN** MGMT_MODE is `user`
- **THEN** the readiness check requires `SWARM_BRIDGE` to exist and does not require `MGMT_BRIDGE`
