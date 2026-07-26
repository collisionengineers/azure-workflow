# System architecture

## Purpose

`azure-workflow` is a policy and orchestration plugin. It does not replace Git, GitHub, a repository's build system, Azure resource providers, or human product authority. It supplies one dependable repository lifecycle plus a read-only explanation route, with explicit ownership and stopping boundaries.

## Context

```text
                                     USER
                                      |
                 product decisions   |   exact Azure apply approval
                                      v
+----------------------- CODEX + azure-workflow -----------------------+
|                                                                      |
|  onboard ----------------> convert truth, docs/design, GitHub, CI    |
|       |                                                              |
|       `------------------> ready conversion PR                        |
|                                                                      |
|  plan -------------------> inspected record + canonical intent docs   |
|       |                    Docs check + plan review                    |
|       `------------------> ready documentation PR; planned STOP       |
|                                                                      |
|  deliver ----------------> plan prerequisite when absent              |
|       |                    implement + docs + tests + push PR          |
|       `------------------> review skill + CI + remediation -> ready   |
|                                                                      |
|  explain ----------------> code/docs/GitHub/official evidence         |
|       `------------------> plain-English understanding; no changes    |
|                                                                      |
|  review PR --------------> actual PR + exact head + full diff         |
|       `------------------> read-only findings/verdict; no fixes       |
|                                                                      |
|  operate ----------------> Learn MCP + Azure MCP + az/azd/IaC         |
|       `------------------> read/validate or approved apply + verify   |
|                                                                      |
+---------------------------------------------------------------------+
           |                         |                         |
           v                         v                         v
   TARGET REPOSITORY              GITHUB                    AZURE
 durable truth/evidence     live work and releases     observed resources
```

## Component model

```text
.codex-plugin/plugin.json
          |
          +--> onboard-azure-repository
          |       +--> references + repository template assets
          |
          +--> plan-azure-repository-change
          |       +--> references + change-record template
          |
          +--> deliver-azure-repository-change
          |       +--> references
          |
          +--> explain-repository
          |       +--> references
          |
          +--> review-repository-pull-request
          |       +--> references + shared PR-evidence helper
          |
          +--> operate-azure-repository
          |       +--> references
          |
          +--> shared conditional references
          |       `--> dotnet-projects.md (onboard/plan/deliver/explain/review)
          |
          +--> plugin-root PowerShell helpers
          |
          `--> .mcp.json
                  +--> azure
                  `--> microsoft-learn

No hooks.json
No .app.json
No workflow database or JSON task state
No public UI/testing/documentation skill
```

## Ownership boundaries

| Boundary | Plugin owns | Plugin does not own |
| --- | --- | --- |
| Repository truth | Authority map, canonical documentation/design structure, consistency, conversion, change records, and declared human-owned-root boundaries | Undeclared business decisions or edits to `operator-notes/`/other protected human roots without request |
| Visual design | Conditional root `design/` schema, source/runtime mapping, one token-source rule, UI planning/delivery/review gates | A default brand, palette, logo, font, component system, product copy, or duplicated runtime assets |
| .NET technology profile | Conditional discovery, planning, implementation, and review rules for actual .NET project types and toolchains | A forced target framework, solution format, project count, architecture pattern, test framework, Azure host, or automatic modernization |
| Planning | Repository-grounded research, canonical intent/roadmap updates, risk/release/UI/GitHub decisions, reviewed Docs-only plan PR, stop boundary | Product implementation or executable/runtime mutation |
| Implementation | Scoped code/config/docs/tests, caller proof, proportional verification, remediation | Unrelated dirty work or speculative scope |
| Explanation | Evidence-grounded plain-English feature/system/term/feedback explanation with current/intended/proposed separation | Correctness verdict, plan, fix, persistent documentation, GitHub response, or state mutation |
| Review | Fresh read-only review of the actual PR, exact-head findings/verdict, and feedback reconciliation | Implementation fixes, same-author approval, review dismissal, or automatic merge |
| GitHub | Forms/templates in the repository; scoped branch/commits/PR; issue/project/milestone updates under the exact workflow | Organization-wide type changes or unrelated project mutation without confirmation |
| Azure | Read discovery, official research, validation, exact approved mutation, post-change proof | Credential custody, guessed subscription, or unapproved mutation |
| Tooling | Four shared deterministic PowerShell helpers | Replacement of a sound native build/test system |

## Four different state systems

Do not put all state into one feature-list status column.

```text
SOFTWARE IDENTITY       PRODUCT READINESS       FUTURE ALLOCATION       LIVE WORK
SemVer                  maturity stage          roadmap horizon         GitHub status
0.4.0-beta.1            beta                    Now / Next / Later       Triage -> Done
```

Their owners are manifest/tags/releases, `docs/product/index.md`, `docs/roadmap.md`, and GitHub respectively.

## Change-record state

A change record is the durable plan and evidence envelope for one bounded change, not a live task board.

```text
request
   |
   v
active (planning) -- material decision/external prerequisite --> blocked
   ^                                                            |
   |---------------------- resolved -----------------------------+
   |
   +---- planning content/review gate -------------------------> planned
   |                                                               |
   |                         later delivery request ----------------+
   |                                                               v
   `-------------------------------> active (delivery) ---------> ready

active / blocked / planned ---------------- request replaced ---> superseded
```

- `active`: planning or implementation is in progress.
- `blocked`: one named decision or prerequisite prevents the endpoint.
- `planned`: decision-complete, risk-appropriate review complete, implementation not started; standalone plans normally sit in a ready documentation PR or merged plan record.
- `ready`: agreed implementation endpoint reached; normally a green exact-head-reviewed PR.
- `superseded`: another record replaces it and is linked.

GitHub owns finer live states such as Triage, In progress, In review, and Done. The record never attempts to mirror every issue transition.

## Documentation and work routing

```text
operator-notes/ + declared human-owned roots
       |          binding/non-binding and mutation role explicit
       v
AGENTS.md         short always-loaded prohibitions and routes
       |
       +--> docs/product/       intended behavior and supported contracts
       +--> docs/roadmap.md     outcome allocation only
       +--> docs/architecture   current implemented boundaries
       +--> docs/operations     verified operation/recovery
       +--> docs/decisions      durable reasons
       `--> docs/changes        one-change plan and evidence
                                      |
                                      v
                          GitHub Issues + Project + milestones
                                  live work only
```

## Delivery interaction

```text
implementation request
        |
        v
usable reviewed plan? -- no --> invoke plan skill as prerequisite
        | yes                         |
        +<----------------------------+
        |
        v
baseline drift -> implementation -> proof -> commit/push -> actual PR + CI
                                                        |
                                                        v
                                                fresh PR reviewer
                                                  | finding
                                                  v
                                               remediate
                                                  |
                                                  +--> push new head
                                                           |
                                                           v
                                                   complete re-review
                                                           |
                                                           v
                                                final exact-head attestation
                                                           |
                                                           v
                                                         ready
```

## Repository mode

```text
development
  one current path; remove replaced behavior; no speculative fallback/legacy code
        |
        | explicit stable-release decision + supported contracts + operations proof
        v
released
  compatibility only for a named supported contract; explicit migration/deprecation
```

Mode is declared in `AGENTS.md` and `docs/product/index.md`. It is related to maturity/version but never inferred solely from a version string.

## Trust model

```text
current user instruction
          |
operator-notes + declared product authority + active ADRs
          |
          v
intended change record
          |
          v
code + configuration + IaC
          |
          v
caller-backed checks + observed Azure state
          |
          v
fresh independent review + CI
```

Code is evidence of current behavior, not automatic evidence of intended behavior. Plans are historical after their change; they do not outrank canonical product authority.

## Deliberate simplifications

- One plugin distributes six focused skills; there is no plugin-per-stage suite.
- One change record replaces fixed task folders, journals, JSON handoffs, and duplicated plan artifacts.
- A stable capability index replaces giant feature checklists; GitHub issues exist only for activated work.
- PR review is both a standalone read-only user goal and an internal fresh role invoked by owning workflows. Explanation is a standalone read-only user goal but is not invoked for routine communication inside other skills. Validation is evidence, while UI/UX and .NET technology guidance remain conditional routes rather than public skills for symmetry's sake.
- Two MCPs provide current Microsoft/Azure data; GitHub remains on Git/CLI and no documentation corpus is vendored.
- One shared plugin-root .NET reference prevents five goal-specific copies from drifting. Each consuming skill links it directly and loads only the sections relevant to the detected project type.
- `AGENTS.md`, `docs/index.md`, and conditional `design/README.md` provide durable routing; no session hook injects context.
