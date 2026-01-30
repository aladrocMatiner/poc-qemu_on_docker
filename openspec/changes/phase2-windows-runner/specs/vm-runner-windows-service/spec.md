## ADDED Requirements

### Requirement: Windows VM runner boots from ISO media
The Windows VM runner service SHALL boot a Windows guest using a configured Windows ISO and virtio driver ISO.

#### Scenario: ISO paths configured
- **WHEN** VM_WINDOWS_ISO and VM_VIRTIO_ISO are provided in the service environment
- **THEN** QEMU attaches both ISOs and boots the Windows guest

### Requirement: Deterministic VM configuration
The Windows VM runner service SHALL apply deterministic VM settings (name, MAC, disk path) from environment variables.

#### Scenario: Deterministic settings applied
- **WHEN** VM_NAME, VM_MAC, and VM_DISK are set
- **THEN** the guest uses those values in the VM definition

### Requirement: Minimal privileges and KVM acceleration
The Windows VM runner service MUST run without --privileged and SHALL use /dev/kvm when available.

#### Scenario: KVM device present
- **WHEN** /dev/kvm is mounted into the container
- **THEN** QEMU starts with hardware acceleration enabled
