# Style Guide

## Markdown conventions and section order
- Use ATX headings (`#`, `##`, `###`).
- Keep paragraphs short; prefer bullets for procedures and checklists.
- Use fenced code blocks with language tags.
- Standard section order for skills/specs/templates as defined in their templates.

## Naming conventions
- **Specs:** `specs/<id>.yaml` (kebab-case `id`).
- **Spec IDs:** lowercase kebab-case (e.g., `qemu-runner-container`).
- **Skills:** `skills/<skill_name>/skill.md` (snake_case).
- **Agents:** `agents/<role>/agent.md` (lowercase, no spaces).
- **Runbooks:** `docs/runbooks/<topic>.md` (snake_case).
- **ADRs:** `docs/adr/NNNN-<topic>.md` (zero-padded).

## Commands, env vars, and assumptions
- Commands in code blocks; prefix shell commands with `$`.
- Environment variables in ALL CAPS (e.g., `VM_BRIDGE=br0`).
- File paths in backticks (e.g., `/var/lib/poc-qemu/images`).
- Assumptions listed explicitly in specs and runbooks.

## Internal link conventions
- Link chain: **spec → skill → runbook → ADR**.
- Use relative links (no external URLs unless required).
- Skills must reference **spec IDs** from `specs/index.yaml`.
- ADRs link back to the primary spec and related skills/runbooks.
