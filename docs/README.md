# Documentation

This repository documents a PoC for **Docker Swarm + QEMU/KVM VM runners** with:
- L2 LAN attachment via **`br0` + TAP/vhost**
- **DHCP reservations by MAC** for stable addressing
- **Overlay networks** for internal service traffic

Start with specs in `../specs/` and follow skills in `../skills/`.

## Structure
- `adr/` — architecture decisions (required for major changes)
- `runbooks/` — operational procedures and troubleshooting
- `diagrams/` — network and architecture diagrams
