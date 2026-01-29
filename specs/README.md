# Specs

## What is a challenge spec?
A challenge spec is the source-of-truth definition for a significant change in this PoC. It defines scope, constraints, interfaces, acceptance tests, rollback, and ownership.

## Naming and versioning
- Specs live in `specs/<id>.yaml` using kebab-case IDs.
- IDs must be unique and listed in `specs/index.yaml`.

## Acceptance tests and rollback
- Each spec must include **acceptance tests** with commands and expected outcomes.
- Each spec must include **rollback** steps that are safe and reversible.

## Ownership and dependencies
- Each spec has an **owner agent** and explicit **dependencies**.
- Agents use skills to implement specs and update related runbooks/ADRs.

## Status lifecycle
- `draft` → `implemented` → `validated`
- Update `specs/index.yaml` when status changes.
