## ADDED Requirements

### Requirement: Windows VM assets exist on vm-capable nodes
The system SHALL ensure required Windows VM assets are present on all vm-capable nodes before deployment.

#### Scenario: Assets prepared
- **WHEN** the asset preparation playbook runs
- **THEN** the Windows ISO, virtio ISO, and base disk paths exist on each vm-capable node

### Requirement: Assets are referenced by consistent paths
The Windows VM runner service SHALL use consistent, documented paths for ISO and disk assets across nodes.

#### Scenario: Consistent paths
- **WHEN** the stack deploys on any vm-capable node
- **THEN** the VM runner finds the ISO and disk paths without node-specific overrides
