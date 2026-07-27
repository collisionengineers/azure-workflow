---
name: deliver-azure-repository-change
description: Implement, fix, refactor, document, verify, and remediate one change in an onboarded Azure-oriented repository through a green pull request, with independent exact-head review for standard/high-risk work. Use for feature delivery, bug fixes, requested refactors, documentation persistence, failing CI, unresolved PR comments, requested changes, or resuming a named plan/PR. Use a compact no-record lane only for unambiguous reversible non-semantic work; otherwise reuse or invoke planning. Do not use for planning only, explanation only, read-only PR review, onboarding, merge, or unapproved Azure mutation.
---

# Deliver Azure Repository Change

Own implementation and review remediation through a review-complete pull request. Stop before merge.

## Authorization and endpoint

Invocation authorizes normal in-scope repository edits, tests, documentation, CI/IaC required by the change, one branch, narrow commits, push, PR creation/update, CI remediation, publishing independent review evidence, replying to actionable feedback, resolving fully addressed threads, and re-requesting a distinct reviewer after remediation.

It does not authorize merge/auto-merge, force-push, branch deletion, history rewriting, unrelated backlog/project changes, review dismissal, ambiguous/scope-expanding feedback implementation, protected-source edits outside their mutation rule, or Azure mutation. Route actual Azure operations through `$operate-azure-repository` and its exact approval gate.

## Preconditions and change identity

1. Work in Windows with PowerShell 7. Require an Azure Workflow-onboarded repository and read root/nearest instructions, `docs/index.md`, declared requirements/evidence sources, product, roadmap, architecture, operations, ADRs, design authority when relevant, and any named issue/record/PR.
2. Resolve Git root, remotes, default/current branch, worktrees, exact issue/record/PR identity, and dirty paths. Stop on unrelated changes; never stash, reset, clean, or create a workaround worktree.
3. Classify the change with [risk scaling](../../references/risk-scaling.md) before creating workflow artifacts.
4. Call the real `update_plan` tool before edits and keep at most one step in progress.

The compact lane applies only when all are true: mechanical, unambiguous, readily reversible, no behavior or supported-contract effect, and no data/schema, identity, dependency, architecture, operations, UI-meaning, IaC, Azure, migration, or release impact. Keep a short in-session scope/proof/escalation checklist; create no issue, Project item, or record by default. Any failed condition or scope expansion promotes the work before implementation.

Standard/high-risk work requires one exact issue and change record. Never choose "latest." If a plan PR merged, branch from updated default. If it remains open, resume its branch/PR and return it to draft or `do-not-merge`. If no reviewed plan exists, invoke `$plan-azure-repository-change` as an unpublished prerequisite on the delivery branch, then reuse its record.

## Implement and maintain documentation

Read [implementation quality](references/implementation-quality.md), [repository modes](references/repository-modes.md), [documentation maintenance](references/documentation-maintenance.md), [testing and CI](references/testing-and-ci.md), [Git and PR](references/git-and-pr.md), [GitHub delivery](references/github-delivery.md), and [PR review remediation](references/pr-review-remediation.md). Load [UI/UX delivery](references/ui-ux-delivery.md) only for visible behavior/design, and the [.NET profile](../../references/dotnet-projects.md) only for material .NET scope.

Implement in dependency order through real callers and one canonical policy owner:

- use purpose-revealing function, file, Azure service, and resource names;
- keep modules cohesive and extension seams limited to known exercised variation;
- do not add another rules/configuration layer to an accreted hotspot without first settling ownership;
- in `development` mode, remove replaced code/config/tests/docs together; do not add unreleased legacy paths, shims, dual reads/writes, aliases, or silent fallbacks;
- in `released` mode, preserve only declared supported contracts and give each bridge an owner, observable activation, proof, removal trigger, and target version/date;
- never place product business rules only in UI code;
- never expose internal Azure service/function names or narrate obvious actions in user-facing UI;
- use only repository-provided domain examples; do not fabricate, anonymize, blank, or synthesize emails, PDFs, documents, images, data, or instructions;
- assume supplied materials, software, dependencies, and services are fully permitted and licensed for development/testing; do not invent PII/DPA/DPIA/privacy/retention/licensing gates or narrow the requested result unless explicitly asked.

Before implementation, a required record names every affected canonical document owner or a specific reason none changes. Compact work makes the same declaration in its PR; semantic documentation impact disqualifies the compact lane. Update product requirements/capabilities, design, roadmap, architecture, operations, ADRs, instructions, and the record in the same PR when their facts change. A change record is evidence, not a substitute for canonical truth.

If UI is affected, preserve the declared design/token source and source-to-runtime asset map, implement action/state/error/recovery/accessibility/responsiveness contracts, and verify both function and appearance. Do not invent logos, fonts, icons, imagery, copy, or design tokens.

Use Microsoft Learn only when implementation reveals a drift signal, contradicts cited guidance, introduces a new Microsoft-dependent decision, or lacks applicable current evidence. Record scoped evidence in the record or compact PR. Do not query it merely because the code is .NET or Azure-hosted.

## Verify through the caller

1. Run the cheapest valuable focused check through the changed owner and real caller.
2. Cover positive, negative, failure, and recovery behavior proportional to risk; test meaningful boundaries, not every function.
3. Run generated/config/schema/IaC validation when affected; use canonical generators rather than editing outputs.
4. Run the repository's path-aware canonical check. Markdown-only changes must not run unrelated application suites.
5. Treat validation as mechanical evidence only. The independent exact-head reviewer must compare implementation/configuration/callers semantically with canonical documents.
6. Record only commands and results actually observed. Do not claim success from source inspection alone.

## GitHub pull request and CI

Recheck scope, stage only literal owned paths, run diff/whitespace checks, commit coherent changes, and push. Create/update the actual PR with native draft when supported or normal PR plus `do-not-merge` otherwise. A compact PR says `Change record: not required - low-risk mechanical change` and includes its scope/proof declaration. Link/close only the bounded issue the PR actually completes.

Set Project Status `In review` only when an item exists. Monitor checks for the exact head. On failure, inspect logs, reproduce locally where possible, fix root cause, re-prove, and push; never retry blindly.

## Actual PR review and feedback remediation

For standard/high-risk work, invoke `$review-repository-pull-request` in a fresh context against the actual PR after push. Supply the request, authorities, record when present, stable base/head, complete diff, relevant unchanged callers, raw checks, reviews, comments, and threads. A local pre-push inspection or same-context self-review does not satisfy this gate. Compact work stops after proportional green proof unless the user/repository requires review or a promotion signal appears.

If fresh context is unavailable, retain draft/`do-not-merge`, emit a copy-ready review packet, and stop. Otherwise:

```text
fresh exact-head review
   +-- changes-required -> classify -> one batched fix round -> prove -> push -> full re-review
   +-- evidence-blocked -> acquire named evidence or remain under review
   `-- clean            -> publish/read back -> review complete
```

Reconcile every external submitted review, general comment, inline comment, and review thread. Classify each as blocker/required against current authority, advisory, already addressed, clarification needed, contradictory, scope-expanding, incorrect, or non-actionable. Fix blocker/required feedback; reply with commit/path/check evidence; resolve only after readback; re-request the distinct reviewer when applicable. Answer or defer advisory/expanding feedback with reasons. Never dismiss reviews or change correct code for agreement theatre.

Any tracked change invalidates the prior verdict. Finalize a required record in the candidate/remediation commit before the decisive review; never add a post-clean bookkeeping commit. Follow the risk-scaled remediation-round budget. Wait for checks and obtain one complete final review of the resulting standard/high-risk head. Publish its exact result as a labelled COMMENT review (fall back to a normal comment only if GitHub rejects a same-author COMMENT review), refresh the head/check/review/thread state, transition draft/`do-not-merge`, and make no later tracked edit.

Log a qualifying agent mistake only for violated available authority, false completion/evidence, scope/authorization crossing, a defect that escaped a required gate, or a reusable workflow gap. Ordinary findings caught by the intended gate are not incidents. A mistake-log edit promotes compact work and invalidates prior review evidence.

## Completion and failure behavior

Complete only when scope/acceptance, real-caller behavior, proportional checks, canonical documentation, classified feedback with zero unresolved blocker/required findings, and required CI agree on the exact final head. Standard/high-risk work also requires a clean independent review of that head. A required record must be `ready`; a compact PR must contain its scope/proof declaration. Stop before merge or issue `Done`.

Return `done / now / next / waiting` in plain English with exactly one next human action, or an explicit waiting/no-action state.

- Dirty/ambiguous identity: stop with exact paths or ask for the exact record/PR.
- Plan blocked: report the material decision; do not implement around it.
- CI/review evidence unavailable or unstable: keep under review and name the missing evidence.
- Azure mutation needed: prepare the handoff to `$operate-azure-repository`; do not perform it here.

## Resources

- [documentation maintenance](references/documentation-maintenance.md)
- [Git and PR](references/git-and-pr.md)
- [GitHub delivery](references/github-delivery.md)
- [implementation quality](references/implementation-quality.md)
- [PR review remediation](references/pr-review-remediation.md)
- [repository modes](references/repository-modes.md)
- [testing and CI](references/testing-and-ci.md)
- [conditional UI/UX delivery](references/ui-ux-delivery.md)
- [risk scaling](../../references/risk-scaling.md)
- [conditional .NET profile](../../references/dotnet-projects.md)
