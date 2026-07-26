# Feature-planning workflow

## How the plugin directs planning

Planning is activated by its own goal-specific skill, not by a hook, MCP call, hidden planner, or action buried inside delivery.

```text
plugin installed
      |
      v
frontmatter description matches plan/design/research/scope language
      |
      v
Codex loads plan-azure-repository-change/SKILL.md
      |
      +--> authorization says documentation-only plan delivery, no implementation
      +--> core route says inspect before interview
      +--> conditional references add GitHub/version/UI/risk/.NET detail
      |
      v
change record + settled product/roadmap/ADR effects = reviewed plan
      |
      v
Docs check -> documentation-only PR -> actual PR review -> status planned -> STOP
```

The delivery skill may explicitly invoke the same content/review gate as a prerequisite. It skips a separate plan PR and continues the same branch/record under the already-granted delivery request.

## Instruction layers

| Layer | Responsibility |
| --- | --- |
| `SKILL.md` frontmatter | Match a recognizable plan-only user goal |
| `agents/openai.yaml` | Display label and default invocation prompt; not workflow authority |
| `SKILL.md` authorization | Permit documentation-only branch/PR work and establish the hard no-implementation boundary |
| `references/change-planning.md` | Exact inspection, interview, design, review, persistence, and drift procedure |
| Conditional references | Version/release, GitHub, UI/UX, documentation, risk, and shared .NET details only when relevant |
| Change record | Durable decisions, ordered plan, intended proof, baseline, and lifecycle state |
| Scenario tests | Prove correct activation, useful output, and stop enforcement |

No MCP or hook selects planning. After selection, the skill explicitly applies the Microsoft Learn guidance gate. It calls Learn when the user requests Microsoft guidance or a material decision depends on a current Microsoft-controlled fact, reuses scoped same-change evidence without drift, and makes no ceremonial call for pure repository-owned logic.

## Endpoint classifier

```text
USER REQUEST
     |
     +-- plan/design/research/compare/explore/scope + no implementation
     |          |
     |          `--> PLAN SKILL -> exact-head-reviewed Docs-only plan PR -> STOP
     |
     +-- implement/build/fix/change/deliver
     |          |
     |          `--> DELIVERY SKILL
     |                    |
     |                    `-- no plan -> invoke PLAN SKILL prerequisite -> continue
     |
     +-- explain/translate/how does this work/what does this mean
     |          |
     |          `--> EXPLAIN SKILL -> evidence-linked understanding -> STOP
     |
     +-- review/judge correctness of an existing PR or comment
     |          |
     |          `--> REVIEW SKILL -> exact-head verdict -> STOP
     |
     `-- live Azure inspection/deployment/configuration
                |
                `--> OPERATE SKILL
```

If a request explicitly asks for both a plan and implementation, select delivery; it calls planning first. “Compare possible designs” is planning, while “compare what is implemented with what the documents currently intend” is explanation unless the user asks to choose or change something. If the requested endpoint is genuinely ambiguous, ask one short endpoint question before any mutation.

## End-to-end flow

```text
confirm planning endpoint and repository identity
      |
      v
clean onboarded Git repository? -- no --> route/refuse with exact reason
      |
      v
read AGENTS + docs/index + operator-notes + product/roadmap/ADRs
      |
      v
record baseline commit + issue/capability/release/horizon/mode
      |
      v
inspect real callers, owners, rules, config, source roles, hotspots, data, failure, tests, UI, Azure
      |
      v
material unresolved choice?
      | yes
      +----> ask one decision -> incorporate -> reinspect affected area ---+
      |                                                               |
      no <--------------------------------------------------------------+
      |
      v
write acceptance + ordered implementation/proof/recovery/docs plan
      |
      v
standard/high risk? -- yes --> fresh read-only plan review -> remediate
      |
      v
no unresolved material decision?
      | no  -> status blocked + exact owner/question
      | yes
      v
update settled product/capability/roadmap/ADR docs + Docs check
      |
      +-- delivery prerequisite --> return same branch/record to delivery
      |
      `-- standalone --> docs commit -> push -> capability-appropriate plan PR
                                                   |
                                                   v
                                        Docs CI + actual PR review
                                                   |
                                                   v
                                         issue Ready + STOP
```

## Phase 1: identity and authority

Record before design:

- repository root/URL, default branch, and baseline commit SHA;
- exact issue/parent issue if supplied;
- capability IDs and canonical product sections;
- current semantic version, maturity stage, repository mode, target release, and horizon;
- current user instruction, applicable `operator-notes/`, active product authority, and active ADRs; and
- risk level and why.

Do not select the newest record or assume a feature-list row is active work. `unallocated` and no issue are valid states.

## Phase 2: current reality

Inspect:

- real entry points, callers, users/operators, and preceding/following workflow;
- current policy/component owner and nearby exercised seams;
- canonical business-rule and behaviorally important configuration owners, precedence, activation, and every competing decision surface;
- live/generated/materialized/reference/test-only/compatibility source roles and any required bridge-removal lifecycle;
- size, branch, fan-out, caller, and recent-churn hotspots the change would deepen;
- interfaces, schemas, persistence, configuration, permissions, secrets, and trust boundaries;
- happy, negative, failure, retry, conflict, and recovery behavior;
- tests, canonical check, CI classification, and repository-provided examples;
- product/area/capability/roadmap/architecture/operations/decision documents;
- UI routes, root `design/` authority, one token source, source/runtime asset mappings, components, viewports, inputs, and accessibility evidence when relevant;
- IaC and actual Azure state when relevant, using reads/validation/what-if only.

When .NET source/project/build/package/test/persistence/host/deployment is affected, load the shared .NET profile and additionally map exact solution/project/TFM scope, project references, composition root/host, options/DI ownership, analyzer/package authority, test-suite roles, and current Microsoft support evidence for version-specific decisions.

Separate intended behavior, observed behavior, external constraints, assumptions, and unresolved decisions.

For each Microsoft Learn result actually used, record official URL, UTC retrieval time, exact product/version/host scope, whether the page states a requirement/recommendation/example, and the decision effect. Do not paste the documentation corpus into the plan.

## Phase 3: focused interview

Ask only when authority and inspection cannot safely resolve a choice that changes behavior, safety, architecture, supported contracts, release allocation, migration, cost, UI direction, or acceptance.

Ask one material question at a time and include:

- the conflict/unknown;
- its concrete consequence;
- the recommended default and reason; and
- the exact decision required.

Do not ask the user to select ordinary filenames, patterns already established in code, routine test mechanics, or other implementation details discoverable by inspection.

## Phase 4: decision-complete design

Settle, where applicable:

1. Goal, user/operator, observable success, scope, and exclusions.
2. Owning component and real caller changes.
3. Exact interfaces, data/control flow, schema/config changes, permissions, failure, retry, conflict, and recovery, with one canonical rule/configuration owner and explicit precedence.
4. Supported-contract/migration consequences under the declared mode.
5. Target release, maturity/horizon effect, capability/product/roadmap changes, and GitHub issue hierarchy.
6. Azure resources, IaC, identity, networking, cost, reliability, deployment, what-if, and recovery.
7. UI/UX contract when affected: journey, action mapping, state matrix, wording, accessibility, viewport/input, reuse, exact `design/` owners/source-runtime mappings changed or retained, and evidence.
8. Smallest exercised future seam required by known scope; no dormant service, flag, queue, table, interface, or generic framework.
9. Ordered implementation steps naming owner/path, intended behavior, dependency, and proof.
10. Focused tests, real-caller proof, canonical docs/full check, independent review inputs, documentation/ADR updates, rollout, and recovery.
11. Source-role and bridge lifecycle changes, hotspot effect, and local/CI reproducibility consequences.

The implementer must not need to invent an architecture, ownership boundary, interface, data policy, failure behavior, UI direction, migration rule, release placement, or acceptance criterion.

## Options

Compare alternatives only when two viable choices differ materially in behavior, cost, risk, reversibility, or future constraint. For each, record shape, benefits, cost, failure modes, mode fit, current/future impact, and evidence. Make a recommendation. Do not generate ceremonial alternatives for a settled local pattern.

## GitHub behavior

- Reuse a supplied Feature/Bug/Task/Decision issue. Require exactly one owner-aware work kind, registered project-specific facets only, required semantic content, and explicit Project membership; repair unambiguous metadata and ask one focused question when classification is ambiguous. On an organization without native Decision, Decision is native Task + `decision`.
- Update release, horizon, dependencies, and Status `Ready` only after the plan/Docs publication gate passes or delivery immediately continues. Never assume private form validation or form Project auto-add enforced the issue contract.
- For low-risk planning with no issue, record `Issue: none — low-risk plan`; the plan PR is sufficient unless an issue was requested/required.
- For a standard/high-risk implementation-ready plan, create the correct issue when GitHub is available/in scope. If it is unavailable or explicitly excluded, preserve `planned` locally but prevent Project `Ready`/delivery until the issue exists.
- Create one parent Feature issue for an activated outcome, not one issue per capability row. Create sub-issues only when independently deliverable work is ready to enter the queue.
- Never close an issue during planning.

## Persistence and stop

In an execution-capable Codex mode:

1. Call the real `update_plan` tool for the session work.
2. Create/resume exactly one change record.
3. Fill planning sections; mark intended checks `not run — planning only`.
4. Update product/capability/roadmap/ADR documents only for already-settled intended facts; never describe unimplemented architecture/operations as current.
5. Obtain required plan review, preserve the round, and run the Docs-scope canonical check.
6. Set `planned` or `blocked`.
7. If delivery invoked the prerequisite, return without a separate push/PR so delivery continues the same branch and record.
8. Otherwise commit the documentation with `docs: plan <short outcome>`, push, and open/update the plan PR using native draft when supported or normal PR + `do-not-merge` on the personal Free/private route. Link the issue/record both ways and monitor Docs CI.
9. For standard/high risk, invoke `$review-repository-pull-request` in a fresh context against the actual plan PR. Remediate/recommit/re-push documentation findings and repeat complete review. Publish the final exact-head `COMMENT` review, transition the under-review marker, and then stop.
10. Do not change product code, runtime configuration, IaC, executable CI/workflows, Azure, or merge state.

If remote publication is explicitly excluded/unavailable, make the verified local documentation commit and report that the normal ready-plan-PR endpoint remains unavailable. If repository mutation itself is unavailable, return the complete proposed plan/intended paths and do not falsely claim persistence.

## Completion gate

```text
identity/baseline/authority clear
AND goal/scope/exclusions/acceptance clear
AND caller/owner/rule/config/source-role/data/failure/recovery clear
AND release/horizon/GitHub relationship settled when relevant
AND UI/UX contract settled when relevant
AND design/token/source-runtime impact settled when relevant
AND ordered implementation and proportional proof explicit
AND no material decision unresolved
AND required fresh plan review clear
AND no implementation performed
                    |
                    v
       content status: planned
                    |
      standalone + remote available?
             | yes -> Docs CI + required exact-head plan-PR review
             ` no  -> explicit local-only/unavailable fallback
```

If blocked, record the exact question/prerequisite, owner, affected sections, and safe boundary. A partial design is not called implementation-ready.

## Drift and later delivery

Delivery compares the recorded baseline with the current base and authorities. Cosmetic/unrelated drift is noted. Material drift reopens only affected sections and repeats the required review. The same record is then set `active`; a second plan is not created.
