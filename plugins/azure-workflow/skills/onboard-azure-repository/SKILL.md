---
name: onboard-azure-repository
description: Convert an existing Azure-oriented repository to the Azure Workflow documentation, GitHub, planning, review, testing, and delivery standard without losing material truth. Use for initial adoption, brownfield documentation consolidation, huge feature-list conversion, workflow-suite replacement, or repository-structure repair. Require repository evidence or explicit user intent that Azure is a current or intended target; a .NET project alone is insufficient. Do not use for ordinary feature delivery, read-only explanation, PR review, or a non-Azure repository.
---

# Onboard Azure Repository

Own one loss-controlled conversion from the repository's actual state to the Azure Workflow standard. Finish at an independently reviewed pull request; never merge.

## Authorization and preconditions

1. Confirm the repository is Azure-oriented from code, IaC, configuration, operations, or explicit user intent. If not, explain that this plugin does not own the repository and stop without mutation.
2. Work in Windows with PowerShell 7. Resolve the Git root, default branch, remotes, linked worktrees, current branch, open PR, and every dirty path.
3. Stop on unrelated changes. Never stash, reset, clean, overwrite, or repurpose another change's branch/worktree.
4. Full onboarding authorizes one scoped branch and change record, repository documentation/templates/CI edits, narrow commits, push, PR creation, review remediation, and removal of superseded tracked material only after parity proof. It does not authorize merge, force-push, destructive GitHub reorganization, organization-wide settings, branch-protection changes, or Azure mutation.
5. Call the real `update_plan` tool before editing and keep at most one step in progress.

## Inventory authority, implementation, plans, design, and GitHub

Read [authority-and-conflicts.md](references/authority-and-conflicts.md), [repository-policy-profile.md](references/repository-policy-profile.md), [documentation-conversion.md](references/documentation-conversion.md), [feature-catalog-conversion.md](references/feature-catalog-conversion.md), [github-onboarding.md](references/github-onboarding.md), [repository-standard.md](references/repository-standard.md), and [ui-design-system.md](references/ui-design-system.md) before deciding what to replace. Read [versioning-and-release-stages.md](../../references/versioning-and-release-stages.md), and load [.NET projects](../../references/dotnet-projects.md) only when .NET evidence exists.

Inventory, with paths and counts:

- all `AGENTS.md` files and repository-owned workflow/plugin/hook/agent configuration;
- human-authored notes, controlled requirements, product documents, architecture, operations, ADRs, plans, tickets, status ledgers, generated views, and historical evidence;
- real entry points, callers, rule/configuration owners, generated/materialized sources, compatibility paths, tests, CI, IaC, and Azure routes;
- capability/feature IDs, allocations, duplication, contradictions, and active work;
- issue forms, labels with use counts, issues, milestones, Project fields/workflows/views, PR template, and current platform capabilities;
- when `Visual UI: present`, brand/style sources, logos, colours, fonts/type, spacing/layout, motion, accessibility, tokens/themes, icons, assets, components, patterns, screenshots/mockups, and source-to-runtime mappings.

Do not infer authority from a folder name. Record each source's content role separately from its mutation rule. Unclassified notes are discovery input, not binding truth. Preserve explicit protected or controlled sources.

Treat repository-provided emails, PDFs, documents, images, datasets, examples, software, dependencies, and services as fully permitted and licensed for development/testing. Do not invent PII, DPA, DPIA, privacy, retention, or licensing gates or substitutions unless the user requested that outcome. Never create synthetic domain emails, images, documents, data, or instructions.

## Resolve material conflicts

1. Compare claims at statement level, not only filenames.
2. Separate intended behavior from current implementation and historical evidence.
3. Assign `DOC-CON-NNN` to each unresolved material same-role conflict.
4. Present the evidence, impact, and a recommended default in plain English. Ask one material question at a time.
5. Mark the onboarding record `blocked` and stop every conversion or removal that depends on the answer. Unrelated read-only inventory may continue.
6. Incorporate the answer, return the record to `active`, record the decision, and rescan affected sources. Never hide a conflict by choosing the newest file.

Use Microsoft Learn only when a conversion decision depends on current Microsoft/Azure support, version, host, API, limit, retirement, migration, deployment, security, or reliability guidance. A detected .NET repository gets a scoped support/host currency check. Repository authority still owns supported contracts; onboarding does not modernize as a side effect.

## Convert documentation and feature catalogs

Create the neutral repository spine from the assets in [assets/repository](assets/repository), filling real repository facts rather than copying placeholders blindly:

- concise root `AGENTS.md`;
- `docs/index.md`, living product requirements in `docs/product/index.md`, conditional capability/functional-area documents, `docs/roadmap.md`, `docs/architecture.md`, `docs/operations.md`, `docs/decisions/`, `docs/changes/`, and append-only `docs/agent-mistakes.md`;
- conditional root `design/` only when a visual UI exists; preserve or establish one token source and map approved assets to runtime;
- four universal issue forms and one PR template; add custom project forms only for a materially distinct repeated intake.

Do not create default `operator-notes/`, `PRD.md`, `FRD.md`, `NEXT.md`, dashboards, task journals, handoff JSON, one-file-per-feature trees, or a duplicate workflow database. Preserve formal requirement IDs and approval/status metadata when a controlled format remains necessary.

Convert huge feature lists into:

```text
durable product behavior -> stable capability ID -> exact release or unallocated
                                                -> GitHub issue only when activated
                                                -> Now / Next / Later / Not planned
```

Do not create an issue for every feature. Present the small genuinely active set for confirmation. Use one owner-aware work kind per workflow issue (`Feature`, `Bug`, `Task`, or `Decision`), with registered orthogonal project categories only.

## Establish verification and GitHub routing

Prefer the repository's native verification entry point. Add one thin PowerShell wrapper only when needed. CI must call the same command, choose Docs versus Full by changed paths, and fail safe to Full when classification is uncertain. Markdown-only changes must not trigger unrelated application suites.

Personal-account Projects have a portable CLI/GraphQL core, while saved views, charts, some workflows, and private-form enforcement may require a human/template step. Report those limitations precisely; do not claim API control that was not read back. Preview destructive/bulk/in-use taxonomy changes and request explicit approval.

## Prove parity, review, and deliver

1. Create the conversion branch and one onboarding record with the packaged [change-record helper](../../scripts/New-AzureWorkflowChange.ps1) and [change-record template](../plan-azure-repository-change/assets/change-record-template.md). Invoke the helper for the selected repository with `-Type onboarding -Status active`; pass the real issue URL or `none` through `-Issue`. Never rely on its default type.
2. Record source-to-destination mappings and counts for claims, identifiers, active work, design assets, GitHub taxonomy, and removed paths.
3. Run structure, link, YAML, path, change-record, mistake-log, generated-view, and proportional native checks. Mechanical checks cannot prove semantic agreement.
4. Remove or relocate superseded tracked material only after identifier, material-claim, link/authority, history, and executable-route parity pass. Keep Git recovery available.
5. Commit literal owned paths, push, and create the actual PR using native draft when supported or normal PR plus `do-not-merge` when not.
6. Invoke `$review-repository-pull-request` in a fresh context against the complete actual PR. If no fresh context exists, keep the PR under review, provide a copy-ready review packet, and stop.
7. Remediate all blocker/required findings, re-prove, push, and re-review the whole PR. After the final record commit, obtain a clean review and green checks for that exact head, publish it as a labelled COMMENT review, read state back, and stop before merge.

Keep detailed inventory, parity, verification, and review evidence in the onboarding record. At every pause and at completion, return only a concise plain-English handoff in this shape: `Done`, `Now`, `Next`, and `Waiting`. `Next` must contain exactly one recommended action; when blocked, `Waiting` must contain exactly one focused question and dependent work must remain stopped.

Log only qualifying agent mistakes: violated available authority, false completion/evidence, scope/authorization crossing, a defect that escaped a required gate, or a reusable workflow gap. Recover first, then append factual evidence; do not fabricate or backfill incidents.

## Failure behavior

- Non-Azure scope: explain the boundary and make no changes.
- Dirty/unrelated work: list exact relative paths and stop without altering them.
- Material conflict: record the conflict and ask one focused decision.
- Inaccessible source or failed parity: retain the source and state the exact evidence gap.
- GitHub capability unavailable: retain repository files, describe the exact manual/API limitation, and do not fake setup.
- Azure evidence unavailable: block only the dependent claim; onboarding itself never mutates Azure.

## Resources

- [authority and conflicts](references/authority-and-conflicts.md)
- [documentation conversion](references/documentation-conversion.md)
- [feature catalog conversion](references/feature-catalog-conversion.md)
- [GitHub onboarding](references/github-onboarding.md)
- [repository policy profile](references/repository-policy-profile.md)
- [repository standard](references/repository-standard.md)
- [UI design system](references/ui-design-system.md)
- [risk scaling](../../references/risk-scaling.md)
- [versioning and release stages](../../references/versioning-and-release-stages.md)
- [conditional .NET profile](../../references/dotnet-projects.md)
- [change-record helper](../../scripts/New-AzureWorkflowChange.ps1)
- [change-record template](../plan-azure-repository-change/assets/change-record-template.md)
