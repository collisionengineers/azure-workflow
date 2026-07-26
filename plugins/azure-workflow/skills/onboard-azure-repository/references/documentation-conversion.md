# Documentation conversion

## Inventory before moving

Build a claim ledger for material purpose, users, behavior, requirements, limitations, architecture, operations, decisions, design, roadmap, release, and active-work claims. Include stable IDs, links, source role, conflicts, destination, and disposition (`retained`, `merged`, `historical`, `removed after parity`).

## Canonical owners

| Fact | Owner |
| --- | --- |
| repository map/authority/routes | `docs/index.md` |
| living product requirements | `docs/product/index.md` and warranted `docs/product/areas/*.md` |
| stable capability inventory/allocation | `docs/product/capabilities.md` when useful |
| outcome horizon/release intent | `docs/roadmap.md` |
| current architecture/ownership | `docs/architecture.md` |
| build/deploy/monitor/recover/support | `docs/operations.md` |
| hard-to-reverse decision | `docs/decisions/NNNN-*.md` |
| one change's plan/evidence/outcome | `docs/changes/YYYY-MM-DD-*.md` |
| qualifying agent-improvement evidence | append-only `docs/agent-mistakes.md` |
| UI brand/foundations/assets/components/patterns | root `design/` when visual UI exists |

`docs/product/index.md` performs the living PRD role. Create a functional-area document only when an area has enough stable behavior/invariants to justify an owner. Retain formal SRS/URS/PRD/FRD artifacts when their controlled IDs, approvals, or contractual format remain required; route them instead of duplicating them.

## Parity before retirement

Retire a source only when every material claim/ID/link/history requirement has a recorded destination or explicit historical disposition, canonical navigation resolves, generated/source ownership is correct, and a fresh reviewer compares the new claims with real implementation. Mechanical counts alone are insufficient. Record removed paths and Git recovery commit.

Do not create temporary task trees, session journals, generated dashboards, or permanent conversion ledgers outside the onboarding change record.
