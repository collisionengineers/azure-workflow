# Independent pull-request review workflow

## Purpose

Challenge the actual GitHub pull request with fresh context before an owning workflow declares it deliverable. Review is exposed through `$review-repository-pull-request` and is also invoked by onboarding, standard/high-risk plan publication, and delivery.

A local diff review performed before the PR exists is useful implementation self-checking but does not satisfy this workflow.

If the user asks only what one PR, review comment, thread, or check means, route to `$explain-repository`. Review owns “is it correct/acceptable?” and returns a verdict; explanation owns “help me understand it” and returns no verdict.

## Four distinct review layers

| Layer | What it proves | Does it satisfy the plugin gate? |
| --- | --- | --- |
| Implementation self-check | The implementing context inspected its own work before push | No |
| Fresh actual-PR assessment | A separate Codex context inspected the remote PR, complete diff, checks, and feedback | Yes, for the plugin's evidence gate |
| GitHub `COMMENT` review | The exact assessment is durably attached to the PR and names the reviewed head | Records the gate; it is not approval |
| Distinct-account approval | A human or bot using another GitHub identity submits native approval | Required only when repository rules or recorded policy require it |

The plugin always requires the second and third layers for delivery. It honors the fourth whenever GitHub rules or repository policy require it, but never fabricates it with the author's credential.

## Separation of roles

```text
implementation/planning owner                 fresh PR reviewer
          |                                            |
          |-- push + create/update actual PR --------->|
          |-- request + record + authorities --------->|
          |                                            |
          |<-- exact-head verdict and findings --------|
          |                                            |
          +-- remediate/re-prove/update record          |
          |                                            |
          |-- push new head --------------------------->| full re-review
```

The reviewer must be a fresh Codex context that did not implement, direct, or pre-decide the change. It receives raw task/PR artifacts and repository authority, not the implementation owner's suspected problems, defence, or desired verdict.

On re-review, previous findings are supplied only so their disposition can be verified. The reviewer still examines the complete current PR independently.

## Authorization boundary

The reviewer is read-only:

- may read repository/GitHub state, fetch exact refs without checkout, and run permitted non-mutating checks;
- must not edit files, implement fixes, switch branches, create a worktree, commit, push, post comments/reviews, reply, resolve threads, change PR/Project/issue state, merge, or mutate Azure;
- must distinguish static, runtime, CI, GitHub, and unavailable evidence; and
- must not treat its same-account identity as GitHub approval.

The owning workflow—not the reviewer—may publish the returned report verbatim as a GitHub `COMMENT` review and may remediate findings under its separate mutation authority.

## Required inputs

- Explicit repository and PR number/URL.
- User request, acceptance criteria, and exclusions.
- Linked issue/capability/release intent.
- Change-record path and relevant canonical product/design/architecture/operations/ADR paths.
- PR base/head refs and OIDs, snapshot time, and evidence fingerprint from a stable evidence snapshot.
- Complete base-to-head diff and changed-path list.
- Real entry points, callers, and policy owners.
- Rule/configuration authority and live/generated/reference/compatibility source-role evidence when behavior is non-trivial.
- Applicable .NET project/host/toolchain/profile evidence when the diff or unchanged callers affect .NET.
- Exact focused/canonical commands already run and raw result summaries.
- Current checks, reviews, review decision/requests, general comments, inline comments, and all review threads.

Use the collection contract in [GitHub PR review research](../research/github-pull-request-review-capability-audit.md). In the implemented plugin, the review skill loads its direct `pr-evidence-collection.md` reference and runs the shared evidence collector.

The reviewer applies the Microsoft Learn call gate independently. If a current Microsoft claim can determine a blocker or required finding, it queries/fetches the official guidance and records compact evidence in the result. It does not treat the implementation owner’s citation as independent proof, and it does not repeat background research that cannot affect the verdict.

## Stable evidence gate

```text
collect start base/head + PR/check/feedback markers
        |
        v
exhaust every declared page + inspect full diff/checks/feedback
        |
        v
collect end base/head + PR/check/feedback markers
        |
        +-- changed/incomplete --> discard; retry once or evidence-blocked
        |
        `-- stable -----------> review exact head
```

After examining the diff, the reviewer runs the collector again. A changed head or evidence fingerprint means new checks or feedback arrived; the reviewer incorporates it and repeats the affected analysis. No finding or clean verdict may be issued as complete when file/comment/thread/check pagination is truncated, required checks are pending, the head or feedback/check snapshot changed during review, or the complete diff is unavailable.

## Review checklist

1. PR purpose/body, linked issue, scope, exclusions, and change record agree; the issue has exactly one owner-aware work kind, registered facets only, and explicit Project membership.
2. Exact base/head and complete diff are known; every changed path is explained.
3. Real callers reach the intended policy owner; registrations or unused code do not count as completion.
4. Each changed behavior and behaviorally important setting has one discoverable canonical owner and explicit precedence; the PR does not add a second rule/configuration stage to an unresolved hotspot.
5. Positive, negative, failure, retry, conflict, recovery, and observability behavior match the request.
6. Relevant `operator-notes/` were read, remain unchanged unless explicitly requested, and are not contradicted.
7. Repository mode is applied: no unreleased legacy/fallback path in development; only named, observable compatibility/replay bridges with complete retirement metadata in released mode.
8. Public interfaces, schemas, persistence, configuration, migrations, deployment, and recovery are safe and coherent.
9. Authentication, permissions, secrets, and trust boundaries are correct.
10. Functions, files, services, Azure resources, tests, and configuration have purpose-revealing names.
11. UI action mapping, state behavior, accessibility, viewport/input boundary, and wording are correct when affected; the one token source and changed logo/icon/font/design sources map to their actual runtime outputs/callers; no generated output is hand-edited and no internal Azure/development narration leaks to users.
12. Azure/IaC, cost, reliability, deployment, and live-evidence claims are handled without unapproved mutation.
13. Tests target plausible regressions, CI selected the correct path-aware scope, and no prohibited synthetic domain examples were created.
14. Generated/materialized outputs trace to one canonical source and deterministic command; reference/test-only code is not exported or represented as the live owner.
15. Planned future capability produced only a small currently exercised seam, not dormant abstraction or resources.
16. Product, design, architecture, operations, ADRs, roadmap/capabilities, and change record agree with the implementation.
17. For .NET-affecting PRs, the shared profile’s project graph, DI/options, compatibility, tooling/support, variant, and proportional-test checks pass without imposed modernization.
18. Existing human/automated feedback was reconciled against the current head; unresolved or requested-changes state is not hidden.
19. No unrelated paths, unexplained generated output, hidden scope expansion, or user work are included.
20. Git/PR/CI/review claims are backed by current exact-head evidence.

## Finding schema

```markdown
#### RVW-NNN: <short title>

- Severity: blocker | required | advisory
- Evidence: `<relative/path:line>`, command result, caller trace, or GitHub URL
- Impact: <observable consequence>
- Required outcome: <testable correction>
- Recheck: <exact evidence needed>
```

Severity:

- `blocker`: unsafe to proceed or the core request is not met.
- `required`: must be corrected before completion.
- `advisory`: optional improvement with no acceptance/safety impact.

Every finding requires evidence and an observable outcome. Style preference is not required remediation unless a declared repository standard makes it so.

## Verdict

Return exactly one, bound to the stable `headRefOid`:

- `clean`: no blocker/required findings and no evidence blocker;
- `changes-required`: at least one blocker or required finding; or
- `evidence-blocked`: a named missing/pending/unstable evidence source prevents a reliable verdict.

Advisories may accompany `clean`. “Mostly clean,” “looks good,” and approval language are forbidden because they obscure the actual gate or impersonate GitHub approval.

The result also names the final evidence-snapshot timestamp and fingerprint. A later comment, review, thread-state change, check transition, or head change does not rewrite history, but it requires the owning workflow to refresh state before completion and may reopen the gate.

## Feedback reconciliation

Every review, general comment, inline comment, and thread is classified as actionable, already addressed, clarification needed, contradictory, scope-expanding, incorrect, or non-actionable. The reviewer reports the evidence and required next action but does not reply or resolve.

The implementation owner:

1. fixes clearly actionable in-scope feedback;
2. reruns the exact finding recheck plus affected canonical proof;
3. replies with commit/path/check evidence;
4. resolves only fully addressed threads and reads them back;
5. leaves ambiguity, contradiction, and scope expansion unresolved for a decision; and
6. re-requests a distinct human review after addressing `CHANGES_REQUESTED`.

The workflow never dismisses a human review.

## Remediation and re-review loop

```text
review head H1
     |
     +-- changes-required --> record findings -> fix/prove -> push H2
     |                                                   |
     |                                                   v
     |                                          review full H2 diff
     |
     +-- evidence-blocked --> remain under review
     |
     `-- clean --> prepare final record commit Hfinal
                                      |
                                      v
                           complete review of Hfinal
                                      |
                                      v
                       publish COMMENT review; no later tracked change
```

The change record retains remediation rounds up to the final candidate. The final exact-head attestation is stored on the PR so recording it does not create another commit and invalidate itself.

## Reviewer unavailable

If no fresh-agent capability is available:

1. Keep native draft state or the `do-not-merge` fallback marker.
2. Keep the change record `active` or `blocked` with reason `fresh independent PR reviewer unavailable`.
3. Provide a copy-ready prompt containing the required inputs without the implementation owner's conclusions.
4. Resume only after a separate new Codex thread returns a review result for the still-current head.

Self-review in the implementation context never satisfies the gate.
