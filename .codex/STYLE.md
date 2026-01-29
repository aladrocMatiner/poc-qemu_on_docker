# Style Guide

## Markdown conventions
- Use ATX headings (`#`, `##`, `###`).
- Keep paragraphs short; prefer bullet lists for procedures and checklists.
- Use fenced code blocks with a language tag (e.g., `bash`, `yaml`).
- Use **bold** for emphasis, not as a heading substitute.

## Naming conventions
- **Agents:** `agents/<role>/agent.md` (role is lowercase, hyphen-free).
- **Skills:** `skills/<skill_name>/skill.md` (snake_case only).
- **Runbooks:** `docs/runbooks/<topic>.md` (snake_case).
- **ADRs:** `docs/adr/NNNN-<topic>.md` (NNNN is zero-padded).

## Commands and variables
- Commands in code blocks; prefix with `$` when showing shell invocations.
- Environment variables in ALL CAPS (e.g., `VM_BRIDGE=br0`).
- File paths in backticks (e.g., `/var/lib/poc-qemu/images`).
- Document required privileges (`root`/`sudo`) explicitly.

## Troubleshooting sections
Use this format:

```
- Symptom: <what you see>
  Cause: <likely root cause>
  Fix: <specific action>
```

Keep each entry short and actionable.

## Internal link conventions
- Use relative links within repo, e.g., `../docs/adr/README.md`.
- Link to skills/agents by path (no external URLs unless required).
- Prefer linking to runbooks and ADRs from skills.
