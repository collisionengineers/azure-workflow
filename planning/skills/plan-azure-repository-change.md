# Skill specification: `plan-azure-repository-change`

## Public purpose

Turn one repository feature, fix, refactor, operation, or documentation change into a decision-complete, repository-grounded, risk-scaled plan. Persist the record and any settled canonical planning-document effects in a documentation-only PR reviewed at its exact final head, then stop before implementation.

The same skill may be invoked as a prerequisite by delivery. Its content/review output is identical, but it returns control before standalone publication so delivery can continue the same branch, record, and eventual implementation PR.

## Exact folder

```text
skills/plan-azure-repository-change/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
|-- assets/
|   `-- change-record-template.md
`-- references/
    |-- change-planning.md
    |-- documentation-lifecycle.md
    |-- github-planning.md
    |-- risk-scaling.md
    |-- ui-ux-planning.md
    `-- versioning-and-release-stages.md
```

No `scripts/` subfolder exists. The plugin-root create-only script copies the plan skill's change-record asset. The conditional shared .NET profile lives at `plugins/azure-workflow/references/dotnet-projects.md`, outside this skill-local tree, and is linked directly from `SKILL.md`.

## `SKILL.md` frontmatter

```yaml
---
name: plan-azure-repository-change
description: Research, interview, design, scope, review, and persist a decision-complete plan for one change in an onboarded Azure-oriented repository, normally as a documentation-only pull request reviewed at its exact final head, then stop before implementation. Use when the user asks to plan, design, research, compare options, explore future choices, scope, or make an implementation-ready plan for a feature, fix, refactor, documentation change, UI/UX change, release outcome, or repository operation. Use explain-repository instead when the endpoint is only understanding existing behavior, terminology, or feedback and no decision-complete plan is requested.
---
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Plan Repository Change"
  short_description: "Create a decision-complete repository-grounded plan"
  default_prompt: "Use $plan-azure-repository-change to inspect and plan this change, persist it through a documentation-only pull request reviewed at its exact final head, and stop before implementation."

policy:
  allow_implicit_invocation: true
```

No MCP is unconditionally required. Apply the central Microsoft Learn guidance gate. Call it when the user asks for Microsoft guidance or when a material decision depends on current Microsoft version/support/tool/API/host/service/migration/deployment guidance; do not call it for pure repository-owned logic. Record compact evidence for delivery reuse. Unavailable official evidence blocks only the dependent decision. Planning cannot authorize an Azure mutation.

## Required `SKILL.md` body structure

```markdown
# Plan Azure Repository Change
## Confirm the planning endpoint
## Preconditions and authorities
## Establish change identity and baseline
## Inspect repository reality
## Interview material decisions
## Select risk and conditional routes
## Write and review the change record
## Publish the plan and stop
## Resources
```

## Authorization contract

Standalone invocation authorizes:

- read-only repository, Git, GitHub, official-document, and Azure discovery;
- one scoped planning branch when repository writes are permitted;
- one change record and only those canonical product/capability/roadmap/ADR documentation edits required by settled planning decisions;
- documentation validation, narrow documentation commits, branch push, capability-appropriate plan PR creation, Docs CI observation/remediation, required actual-PR review, publication of its exact review evidence, and completion transition;
- updating an explicitly supplied GitHub issue with the remote plan link; and
- creating the required standard/high-risk issue as a normal planning step when a GitHub remote is available, unless the user explicitly requested local-only/no-GitHub planning.

It does not authorize:

- product implementation, runtime configuration, IaC, executable CI/workflow changes, or current-state architecture/operations claims not changed by implemented reality;
- merge or issue closure;
- bulk issue creation or roadmap reallocation outside the named change;
- Azure mutation; or
- rewriting `operator-notes/`.

When delivery invokes this skill as a prerequisite, it performs the same planning/documentation/review gate but skips the standalone push/plan-PR endpoint. The delivery request authorizes continuation on the same branch and eventual implementation PR. The planning skill itself never performs implementation.

## Core instructions

1. Confirm that the endpoint is planning, either standalone or as the explicit prerequisite of `$deliver-azure-repository-change`.
2. Require an onboarded repository and a clean worktree. Route brownfield conversion to `$onboard-azure-repository`.
3. Resolve/fetch the remote default branch. Create or unambiguously resume `workflow/YYYYMMDD-<slug>` from that base before writing the record; never attach to a similarly named branch by age alone.
4. Read root/nearest `AGENTS.md`, `docs/index.md`, relevant `operator-notes/`, product authority, current architecture/operations including the GitHub taxonomy registry, active ADRs, roadmap/capability entries, existing issue, and any named prior record. When `Visual UI: present`, read `design/README.md` and the applicable brand/foundation/token/asset/component/pattern authorities before proposing UI work.
5. Resolve repository mode, current version/maturity stage, target release/horizon, and baseline commit.
6. Inspect real callers, owning components, data/configuration/persistence, rule/configuration authority, source roles, failure/recovery behavior, tests, UI, CI, Azure impact, and existing extension seams. Note size/branch/fan-out/churn hotspots that the change would deepen. For UI work, resolve the one token source and every affected design-source/runtime mapping.
7. Distinguish intended behavior, current implementation, external constraints, and historical evidence.
8. Apply the Microsoft Learn call gate. Reuse a scoped official result already recorded for the same active change only when its product/version/host and baseline remain applicable and no drift signal exists.
9. Ask one material question at a time only when repository authority cannot answer it and the answer changes behavior, safety, architecture, release allocation, migration, cost, or acceptance.
10. Use the real Codex `update_plan` harness for the active planning work; a Markdown checklist is not a substitute.
11. Select low/standard/high risk and load only applicable references:
   - always: `change-planning.md`, `risk-scaling.md`, `documentation-lifecycle.md`;
   - release/version/horizon affected: `versioning-and-release-stages.md`;
   - GitHub issue/milestone/hierarchy affected: `github-planning.md`;
   - UI/UX affected: `ui-ux-planning.md`;
   - .NET source/project/build/package/test/persistence/host/deployment affected: shared `../../references/dotnet-projects.md`, using only the applicable variant sections.
12. Explore alternatives only when two or more viable options differ materially.
13. Write one change record containing scope, exclusions, baseline, authorities, current state, callers/owners, rule/configuration/source-role effects, acceptance, ordered implementation plan, failure/recovery, tests, documentation, Azure effects, decisions, intended proof, and compact Microsoft evidence when used. UI plans name exact `design/` owners/mappings to update or state why the current design authority remains unchanged. .NET plans include the exact solution/project/TFM scope, entry-point-to-owner path, dependency/configuration/DI/public-contract/migration effects, proportional test route, and current Microsoft support evidence whenever a version-specific choice is made.
14. Update canonical product/capability/roadmap/ADR documents only for intended facts and allocations that are already settled by authority. Proposed/unresolved behavior remains in the record; never edit architecture/operations as though unimplemented work exists.
15. For standard/high risk, obtain a fresh read-only plan review and remediate every blocker/required finding.
16. Set status `planned` and run the Docs-scope canonical check.
17. If invoked as a delivery prerequisite, return control on the same cleanly scoped branch without creating a separate plan PR.
18. Before publishing remote work, require the selected/created issue to have exactly one owner-aware work kind, only registered custom categories, required semantic content, and Project membership. Repair unambiguous metadata; ask one focused question when classification is ambiguous. Do not rely on private form requiredness or form Project auto-add.
19. For standalone planning, stage literal documentation paths, commit narrowly, push, and create/update a plan PR that never closes the implementation issue. Use native draft when supported or normal PR + `do-not-merge` on the personal Free/private route. Monitor Docs CI. For standard/high risk, invoke `$review-repository-pull-request` in a fresh context against the actual PR; remediate documentation findings and repeat full review. Publish the clean exact-head result, transition the under-review marker, and stop before implementation. If remote publication was explicitly excluded/unavailable, make the verified local documentation commit and report that fallback.

## Interview rule

Ask only decisions that cannot be resolved safely from current authority. Examples:

- Which conflicting operator behavior is intended?
- Is a supported external contract allowed to break?
- Which exact release/maturity gate owns this outcome?
- Which of two materially different UI journeys is selected?
- Is a destructive data/Azure migration acceptable?

Do not ask the user to choose ordinary implementation details that source inspection can settle. Do not batch an intimidating questionnaire; ask the next blocking material question, incorporate the answer, and continue.

## Change-record completion gate

```text
goal + scope + exclusions clear
AND authority/current-state distinction clear
AND real caller/owner/data/failure/recovery covered
AND release/horizon and GitHub relationship settled where applicable
AND UI contract complete where applicable
AND acceptance and proportional proof explicit
AND no unresolved material decision
AND required plan-content review clear
AND required actual plan-PR review clear for exact final head
AND no implementation performed
                 |
                 v
             status: planned
```

If a material decision remains, set status `blocked`, record the exact decision, decision owner, affected plan sections, and safe current boundary. Do not call the plan implementation-ready.

## Baseline and drift

Record:

- repository URL/root;
- default branch;
- baseline commit SHA inspected;
- issue URL, if any;
- capability IDs/product sections;
- target release/horizon; and
- last review date.

Delivery must compare the current base with this baseline. Material drift updates and re-reviews only affected sections; it does not create a second plan.

## GitHub behavior

- Existing Feature/Bug/Task/Decision issue: normalize exactly one work kind and registered facets, record it in the change record, and place/update appropriate milestone, horizon, dependencies, and Status `Ready` only after the plan gate and standalone plan-PR readiness pass (or when delivery immediately continues). Link the remote plan record after push.
- No issue, low-risk plan: leave `Issue: none — low-risk plan`; the plan PR itself is sufficient unless the user asks for an issue or repository policy requires one.
- No issue, standard/high-risk implementation-ready plan: create the correct issue as a normal authorized planning step when GitHub is in scope, link the plan PR/record, then set Project `Ready` after review/Docs CI. If GitHub is unavailable or excluded, the record may still be `planned`; record `Issue: unavailable/excluded — create before delivery` and do not claim Project `Ready`.
- Never create one issue per capability row or create child issues for speculative Later work.
- Never close the issue during planning.

## Assets

`assets/change-record-template.md` is the exact template from [the change-record contract](../standards/change-record.md). The plugin-root create script performs create-only placeholder replacement and refuses duplicate/unresolved identity.

## References

### `references/change-planning.md`

Contains the inspection, current-state mapping, interview, option, plan-writing, review, persistence, stop, and drift procedures from [feature planning](../workflows/feature-planning.md).

### `references/documentation-lifecycle.md`

Contains the canonical truth/roadmap/GitHub/change-record ownership matrix and documentation update rules from [documentation lifecycle](../standards/documentation-lifecycle.md).

### `references/github-planning.md`

Contains the issue-required matrix, exactly-one owner-aware work-kind rule, registered-facet/form limitations, semantic-content and Project-membership readback, capability/parent relationship, milestone/horizon decisions, documentation-only plan-PR publication, and planning status transitions from [GitHub work management](../interfaces/github-work-management.md).

### `references/risk-scaling.md`

Defines low/standard/high planning depth and review requirements.

### `references/ui-ux-planning.md`

Contains the UI-impact classifier, `design/` authority and token/source mapping, UI contract, state matrix, incremental route, major-direction approval, and UI plan completion gates from [UI/UX](../workflows/ui-ux.md).

### `references/versioning-and-release-stages.md`

Contains SemVer, maturity-stage, roadmap-horizon, and release-allocation rules from [versioning](../standards/versioning-and-release-stages.md).

### `../../references/dotnet-projects.md`

Shared conditional .NET profile derived from [the .NET project standard](../standards/dotnet-projects.md). It is loaded directly when the change affects .NET code or its project/build/package/test/persistence/host/deployment contract; it is not loaded for a prose-only mention of .NET.

## Failure behavior

- Dirty tree: stop with exact paths; do not stash/reset/worktree.
- Repository not onboarded: route to onboarding.
- Existing plan ambiguous: ask for the exact record/issue; never select the newest.
- Material authority conflict: ask one decision and set `blocked` if unanswered.
- Official/current fact unavailable: record uncertainty and source requirement; do not invent.
- GitHub unavailable/excluded: complete and commit the decision-complete documentation locally, record the publication limitation, and require issue creation before standard/high-risk delivery; do not claim the normal ready-plan-PR endpoint.
- Plan PR CI failure: retain native draft or `do-not-merge`, fix documentation/schema/link failures only, rerun Docs checks, and never broaden the planning request into implementation.
- Standard/high-risk reviewer unavailable: keep `blocked` and retain native draft or `do-not-merge`; provide the exact review handoff and do not claim the remote endpoint complete.
- Delivery prerequisite invocation: return control to delivery only after the same planning completion gate passes.
