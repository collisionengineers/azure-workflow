# Change-delivery workflow

## Outcome

Implement or remediate one decision-complete change and stop at a green pull request reviewed at its exact final head. The plugin does not merge.

## Routing

```text
IMPLEMENTATION REQUEST
        |
        v
onboarded + clean repository? -- no --> onboard/refuse
        |
        v
exact planned/active record or plan PR exists?
        | no
        +----> invoke $plan-azure-repository-change unpublished prerequisite
        |             |
        |             `--> blocked? STOP
        |             `--> planned? continue same record
        |
        v
baseline drift review -> implement -> prove -> PR/CI -> actual PR review -> ready
```

An existing PR, failed CI run, or review finding selects resumption/remediation of its linked record. It is not a separate public action or a duplicate record.

If the user asks only what an existing feature, failure, or review comment means, route to `$explain-repository`; do not infer authorization to remediate. A request to fix/address it or persist the explanation selects delivery.

## Stage 1: preflight and identity

1. Resolve the Git root, remote, default branch, current branch, worktree status, issue, PR, and record. Confirm the issue has exactly one owner-aware work kind, registered facets only, sufficient semantic content, and explicit Project membership; repair unambiguous metadata and ask on ambiguity.
2. Stop on any unrelated staged, modified, deleted, renamed, or untracked path. Never stash, reset, clean, or create a worktree.
3. Read root and nearest instructions, `docs/index.md`, relevant `operator-notes/`, product/roadmap/capability authority, architecture, operations, active ADRs, and the record. For UI work, read the applicable `design/` brand/foundation/token/asset/component/pattern authorities.
4. Resolve repository mode, risk, target version/maturity/horizon, and exact caller/owner.
5. When .NET scope is affected, load the shared profile and resolve the exact solution/project/TFM, project graph, host/composition root, rule/configuration owner, source roles, toolchain, test-suite roles, and any current support fact the plan depends on.
6. Reuse scoped Microsoft Learn evidence from the plan. Refresh only when a support/version/baseline/error/deprecation drift signal exists or implementation introduces a new Microsoft-dependent decision; record the new evidence in the same change record.
7. If multiple records/PRs might match, ask for the exact one; never select newest.
8. Fetch the remote default branch. Create or resume `workflow/YYYYMMDD-<slug>` only when identity is unambiguous.

## Stage 2: plan prerequisite and drift

- Reuse a named `planned` record. If its documentation-only plan PR merged, start the implementation branch from updated default. If it remains open, resume that branch/PR and restore native draft or `do-not-merge` before implementation.
- Reuse an `active` record linked from the branch/PR for remediation.
- If no usable record exists, invoke the plan skill's content/review gate on the delivery branch; do not create a separate plan PR because the implementation request already authorizes continuation.
- Compare the record's baseline SHA and authorities with the current base.
- Re-plan/re-review only materially invalidated sections.
- Set status `active`, record the branch/base/head, and call the real `update_plan` tool before implementation edits.

## Stage 3: implementation

Implement dependency-first through the real entry point:

```text
contract/data/config boundary
          |
          v
owning domain/service behavior
          |
          v
real caller / API / job / UI
          |
          v
failure + recovery + observability
          |
          v
canonical documentation and proof
```

Rules:

- One behavior has one clear owner and one current path.
- One behaviorally important setting has one declaration/binding/validation owner and an explicit reader set; do not scatter new direct environment/config reads through business logic.
- Names reveal purpose for functions, files, services, Azure resources, tests, and configuration.
- Use the smallest exercised seam needed for known future scope; record later work but do not build dormant architecture.
- In development mode, remove replaced code/config/tests/docs and prohibit unreleased legacy/fallback/dual-path compatibility.
- In released mode, preserve only named supported contracts through explicit, observable, time-bounded migration/deprecation behavior.
- Classify generated/materialized, reference/test-only, replay, and compatibility code explicitly. Run the canonical generator rather than hand-editing copies; give every released bridge an owner, activation scope, proof, removal trigger, and target removal version/date.
- Never put product business rules only in the UI.
- Never expose internal Azure implementation names or narrate obvious UI functions to users.
- Use only repository-provided domain examples; do not synthesize emails, PDFs, documents, images, data, or instructions.
- Preserve unrelated changes and stage only literal owned paths.

## Stage 4: UI/UX route when affected

Implement the planned UI contract:

- map every visible action to the real command/query/policy owner;
- cover applicable loading, empty, success, validation, permission, conflict, dependency-failure, retry, and recovery states;
- use approved components/tokens/assets before adding abstractions;
- update the canonical `design/` rule/source inventory and source-to-runtime mapping when colour, typography/font, style, imagery/logo/icon, tokens, component, or pattern authority changes; never hand-edit declared generated outputs;
- use direct labels and product-authoritative status language;
- prove keyboard/focus/semantics/error association/contrast or non-colour cues and supported viewport/input boundaries as applicable;
- capture real-route functional and proportional visual evidence.

Major direction changes return to the plan decision gate; implementation does not select a new visual/product direction silently.

## Stage 5: documentation maintenance

Update each canonical owner only when its fact changed:

| Change | Update |
| --- | --- |
| Intended behavior/contract | `docs/product/` and capability index |
| Release outcome/allocation | `docs/roadmap.md`, issue milestone/fields |
| Visual rule/token/source asset/component/pattern mapping | Applicable root `design/` owner and its runtime consumer/export |
| Implemented boundary/data/control flow/Azure topology | `docs/architecture.md` |
| Rule/configuration owner, source role, generated/materialized path, or bridge lifecycle | `docs/architecture.md` and relevant `docs/operations.md` procedure |
| Build/deploy/monitor/recover/support procedure | `docs/operations.md` |
| Hard-to-reverse durable choice | ADR |
| This change's plan/evidence/deviation/outcome | Existing change record |

Do not copy live issue status into roadmap/product docs. Do not leave intended behavior solely in the change record.

## Stage 6: proportional verification

1. Run the cheapest valuable focused check through the changed owner/caller.
2. Prove relevant negative/failure/recovery paths.
3. Run UI/accessibility/visual evidence when applicable.
4. Run IaC format/validate/what-if when applicable; no Azure mutation without the operate-skill approval.
5. Run the repository canonical command. Markdown-only changes select Docs; executable or ambiguous paths select Full.
6. For .NET work, apply the shared profile’s project/variant-specific proof without changing framework, solution format, package management, analyzers, or test platform outside the plan.
7. Record exact commands/procedures, results, timestamps or environment where material, required suites that skipped, ratchets, platform, and evidence limitations.

Tests exist to catch plausible regressions. Do not add low-value tests for getters, framework wiring, static markup, or every line merely to increase a count.

## Stage 7: create the actual pull request

1. Recheck `git status`, base/head diff, generated files, secrets, and scope.
2. Stage literal owned paths and commit coherent changes, including the current implementation evidence in the change record.
3. Push the scoped branch and create/update the PR using `.github/pull_request_template.md`.
4. Use native draft state when supported. On the personal GitHub Free/private baseline, create a normal PR and apply `do-not-merge`; never claim it is a draft.
5. Link the parent/sub-issue. Use `Closes` only when this PR fully satisfies it; otherwise use `Related to` or equivalent non-closing text.
6. Set Project Status `In review`.
7. Monitor required checks for the exact head. For failures: inspect logs, reproduce where possible, fix root cause, rerun local proof, update the record, commit/push, and restart exact-head checks.

## Stage 8: fresh review of the actual PR

Invoke `$review-repository-pull-request` in a fresh context with:

- PR URL/number and repository;
- request, acceptance, exclusions, issue, and change record;
- stable exact base/head OIDs and complete base-to-head diff;
- real caller/owner paths and raw verification;
- current checks, submitted reviews, general/inline comments, and every review thread; and
- Azure/UI/design/operations evidence where applicable.

```text
actual PR review at head H
       |
       +-- changes-required --> record findings -> fix -> prove -> commit/push H2
       |                                                     |
       |                                                     `--> review full H2 PR
       |
       +-- evidence-blocked --> retain draft/do-not-merge
       |
       `-- clean --> continue finalization
```

For clearly actionable in-scope external feedback, fix automatically, prove, reply with exact evidence, and resolve only after readback. Ask before ambiguous, contradictory, or scope-expanding work. Never dismiss a human review; re-request it after remediation when applicable.

The review skill never edits or changes GitHub state. Delivery may publish its exact returned result as a `COMMENT` review. A same-author Codex review is not an approval.

## Stage 9: final exact-head gate

1. After a clean candidate review, update the record with PR, final evidence, remediation rounds, documentation, deviations, recovery, and status `ready`.
2. Commit and push that final tracked update; this creates a new head and invalidates the candidate verdict.
3. Wait for required checks on the new head and invoke one last complete PR review. Do not edit tracked files after it returns clean.
4. Publish the exact result as a clearly labelled `COMMENT` review containing the reviewed head SHA.
5. Refresh head, checks, review decision, all feedback, and unresolved threads. They must still describe the same clean head.
6. If native draft is supported, mark the PR ready. Otherwise remove `do-not-merge`. Read the state back.
7. Refresh once more. New blocking feedback or a changed head returns the PR to under review.
8. Stop. Do not merge, close the issue, or set Project Status `Done`; merge/closure automation or a human does that later.

## Completion gate

```text
acceptance met
AND actual caller and applicable failures proved
AND canonical check green
AND docs/roadmap/capability/GitHub relationships consistent
AND actual PR reviewer has no blocker or required finding for exact final head
AND all feedback is reconciled and no blocking unresolved thread/review remains
AND required CI is green for that same head
AND record complete and status ready
             |
             v
       PR review-complete
             |
             v
            STOP
```

## Failure and interruption

- Dirty/unrelated state: stop with exact paths.
- Missing/ambiguous record: ask for identity or run the planning prerequisite.
- Closed-unmerged plan PR: ask whether to reopen/resume it or create a superseding plan; do not treat its documentation as default-branch authority.
- Material requirement/authority drift: update affected plan sections and re-review before continuing.
- Toolchain failure: report the exact probe/error and the smallest remediation; do not fabricate proof.
- Reviewer unavailable: retain native draft or `do-not-merge` and store the exact review packet.
- CI unavailable: leave draft and status `blocked` with external prerequisite.
- Azure apply absent/denied: retain validated repository changes but do not claim observed live behavior.
- Interrupted session: recover from the issue/record/branch/PR identity and observed Git state; never infer a latest task or create a handoff subsystem.
