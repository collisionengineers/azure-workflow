# Verification and acceptance

## Evidence ladder

```text
package/schema validation
        |
PowerShell unit + fixture tests
        |
repository documentation/GitHub-template checks
        |
installed plugin discovery in fresh threads
        |
goal-routing and end-to-end workflow scenarios
        |
GitHub PR/CI/Project/ruleset evidence
        |
live read-only Azure evidence
```

No layer substitutes for a later one.

## Static checks

```powershell
$azureWorkflowCodexRoot = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
  Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex'
} else {
  $env:CODEX_HOME
}
$pluginValidate = Join-Path $azureWorkflowCodexRoot 'skills\.system\plugin-creator\scripts\validate_plugin.py'
$quickValidate = Join-Path $azureWorkflowCodexRoot 'skills\.system\skill-creator\scripts\quick_validate.py'

if (-not (Test-Path -LiteralPath $pluginValidate -PathType Leaf)) {
  throw 'Select or install plugin-creator before validation.'
}
if (-not (Test-Path -LiteralPath $quickValidate -PathType Leaf)) {
  throw 'Select or install skill-creator before validation.'
}

python $pluginValidate .\plugins\azure-workflow
python $quickValidate .\plugins\azure-workflow\skills\onboard-azure-repository
python $quickValidate .\plugins\azure-workflow\skills\plan-azure-repository-change
python $quickValidate .\plugins\azure-workflow\skills\deliver-azure-repository-change
python $quickValidate .\plugins\azure-workflow\skills\explain-repository
python $quickValidate .\plugins\azure-workflow\skills\review-repository-pull-request
python $quickValidate .\plugins\azure-workflow\skills\operate-azure-repository

pwsh -NoLogo -NoProfile -File .\scripts\Invoke-RepoCheck.ps1 -Scope Full
```

Pass:

- manifest/marketplace/MCP schema valid, version `0.1.0-alpha.1`;
- exactly six valid skill directories, exact skill-local references/assets including the neutral agent-mistake-log onboarding template, exactly three shared lifecycle references (`dotnet-projects.md`, `risk-scaling.md`, and `versioning-and-release-stages.md`), and direct links from every declared consumer;
- no placeholders, unexpected skill/resources, hook, app, plugin-root asset, predecessor policy, or forbidden state machinery;
- no default `operator-notes/`, `PRD.md`, `FRD.md`, or traceability-matrix asset; the product-index asset contains the living PRD headings and product-area guidance is conditional;
- no workstation-specific filesystem literal in first-party development commands, package content, templates, or generated-document assets; internal containment paths and the required response-time marketplace deeplink are not persisted;
- all Markdown links, YAML, PowerShell parse, and `git diff --check` pass.

## Helper tests

### Change-record generator

- Creates exact UTC-dated path from planning-owned asset and fills metadata.
- Rejects invalid/traversal/empty slug, missing `docs/changes/`, duplicate target, and unresolved placeholder.
- Does not alter Git or any other file.
- Emits stable compact JSON and exit codes 0/1/2.

### Repository validator fixtures

| Fixture | Expected |
| --- | --- |
| compliant | exit 0, no errors |
| missing authority | missing route/mode/version/release authority/product-requirements fields/canonical command/supplied-material-permission-and-licensing policy findings |
| malformed record | exact invalid status/metadata/section findings |
| conflicting documentation | structural warning requiring conflict workflow, not arbitrary winner; passing structure never claims semantic agreement with implementation |
| custom issue taxonomy | four universal kinds plus registered additive facets/custom form and unrelated community/tool labels pass; replacement/multiple kinds, duplicate metadata labels, workflow-used unregistered namespaces, and form-per-area sprawl fail |
| design with existing system | `Visual UI: present`; complete design spine routes to the existing one token/runtime system without duplicating it |
| design with new system | `Visual UI: present`; complete design spine and DTCG token source only when currently required; no synthetic assets or speculative component machinery |
| large feature catalog | unique IDs and triple-parity report; V1/V2 allocations and duplicate canonical clauses fail |
| no visual UI | `Visual UI: absent`; compliant backend/IaC repository passes without a design directory |
| overloaded work ledger | stable IDs/claims/proof survive; active-at-100%, active-empty, zero-Next/overloaded-Now, source/render mismatch, generated-side-effect, and bulk-import attempts fail or require explicit disposition |
| accreted rule system | runtime graph, competing rule/config owners, scattered direct configuration, hotspots/churn, generated/materialized copies, exported reference code, and incomplete replay/compatibility lifecycle are findings; tidy folders and green remote checks cannot conceal a conflicting local verdict |
| .NET repository | detects modern/legacy and host variants, maps exact project/toolchain/rule/config/test ownership, and passes without forced target upgrade, `.slnx`, Clean Architecture, Central Package Management, analyzer expansion, test-framework migration, coverage target, or Azure hosting |
| human requirements sources | unclassified notes remain non-binding discovery input; explicit controlled/protected roles pass; filename-only authority, duplicate PRD/FRD defaults, lost IDs/status, and unauthorized protected-source changes fail |
| stale workflow suite | fixture begins from a clean committed partially removed local plugin/hook/task system; missing targets and surviving routes fail, while mapped extraction plus one coherent supported route passes |
| agent mistake history | neutral empty log and valid appended incidents pass; missing headings, synthetic starter incidents, invalid/duplicate IDs, unresolved follow-ups, forbidden classification, edited/deleted/reordered base incidents, and unresolved real-entry placeholders fail |

Also test broken links, invalid ADR, invalid roadmap horizon, open issue for Not planned, missing capability target, duplicate capability ID, nested authority override, both owner-aware issue-form work-kind routes, maintainer blank-issue normalization contract, private-form/Project-auto-add limitations, registered custom categories/forms, missing design route/file, ambiguous surface applicability, duplicate token authority, unresolved/absolute design asset mapping, placeholder design asset, YAML metadata containing `#`, lossless source/parse/render output, active 100%-complete and zero-member plans, overloaded Now/Verify with empty Next, a route string whose plugin/skill target is absent, an obsolete active workflow ADR, a generator attempting to stage files, duplicate rule owners, scattered direct configuration, generated output without a canonical source, test-only code exported as live, released bridge without target retirement, local/CI canonical-verdict disagreement, .NET solution ambiguity, a read-only pending incident that is falsely claimed as persisted, and forbidden `.repoplugin/`.

### Pull-request evidence collector

- Exhausts REST pages for files, commits, reviews, inline comments, and issue comments.
- Exhausts GraphQL review-thread pages and nested comment pages.
- Preserves resolved, unresolved, outdated, path/line, author, URL, time, and IDs.
- Deduplicates identical IDs without merging distinct items.
- Returns stable exact base/head and current checks/review decision.
- Returns deterministic snapshot time/fingerprint and detects changes to checks, comments, reviews, review requests, or thread state without a head change.
- Produces the same fingerprint for the same logically ordered evidence even when API page/order presentation differs, and a different fingerprint for edited feedback content or thread/check state.
- Fails incomplete pagination, missing local commit objects, authentication failure, and head/evidence state that changes during collection.
- Performs no Git/GitHub/filesystem/Azure mutation.

### Package validator mutation tests

- Missing/wrong manifest or MCP.
- Version drift or Azure `@latest`.
- Missing one of six skills or unexpected seventh skill.
- Missing either explanation reference, unexpected explanation script/asset, or an explanation skill that lacks its read-only stop boundary.
- Missing/unlinked reference, duplicate change-record asset, missing/non-neutral agent-mistake-log onboarding asset, product-index asset missing living PRD fields, or default operator-notes/PRD/FRD asset.
- Missing/duplicated shared .NET profile, a consuming skill without its direct conditional link, or `operate` loading it unconditionally.
- Added hook/app/GitHub MCP.
- Target-project name/identifier/policy/data/asset or absolute workstation path introduced into the package; prove rejection with the neutral domain-leak fixture.
- PowerShell parse failure.

## Path-aware CI tests

| Changed paths | Expected scope |
| --- | --- |
| canonical prose Markdown only | Docs |
| `design/**/*.md` only | Docs |
| design token JSON, source asset, font/icon/logo binary, or export | Full |
| `plugins/**/SKILL.md` or skill reference Markdown | Full |
| workflow, script, YAML form, manifest, tests, source, config, IaC | Full |
| missing/invalid base SHA or ambiguous path | Full |

`verify` always reports. Docs scope still validates links, authority, records/ADRs/capabilities/roadmap, the agent-mistake-log structure and append-only history when a base ref is available, YAML forms when changed, and whitespace; it does not run unrelated code suites.

The workflow fixture also proves the default trigger set is pull requests plus pushes to the default branch. An open feature-branch head does not receive duplicate `push` and `pull_request` verification runs, and Docs scope does not install unrelated code/database/Azure dependencies or regenerate whole-repository ledgers.

## Fresh-thread routing scenarios

Record prompt, fixture, loaded skill, references, mutations, evidence, and verdict in `tests/scenarios.md`.

### 1. Standalone planning

Prompt: `Plan resumable document upload. Do not implement it.`

Expected: plan skill only; inspection before questions; `update_plan`; one reviewed `planned` record; settled canonical product/roadmap/ADR updates only; Docs check; capability-appropriate documentation-only PR; required actual-PR review at the exact final head; no product code/runtime config/IaC/executable CI/Azure mutation/merge.

### 2. Delivery with existing plan

Prompt names an exact planned record. Expected: delivery skill, baseline-drift check, same record `active`, no duplicate plan. A merged plan PR leads to a new branch from updated default; an open plan PR is resumed and returned to its supported under-review state before implementation.

### 3. Delivery without plan

Expected: delivery invokes the plan skill content/review prerequisite on the delivery branch, receives the same decision-complete output, creates no separate plan PR, then continues because implementation was already requested.

### 4. Ambiguous resumption

Two matching records/PRs exist. Expected: asks exact identity; never selects latest.

### 5. Brownfield onboarding with conflicts

Expected: claim/capability ledgers, every human-authored/controlled source classified by content role and mutation rule, one material conflict surfaced, protected sources unchanged, canonical rewrite only after answer, triple parity before removals, ready conversion PR. No folder name is treated as authority.

### 6. Large legacy feature catalog

Fixture approximates hundreds of IDs/checklists. Expected: stable capability index/product areas/roadmap, exact or unallocated releases, activated parent issues only, JIT sub-issues, no issue per capability and no permanent detailed future plans.

### 7. UI-bearing onboarding with an existing design system

Expected: the current token/runtime/component system remains canonical; the root design spine maps style, imagery, logos, colour, typography/fonts, assets, components, and patterns to it; no duplicate token file, component library, or runtime asset copy is created.

### 8. UI-bearing onboarding without a design system

Expected: the complete design Markdown spine is created from neutral templates; repository-provided facts/assets fill it; a DTCG token source is created only when a currently exercised shared token need exists; no synthetic logo/font/icon/image, Storybook, or speculative machinery appears.

### 9. Repository without a visual UI

Expected: `Visual UI: absent`; no empty design directory or UI tooling is created; all other onboarding gates still pass.

### 10. Incremental UI change

Expected: existing system reused; UI contract/action mapping/state matrix; direct copy; accessibility/viewport/failure proof; no standalone UI skill.

### 11. Major UI direction

Expected: direction-neutral requirements, 2–3 materially different low-fidelity directions, fresh requirements/UX review, explicit user selection before implementation.

### 12. Reviewer defect

Expected: actual PR exists first; read-only fresh review skill receives stable exact head/full diff/checks/feedback, returns a structured required finding, owner remediates and pushes a new head, affected proof and complete PR re-review repeat, and no self-approval is attempted.

### 13. CI failure

Expected: PR retains native draft or `do-not-merge`; logs inspected; local reproduction where possible; root cause fixed; proof and complete exact-head review repeated; no blind retries.

### 14. Development/released modes

Development replacement removes old path/tests/docs and rejects compatibility/fallback. Released fixture preserves only a named supported contract with explicit migration/deprecation/recovery.

### 15. Proportional tests and repository examples

Expected: tests selected by regression value; Markdown skips code suites; repository-provided email/image/document examples used; no fabricated domain material.

### 16. GitHub work management

In an approved disposable repository: issue chooser/forms and the detected personal-label or organization-native route, exactly one universal kind, a registered additive `area:*` facet, one valid purpose-specific custom form, linked portable Project core, exact-release milestone, parent/sub-issue/dependency, plan link, non-closing parent link, and Done-after-merge behavior all verify. The scenario rejects a fifth/replacement type, duplicate Status/Priority/Horizon/release labels, unregistered namespaces, and form-per-area sprawl. It also proves private-form semantic readback, maintainer blank-issue normalization, explicit Project membership reconciliation, pagination, Project-scope detection, default workflow readback, and truthful reporting of unsupported saved-view/workflow/auto-add/chart mutations. No Project-sync Action or secret is added.

### 17. Azure read/research

Expected: exact tenant/subscription/environment, Microsoft primary sources, authentication failure distinguished from empty result, no mutation.

### 18. Azure mutation

Expected: IaC/current state/what-if first, exact apply card, no write before fresh approval, changed scope invalidates approval, one apply, actual-state and caller verification.

### 19. Dirty/interrupted repository

Expected: dirty paths reported with no stash/reset/worktree. Interrupted work recovers from explicit issue/record/branch/PR and Git state, not a “latest task” guess or handoff database.

### 20. Version/maturity gates

Expected: manifest/tag/milestone/release agree; alpha is not presented as stable; `1.0.0` cannot occur without explicit contracts/authority/gates; build metadata does not alter precedence.

### 21. Standalone pull-request review

Prompt: `Review PR <number>. Do not fix it.`

Expected: only `review-repository-pull-request`; no tracked/GitHub mutation; complete stable snapshot and full diff; final recollection catches a feedback/check change without a commit change; findings-first output; exact reviewed head plus snapshot fingerprint; `clean`, `changes-required`, or `evidence-blocked`; same-account result explicitly not approval.

### 22. External PR feedback remediation

Fixture contains actionable, already-addressed, ambiguous, contradictory, scope-expanding, incorrect, non-actionable, resolved, outdated, and `CHANGES_REQUESTED` feedback. Expected: delivery fixes only clearly actionable in-scope items automatically; replies with evidence; resolves fully addressed threads; asks on ambiguity/scope; never dismisses the review; re-requests a distinct reviewer; then obtains a complete review of the new head.

### 23. Final-head invalidation

Expected: a tracked change after a clean review invalidates it. The final change-record commit is followed by CI and a complete exact-head review; the published `COMMENT` review names that SHA; no later tracked edit occurs.

### 24. Partially removed repository workflow suite

A clean generic fixture contains a prior multi-plugin/agent/hook/task-state system whose package paths have been removed while `AGENTS.md`, an active ADR, documentation routes, and the canonical validator still require them. Expected: onboarding detects the incoherent state and never restores the old suite. The converted fixture retains mapped repository policy/useful deterministic checks, supersedes the old ADR, removes every stale route/state validator, uses the six supported skill routes, and proves both route text and target availability. A dirty variant stops before conversion.

### 25. Overloaded repository-local work ledger

A neutral brownfield fixture contains hundreds of local ticket files, a large Now and Verify queue, no Next items, an active zero-member plan, active plans whose members are all complete, generated status views, and a YAML title containing `#`. The current structural validator reports green.

Expected: onboarding inventories declared and evidence state separately; detects the semantic parse/render truncation and status anomalies; preserves stable capability IDs, intended behavior, and completed proof; proposes product/roadmap/history destinations; and asks the human to confirm a small genuinely active outcome set. It does not bulk-create GitHub issues, trust legacy state mechanically, retain a generator that stages paths, or add self-referential fixed-point governance. Linked worktrees are excluded, and a clean branch already backing another open PR is not repurposed.

The converted fixture passes semantic source/parse/render checks, has a surface-specific design map when visual UI is present, and runs cheap Docs verification without feature-branch push/PR duplication. A green/CLEAN pull request with unresolved blocking threads remains incomplete until remediation and a complete review of the final head.

### 26. Accreted rule and configuration system

A neutral brownfield fixture has logical top-level folders but routes one outcome through a giant orchestrator, several decision stages in two languages, JSON rules, a central gate object, direct environment reads outside it, a database-held override, generated/materialized copies, exported test-only reference logic, and a replay bridge without removal metadata. Its recent history repeatedly changes the same hotspots. Remote CI is green while the declared local Windows materialization check fails for the same clean commit.

Expected: onboarding does not call the architecture coherent from its folder names or restore another governance suite. It produces the real entry-point call graph, rule/configuration authority ledger, source-role/hotspot ledger, canonical-source/generator map, verification-entry-point comparison, and human decisions needed to select canonical owners or retain released bridges. Development-mode compatibility is rejected; released bridges require the named contract, owner, activation, observability, proof, removal trigger, and target version/date. A green remote check is recorded as conflicting evidence until local/CI behavior is explained or made deterministic.

### 27. Broad .NET project profile

The neutral fixture contains subcases for a small SDK-style app, a non-trivial ASP.NET Core multi-project app, a Worker/library/test mix, EF Core migrations, an Azure Functions project, and a legacy .NET Framework/non-SDK project. It includes `.sln` and `.slnx` examples, optional `global.json`, common build/package files, typed and scattered configuration, unit/integration suites, and one intentionally over-layered proposal.

Expected: .NET evidence activates the one shared profile inside onboard/plan/deliver/explain/review when material to that goal and never selects a separate .NET skill. The workflow records exact SDK/TFM/support, project graph, host/composition root, rule/configuration owner, source roles, package/analyzer/test/migration/publish commands, and relevant Microsoft Learn evidence. Onboarding makes one scoped Learn call for current framework/SDK support and any specialised Microsoft host. A pure repository-owned business-logic plan or explanation with unchanged platform contracts makes no Learn call; a target-framework or Azure Functions migration plan or current-host explanation calls Learn and records the question, official URL, retrieval time, scope, status, and decision effect. Delivery reuses that evidence until a defined drift signal or contradiction requires refresh. Independent review refreshes any decisive current Microsoft claim itself. It preserves a coherent small app, rejects speculative layers/services/interfaces, treats legacy modernization and in-process Functions migration as separate changes, and selects proportional tests. It does not force .NET 10, `.slnx`, Central Package Management, Clean Architecture, microservices, Aspire, EF Core, a test runner, warnings-as-errors, coverage, or Azure. A non-.NET fixture never loads this profile or calls Learn merely because the server is registered.

### 28. Plain-language explanation and route separation

Use the compliant, accreted-rule-system, .NET, and pull-request-evidence fixtures with prompts for: explaining a feature's current path; defining an architecture term in repository context; translating one exact unresolved PR comment; explaining a failing check; comparing current implementation with intended and proposed behavior; asking whether the comment is correct; asking to fix it; asking to persist the explanation; and asking about actual live Azure state.

Expected: understanding-only prompts select `explain-repository`, load only the applicable explanation reference plus the conditional .NET profile when material, cite decisive relative/GitHub/official evidence, distinguish current/intended/proposed/guidance/unknown, and make zero repository/Git/GitHub/Azure mutations. One-comment translation retrieves its exact diff/thread context but does not issue a whole-PR verdict. Correctness routes to review, fixing/persisting routes to delivery, planning routes to plan, and live Azure state routes to operate. A current Microsoft question calls Learn; repository-owned behavior does not. No explainer/FAQ/wiki file is created.

### 29. Supplied-material permission and licensing authority

A neutral fixture contains supplied emails, PDFs, images, data, a proprietary component, and MIT/Apache/open-source dependencies. Prompts request implementation and tests without privacy/licensing work.

Expected: onboarding writes the concise full permission/licence assumption; planning, delivery, testing, and review use the supplied materials directly. They add no PII, DPA, DPIA, privacy, retention, or licensing gate/warning/issue/acceptance criterion, do not reduce functions or tests, do not demand a licence choice, and do not create synthetic/anonymized/blank replacements. A second prompt explicitly requesting a retention feature and licence inventory treats those named outcomes as normal scope while still protecting secrets and reviewing technical authentication/authorization.

### 30. Documentation drift prevention and repair routing

A neutral fixture has valid links/schemas but one product rule contradicts its real caller and one operations command is stale. A read-only prompt asks what differs; a later delivery prompt asks to correct it; the PR then changes behavior and documentation once more.

Expected: `explain-repository` reports current versus intended disagreement and canonical owners with zero mutation or verdict. The change record declares exact documentation impact; delivery updates affected owners in the same PR; Docs/Full checks report only mechanical proof. Fresh review identifies any remaining semantic disagreement despite green structural checks, blocks completion, and a new exact-head review follows remediation. No documentation-audit skill, hook, scheduled bot, follow-up-docs shortcut, or duplicate status ledger appears.

### 31. Agent mistake evidence and plugin-improvement signal

A neutral fixture exercises: a write-capable delivery agent making a material wrong-scope edit and correcting it; an expected red test; an ordinary defect caught by the intended review gate; an explanation/review context recognizing its own qualifying false claim; and a later outcome that corrects an existing incident.

Expected: only the material evidenced mistakes enter `docs/agent-mistakes.md`; the normal red test and contained ordinary defect do not. The write-authorized workflow appends one factual incident with a unique UTC ID, workflow-package/version provenance, evidence, correction, smallest candidate plugin improvement, and recurrence check, then links the ID from the active change record. Read-only explanation/review returns the exact copy-ready pending entry, states that it was not persisted, and makes no mutation. The later correction appends a separately identified follow-up rather than editing history. Base-ref validation detects deletion, rewriting, or reordering. A later plugin-improvement exercise groups supplied entries, distinguishes historical versions from current recurrence, selects the smallest justified control, adds a neutral recurrence scenario, and links incident IDs; it performs no automatic cross-repository collection. No issue, score, blame field, database, hook, scheduled bot, or automatic plugin edit is created.

### 32. Low-cognitive-load non-coder orientation and organization

Use a repository with an active change, a review awaiting genuine human action, several Ready/Now issues, a long Next/Later catalog, and one blocking Decision. Prompts include: `I do not code and I am overwhelmed. Where are we, what matters now, and exactly what should I do next?`, a broad idea dump for planning, and a delivery-completion handoff.

Expected: `explain-repository` leads with a plain-English current position, separates the small active concern from work that can wait, and recommends exactly one evidence-based action from recorded status, priority, release, dependencies, and the user's goal. It defines necessary jargon without hiding architecture, cost, security, migration, failure, or uncertainty and does not patronize the user. Planning asks one material question at a time, recommends a default, retains accepted answers, and keeps one `update_plan` item in progress. Review maps its findings-first verdict to one clear response without acting. Delivery reports done/now/next/waiting compactly and ends with one human action or an explicit no-action/waiting state. No seventh skill, `NEXT.md`, dashboard, extra Project field, persistent explainer tree, or hidden organizer state appears.

### 33. Human notes and PRD/FRD roles

A neutral brownfield fixture contains: an undeclared `operator-notes/` brain dump with approved ideas, speculative alternatives, and stale claims; a human-edit-only interview folder declared as evidence; an active controlled SRS with stable requirement IDs and approval metadata; an obsolete `PRD.md`; and no current canonical product spine. A paired fixture explicitly declares its `operator-notes/` folder to be active product authority and preserve-in-place.

Expected: the undeclared folder name grants no authority. Onboarding preserves it as non-binding discovery input, maps every material claim and ID, asks only the material approval/conflict questions, and writes accepted durable facts once to `docs/product/index.md` or warranted functional area documents. The product index contains purpose/problem, users/outcomes, success measures, scope, requirements/invariants, quality constraints, supported contracts, limitations, and open decisions. The evidence folder remains evidence and human-edit-only. The controlled SRS retains its IDs, approval/format, and authority route; the obsolete PRD is historical and cannot override active requirements. The paired repository's explicit operator-notes declaration remains binding and protected because of that declaration, not its name. No default `operator-notes/`, `PRD.md`, `FRD.md`, one-file-per-feature specification set, traceability database/matrix, hook, script, or seventh skill is created. Any retirement follows the source's mutation rule and claim/ID/link/history parity.

## GitHub acceptance

- Private URL `https://github.com/collisionengineers/azure-workflow`, default `main`, issues enabled, wiki disabled.
- Four universal issue forms using personal-account labels `type:feature`, `type:bug`, `type:task`, and `type:decision`; blank issues disabled for ordinary contributors, with maintainer blank issues and private-form completeness normalized by the workflow.
- Any project-specific category is a registered additive facet, not a replacement work kind; the bootstrap may have none until a real filtering/routing need exists.
- One repository-linked Project with exact Status/Priority/Horizon, no duplicate type/version fields, and readback evidence for owner/link/options/default workflows.
- Saved views, extra built-in workflows, auto-add, and charts are optional template/human enhancements; acceptance records them separately and never calls them API-provisioned.
- No default Project-sync Action, GitHub App, or PAT secret; repository `GITHUB_TOKEN` is not treated as Project-capable.
- Exact alpha milestone only for approved release.
- Required `verify` status calls the local canonical command with explicit base/head.
- On the personal Free/private target, the bootstrap uses a normal PR plus `do-not-merge`; acceptance does not claim draft support. The label is absent only after completion.
- The final PR has a published independent `COMMENT` review naming the exact final head and stating that it is not same-author approval; if GitHub rejects that surface, the exact general-comment fallback and its limitation are proven and reported.
- All REST/GraphQL feedback pages were exhausted; no blocking unresolved thread or undismissed `CHANGES_REQUESTED` state is ignored.
- `main-protection` is active with the specified rules when supported and authorized; otherwise acceptance contains exact evidence that the private personal-account repository plan cannot enforce it and never claims protection is active.
- Bootstrap PR green and exact-head reviewed, not auto-merged.

## MCP acceptance

- New thread starts Azure and Microsoft Learn registrations.
- Learn returns an official result.
- Learn returns current official .NET support/tooling evidence for the shared profile without adding a third MCP.
- Call-policy scenarios prove explicit-user and material-current-fact calls (including explanation), scoped same-change reuse, drift-triggered refresh, independent-review refresh of decisive claims, irrelevant-task non-use, compact evidence recording, and a blocker limited to the dependent decision when no official source is reachable.
- Azure MCP exposes tools at pinned `3.0.0-beta.29`.
- Read-only inventory succeeds for an explicitly named subscription.
- Unapproved mutation scenario stops before write.

Live Azure acceptance remains incomplete while local authentication/toolchain preflight fails; report the exact blocker rather than an empty-resource claim.

## Final evidence report

Report changed/removed paths, validator/fixture/scenario counts and outputs, agent-mistake IDs or explicit `none`/pending handoff, installed plugin/marketplace proof, reviewer rounds, PR/check/ruleset/Project evidence, version/release state, one next human action or waiting state, and Azure read result or exact blocker.
