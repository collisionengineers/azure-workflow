# Skill boundaries and progressive disclosure

## Decision

`azure-workflow` contains six public skills:

1. `onboard-azure-repository`
2. `plan-azure-repository-change`
3. `deliver-azure-repository-change`
4. `explain-repository`
5. `review-repository-pull-request`
6. `operate-azure-repository`

Planning is no longer an action hidden inside delivery. Pull-request review is public because the user explicitly requires standalone review of an existing PR and its read-only authorization must not imply implementation. Plain-English explanation is also public because “help me understand this feature/comment/check” is a standalone read-only endpoint that must not silently become a review verdict, plan, fix, or documentation write. UI/UX, documentation maintenance, GitHub work tracking, testing, and CI remain conditional procedures inside the public goal that owns their endpoint.

## Why the earlier three-skill design changes

The earlier design combined `PLAN`, `DELIVER`, and `REMEDIATE` in one skill. That reduced the skill count, but it gave one skill two materially different user goals:

- produce a decision-complete plan and stop without implementation; and
- change the repository through a green pull request reviewed at its exact final head.

Those goals have different trigger language, authorization, inputs, and success criteria. OpenAI's current skill builder guidance says to keep each skill focused on a recognizable user goal and to split workflows when their triggers, inputs, or success criteria differ. It also says to keep `SKILL.md` concise and move detailed policies and procedures into conditionally loaded references. See [OpenAI: Build skills](https://developers.openai.com/plugins/build/skills).

The open [Agent Skills specification](https://agentskills.io/specification) supports the same implementation shape: metadata loads first, the selected `SKILL.md` loads second, and referenced files load only when required. It recommends a `SKILL.md` below 500 lines, focused reference files, and one-level reference links.

The revised boundary is therefore:

```text
recognizable user goal
        |
        +--> own public skill
        |
        `--> conditional concern within that goal
                 |
                 `--> reference loaded only when relevant
```

## Public-skill test

A concern becomes a public skill only when all three are true:

1. A user can reasonably ask for it as a standalone outcome.
2. It has a distinct authorization or stopping boundary.
3. It has a distinct success criterion that is not merely a quality gate inside another outcome.

Apply the test as follows:

| Concern | Standalone outcome? | Distinct boundary? | Distinct success criterion? | Placement |
| --- | --- | --- | --- | --- |
| Brownfield onboarding | Yes | Broad documentation and workflow conversion | Repository conforms and conversion PR is ready | Public skill |
| Feature/change planning | Yes | Documentation-only branch/PR permitted; no product implementation or Azure mutation | Decision-complete exact-head-reviewed plan PR, or explicit verified local-only fallback | Public skill |
| Delivery/remediation | Yes | Repository edits, branch, push, and PR authorized | Green exact-head-reviewed PR | Public skill |
| Explanation/education | Yes | Read-only; stops before verdict, plan, fix, GitHub response, persistent documentation, or Azure mutation | Accurate evidence-linked plain-English explanation | Public skill |
| Pull-request review | Yes | Strictly read-only; no fixes or GitHub mutation | Exact-head evidence-based verdict on an existing PR | Public skill |
| Azure operation | Yes | Live external state and explicit mutation approval | Exact Azure state observed and, if approved, changed and verified | Public skill |
| UI/UX | Usually a property of a planned or delivered change | Material redesign may add a user decision gate | UI contract or implemented behavior contributes to the parent endpoint | Conditional plan/delivery references |
| GitHub issue tracking | No; it records and routes work | External GitHub writes are normal workflow steps | Correct issue/project state contributes to planning/delivery | Conditional references |
| Documentation maintenance | No; every repository change must maintain truth | Canonical-document ownership | Documentation current at the parent endpoint | Core instructions and references |
| Testing and CI | No; they prove work | Proportional evidence gate | Green relevant proof contributes to delivery | Delivery reference |
| .NET technology guidance | No; it modifies how an existing goal is performed | Same authorization as onboard/plan/deliver/explain/review | Correct project-specific evidence contributes to the parent endpoint | One shared conditional plugin-root reference |

Review and explanation are not added for symmetry. The user identified the concrete standalone requests “review this PR” and “explain this feature/comment in plain English”; they have different endpoints even though both are read-only. UI design, documentation, and testing still fail the standalone-boundary test and remain routed concerns.

## Exact routing

```text
USER REQUEST
     |
     +-- convert/onboard/adopt standard ----------> onboard
     |
     +-- plan/design/research/scope and stop -----> plan
     |
     +-- implement/fix/deliver/remediate ---------> deliver
     |                                                 |
     |                                                 `-- no usable plan?
     |                                                        |
     |                                                        `-- invoke plan as prerequisite,
     |                                                            then continue same request
     |
     +-- explain/translate/teach/what does this mean
     |                                           -> explain repository
     |
     +-- review/audit/check an existing PR --------> review PR
     |
     `-- inspect/deploy/change live Azure ----------> operate
```

The planning prerequisite used by delivery produces the same record/canonical-document content and passes the same planning review gate. It does not create a separate plan PR; the user's delivery request already authorizes continuation on the delivery branch.

## Reference-loading rule

Every `SKILL.md` contains:

- its authorization and endpoint;
- mandatory preflight and stopping rules;
- a short main route;
- an explicit table saying which reference to load for each condition; and
- no copied repository-specific facts.

Example for delivery:

```text
always load:       repository mode, implementation quality, Git/PR
code changed:      testing and CI
UI affected:       UI/UX delivery
issue supplied:    GitHub delivery
PR candidate:      invoke fresh review skill after push
Azure impact:      route bounded work to operate skill
```

References are loaded by a direct link from `SKILL.md`; a reference never instructs the agent to chase another reference. Goal-specific references are skill-local. The single cross-stage .NET technology profile is plugin-root-owned and directly linked by each of its five consumers so its rules cannot drift across lifecycle copies. Assets contain only files copied or transformed into a repository. Scripts exist only for deterministic operations that are more reliable than prose.

## Cloudflare comparison

The current [Cloudflare skills repository](https://github.com/cloudflare/skills) is useful, but it does not establish that every workflow should be one monolithic skill. It contains:

- a broad `cloudflare` platform router with decision trees and many product references; and
- separate goal-specific skills such as `wrangler`, `durable-objects`, `agents-sdk`, and MCP/agent-building workflows.

Its broad router works because the top-level user goal is coherent: choose and use the correct Cloudflare platform capability. The detailed product material is retrieved only after routing. The router also warns that live Cloudflare documentation and installed schemas override baked-in reference data. See the actual [Cloudflare `SKILL.md`](https://github.com/cloudflare/skills/blob/main/skills/cloudflare/SKILL.md).

The same pattern is adopted here only within a coherent goal. For example, the planning skill routes to versioning, UI/UX, or GitHub references. It is not used to collapse planning, repository mutation, and live Azure mutation into one trigger.

## Rejected alternatives

### One universal Azure Workflow skill

Rejected because its description would match almost every repository request, its body would contain incompatible authorization boundaries, and failures in one route could activate unrelated instructions.

### Eight lifecycle plugins

Rejected because installation, discovery, ownership, and state would be fragmented. A plugin is the distribution unit; a skill is a focused workflow. There is no reason for plan, implementation, validation, and review to be separately installed products.

### Three skills with a plan/deliver action selector

Rejected after checking current OpenAI guidance. The small numerical saving is not worth ambiguous activation and two different completion definitions in one skill.

### Separate UI, documentation, and testing skills immediately

Rejected for `0.1.0-alpha.1` because they are mandatory or conditional stages of planning/delivery rather than proven standalone user endpoints. Pull-request review is the exception because its standalone demand and read-only boundary are now explicit and observed.

### Put explanation inside review or planning

Rejected because explaining one comment is not a complete PR correctness assessment, and understanding current behavior is not a plan to change it. Combining them would activate unnecessary evidence/PR machinery and blur the stop boundary. The detailed comparison is in [translator and educator workflow placement](../research/translator-educator-placement.md).

## Acceptance tests

1. A plan-only prompt selects only `plan-azure-repository-change`, produces a Docs-only ready plan PR when a remote is available, and stops before implementation.
2. An implementation prompt selects delivery; if no plan exists, delivery invokes planning as an unpublished prerequisite and then continues the same branch/record.
3. A UI implementation request does not activate a competing UI skill; it loads the UI references inside plan/delivery.
4. A live Azure request selects `operate-azure-repository`, even when repository changes may later be required.
5. A request to explain a feature or exact review comment selects only `explain-repository`, returns a layered evidence-linked explanation, and makes no mutation or whole-PR verdict.
6. “Is this PR/comment correct?” selects review; “fix it” selects delivery; “write this explanation into docs” selects delivery.
7. A request to review an existing PR selects only `review-repository-pull-request`, returns an exact-head verdict, and makes no repository or GitHub mutation.
8. Delivery creates/updates the PR first, then invokes a fresh review context; any tracked remediation invalidates the verdict and triggers complete re-review.
9. Every `SKILL.md` remains under 500 lines and every referenced file is directly linked from its owning `SKILL.md`.
10. A .NET repository activates the shared profile inside the selected goal skill, including explanation when .NET mechanics are material; a non-.NET repository does not load it, and no `.NET` public skill competes for the request.
