# OpenSpec Workflow

## Create a new challenge spec
1. Copy `specs/templates/challenge.template.yaml` to `specs/<id>.yaml`.
2. Fill in problem statement, scope, constraints, assumptions, and acceptance tests.
3. Assign an **owner agent** and list dependencies.

## Update `specs/index.yaml`
- Add a new entry with:
  - `id`, `title`, `owner_agent`, `status`, `priority`
  - `dependencies`, `related_skills`, `related_runbooks`, `related_adrs`
- Keep `id` in kebab-case and unique.

## Mapping specs to skills and agents
- **Specs** define *what* and *why*.
- **Skills** define *how*.
- Agents **own specs** and use skills to implement them.
- Every skill must reference at least one spec ID.

## Acceptance tests
- Each spec must include acceptance tests with commands and expected outcomes.
- Tests must be runnable on a clean Swarm cluster.
- Document required environment variables or prerequisites.

## ADRs
- Any architectural decision requires an ADR in `docs/adr/`.
- ADRs must link back to the driving spec and relevant skills/runbooks.

## Change control
- Every PR must reference **at least one spec ID** (or state why not).
- Specs transition through: `draft` → `implemented` → `validated`.
