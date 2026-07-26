---
name: review-repository-pull-request
description: Independently and read-only review one existing GitHub pull request in an Azure-oriented or Azure Workflow-onboarded repository against its request, repository authority, linked issue/change record when required, exact base/head, complete diff, real callers, tests, checks, documentation, reviews, comments, and unresolved threads. Use for PR review, correctness audits, requested-changes assessment, or the fresh post-push review required by onboarding/planning/delivery. Return findings and an exact-head verdict without fixing code or changing GitHub state. Use explain-repository when the user only asks what feedback means.
---

# Review Repository Pull Request

Provide a fresh evidence-based verdict for the actual PR. This skill is read-only; review and remediation are deliberately separate.

## Read-only authorization and endpoint

Invocation authorizes repository/GitHub reads, fetching exact remote objects without checkout when needed, running known non-mutating checks whose normal artifacts are allowed, and returning a review in the conversation. It does not authorize tracked edits, branch switching, staging, commits, pushes, comments/reviews, thread resolution, labels/Project changes, approvals, merges, or Azure mutation.

If fixes were requested, complete this review first and hand findings to `$deliver-azure-repository-change`. Do not silently change modes.

## Resolve the exact PR and repository

1. Require a PR number/URL or one unambiguous current-branch PR; never select the newest.
2. Work in Windows with PowerShell 7. Resolve the Git root, remote repository, PR author, authenticated identity, base/head OIDs, and local worktree status.
3. A dirty tree does not invalidate object-level review, but it blocks local commands whose result would consume dirty files. Never stash, reset, clean, switch branches, or create a worktree.
4. Read root/nearest `AGENTS.md`, `docs/index.md`, declared requirements/evidence sources, product, roadmap, architecture, operations, active ADRs, design authority when UI is affected, linked issue, and change record when required.
5. Load [PR evidence collection](references/pr-evidence-collection.md) and [review contract](references/review-contract.md). Load the [.NET profile](../../references/dotnet-projects.md) only when the change or relevant caller is materially .NET.

## Collect stable PR evidence

Run the plugin-root `scripts/Get-AzureWorkflowPullRequestEvidence.ps1` for the exact PR. Require:

- stable start/end base and head OIDs;
- complete pagination for files, commits, checks/statuses, submitted reviews, review requests, general comments, inline comments, review threads, and nested replies;
- a deterministic evidence fingerprint stable across the collection;
- both exact commit objects locally available;
- the full `baseOid...headOid` diff without checkout.

If evidence is partial, unstable, unauthenticated, rate-limited, pending in a verdict-relevant way, or missing required objects, return `evidence-blocked`. Never review a truncated `gh pr view --comments` result as complete.

## Review the complete change

Review the request/PR/issue/record consistency and every changed path plus relevant unchanged callers/owners. Check:

- observable acceptance; positive, negative, failure, and recovery behavior;
- supported contracts, data/schema/migrations, authentication/permissions, configuration/rule ownership, dependencies, generated/source roles, IaC and Azure consequences;
- UI/UX actions/states/content/accessibility/responsiveness and design-source-to-runtime consistency when affected;
- proportional tests, exact commands, CI results, documentation impact, source roles/mutation rules, naming, mode, release allocation, scope, maintainability, and absence of speculative architecture;
- semantic agreement between canonical documents and current implementation/configuration/callers. Structural validators cannot prove this;
- for .NET, project/reference/host call paths, DI/options lifetimes, package/public/schema compatibility, toolchain, test-suite role, and decisive support claims.

Apply the repository's full-permission/licence assumption to supplied materials/software/services. Do not invent PII/DPA/DPIA/privacy/retention/licensing findings, substitutions, warnings, or scope reductions unless that outcome is explicitly in scope.

Independently query Microsoft Learn only when a current Microsoft-controlled claim can materially change a finding. Record the official source and decision effect. Do not repeat background research that cannot affect the verdict.

## Reconcile existing feedback

Inspect and deduplicate all reviews, general comments, inline comments, and threads by GitHub identity. Distinguish unresolved, resolved, and outdated state. Classify every material item as:

- actionable and still applicable;
- already addressed with evidence;
- clarification needed or contradictory;
- scope-expanding;
- incorrect, with evidence; or
- non-actionable.

Do not inherit the implementation owner's suspected findings or desired verdict. On re-review, use previous findings only to check disposition, then review the complete current diff independently.

Immediately before deciding, rerun the collector. If head or evidence fingerprint changed, incorporate the new snapshot and repeat affected review once; if instability repeats, return `evidence-blocked`.

## Return findings and exact-head verdict

Return findings first, ordered `blocker`, `required`, then `advisory`. Each finding needs observable evidence, impact, testable required outcome, and exact recheck. Return exactly one verdict:

- `clean`: no blocker/required findings and required evidence is complete;
- `changes-required`: at least one blocker/required finding;
- `evidence-blocked`: a required correctness claim cannot be established.

Use this shape:

```markdown
## Pull-request review
- Pull request: <URL>
- Base: `<branch>` at `<40-char SHA>`
- Reviewed head: `<40-char SHA>`
- Evidence snapshot: <UTC>; fingerprint `<value>`
- Verdict: clean | changes-required | evidence-blocked
- Existing review decision: <value or none>
- Unresolved threads: <count>
- Evidence limits: <none or exact limits>

### Findings
#### RVW-NNN: <title>
- Severity: blocker | required | advisory
- Evidence: `relative/path:line`, command result, or GitHub URL
- Impact: <observable consequence>
- Required outcome: <testable correction>
- Recheck: <exact evidence>

### Feedback reconciliation
| GitHub item | Classification | Evidence | Required next action |
| --- | --- | --- | --- |

### Review identity
Fresh Codex review context; read-only; not a human or separate-account GitHub approval.

### Recommended next action
<exactly one verdict-derived action or waiting state>
```

When clean, state `No blocker or required findings.` Advisories do not change a clean verdict. If this read-only reviewer itself makes or recognizes a qualifying agent mistake, add a copy-ready `Pending mistake-log entry` and explicitly say it was not persisted; do not log ordinary implementation findings.

## Failure behavior

- Ambiguous/missing PR: request the exact identity and make no external mutation.
- Authentication/permission/pagination/object failure: return the exact evidence limit and `evidence-blocked`.
- Checks pending: report which checks matter and `evidence-blocked`.
- Requested implementation: return findings, then route to delivery.
- Fresh reviewer isolation unavailable to an owning workflow: provide a copy-ready new-thread review packet and leave the PR under review.

## Resources

- [PR evidence collection](references/pr-evidence-collection.md)
- [review contract](references/review-contract.md)
- [conditional .NET profile](../../references/dotnet-projects.md)
