# Smoke Tests

## How to run
```bash
$ make smoke
$ make smoke-idempotent
```

## Artifacts to collect on failure
- `work/inventory.json`
- `work/tofu-outputs.json`
- `ansible` logs (stdout)
- `virsh list --all`

## Common failures
- SSH auth failure: check keys and inventory
- DHCP discovery failure: check libvirt leases
- Docker install failure: rerun ansible-docker
