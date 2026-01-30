## ADDED Requirements

### Requirement: VM runner container launches a Linux guest
The VM runner service SHALL launch a Linux VM using QEMU inside a Swarm service container with deterministic configuration provided via environment variables.

#### Scenario: Launch with required environment
- **WHEN** the vm-runner service starts with VM_NAME, VM_DISK, VM_SEED, and VM_MAC
- **THEN** the container launches QEMU for the Linux guest using those parameters

### Requirement: KVM acceleration is used when available
The VM runner service SHALL use /dev/kvm when present on the node to enable hardware acceleration.

#### Scenario: KVM device present
- **WHEN** /dev/kvm is mounted into the container
- **THEN** QEMU starts with KVM acceleration enabled

### Requirement: Minimal privileges are sufficient for operation
The VM runner service MUST run without --privileged and instead use only required capabilities and device mounts.

#### Scenario: Minimal capability set
- **WHEN** the service is deployed with only NET_ADMIN and access to /dev/kvm and /dev/net/tun
- **THEN** the VM runner starts successfully and the guest is reachable

### Requirement: SSH access to the guest is supported
The VM runner service SHALL expose SSH access to the guest via an agreed mechanism (direct L2 reachability or a defined forward in the container).

#### Scenario: Guest SSH reachable
- **WHEN** the guest boots with cloud-init and SSH enabled
- **THEN** the guest accepts SSH connections using the configured key
