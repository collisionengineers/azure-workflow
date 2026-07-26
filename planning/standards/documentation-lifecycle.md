# Documentation and planning lifecycle

## Core model

The repository separates durable truth, future allocation, live work, and historical evidence. Each fact has one canonical owner.

```text
WHAT SHOULD THE PRODUCT DO?
        |
        +--> docs/product/ living requirements
        `--> declared active controlled/external requirement when applicable

WHAT OUTCOMES COME NOW/NEXT/LATER?
        |
        `--> docs/roadmap.md

WHAT WORK IS LIVE?
        |
        `--> GitHub Issues + Project + milestones

HOW WILL THIS ONE CHANGE BE DONE?
        |
        `--> docs/changes/YYYY-MM-DD-slug.md

WHAT DOES THE SYSTEM DO NOW?
        |
        `--> code + docs/architecture.md + docs/operations.md

WHAT VISUAL LANGUAGE AND SOURCE ASSETS DOES THE UI USE?
        |
        `--> design/ when Visual UI: present

WHY WAS A HARD-TO-REVERSE CHOICE MADE?
        |
        `--> docs/decisions/

WHAT HAPPENED?
        |
        `--> merged change records + Git/PR/release history

WHAT MATERIAL AGENT MISTAKES SHOULD IMPROVE THE WORKFLOW?
        |
        `--> docs/agent-mistakes.md
```

No file is permitted to be requirements catalog, roadmap, active-status board, implementation plan, and completion ledger at the same time.

## Canonical document classes

| Class | Owns | Must not own |
| --- | --- | --- |
| Product authority | Purpose/problem, intended outcomes, users, success measures, functional rules, quality constraints, boundaries, terminology, supported contracts | Live implementation status, assignees, PR progress |
| Controlled/external requirement | Stable clauses/IDs and approval/contract status whose artifact remains an active authority | Unclassified notes, inferred filename authority, or duplicated repository interpretation |
| Capability index | Stable IDs, concise outcome, product area, disposition, target release, canonical product owner | Detailed implementation steps or checklists |
| Roadmap | Small set of outcome-level Now/Next/Later allocations and gates | Per-task status or exhaustive feature catalog |
| UI/design system | Brand/foundation rules, one token-source route, approved source-asset mapping, component/pattern routes | Product behavior, live task state, or a copied runtime implementation |
| GitHub issue | Actionable problem/change discussion, owner, dependencies, milestone, current work state | Canonical long-term product truth |
| Change record | Decision-complete just-in-time plan, implementation evidence, review, outcome for one deliverable | Programme-wide backlog or repeated product requirements |
| ADR | Significant architectural decision and consequences | Ordinary implementation diary |
| Architecture/operations | Current implemented and operable reality | Unimplemented future design presented as current |
| Agent mistake log | Append-only factual incidents, recovery evidence, reusable prevention signals, and candidate plugin improvements | Product authority, live remediation state, review findings, automatic plugin changes, or routine tool/test noise |
| Archive/reference | Superseded or evidentiary material with status and successor link | Active authority or work state |

## Required target structure

```text
repository/
|-- AGENTS.md
|-- README.md
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |   |-- bug.yml
|   |   |-- decision.yml
|   |   |-- feature.yml
|   |   |-- task.yml
|   |   `-- config.yml
|   `-- pull_request_template.md
|-- docs/
|   |-- index.md
|   |-- roadmap.md
|   |-- product/
|   |   |-- index.md                 # living product-requirements/PRD role
|   |   |-- capabilities.md          # conditional: create when stable IDs or a large catalog add value
|   |   `-- areas/                   # conditional functional specifications for bounded product areas
|   |       `-- <area>.md
|   |-- architecture.md
|   |-- operations.md
|   |-- agent-mistakes.md
|   |-- decisions/
|   |   `-- NNNN-title.md
|   |-- changes/
|   |   `-- YYYY-MM-DD-slug.md
|   `-- reference/                   # conditional retained evidence or external/internal reference
|       `-- ...
`-- design/                          # required only when Visual UI: present
    |-- README.md
    |-- brand/
    |-- foundations/
    |-- tokens/
    |-- assets/
    |-- components/
    |-- patterns/
    `-- references/
```

There is no canonical general-purpose `docs/plans/` directory. During brownfield conversion, an existing plans directory may remain temporarily until parity checks pass. It is then either removed because the material moved to canonical owners or retained under `docs/reference/` with a clear non-authoritative status and successor links.

The full conditional design structure and one-source mapping rules are defined by [the UI and design-system standard](ui-design-system.md). Product behavior remains in product docs; design files own visual rules/assets; runtime source owns execution.

## Planning depth by horizon

```text
Later                 Next                    Now
-----                 ----                    ---
problem               outcome                 decision-complete scope
why retain            dependency              callers and owners
activation condition  release gate            data/failure/recovery
                                               UI/UX where relevant
                                               proof and docs
                                               one change record
```

Only `Now` normally receives detailed implementation planning. `Next` receives enough detail to make sequencing and activation decisions. `Later` remains cheap to change.

## When a plan file exists

A new `docs/changes/<date>-<slug>.md` exists only when one of these is true:

- the user asks for a decision-complete implementation plan;
- a standard/high-risk delivery is about to begin;
- a low-risk delivery needs a durable record under repository policy; or
- an existing planned record is being resumed.

It does not exist merely because an idea was mentioned. Ideas and untriaged requests belong in GitHub Issues. Settled product rules belong in product docs.

## Plan lifecycle

```text
idea / feature request
        |
        +--> not actionable yet --> GitHub issue: Triage
        |
        `--> user asks for plan
                 |
                 v
        inspect authority + reality
                 |
                 v
        interview material decisions
                 |
                 v
        create one change record: planned
                 |
                 +--> standalone: Docs check + ready plan PR -> stop
                 |
                 `--> delivery prerequisite: same branch/record continues
                           |
                           v
                    implementation + proof + review
                           |
                           v
                    exact-head-reviewed PR; record: ready
                           |
                           v
                    merge closes implementation issue
```

The record is not copied into a second implementation plan. Repository drift updates the affected sections with a dated note; it does not create a new task folder.

## Brownfield work-ledger conversion

An existing ticket directory, plan pack, generated board, verification queue, or local status database is an onboarding source, not a presumed target. Its identifiers and evidence may be valuable even when its live-state model is not.

```text
legacy ticket / plan / board
          |
          +--> intended behavior ----------> product area + capability ID
          +--> release allocation ---------> roadmap + exact release/unallocated
          +--> genuinely active outcome ---> human-confirmed GitHub parent issue
          +--> verification debt ----------> proof task/issue only when still actionable
          +--> completed proof/history ----> change record, reference, PR/Git history
          `--> duplicate generated state --> retire after semantic parity
```

Onboarding records both declared state and evidence state. It flags rather than normalizes away:

- an `active` plan whose own members are all complete;
- an active zero-member plan;
- an overloaded active/verification queue or empty sequencing horizon;
- one fact copied into plan, ticket, board, and generated index state;
- source metadata that changes meaning when parsed or rendered; and
- generated output with no named consumer or protected risk.

The human confirms the small set of genuinely active outcomes. The plugin does not bulk-create GitHub issues from legacy status values, and it does not discard completed identifiers or proof merely because they are not active work.

## Capability-index threshold

Create `docs/product/capabilities.md` when at least one is true:

- the repository already uses stable requirement/feature IDs;
- more than roughly twenty independent product capabilities must be routed;
- external authority requires traceability by stable ID; or
- one requirement is implemented across multiple releases and needs a stable identity.

The threshold is guidance, not an excuse to split a naturally small product. A repository with ten clear outcomes can keep them in product-area prose and omit the table.

## Exact capability row

```markdown
| ID | Capability/outcome | Area | Disposition | Target release | Canonical product section | Authority |
| --- | --- | --- | --- | --- | --- | --- |
| <capability-id> | <concise user or operator outcome> | <product area> | allocated | 0.4.0-beta.1 | `areas/<area>.md#<capability>` | `<relative-authority-path>` |
```

Allowed dispositions:

- `allocated`: assigned to an exact release;
- `unallocated`: retained product capability with no release commitment;
- `conditional`: requires the stated activation decision;
- `not-planned`: explicit product boundary;
- `retired`: formerly intended/supported behavior retained for identity/history, with the retirement release when known.

The index contains no `implemented`, `in progress`, `done`, assignee, checkbox, or PR column. Those values change too often and belong to GitHub/code evidence.

## Roadmap contract

`docs/roadmap.md` contains:

```markdown
# Roadmap

## Release model
## Now
## Next
## Later
## Not planned
## Allocation changes
```

Each Now/Next/Later entry contains only:

- outcome;
- exact target release when allocated;
- capability IDs or canonical product link;
- dependency/activation gate;
- parent GitHub issue when activated; and
- evidence required to leave the horizon.

`Allocation changes` is a compact dated log of material horizon/release moves. It is not an implementation status log.

## Documentation update matrix

| Change | Product | Capability index | Roadmap | Design | Architecture | Operations | ADR | Change record |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| New intended behavior | Update | Add/update if used | Update only if allocation changes | Update only when visual contract/assets change | When implemented | If operated differently | Only for significant choice | Required for planned/implemented change |
| Bug restoring documented behavior | Usually no | No | No | Correct drift if design authority was wrong | If current description was wrong | If procedure changes | No | Required |
| Refactor with no behavior change | No | No | No | Update source/runtime mapping if changed | Update boundaries if changed | If commands/deploy change | Sometimes | Required |
| Release allocation move | No behavior rewrite | Update target | Update horizon/release | No | No | No | No | Planning record or issue history |
| Feature implemented | Product already canonical; correct drift | No status field | No live status edit | Apply already-planned visual/source updates | Update current reality | Update run/recovery | As required | Evidence and ready outcome |
| Feature rejected/not planned | Update boundary | `not-planned` | Remove from Now/Next/Later; list boundary | Remove only approved-now-unused design authority/assets with caller proof | No | No | Only if architectural | Issue close reason/change record if material |

## Drift-prevention contract

Documentation maintenance has three independent layers:

```text
plan/change record
declare exact canonical owners affected, or a specific reason for none
        |
        v
same pull request
update implementation + owning docs + record; run Docs/Full checks
        |
        v
fresh exact-head review
compare request + intended authority + real callers/configuration semantically
        |
        +-- disagreement --> blocker/required -> remediate -> review new head
        `-- agreement ----> eligible for clean verdict
```

1. **Declared impact:** before implementation, the change record names the product, capability, roadmap, design, architecture, operations, ADR, and instruction owners that must change, or gives a specific reason each is unaffected.
2. **Same-change maintenance and mechanical proof:** implementation changes each affected canonical owner in the same pull request. Deterministic checks prove routes, links, headings, schemas, IDs, source/generated mappings, and other machine-testable contracts.
3. **Semantic exact-head proof:** a fresh reviewer traces current code, configuration, real callers, and operational procedures and compares them with intended product/design authority and current architecture/operations. Mechanical validation cannot prove semantic agreement.

Document disagreement is not deferred as normal follow-up work. It blocks a clean verdict unless the requested change explicitly excludes a different, pre-existing drift item and the remaining repository truth is not made misleading by the PR.

For an on-demand read-only audit, use `$explain-repository` to compare current implementation with intended/canonical documentation and identify the disagreeing owner. Use onboarding for a non-conforming repository, planning for a decision-complete correction, delivery to make the correction, and PR review to judge the resulting change. Explanation reports no verdict and performs no write.

No hook or scheduled drift bot is part of the default. Neither can decide semantic truth, and both add routine work without a named repository need. A repository-specific periodic audit is admissible only with a named consumer, owner, cadence, maximum scope, and response to findings.

## Staleness controls

- `docs/index.md` routes every canonical class and names its authority.
- Repository validation checks links, required headings, duplicate stable IDs, allowed dispositions, valid versions, and absence of live-status columns in capability/roadmap files.
- Source-backed human views must preserve parsed and rendered meaning; fixtures include YAML/Markdown special characters rather than checking syntax alone.
- Active records that are 100% complete or have no members, and a live ledger with no credible sequencing signal, are surfaced for disposition instead of passing silently.
- Generated inventories, boards, or indexes have one source owner, a named consumer/risk, deterministic lossless generation, and no hidden staging side effect; otherwise they are not canonical artifacts.
- Change records record the baseline commit used for planning. Delivery compares it with the current base before implementation.
- Every plan/change record declares documentation impact before implementation, and every PR states which canonical documents changed or gives a specific reason none changed.
- Every UI-impacting PR states which `design/` authorities/source mappings changed or why the existing system remains correct.
- Deterministic validation reports only the structural/semantic-source contracts it actually proves; it never claims that link/schema success proves prose matches runtime behavior.
- Fresh exact-head review compares canonical claims with real implementation/configuration/callers. Semantic drift is blocker/required work and invalidates a clean verdict.
- A plan older than the configured review interval is not automatically invalid, but delivery must run drift review before use.
- Historical files begin with a status explaining that they cannot allocate work or override current authority.
- `docs/agent-mistakes.md` preserves existing incident IDs/order/bodies; new qualifying entries and factual follow-ups are appended under the standard rather than rewriting history.
- No `NEXT.md`, duplicate Markdown task board, or generated orientation dashboard is canonical. README/docs index route humans, GitHub owns live order, and explanation synthesizes current position on demand.

## Why this model fits large feature lists

A large feature inventory is valuable when it preserves stable identity and exact scope. It becomes harmful when the same 200 rows are copied into roadmaps, plan packs, checklists, and status ledgers. This model retains one stable catalog, promotes only active outcomes into GitHub, and creates detailed plans just in time.

```text
200 durable capability rows
          |
          +--> 5-10 outcome-level roadmap entries
          |
          +--> only activated parent issues
          |
          `--> only current deliverables receive detailed change records
```

## Rejected approaches

- **One enormous living plan:** mixes authority and status, creates merge conflicts, and makes later details falsely precise.
- **One Markdown plan per feature from day one:** produces stale implementation assumptions and navigation overhead.
- **One GitHub issue per catalog row:** floods the actionable backlog and makes `open` mean nothing.
- **GitHub-only requirements:** loses durable product truth in issue discussion and makes offline repository reasoning incomplete.
- **Docs-only status boards:** duplicate GitHub state and drift.

## Acceptance checks

1. Every durable product claim has exactly one canonical product owner.
2. Every stable capability ID occurs exactly once in the capability index.
3. Roadmap entries route to capabilities but do not duplicate their full requirements.
4. GitHub owns live work state; product/roadmap docs contain no live-status columns.
5. A detailed plan exists only for a selected change and carries through implementation.
6. Superseded plan material is removed or explicitly non-authoritative with a successor link.
7. When `Visual UI: present`, `design/` has one token route and every tracked design source maps to its runtime consumer/export without an unlabelled duplicate.
8. Brownfield work-ledger conversion preserves IDs, claims, and proof, but creates GitHub work only for the human-confirmed active set.
9. Generated human-facing views preserve source semantics, including special characters, and cannot report completed/empty plans as unexamined active work.
10. Every implemented change names its documentation impact before work and updates affected owners in the same pull request.
11. Mechanical checks and semantic exact-head review state their distinct evidence limits; neither impersonates the other.
12. An on-demand drift audit is read-only through explanation, and correction routes through plan/deliver without creating a seventh skill, hook, or duplicate documentation ledger.
13. One required append-only mistake log retains only qualifying agent-improvement evidence and creates no automatic work or plugin change.
14. A user can find durable truth and live work through README/docs index/GitHub, while explanation supplies one current next action without a duplicated status file.
