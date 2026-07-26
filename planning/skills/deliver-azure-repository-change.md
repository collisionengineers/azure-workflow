# Skill specification: `deliver-azure-repository-change`

## Public purpose

Own implementation or remediation of one repository change through scoped code/documentation edits, proportional proof, a fresh review of the actual GitHub PR, feedback remediation, GitHub CI, and a green exact-head-reviewed pull request.

A plan-only request belongs to `$plan-azure-repository-change`. If standard/high-risk implementation is requested but no usable reviewed plan exists, this skill invokes planning as a prerequisite and then continues the same change record under the user's existing implementation authority. A qualifying compact-lane change uses a short in-session scope/proof checklist and no durable record.

## Exact folder

```text
skills/deliver-azure-repository-change/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
`-- references/
    |-- documentation-maintenance.md
    |-- git-and-pr.md
    |-- github-delivery.md
    |-- implementation-quality.md
    |-- pr-review-remediation.md
    |-- repository-modes.md
    |-- testing-and-ci.md
    `-- ui-ux-delivery.md
```

There is no skill-local `scripts/` or `assets/` folder. It uses plugin-root scripts, the plan skill's existing change-record asset when a record is required, and the target repository's PR template. Shared .NET and risk references live under `plugins/azure-workflow/references/` and are linked directly from `SKILL.md`.

## `SKILL.md` frontmatter

```yaml
---
name: deliver-azure-repository-change
description: Implement, fix, refactor, document, verify, remediate pull-request reviews and comments, and deliver one change in an onboarded Azure-oriented repository through a green pull request independently reviewed at its exact final head. Use when the user asks to implement, build, change, fix, deliver, resume a planned change, address PR review feedback or unresolved threads, repair failing CI, or persist an explanation into repository documentation. Use the compact lane only for unambiguous reversible non-semantic work; otherwise invoke planning when no decision-complete plan exists. Use the read-only review skill for a correctness assessment and explain-repository for understanding only.
---
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Deliver Repository Change"
  short_description: "Implement and independently prove one repository change"
  default_prompt: "Use $deliver-azure-repository-change to implement this change through a green pull request reviewed at its exact final head. Reuse its plan or create one through the planning prerequisite."

dependencies:
  tools:
    - type: "mcp"
      value: "microsoft-learn"
      description: "Current official Microsoft and Azure documentation"
      transport: "streamable_http"
      url: "https://learn.microsoft.com/api/mcp"

policy:
  allow_implicit_invocation: true
```

The dependency makes Microsoft Learn available; it does not make every call mandatory. Reuse scoped evidence recorded by planning. Call Microsoft Learn only when implementation reveals a drift signal, contradicts cited guidance, introduces a new Microsoft-dependent decision, or lacks required current evidence. Any live Azure mutation is routed through `$operate-azure-repository` and its separate exact-approval gate.

## Required `SKILL.md` body structure

```markdown
# Deliver Azure Repository Change
## Authorization and endpoint
## Preconditions and change identity
## Establish or validate the plan
## Implement and maintain documentation
## Verify through the caller
## GitHub pull request and CI
## Actual PR review and feedback remediation
## Completion and failure behavior
## Resources
```

## Authorization contract

Invocation authorizes normal in-scope delivery actions. Before creating a durable record, classify whether every compact-lane condition is satisfied: the work is mechanical, unambiguous, readily reversible, and has no behavior, supported-contract, data/schema, authentication, dependency, architecture, operations, UI-meaning, IaC, Azure, migration, or release effect. Otherwise use the standard route.

- create or resume one scoped branch;
- create a plan through `$plan-azure-repository-change` when required;
- edit implementation, tests, configuration, IaC, CI, and canonical documentation required by the named change;
- create/update the one change record and associated GitHub metadata when the standard route requires them; compact-lane work creates neither unless explicitly requested;
- make narrow commits, push the scoped branch, create/update the PR, publish exact independent review evidence, reply to clearly actionable in-scope feedback, resolve fully addressed threads, re-request a distinct reviewer after remediation, and transition the PR from its supported under-review marker after all gates pass.

It does not authorize:

- merging, auto-merging, force-pushing, deleting branches, or rewriting unrelated history;
- broad backlog/project reorganization unrelated to the change;
- dismissing reviews, submitting a same-author approval/request-changes review, resolving ambiguous/contradictory/scope-expanding threads, or closing partially satisfied issues;
- altering a human-edit-only, preserve-in-place, or other protected source outside its declared mutation rule; or
- any Azure mutation.

## Entry modes

```text
implementation request
       |
       +--> all compact-lane conditions hold? -----> short scope/proof checklist
       |                                            no issue or record by default
       |
       +--> exact planned record named? ----------> merged plan PR: new branch
       |                                           open plan PR: resume it under review
       |
       +--> exact active branch/PR/record named? -> remediate/resume it
       |
       `--> standard/high with no usable record ---> invoke planning prerequisite
                                                        |
                                                        v
                                                   continue same record
```

Never choose “latest” when multiple records or PRs could match. Ask for the exact identity.

## Core instructions

1. Confirm that the requested endpoint includes implementation. Route a plan-only request to `$plan-azure-repository-change` and do not retain control.
2. Require an onboarded Git repository and clean worktree. Read root/nearest `AGENTS.md`, `docs/index.md`, declared active product/external requirements and relevant discovery/evidence sources, mode, architecture, operations, ADRs, roadmap/capability entries, issue, and named record. Respect every recorded source role and mutation rule. For UI work, also read the applicable `design/` brand/foundation/token/asset/component/pattern authorities.
3. Work in Windows with PowerShell 7. Probe Git, `gh`, repository tools, `az`, and `azd` only when their route needs them.
4. Classify risk before creating workflow artifacts. Use the compact lane only when every condition in shared `../../references/risk-scaling.md` holds; record the scope, exclusions, proof, and escalation trigger in the active Codex plan/conversation. Otherwise resolve the exact issue/record/branch identity and require the issue to have exactly one owner-aware work kind, only registered project-specific categories, sufficient semantic content, and explicit Project membership. Repair unambiguous in-scope metadata; ask one focused question when classification is ambiguous. Fetch the remote default branch without merging unrelated work.
5. Establish the branch/PR before planning: if a plan PR merged, create `workflow/YYYYMMDD-<slug>` from updated default; if it remains open, resume its branch/PR and restore native draft or `do-not-merge`; otherwise create the scoped delivery branch from default.
6. For standard/high-risk work, invoke `$plan-azure-repository-change` as an unpublished prerequisite when no reviewed plan exists. Continue only when its content/review gate passes. Compact-lane work skips this prerequisite.
7. When a record exists, compare its baseline commit and authorities to the current base, update/re-review only sections invalidated by material drift, and never create a duplicate plan.
8. Set a required record to `active`; then call the real Codex `update_plan` tool before implementation edits for both routes. Maintain at most one in-progress step.
9. Load always-applicable references: `implementation-quality.md`, `repository-modes.md`, shared `../../references/risk-scaling.md`, `documentation-maintenance.md`, `testing-and-ci.md`, `pr-review-remediation.md`, and `git-and-pr.md`.
10. Load `github-delivery.md` for issue/project/PR state. Load `ui-ux-delivery.md` only when visible behavior, interaction, content, accessibility, layout, tokens, or visual source assets are affected. Load shared `../../references/dotnet-projects.md` only when .NET source/project/build/package/test/persistence/host/deployment is affected.
11. Apply the Microsoft Learn reuse/refresh gate. Record any refreshed source, scope, timestamp, status, and decision effect in the existing record, or in the compact PR evidence when no record exists.
12. Implement in dependency order through real callers and one canonical policy owner. Use logical purpose-revealing names and the smallest currently exercised extension seams. Do not add another rule/configuration stage to an existing hotspot without the plan settling ownership first.
13. In `development` mode, remove replaced behavior/code/config/tests/docs together; do not add unreleased legacy paths, shims, dual reads/writes, aliases, or silent fallbacks.
14. Treat supplied emails, PDFs, documents, images, datasets, examples, software, dependencies, and services as fully permitted and licensed for development/testing. Use only repository-provided domain materials; do not invent, anonymize, blank, or fabricate substitutes. Do not add PII/DPA/DPIA/privacy/retention/licensing analysis, gates, warnings, work items, test substitutions, or scope reductions unless the user explicitly requested that separate outcome.
15. Declare affected canonical owners or a specific reason none change in the record when present, otherwise in the compact PR. Update canonical product, design, roadmap, architecture, operations, ADR, capability, instruction, and change-record owners in the same pull request when their facts change. Any semantic documentation impact disqualifies the compact lane. For UI work, keep the declared token source, source-asset inventories, component/pattern routes, generated outputs, and runtime callers synchronized. Do not use a change record as a substitute for canonical truth or hand-edit generated outputs. Treat Docs/Full checks as mechanical proof and rely on fresh exact-head review to detect semantic disagreement with implementation/configuration/callers.
16. Run the cheapest focused caller-backed checks first, then the canonical path-aware repository check. Record only commands/procedures actually run and their observed results.
17. Recheck clean scope, stage literal owned paths only, run diff checks, create narrow commits, push, and create/update the actual PR. Use native draft when supported or the normal PR + `do-not-merge` fallback. Link the issue correctly; use a closing keyword only when the PR fully completes it.
18. Set Project Status `In review` only when the change has a Project item, then monitor required checks for the exact head. Diagnose failures, reproduce locally where possible, fix, re-prove, update the record when present, and push; do not retry blindly.
19. Invoke `$review-repository-pull-request` in a fresh context against the actual PR. Supply the request, authorities, record when present, exact stable base/head, complete diff, callers, raw evidence, checks, reviews, comments, and threads. If a fresh context is unavailable, retain draft or `do-not-merge`, emit a copy-ready review prompt, and stop.
20. Remediate every blocker/required finding and every clearly actionable in-scope external comment. Re-run affected proof, reply with exact evidence, resolve only fully addressed threads, and re-request a distinct human reviewer when applicable. Push changes and obtain a complete fresh PR review; preserve remediation rounds in the record when present.
21. As soon as this workflow makes or discovers a qualifying agent mistake, contain/recover it, append the factual entry to `docs/agent-mistakes.md`, and link its ID in the record when present. The semantic log edit promotes compact work to the standard route before continuing. Do not log every review finding or expected red test. If unrelated dirty state prevents an authorized append, return the copy-ready pending entry and keep completion blocked rather than bypassing scope rules.
22. After a clean candidate review, set a required record `ready` and commit/push its final evidence including any mistake IDs. Compact-lane work has no final record commit. Wait for checks and obtain one final complete review of the resulting exact head; make no later tracked changes.
23. Publish the returned result verbatim as a labelled `COMMENT` review, refresh head/checks/reviews/comments/threads, transition native draft to ready or remove `do-not-merge`, read back state, and stop. Do not merge or set the issue to Done before merge. Return a compact `done / now / next / waiting` handoff with exactly one next human action or an explicit no-action/waiting state.

## Completion gate

```text
scope and acceptance satisfied
AND real caller/failure behavior proved
AND selected focused checks and canonical check green
AND canonical documentation agrees
AND actual PR review has no blocker/required finding for final head
AND all review feedback is reconciled with no blocking unresolved state
AND all required PR checks are green for that same head
AND required change record contains final evidence/recovery, or compact-lane PR contains its scope/proof declaration
AND every qualifying agent mistake is durably appended and linked, or completion states the exact pending blocker
                   |
                   v
        required record ready + PR review-complete + STOP
```

No individual test, reviewer verdict, or green build substitutes for the other gates.

## References

| Reference | Load/use |
| --- | --- |
| `documentation-maintenance.md` | Canonical owner/update matrix, declared impact, same-PR maintenance, agent mistake-log admission/append rules, mechanical-versus-semantic proof boundary, drift blocking, capability/roadmap rules, and record-vs-truth boundary |
| `git-and-pr.md` | clean tree, branch/base, literal staging, commits, draft-capability/fallback PR handling, prohibited Git actions |
| `github-delivery.md` | exactly-one-kind/registered-facet normalization, semantic-content and Project-membership readback, issue/project transitions, parent/sub-issue/dependency relationships, PR closing behavior |
| `implementation-quality.md` | ownership, naming, callers, maintainability, extension seams, internal-Azure wording boundary |
| `pr-review-remediation.md` | invoke the public review skill after push, publish COMMENT evidence, classify/reply/resolve feedback, re-review and final-head gate |
| `repository-modes.md` | development/released compatibility, fallback, migration, and future-feature rules |
| `../../references/risk-scaling.md` | compact/standard/high depth and escalation |
| `testing-and-ci.md` | test-value selection, docs/full path classifier, test-data policy, CI remediation |
| `ui-ux-delivery.md` | design/token/source-runtime synchronization, UI action mapping, state implementation, language, accessibility, viewport, visual/functional proof |
| `../../references/dotnet-projects.md` | Conditional shared .NET project, architecture, configuration/DI, package, variant, delivery, proportional-test, and documentation rules |

`pr-review-remediation.md` has this exact internal outline:

```markdown
# Pull-request review remediation
## Invoke the fresh read-only PR reviewer
## Record findings without rewriting them
## Classify external feedback
## Fix and prove actionable in-scope findings
## Reply, resolve, and read back review threads
## Re-request distinct reviewers
## Repeat complete review after every tracked change
## Publish the final COMMENT review
## Final head, check, and feedback readback
## Blocked and prohibited actions
```

It links directly to the shared evidence helper contract and does not copy the review checklist. It contains the exact GitHub mutation commands authorized to delivery; the public review skill contains none.

## Failure behavior

- Not onboarded: route to `$onboard-azure-repository` before implementation.
- Dirty worktree: list exact paths and stop; do not stash/reset/clean/worktree.
- Ambiguous identity or a plan PR closed unmerged: request the exact record/issue/PR and whether to reopen/resume or supersede; never infer newest or treat an unmerged closed plan as canonical.
- Planning gate blocked: stop implementation and report the exact decision/prerequisite.
- Requirement or base drift: pause affected work, update and re-review only invalidated plan sections.
- Fresh reviewer unavailable: retain native draft or `do-not-merge`; store the exact review handoff for a new thread.
- CI unavailable/failing: retain native draft or `do-not-merge` and record the limitation/failure; do not call the endpoint complete.
- Required finding: remediate or remain blocked; never downgrade it merely to finish.
- Azure mutation needed: stop at the operate-skill approval boundary and resume delivery only after observed evidence exists.
