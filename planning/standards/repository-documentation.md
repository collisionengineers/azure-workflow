# Repository documentation standard

## Goal

Give humans and agents a short durable route to the correct authority while supporting large products without a giant plan folder or duplicated feature list.

## Required and conditional spine

```text
repository/
|-- AGENTS.md                              required
|-- README.md                              required
|-- .github/                               required when GitHub is the remote
|   |-- ISSUE_TEMPLATE/
|   |   |-- bug.yml
|   |   |-- config.yml
|   |   |-- decision.yml
|   |   |-- feature.yml
|   |   |-- task.yml
|   |   `-- <purpose-named>.yml              conditional: distinct registered intake only
|   |-- pull_request_template.md
|   `-- workflows/
|       `-- <canonical-verify-workflow>.yml
|-- docs/
|   |-- index.md                           required
|   |-- product/
|   |   |-- index.md                       required living product-requirements/PRD role
|   |   |-- capabilities.md                conditional: use for stable capability IDs
|   |   `-- areas/                         conditional: use for real product areas
|   |       `-- <area>.md
|   |-- roadmap.md                         required
|   |-- architecture.md                    required
|   |-- operations.md                      required
|   |-- agent-mistakes.md                  required append-only historical learning evidence
|   |-- decisions/
|   |   `-- NNNN-title.md                  conditional per durable decision
|   |-- changes/
|   |   `-- YYYY-MM-DD-slug.md             one per planned/implemented change
|   `-- reference/                         conditional retained evidence only
|       `-- <purpose-named-category>/
`-- design/                                required when Visual UI: present
    |-- README.md
    |-- brand/                             style, imagery, logo sources
    |-- foundations/                       colour, typography, layout, motion, accessibility
    |-- tokens/                            exactly one source route or explicit none
    |-- assets/                            icon and font source inventories
    |-- components/
    |-- patterns/
    `-- references/
```

All canonical files are tracked. Required files cannot be empty. A section that genuinely does not apply says why and what condition would make it applicable. `docs/product/index.md` declares `Visual UI: present | absent`; the exact conditional design tree and ownership rules are defined in [the UI and design-system standard](ui-design-system.md).

There is no canonical `docs/plans/` directory. An existing one may remain only as a temporary conversion source until the parity gates in [feature-catalog conversion](../workflows/feature-catalog-conversion.md) pass.

## Root `AGENTS.md`

Purpose: the thin always-loaded authority and workflow router, not a second product or architecture document.

Required headings:

```markdown
# Repository instructions
## Authority
## Active mode
## Environment
## Repository map
## Workflow
## Validation
## Product and data constraints
## Local instructions
## Safety boundaries
```

Required content:

- name every declared human-authored source/protected root relevant across sessions, its content role, canonical destination or external owner, and mutation rule; never infer authority from a path name;
- route all other durable truth through `docs/index.md`;
- route visual design authority through `design/README.md` when `Visual UI: present`;
- declare `development` or `released` and link `docs/product/index.md`;
- state Windows/PowerShell 7 and probe-before-use expectations for `az`, `azd`, workflow skills, and Azure MCP;
- name the exact canonical verification command and its path-aware behavior;
- route onboarding, planning, delivery, plain-language explanation, pull-request review, and Azure operations to the six skills;
- require evidence-based qualifying agent mistakes to be appended to `docs/agent-mistakes.md`, while read-only workflows return a pending entry instead of writing;
- require low-cognitive-load collaboration: outcome first, one recommended next action, one material question at a time, and no burdening the user with inspectable implementation choices;
- require exactly one GitHub work kind and only `docs/operations.md`-registered project-specific categories for issues the workflow touches;
- explain nearest nested `AGENTS.md` behavior;
- state the user-facing wording, internal-Azure-language, supplied-material permission/licensing assumption, excluded unsolicited PII/DPA/DPIA/privacy/retention/licensing work, non-synthetic-domain-example, purpose-revealing-name, and non-speculative-design constraints; and
- state repository-specific immutable/sensitive boundaries.

Forbidden content:

- duplicated architecture/product narrative;
- long commands already owned by operations;
- copied dependency/resource lists that can be discovered dynamically;
- active task status, historical plan/review logs, or plugin internals irrelevant to the target repository.

## Nested `AGENTS.md`

Create only for a materially different local owner, caller, validation command, security boundary, generated-code policy, or operational hazard.

```markdown
# Local instructions: <path>
## Boundary
## Owner and callers
## Local validation
## Local hazards
```

It inherits root authority and contains deltas only.

## Root `README.md`

Human discovery and supported use only:

```markdown
# <Repository name>
## Purpose
## Status
## Quick start
## Development
## Documentation
```

It links to `docs/index.md` and the repository's live GitHub work surface when present. It does not carry agent policy, a feature backlog, a release checklist, or a duplicated “what next” status board.

## `docs/index.md`

Canonical router:

```markdown
# Documentation
## Authority order
## Canonical documents
## Product areas
## Human-authored sources and protected roots
## Visual design system
## Dynamic discovery
## Historical records
```

The authority order names real paths/owners for product, external/controlled requirements, security, architecture, operation, decisions, visual design when present, and historical agent-mistake evidence. When human-authored sources or protected roots exist, their table records path/URI, content role, status, canonical destination, and mutation rule. Dynamic discovery gives live commands/searches for callers/config/tests/deploy entry points instead of copying mutable lists. `Historical records` routes `docs/changes/` and `docs/agent-mistakes.md` without presenting either as live work.

## `docs/product/index.md`

Top-level living product-requirements and release contract. This performs the repository-level PRD role without creating a duplicate `PRD.md`:

```markdown
# Product requirements
Mode: development | released
Versioning scheme: SemVer 2.0.0 | <recorded alternative>
Current version: <exact version>
Maturity stage: prototype | alpha | beta | release-candidate | stable | maintenance | retired
Release authority: <person/role/source>
Visual UI: present | absent

## Purpose and problem
## Users and desired outcomes
## Success measures
## In scope
## Out of scope
## Requirements and invariants
## Quality attributes and constraints
## Supported contracts
## User-facing language and interaction
## Development materials, licensing, and test examples
## Product areas and capabilities
## Current limitations
## Open product decisions
```

It states intended behavior, success, and supported boundaries; it never implies that every intended capability is currently implemented. Success measures are observable outcomes or explicit evidence routes, not invented vanity metrics. Quality attributes and constraints contain only product-level performance, reliability, accessibility, security, compatibility, or operational outcomes that the product must satisfy; implementation design remains with architecture and change planning.

The default section says supplied materials, software, dependencies, and services are fully permitted and licensed for development/testing and that unsolicited PII/DPA/DPIA/privacy/retention/licensing work does not constrain scope. It also routes repository-specific exceptions only when a human authority explicitly records one. It does not duplicate dependency inventories or invite licence classification.

## `docs/product/capabilities.md`

Create when the product has a meaningful stable feature/capability catalog or existing IDs must survive conversion.

```markdown
# Capability index

| ID | Capability/outcome | Area | Disposition | Target release | Canonical product section | Authority |
| --- | --- | --- | --- | --- | --- | --- |
| <capability-id> | <concise user or operator outcome> | <product area> | allocated | 0.4.0-beta.1 | `areas/<area>.md#<capability>` | `<relative-authority-path>` |
```

Rules:

- IDs are stable, unique, and never silently reassigned.
- Full behavior lives at one linked product section; the row is an index, not a second specification.
- Disposition is exactly `allocated`, `unallocated`, `conditional`, `not-planned`, or `retired`. `retired` preserves the identity of formerly supported behavior without pretending it is live work.
- Target is an exact version for `allocated`; for `retired`, use the exact retirement release when known. Every other case uses `unallocated`. Never use `V1`, `V2`, `Phase 3`, or `someday`.
- No assignee, implementation status, checkbox, implementation steps, or percent-complete field.
- A capability does not require a GitHub issue until an outcome is activated.

## `docs/product/areas/<area>.md`

Create one only when a product area owns several related capabilities or a distinct user workflow/authority. Required shape:

```markdown
# <Product area>
## Authority, users, and desired outcomes
## Functional behavior and business rules
## Workflow, states, and transitions
## Inputs, outputs, data, and terminology
## Permissions and failure/recovery behavior
## Quality attributes and constraints
## Acceptance examples and evidence routes
## Boundaries, exclusions, and current limitations
```

Split by user/product ownership, not by source-code folder. This is the durable lightweight functional-specification/FRD role when the area warrants it. Small products keep the material in the product index; do not create one file per trivial feature.

## PRD, FRD, SRS, and other formal requirements artifacts

The content role matters more than the acronym:

| Requirements role | Default owner |
| --- | --- |
| Product-wide purpose, users, outcomes, success, scope, requirements, constraints, and contracts | `docs/product/index.md` living PRD role |
| Durable detailed behavior for a real product area | `docs/product/areas/<area>.md` functional-specification role |
| One activated change's acceptance, design, proof, rollout, and recovery | Active `docs/changes/<record>.md`; historical after delivery |
| Live work status, owner, dependency, and target release | GitHub Issue, Project, and milestone |

An existing controlled PRD, FRD, SRS, URS, or contract retains its real path, IDs, status, approval history, and declared authority until migration parity is proved. Keep and route it when its format is a contractual/regulatory/supplier/human-controlled deliverable; otherwise consolidate accepted durable claims into the normal product spine without creating a duplicate acronym-named document. Add formal per-requirement IDs or a traceability matrix only when an existing contract, approval process, regulatory need, or multi-team interface requires that machinery.

## Root `design/`

Create only when `docs/product/index.md` declares `Visual UI: present`. It is the obvious visual-design authority for brand style, imagery, logo sources, colour, typography/font inventory, layout, motion, accessibility foundations, token routing, component/pattern indexes, and approved references. It maps to framework-appropriate runtime paths rather than duplicating them. See [the exact design-system standard](ui-design-system.md).

## `docs/roadmap.md`

Outcome allocation, not a task board:

```markdown
# Roadmap
## Release assumptions and gates
## Now
## Next
## Later
## Not planned
```

- `Now`: current selected release outcomes, exact target release, gate, parent issue once activated.
- `Next`: likely outcomes plus dependency/activation condition; normally no detailed plan.
- `Later`: retained possibility plus reason/trigger; no speculative issue tree.
- `Not planned`: explicit product boundary and authority; no open implementation issue.

It contains no assignees, live status, sprint detail, hundreds of checkboxes, or implementation plan.

## `docs/architecture.md`

Current implementation only:

```markdown
# Architecture
## System context
## Components and ownership
## Entry points and callers
## Data and control flow
## Rules and configuration ownership
## Source roles and generated material
## Persistence and configuration
## Identity and trust boundaries
## Azure topology
## Failure and recovery boundaries
```

Future architecture remains in an active change record/ADR until implemented.

For a non-trivial rule-bearing system, `Rules and configuration ownership` identifies each canonical behavioral owner, precedence, real callers, typed/configuration source, feature-gate lifecycle, and proof route. `Source roles and generated material` distinguishes live code from generated/materialized output, reference/test-only code, released compatibility/replay bridges, and retirement candidates. The document uses relative repository paths and current call graphs; it does not require readers to reconstruct behavior from ticket history.

## `docs/operations.md`

Verified operational procedures:

```markdown
# Operations
## Prerequisites
## Windows and PowerShell environment
## Local run
## Canonical verification
## Technology toolchains and supported platforms
## Test selection and CI scopes
## Repository-provided test data
## GitHub work management
## Configuration and secrets
## Deployment
## Monitoring
## Recovery and rollback
## Troubleshooting
```

Commands are executed/verified or explicitly labelled unverified examples. Secrets are named by custody location/environment-variable name, never value.

When a conditional technology profile applies, `Technology toolchains and supported platforms` records its actual entry point, version/support boundary, prerequisites, and local/CI equivalence. For .NET this includes the selected solution/project, SDK/TFMs, package/analyzer authority, and exact restore/build/test/format/publish/migration commands that genuinely apply; it does not copy generic Microsoft documentation into the repository.

`GitHub work management` contains `Work kinds`, `Project-specific categories`, `Project fields, milestones, and relationships`, `Issue and pull-request lifecycle`, and `GitHub capability limitations`. It owns the custom-category registry. Exactly one universal kind is mandatory; custom categories are additive facets and may not duplicate Project fields, milestones, assignees, or native relationships. When none exist, write `No project-specific categories are currently registered.` rather than placeholder labels. Private issue forms and form Project auto-add are documented as intake conveniences rather than enforcement.

## Architecture decisions

Path: `docs/decisions/NNNN-title.md`.

```markdown
# NNNN: <Decision title>
Status: proposed | active | superseded | rejected
Date: YYYY-MM-DD
Supersedes: none | <relative link>
Superseded by: none | <relative link>

## Context
## Decision
## Alternatives considered
## Consequences
## Validation
```

Numbers are four-digit monotonic and never renumbered after merge. Only active ADRs govern; superseded records link both ways and remain history.

## Change records

Use [the exact change-record contract](change-record.md). It is the only required per-change planning/evidence artifact, but it does not replace canonical product/roadmap/architecture/operations truth.

## `docs/agent-mistakes.md`

Use [the exact agent mistake-log standard](agent-mistake-log.md). It is one append-only file for material evidenced agent mistakes and reusable prevention signals. It is not a backlog, review-finding ledger, product authority, per-change requirement, or automatic source of plugin changes. An empty entries section is valid; no incident is fabricated during onboarding.

## Navigation

```text
AGENTS.md -> docs/index.md
                 |
                 +--> product/index + areas + capabilities  intended behavior
                 +--> roadmap                              outcome allocation
                 +--> architecture                         current structure
                 +--> operations                           run/deploy/recover
                 +--> decisions                            durable reasons
                 +--> changes                              plan/evidence/history
                 `--> agent-mistakes.md                    append-only learning evidence

GitHub Issues + Project + milestones                       live work/release state
```

## Human orientation and next action

`README.md` is the obvious human starting point; `docs/index.md` routes durable truth; GitHub owns live order; `$explain-repository` synthesizes the current position and one evidence-based next action. Do not add `NEXT.md`, `TODO.md`, a generated daily dashboard, a Markdown status board, or a duplicate priority/next-action field.

When current work exists, the explanation and owning workflow present `done / now / next / waiting` only as a concise view of the canonical sources. They do not persist that view as a new owner. See [the ADHD and non-coder collaboration design](../research/adhd-noncoder-collaboration-design.md).

## Canonical verification

- Exactly one local command is declared.
- It supports Docs/Full path-aware selection when code checks are materially more expensive.
- Prefer an existing native entry point; add one thin wrapper only when necessary.
- GitHub CI calls the same entry point and always reports `verify`.
- Markdown-only changes run documentation checks, not code suites. Executable/ambiguous paths run Full.
- Focused proof runs first but never replaces the canonical check.

## Human-authored sources and protected roots

A repository may contain approved specifications, contracts, working notes, interview transcripts, supplied evidence, or scratch areas under any name. `AGENTS.md` and `docs/index.md` record each relevant path/URI using two independent properties:

- content role: approved product authority, active external/controlled requirement, draft/discovery input, evidence/reference, or superseded/history; and
- mutation rule: workflow-maintained, human-edit-only, preserve-in-place, or generated/do-not-edit.

No filename, directory name, human authorship, or immutability sets the content role automatically. In particular, `operator-notes/` has no reserved plugin meaning. A target repository may explicitly declare that exact folder—or any other real path—to be authoritative and human-edit-only, and the workflow then preserves that local rule.

An unclassified human-authored source is preserved during discovery and provisionally treated as non-binding discovery input. Onboarding extracts its material claims, resolves only material ambiguity, and records accepted requirements once in the canonical product owner. Retain, archive, move, or remove the original only under its declared mutation rule and after claim, identifier, link, and history parity. See [the human-notes and requirements audit](../research/operator-notes-and-requirements-documentation-audit.md).

## Generated documentation and views

Generated documentation is admitted only when it has one canonical source, a named consumer, and a concrete risk or navigation need that it protects. Its generation must be deterministic, reproducible, and semantically lossless from source through parser to human-facing view.

Generators and validators may not stage files, commit, or use broad Git-add behavior. Generated destinations are labelled as such and never edited by hand. Repository inventories, reconciliation hashes, fixed-point passes, and duplicate status boards are not defaults; retain them only when repository evidence shows that their value exceeds their review and churn cost.

## Completion gate

A plan/delivery cannot claim its endpoint while any applicable condition is true:

- intended behavior changed without the correct product/capability owner;
- release allocation changed without roadmap, milestone, and issue agreement;
- implemented boundaries changed without architecture agreement;
- run/deploy/monitor/recover behavior changed without operations agreement;
- a durable hard-to-reverse choice lacks an ADR;
- a qualifying agent mistake made or discovered by a write-authorized workflow lacks its append-only entry, or a read-only workflow conceals that its entry is still pending;
- live work status was copied into durable product/roadmap docs;
- required change-record planning/evidence/review is missing; or
- canonical links, schemas, or commands are broken.
