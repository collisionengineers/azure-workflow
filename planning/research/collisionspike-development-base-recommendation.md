# CollisionSpike development-base recommendation

Decision date: 2026-07-26

Scope: comparison of the original `collisionspike` repository and `collisionspike_v2` as the future product-development base. This is project-specific research evidence, not a default rule packaged into the reusable plugin.

Related evidence:

- [CollisionSpike v2 repository and planning audit](collisionspike-v2-planning-audit.md)
- [Original CollisionSpike repository audit](collisionspike-repository-audit.md)

## Recommendation

Continue forward product development in **`collisionspike_v2`**.

Keep the original `collisionspike` running only as the current operational system, behavior/evidence source, and emergency-fix target until an intentional cutover. Do not continue normal feature development in both repositories, do not copy the original implementation wholesale into v2, and do not attempt a large in-place architectural rescue of the original as the main route forward.

This recommendation is not based on v2 being newer or smaller. It is based on where the complexity lives:

```text
original collisionspike
    useful product + operational truth
                  inside
    fragmented live rules/configuration/runtime paths
                  |
                  `--> expensive to understand and dangerous to untangle in place

collisionspike_v2
    useful product truth + restrained application boundaries
                  inside
    overgrown/stale repository workflow and planning shell
                  |
                  `--> removable through one lossless onboarding conversion
```

The original's problem is primarily implementation architecture. V2's problem is primarily repository organization. Repository organization can be replaced around an intact application boundary with much less behavioral risk than disentangling a live accreted runtime.

## Live comparison

The following state was rechecked on 2026-07-26 rather than inferred from documentation.

| Signal | `collisionspike_v2` | Original `collisionspike` | Consequence |
| --- | --- | --- | --- |
| Current branch/head | Clean local `main` at accepted cleanup `19a5231e`; remote `main` is one commit behind | `fix/tkt-303-terminal-archive-retry-loop` at `1dace2d6` | V2 needs only baseline synchronization before a neutral onboarding branch; original still needs a separate neutral baseline |
| Working tree | Clean | Clean, but the branch is the head of open PR 165 | V2 now has the deliberate checkpoint; original remains purpose-bound |
| History | 23 commits | 950 commits, concentrated into roughly five weeks | Original carries far more archaeology and churn risk |
| Tracked files | 254 at the accepted cleanup head | 4,127 | Raw size is not decisive, but original's surface is materially larger |
| Application shape | Four .NET application projects, three test projects, six Bicep files; 66 tracked app/test/infra paths | 648 TypeScript, 85 TSX, 260 Python, 107 SQL, 12 Bicep files across many services/packages | V2 has a much smaller change graph and one primary platform |
| Rule ownership | Named Core use case and policy with Web calling it; Worker has no falsely claimed business caller | JSON, Python, TypeScript, AI, environment, database, orchestration, persistence, and UI/status surfaces can all affect one intake outcome | V2 makes behavioral ownership substantially easier to preserve |
| Largest warning | One 1,031-line infrastructure reader owns PDF, DOCX, email, MIME recursion, image extraction, and resource limits; one integration-test file is 1,300 lines | Triplicated 3,098-line rule engine, triplicated 1,755-line classifier, 867-line intake orchestrator, and many other hotspots | V2 is not pristine, but its hotspot is localized and can be corrected before more formats are added |
| Repository workflow | Failed multi-plugin implementation is removed; remaining instructions/checks still reference it | Sophisticated later governance is replicated across agent adapters and hundreds of work artifacts | Both need plugin onboarding; v2's workflow debt is easier to excise |
| GitHub work system | No open issues, Project, or open PR | No open issues or Project; three open PRs and linked worktrees | Neither currently has the desired work-management model |
| Operational maturity | Development proof; much parity, auth, external integration, deployment, and live operation remain | Real deployed operational system with valuable evidence, rollback, and recovery practices | Original remains essential evidence until v2 proves and replaces each supported slice |

## Why not continue primarily in the original repository

The original is further ahead in delivered behavior, but that advantage does not make it the cheaper long-term development base.

One intake decision currently requires reconstructing precedence across multiple languages, rule stores, configuration routes, compatibility paths, materialized copies, and historical exceptions. The repository's later governance and executable evidence reduce operational risk, but they do not make that decision graph simple. Adding features there would continue paying the highest possible comprehension cost and would encourage more gates, exceptions, and compatibility layers around an already fragmented owner model.

An in-place rescue would also have to preserve the behavior of a live system while changing the mechanisms that define that behavior. That creates a long period in which both old and new rule paths coexist—the exact fallback and dual-path pattern prohibited in development mode. It may be justified for an isolated production fix, but it is a poor default development strategy.

## Why v2 is the better base despite being behind

V2 already has the architectural properties that are hardest to retrofit:

- one Core use case intended for Web, Worker, API, and later MCP callers;
- explicit Infrastructure adapters and persistence;
- a restrained modular monolith rather than a speculative distributed platform;
- architecture, core, and integration test projects;
- repository-provided genuine-input boundaries;
- immutable operator authority separated from agent proposals; and
- no requirement to preserve pre-release application or test-data compatibility.

Missing behavior can be implemented incrementally against preserved product contracts and observed examples. Fragmented ownership is harder to remove safely than missing features are to add to a coherent owner model.

## V2 is ready for baseline synchronization and onboarding

Choosing v2 does not mean starting features before the repository workflow conversion.

The cleanup is now deliberately committed. Before plugin onboarding:

1. Push accepted local commit `19a5231e` to `origin/main` after confirming the remote has not independently advanced.
2. Verify local and remote `main` match and the working tree remains clean.
3. Start onboarding from a new neutral workflow branch based on that fetched remote head.

The [first onboarding run](collisionspike-v2-first-onboarding-run.md) defines the exact commands, branch shape, conversion artifacts, validation, GitHub setup, and PR boundary.

## Development operating model until cutover

```text
original live system
    |-- production evidence and observed behavior ----+
    |-- provided real examples -----------------------+----> v2 slice contract
    |-- operator rules and exception knowledge -------+          |
    `-- emergency fixes only                                      v
                                                       implement once in Core
                                                                  |
                                                                  v
                                                       proportional proof
                                                                  |
                                                                  v
                                                       accepted cutover slice
```

Use these boundaries:

- **Original repository:** live support, urgent correctness/reliability fixes, behavior discovery, and extraction of product/operational evidence.
- **V2 repository:** all planned forward features, clarified canonical rules, new UI, and the replacement implementation.
- **No automatic porting:** transfer a behavior only after it is classified as carry forward, modify, defer, or exclude.
- **No parallel invention:** a forward feature is not independently designed in both repositories.
- **No development fallbacks in v2:** implement one intended route; do not preserve speculative compatibility with pre-release v2 code or data.
- **No premature shutdown:** the original remains operational until the corresponding v2 outcome has accepted evidence and an approved cutover.

## Immediate technical guardrails for v2

The cleaner baseline will degrade if “greenfield” is treated as permission to add freely. Before expanding intake formats or rules:

1. Split the 1,031-line `MimeKitPdfPigOpenXmlIntakeSourceReader` by format/responsibility while retaining one `IIntakeSourceReader` composition boundary. Do this as a focused maintainability change, not a platform redesign.
2. Keep extraction mechanics in Infrastructure and business acceptance/classification policy in Core.
3. Require every new behavioral rule to name its one canonical owner, callers, activation, evidence, and UI/operational exposure.
4. Reject a second rules engine, generic “manager/service” layer, speculative provider abstraction, or feature flag without a present approved need.
5. Keep tests proportional; split the 1,300-line multi-format integration suite when adding another format so failures remain diagnosable.
6. Implement one bounded end-to-end outcome at a time, beginning from the agreed human-review-to-case boundary rather than the 213-item catalog as one release.

## What must be carried forward from the original

The original must not be discarded as though it has no value. V2 needs deliberate parity evidence for:

- Case/PO identity, sequencing, and taxonomy;
- correlation, duplicate and ambiguous-match handling, manual merge, and cancellation;
- readiness fields, queues, overrides, and approvals;
- relational-record versus Box-copy authority, retries, and reconciliation;
- inbox disposition and terminal/closure/reopen behavior;
- chasers and operational administration;
- EVA handoff and Archive filing within the agreed product boundary; and
- deployment, live-state, rollback, audit, and recovery practices that protect real operational risks.

These become product rules, acceptance scenarios, or operations evidence in v2—not copied architecture and not hundreds of mechanically imported GitHub issues.

## Plugin consequence

This comparison does not make the plugin CollisionSpike-specific. It validates generic onboarding requirements already present in the plan:

- compare runtime ownership rather than folder neatness;
- distinguish application debt from repository-workflow debt;
- classify existing code as live, generated, reference, compatibility, or retirement candidate;
- preserve claims and capability identity before deleting old planning machinery;
- avoid bulk issue import;
- require one canonical rule/configuration owner;
- stop on a dirty or already-purpose-bound baseline; and
- keep named case studies in research and neutral fixtures rather than packaged skill defaults.

## Decision

The recommended strategy is therefore:

> Push the accepted v2 cleanup baseline, onboard v2 into the new plugin standard, and use v2 as the only forward-development codebase. Preserve the original as the live operational/reference system with emergency fixes only until evidence-backed slice-by-slice replacement and cutover are complete.

The choice would need reconsideration only if the user decides that immediate production delivery outweighs maintainability, abandons the v2 product boundary, or discovers a non-reproducible critical behavior that cannot be specified or proven outside the original implementation. None of the current evidence establishes one of those exceptions.
