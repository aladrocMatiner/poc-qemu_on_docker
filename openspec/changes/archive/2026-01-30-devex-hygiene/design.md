## Context

As automation expands, we need predictable developer commands, documented standards, and a basic CI gate to prevent regressions without requiring libvirt in CI.

## Goals / Non-Goals

**Goals:**
- Provide a small set of safe UX targets (doctor/clean/reset/snapshot).
- Document project conventions in a single standards doc.
- Add lightweight CI checks for scripts and tofu formatting.

**Non-Goals:**
- Running libvirt-dependent tests in CI.
- Building a full QA pipeline.

## Decisions

- `doctor` is best-effort and non-destructive.
- `clean` only removes local artifacts; `reset` performs lab-destroy first.
- CI runs shellcheck and tofu fmt/validate only.

## Risks / Trade-offs

- [False positives in doctor] → Keep it best-effort and informative.
- [Snapshot limitations] → Clearly warn about best-effort nature.

## Migration Plan

1. Add Make targets and docs/standards.md.
2. Add CI workflow.
3. Add placeholder specs to clarify roadmap.

## Open Questions

- Should `doctor` also validate inventory schema version?
