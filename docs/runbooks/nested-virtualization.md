# Nested virtualization (KVM) for Phase 2

## Purpose
Ensure the lab VMs can expose `/dev/kvm` so vm-runner containers can start QEMU/KVM.

## Quick check
```bash
make nested-kvm-check
```

## Symptoms
- Swarm service `vm-runner-linux` stays in `Pending` with "no suitable node".
- `make ansible-swarm` removes `vm-capable` labels because `/dev/kvm` is missing.

## Diagnosis
On the **host** (not inside the lab VM):
```bash
lsmod | grep -E 'kvm|kvm_intel|kvm_amd'
ls -l /dev/kvm
```

Check nested parameter:
```bash
cat /sys/module/kvm_intel/parameters/nested  # Intel (Y/1 = enabled)
cat /sys/module/kvm_amd/parameters/nested    # AMD (1 = enabled)
```

## Enable nested virtualization (host)
### Intel
```bash
sudo modprobe -r kvm_intel
sudo modprobe kvm_intel nested=1
```
Persist:
```bash
echo 'options kvm_intel nested=1' | sudo tee /etc/modprobe.d/kvm-intel.conf
```

### AMD
```bash
sudo modprobe -r kvm_amd
sudo modprobe kvm_amd nested=1
```
Persist:
```bash
echo 'options kvm_amd nested=1' | sudo tee /etc/modprobe.d/kvm-amd.conf
```

## After enabling
- Recreate the lab VMs (they need to see `/dev/kvm`).
- Then re-run:
```bash
make ansible-swarm
```

## Notes
- This is a **host-level** change (outside the lab VMs).
- If you run the lab inside another VM, the outer hypervisor must allow nested virtualization.

## Links
- `docs/phase2.md`
- `docs/runbooks/ansible-operations.md`
