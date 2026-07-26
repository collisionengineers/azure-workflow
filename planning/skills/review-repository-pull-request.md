# Skill specification: `review-repository-pull-request`

## Public purpose

Independently and read-only assess one existing GitHub pull request against its request, linked issue, repository authority, change record, complete diff, real callers, checks, tests, documentation, existing reviews, comments, and unresolved threads.

The skill returns an exact-head verdict and findings. It never implements fixes, posts GitHub comments, submits approvals, resolves threads, changes PR state, commits, pushes, merges, or mutates Azure.

## Why this is a public skill

It passes all three public-skill tests:

1. A user can ask “review PR 123” as a standalone outcome.
2. Its authorization is read-only, unlike delivery/remediation.
3. Its completion is a review verdict for an exact PR head, not a changed repository.

Delivery, onboarding, and standard/high-risk plan publication invoke a fresh instance after the PR exists. This does not create another plugin or workflow database.

## Exact folder

```text
skills/review-repository-pull-request/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
`-- references/
    |-- pr-evidence-collection.md
    `-- review-contract.md
```

There is no skill-local `scripts/` or `assets/` folder. It uses the plugin-root `Get-AzureWorkflowPullRequestEvidence.ps1` helper and repository-native read-only checks. The conditional shared .NET profile lives at `plugins/azure-workflow/references/dotnet-projects.md`, outside this skill-local tree, and is linked directly from `SKILL.md`.

## `SKILL.md` frontmatter

```yaml
---
name: review-repository-pull-request
description: Independently and read-only review an existing GitHub pull request against its request, linked issue, repository authority, change record, exact base and head, complete diff, real callers, checks, tests, documentation, reviews, comments, and unresolved threads. Use when the user asks to review, audit, assess, judge correctness, or check a PR/comment, or when Azure Workflow onboarding, planning, or delivery requires a fresh post-push review. Return evidence-based findings and an exact-head verdict without fixing code or changing GitHub state. Use explain-repository instead when the user only asks what a PR, comment, or check means and does not request a correctness verdict.
---
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Review Pull Request"
  short_description: "Independently assess one GitHub pull request"
  default_prompt: "Use $review-repository-pull-request to independently review this pull request without changing it."

policy:
  allow_implicit_invocation: true
```

No MCP is unconditionally required. GitHub evidence uses `git`, `gh`, `gh api`, and the shared evidence collector. Independently query Microsoft Learn when a current Microsoft claim can change the verdict, including but not limited to version-specific .NET support/tooling. Do not repeat background guidance that cannot affect a finding. If official evidence is unavailable, return the exact scoped evidence limit.

## Required `SKILL.md` body structure

```markdown
# Review Repository Pull Request
## Read-only authorization and endpoint
## Resolve the exact PR and repository
## Collect stable PR evidence
## Review the complete change
## Reconcile existing feedback
## Return findings and exact-head verdict
## Failure behavior
## Resources
```

Keep the body below 500 lines. Put API/pagination commands in `pr-evidence-collection.md` and the checklist/schema in `review-contract.md`.

## Authorization contract

Invocation authorizes:

- read repository instructions, source, documentation, Git history, PR metadata, linked issues, reviews, comments, threads, and check results;
- fetch remote refs without checkout when required to make the exact base/head objects available;
- run known non-mutating checks whose normal caches/artifacts are allowed by repository instructions; and
- return a structured review result in the conversation.

It does not authorize:

- tracked file edits or implementation/remediation;
- branch creation/switching, checkout of the PR, worktree creation, staging, commit, push, merge, or history rewriting;
- GitHub comment/review submission, replies, review requests/dismissal, thread resolution, labels, Project/issue/PR state changes;
- Azure mutation; or
- treating a same-account agent result as GitHub approval.

If the user explicitly requests fixes, review first and hand the findings to `$deliver-azure-repository-change`; do not silently change modes inside the review skill.

## Core instructions

1. Require an explicit PR number/URL or one unambiguous current-branch PR. Never select the newest PR.
2. Resolve the Git root and snapshot local status. Never mix uncommitted work into the PR evidence. A dirty worktree does not block object-level review, but it blocks local commands whose result would depend on those files; use exact-commit CI evidence or return the precise evidence limit. Do not stash, reset, clean, switch branches, or create a worktree.
3. Read root/nearest `AGENTS.md`, relevant `operator-notes/`, `docs/index.md`, product/roadmap/architecture/operations/ADRs, linked issue, and change record. When `Visual UI: present` and the PR affects UI/design, read the applicable `design/` authorities, token-source declaration, asset inventories, and component/pattern maps. Detect whether the diff or unchanged callers behaviorally affect a .NET project.
4. Load both skill-local references. When .NET is affected, also load shared `../../references/dotnet-projects.md` and its applicable variant sections. Run `Get-AzureWorkflowPullRequestEvidence.ps1` with the repository root and PR number; retain its completion time and fingerprint.
5. Require stable start/end base/head OIDs, stable check/feedback markers, complete pagination, exact base/head objects, and a full `baseOid...headOid` diff. If any is unavailable, return `evidence-blocked` rather than reviewing a partial change as complete.
6. Review the PR purpose/body/issue/record consistency, including exactly one owner-aware issue kind, registered facets, and Project membership; then review every changed path, relevant unchanged callers/policy owners, positive/negative/failure/recovery behavior, permissions/security, schemas/config/migrations, UI/UX and design-source/runtime consistency, Azure consequences, tests, documentation, scope, naming, mode, and non-overengineering. For .NET, additionally verify project/reference and real-host call paths, single rule/configuration authority, DI/options lifetimes, public/package/schema compatibility, generated/source roles, proportional tests, exact commands, and current support evidence when relevant. Apply the Microsoft Learn gate independently for any decisive current claim and include compact source evidence in the verdict.
7. Inspect current checks, submitted reviews, review decisions, general comments, inline comments, and every review thread. Deduplicate feedback by GitHub ID and distinguish unresolved, resolved, and outdated threads.
8. Do not inherit the implementation owner's suspected findings or desired verdict. On a re-review, receive previous findings only to recheck their disposition; still review the entire current diff independently.
9. Immediately before deciding the verdict, rerun the collector. If its head or evidence fingerprint differs, incorporate the new checks/feedback and repeat the affected review once; return `evidence-blocked` if the PR remains unstable.
10. Return findings first, ordered `blocker`, `required`, then `advisory`, each with path/line or GitHub URL, observable impact, required outcome, and exact recheck.
11. Return exactly one verdict bound to the stable head and final snapshot: `clean`, `changes-required`, or `evidence-blocked`.
12. State explicitly that the result is an independent Codex review and not a separate-account GitHub approval.

## Result schema

```markdown
## Pull-request review

- Pull request: <URL>
- Base: `<branch>` at `<SHA>`
- Reviewed head: `<40-character SHA>`
- Evidence snapshot: `<UTC timestamp>`; fingerprint `<value>`
- Verdict: clean | changes-required | evidence-blocked
- Existing review decision: <value or none>
- Unresolved threads: <count>
- Evidence limits: <none or exact limits>

### Findings

#### RVW-NNN: <short title>

- Severity: blocker | required | advisory
- Evidence: `<relative/path:line>`, command result, caller trace, or GitHub URL
- Impact: <observable consequence>
- Required outcome: <testable correction>
- Recheck: <exact evidence needed>

### Feedback reconciliation

| GitHub item | Classification | Evidence | Required next action |
| --- | --- | --- | --- |
| <URL/ID> | actionable / already addressed / clarification needed / contradictory / scope-expanding / incorrect / non-actionable | <evidence> | <action> |

### Review identity

Fresh Codex review context; read-only; not a human or separate-account GitHub approval.
```

When clean, write `No blocker or required findings.` Advisories remain visible but do not change the clean verdict. Any evidence blocker prevents `clean`.

## Invocation by owning workflows

```text
owner creates/updates PR
        |
        v
owner invokes fresh review skill context
        |
        v
review skill returns exact-head result without mutation
        |
        +-- findings --> owner records/remediates/re-proves
        |
        `-- clean ----> owner may publish result verbatim as COMMENT review
```

The implementation owner cannot satisfy the gate by calling this skill in its own context and self-reviewing. Use a fresh agent when available; otherwise provide the exact review packet for a separate new Codex thread and keep the PR under review.

## References

| Reference | Load/use |
| --- | --- |
| `pr-evidence-collection.md` | Exact `gh`/REST/GraphQL collection, pagination, stable-head, draft capability, and same-author review constraints |
| `review-contract.md` | Independence, complete-diff checklist, finding schema, feedback classification, verdicts, and re-review rules |
| `../../references/dotnet-projects.md` | Conditional shared .NET review additions for project/caller graphs, rule/config ownership, DI/options, compatibility, generated material, tests, toolchain, and support evidence |

### Exact `pr-evidence-collection.md` contents

```markdown
# Pull-request evidence collection
## Prerequisites and repository resolution
## Exact PR metadata and base/head objects
## REST pagination routes
## GraphQL review-thread and check pagination
## Stable snapshot and deterministic fingerprint
## Full object-level diff without checkout
## Authentication, rate-limit, and partial-evidence failures
## Same-author review-publication constraints
```

This reference owns command/query examples and field mappings only. It does not contain review judgment or mutation instructions.

### Exact `review-contract.md` contents

```markdown
# Pull-request review contract
## Reviewer isolation and read-only boundary
## Required inputs and authority order
## Complete-change checklist
## Finding severities and evidence requirements
## Existing-feedback classification
## Verdict and result schema
## Re-review and final-head invalidation
## Blocked and handoff behavior
```

This reference owns judgment and output shape. It does not repeat API commands or authorize remediation.

## Failure behavior

- Ambiguous/missing PR: ask for the exact number/URL and perform no external call.
- Dirty tracked worktree: list exact paths, exclude them from PR evidence, and skip any local check that would consume them. Block only the proof that cannot be established from exact objects or CI; do not alter the paths.
- Authentication/permission failure: return the exact `gh` failure and `evidence-blocked`.
- Missing base/head object: fetch only the exact refs when safe; otherwise identify the missing object and block runtime claims.
- Pagination incomplete, rate limited, or head/check/feedback evidence changed during collection or review: discard the partial snapshot and retry once from the new complete snapshot; block if instability repeats.
- Checks pending: report pending and `evidence-blocked`; do not reinterpret as pass.
- Requested implementation: return findings and route to delivery; do not edit.
- Reviewer isolation unavailable: prepare a copy-ready fresh-thread review packet and leave the owning PR under review.
