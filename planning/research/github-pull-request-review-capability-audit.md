# GitHub pull-request review capability audit

Checked: 2026-07-26

Scope: current GitHub.com pull-request reviews, GitHub CLI `2.88.0`, REST, and the live public GraphQL schema. Re-probe during implementation and before each review because PR state and API coverage can change.

## Conclusion

The plugin can reliably inspect an actual pull request and its feedback without GitHub MCP. `gh`, REST, and GraphQL expose the PR identity, exact base/head commits, files, commits, checks, reviews, issue comments, inline comments, review threads, and thread resolution state.

The current plan's earlier sequence was wrong: it reviewed a local diff and opened the PR afterwards. A PR review must occur after the PR exists and must be bound to its exact `headRefOid`.

Two GitHub constraints shape the portable workflow:

1. [Pull-request authors cannot approve their own pull requests](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/reviewing-proposed-changes-in-a-pull-request). A fresh Codex reviewer using the author's GitHub credential is reasoning-independent but not a separate GitHub identity. Its durable GitHub result is a clearly labelled `COMMENT` review, never a claimed approval.
2. [Draft pull requests](https://docs.github.com/en/rest/pulls/pulls) are not available for a private repository on the current personal GitHub Free baseline. Draft state is capability-dependent, not a portable completion primitive.

## Verified CLI and schema surfaces

`gh pr view --json` currently exposes, among other fields:

```text
author, baseRefName, baseRefOid, body, closingIssuesReferences,
comments, commits, files, headRefName, headRefOid, isDraft,
latestReviews, mergeable, mergeStateStatus, reviewDecision,
reviewRequests, reviews, statusCheckRollup, title, url
```

`gh pr review` exposes `--comment`, `--approve`, and `--request-changes`. The plugin uses `--comment` for same-author agent evidence. It never attempts self-approval or self-requested-changes.

The live GraphQL `PullRequest` type exposes `reviewThreads`. `PullRequestReviewThread` exposes:

```text
comments, id, isOutdated, isResolved, path, line, originalLine,
resolvedBy, viewerCanReply, viewerCanResolve, viewerCanUnresolve
```

The live mutation schema exposes `addPullRequestReview`, review comments/replies, `resolveReviewThread`, `unresolveReviewThread`, review dismissal, and review-request mutations. Availability does not grant authorization: the workflow prohibits dismissal and gates replies/resolution through delivery.

## Capability matrix

| Surface | Supported route | Workflow treatment |
| --- | --- | --- |
| PR identity, body, linked issues, base/head OIDs, merge state | `gh pr view --json` | Required and read twice for stability |
| Complete changed-file and commit lists | Paginated REST | Required; do not trust default page sizes |
| Exact full diff | Local `git diff <baseOid>...<headOid>` after both objects exist | Required; inspect every changed path |
| Checks | Exhausted GraphQL check/status rollup (or paginated REST suite/check-run routes); `gh pr checks --json` is a convenience/readback surface | Required for the exact head; never trust a truncated connection |
| Submitted reviews | Paginated REST plus `latestReviews`/`reviewDecision` | Required |
| General PR comments | Paginated issue-comments REST endpoint | Required |
| Inline review comments | Paginated pull-review-comments REST endpoint | Required |
| Resolved/unresolved/outdated review threads | Paginated GraphQL `reviewThreads` and nested comments | Required; REST comments alone are insufficient |
| Submit agent review evidence | Prefer `gh pr review --comment --body-file -`; fall back to `gh pr comment --body-file -` only on an explicit same-author COMMENT-review rejection | Delivery publishes the exact result and names the observed surface |
| Approve an author's own PR | Prohibited by GitHub | Never attempt or claim |
| Native human approval/request changes | GitHub review by a distinct account | Honor when present; never impersonate or dismiss |
| Reply to review thread | GraphQL/REST | Delivery only after classification and remediation |
| Resolve review thread | `resolveReviewThread` | Delivery only when fully addressed and read back |
| Re-request human review | GitHub review request API/UI | Use after material remediation when a reviewer exists |
| Draft-to-ready transition | Plan/visibility-dependent | Optional; use normal PR fallback on personal Free/private |

## Personal-account baseline

For a private repository owned by the personal `collisionengineers` account on GitHub Free:

```text
normal open PR
    |
    +--> Project Status: In review
    +--> do-not-merge label while review is incomplete
    +--> checks + independent COMMENT review
    `--> remove do-not-merge only after the exact-head gate passes
```

The label is a visible workflow warning, not enforcement. Without a supported ruleset, GitHub cannot prevent the owner from merging early. The plugin never describes that warning as branch protection.

Where draft PRs are supported, use native draft state and do not add the fallback label. The workflow reads `isDraft` after every state change and does not infer capability from CLI help alone.

## Review identity and publication

The independent reviewer is a fresh Codex context that did not implement or direct the change. It remains read-only and returns a structured result to the owning workflow.

The delivery/onboarding/planning owner may publish that result verbatim as one GitHub `COMMENT` review. If GitHub explicitly rejects even a same-author COMMENT review, it may publish the same fixed body as one general PR comment and must call it a review-evidence comment, not a submitted review:

```markdown
## Independent PR review — round <N>

- Reviewed head: `<40-character SHA>`
- Verdict: clean | changes-required | evidence-blocked
- Reviewer: fresh Codex review context
- GitHub effect: COMMENT review; not a human or separate-account approval

### Findings

<structured findings or `No blocker or required findings.`>

### Evidence limits

<limits or `None.`>
```

The implementation owner may wrap the returned result with the fixed heading and identity statement but must not rewrite its findings or verdict.

## Exact-head invariant

```text
collect start head H
       |
       v
inspect PR + full H diff + checks + feedback
       |
       v
collect end head == H? -- no --> discard result and restart
       |
       yes
       v
return review bound to H
```

Every code, test, configuration, IaC, migration, or tracked-document change creates a new head and invalidates the previous clean verdict. PR title/body/labels/Project fields/review comments do not change the head, so the collector also fingerprints checks, reviews, comments, review requests, and thread state. The reviewer recollects immediately before verdict; the owning workflow refreshes again before completion.

No tracked change may occur after the final exact-head attestation. The final change-record commit is therefore followed by one last complete PR review whose durable result lives on the PR rather than triggering another self-referential record edit.

The reviewer runs the complete collector before analysis and again immediately before verdict. A changed evidence fingerprint—even with the same head—means checks or feedback changed and must be incorporated. The owning workflow performs one further complete refresh after publishing the review and before removing the under-review marker.

## Feedback-remediation contract

Collect and deduplicate every review, inline comment, issue comment, and thread by GitHub node/REST ID. Classify each item against current code, authority, scope, and the latest head:

| Classification | Action |
| --- | --- |
| Actionable and in scope | Fix under delivery authority, prove, reply with commit/evidence, resolve when fully addressed |
| Already addressed | Reply with exact current evidence; resolve when unambiguous |
| Clarification needed | Ask the user/reviewer; leave unresolved |
| Contradictory | Present the conflict and authority; leave unresolved |
| Scope expanding | Do not implement silently; propose a separate issue/decision |
| Incorrect | Preserve correct behavior and respond with evidence; do not change code for agreement theatre |
| Non-actionable acknowledgement | No reply required |

Resolving a thread does not dismiss a `CHANGES_REQUESTED` review. The plugin never dismisses a review. When a distinct reviewer requested changes, remediate, reply, and re-request their review.

GitHub documents thread resolution and re-requesting in [About pull-request reviews](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews) and out-of-scope follow-up in [Incorporating feedback](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/incorporating-feedback-in-your-pull-request).

## Re-probe contract

Implementation and live use verify:

```powershell
gh --version
gh auth status
gh pr view --help
gh pr checks --help
gh pr review --help
gh api graphql -f query='<targeted PullRequest/PullRequestReviewThread introspection>'
```

The alpha acceptance scenario uses an approved disposable repository to prove paginated collection, head-change detection, a same-author `COMMENT` review, feedback classification, reply/resolution readback, and both native-draft and personal-Free/private fallback behavior where accounts are available. Unsupported capability is recorded exactly rather than simulated as success.
