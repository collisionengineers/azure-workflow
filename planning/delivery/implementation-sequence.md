# Plugin implementation sequence

## Rule

Build in this order so package shape, skill boundaries, repository standards, and tests stabilize before live installation or external setup. Each phase exits green before the next begins.

Run the commands below from the repository root. Resolve the two installed creator skills once per PowerShell session from `CODEX_HOME`, or from Codex's documented per-user default when `CODEX_HOME` is unset:

```powershell
$azureWorkflowCodexRoot = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
  Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex'
} else {
  $env:CODEX_HOME
}

$pluginCreatorSkillRoot = Join-Path $azureWorkflowCodexRoot 'skills\.system\plugin-creator'
$skillCreatorSkillRoot = Join-Path $azureWorkflowCodexRoot 'skills\.system\skill-creator'
$pluginCreator = Join-Path $pluginCreatorSkillRoot 'scripts\create_basic_plugin.py'
$skillCreator = Join-Path $skillCreatorSkillRoot 'scripts\init_skill.py'

if (-not (Test-Path -LiteralPath $pluginCreator -PathType Leaf)) {
  throw 'Select or install plugin-creator before implementation.'
}
if (-not (Test-Path -LiteralPath $skillCreator -PathType Leaf)) {
  throw 'Select or install skill-creator before implementation.'
}
```

If an active skill reports a different filesystem locator, use that discovered locator for the current session. Never copy a resolved workstation path into a tracked file, template, fixture, or generated repository document.

```text
planning freeze
   -> Git baseline
   -> plugin scaffold
   -> six skill skeletons
   -> references/assets
   -> deterministic helpers
   -> self-onboard repository
   -> fixtures/scenarios
   -> installed smoke tests
   -> GitHub setup + actual PR review + review-complete PR
```

## Phase 0: freeze and baseline

1. Run the planning cross-check: links, exact paths, six-skill count, versions, statuses, MCPs, no hooks, owner-aware work-kind model, explanation/review boundaries, actual-PR review contract, and no competing `docs/product.md`/`docs/plans/` standard.
2. Inventory `ref-files/`, `.codex/`, and root `hooks.json`; treat them only as extraction inputs.
3. Confirm no plugin implementation files already exist that would be overwritten.
4. Retain the existing Git repository and planning baseline; do not reinitialize or rewrite it.
5. Create a `main` planning baseline commit containing the planning pack and chosen reference snapshot policy. Do not silently add secrets, machine state, or ignored predecessor artifacts.

Exit: planning pack is internally consistent and recoverable from Git.

## Phase 1: create private repository

Create `collisionengineers/azure-workflow` private with default `main` only after the local baseline exists. Push the baseline, then create `feat/bootstrap-azure-workflow` from `origin/main` with a clean tree.

Do not add a licence, release, Project, ruleset, collaborator, environment, secret, deployment key, or Azure resource yet.

Exit: clean scoped branch, correct remote/default branch, no unrelated GitHub configuration.

## Phase 2: scaffold the plugin

Use the installed `plugin-creator` script exactly once:

```powershell
python $pluginCreator azure-workflow `
  --path .\plugins `
  --marketplace-path .\.agents\plugins\marketplace.json `
  --with-skills `
  --with-scripts `
  --with-mcp `
  --with-marketplace
```

Do not use `--force`, hooks, apps, plugin-root assets, or a custom marketplace name. Populate the exact manifest and MCP contracts, with version `0.1.0-alpha.1`.

Exit: plugin-creator validation passes for the empty package shape.

## Phase 3: initialize six skills

```powershell
$skillRoot = '.\plugins\azure-workflow\skills'

python $skillCreator onboard-azure-repository `
  --path $skillRoot `
  --resources references,assets `
  --interface 'display_name=Onboard Azure Repository' `
  --interface 'short_description=Convert an existing repository to the workflow standard' `
  --interface 'default_prompt=Use $onboard-azure-repository to convert this repository to the Azure Workflow documentation, GitHub, planning, explanation, review, and delivery standard without losing material truth.'

python $skillCreator plan-azure-repository-change `
  --path $skillRoot `
  --resources references,assets `
  --interface 'display_name=Plan Repository Change' `
  --interface 'short_description=Create a decision-complete repository-grounded plan' `
  --interface 'default_prompt=Use $plan-azure-repository-change to plan this change. Inspect the repository, ask only material questions, persist one reviewed change record, and do not implement it.'

python $skillCreator deliver-azure-repository-change `
  --path $skillRoot `
  --resources references `
  --interface 'display_name=Deliver Repository Change' `
  --interface 'short_description=Implement and independently prove one repository change' `
  --interface 'default_prompt=Use $deliver-azure-repository-change to implement this change through a green pull request reviewed at its exact final head. Reuse its plan or create one through the planning prerequisite.'

python $skillCreator explain-repository `
  --path $skillRoot `
  --resources references `
  --interface 'display_name=Explain Repository' `
  --interface 'short_description=Explain repository work and feedback in plain English' `
  --interface 'default_prompt=Use $explain-repository to explain this repository feature, technical concept, or feedback in plain English without changing anything.'

python $skillCreator review-repository-pull-request `
  --path $skillRoot `
  --resources references `
  --interface 'display_name=Review Pull Request' `
  --interface 'short_description=Independently assess one GitHub pull request' `
  --interface 'default_prompt=Use $review-repository-pull-request to independently review this pull request without changing it.'

python $skillCreator operate-azure-repository `
  --path $skillRoot `
  --resources references `
  --interface 'display_name=Operate Azure Repository' `
  --interface 'short_description=Inspect and apply controlled Azure operations' `
  --interface 'default_prompt=Use $operate-azure-repository to inspect this repository''s Azure scope and carry out only explicitly approved changes.'
```

Replace generated bodies with the exact six skill specifications. Remove example/placeholder files. Regenerate `agents/openai.yaml` if manual edits drift.

Exit: all six quick validators pass; plan-only, delivery, explanation-only, review-only, and Azure-operation descriptions have unambiguous mutation boundaries.

## Phase 4: implement references and assets

Create exactly the tree in [the file-tree contract](../02-plugin-file-tree.md).

Requirements:

- Each `SKILL.md` directly links every reference it may load.
- No reference requires a second reference to understand its procedure.
- Create the single plugin-root `references/dotnet-projects.md`; onboard/plan/deliver/explain/review link it directly and load it only for material .NET scope. Do not create a .NET skill, duplicate goal copies, extra MCP, or hook.
- Onboarding assets contain repository-spine/issue/PR templates, the append-only agent-mistake-log template, plus the conditional design Markdown spine and no domain-specific facts, pre-populated incidents, asset binaries, token values, palette, logo, font, or product copy.
- Planning owns the only change-record template.
- Delivery reads the target repository's PR template and owns no duplicate asset.
- Review owns the complete-diff/finding contract and GitHub evidence-collection reference; delivery owns only remediation/publication integration and does not duplicate the checklist.
- Explanation owns separate code/system and GitHub-feedback translation references, has no script/asset/state, and never substitutes for review's correctness verdict.
- Onboarding has one conditional design-system reference; UI planning and UI delivery remain separate conditional references.
- References preserve normative links/provenance but do not vendor large upstream docs.

Exit: exact-tree allowlist passes; each skill remains below 500 lines.

## Phase 5: deterministic PowerShell helpers

Implement:

1. `Get-AzureWorkflowPullRequestEvidence.ps1`
2. `New-AzureWorkflowChange.ps1`
3. `Test-AzureWorkflowRepository.ps1`
4. `Test-AzureWorkflowPlugin.ps1`
5. repository development wrapper `scripts/Invoke-RepoCheck.ps1`

Use strict mode, contained literal paths, stable JSON output, documented exit codes, and no Git/Azure mutations. Add fixtures for compliant, missing authority, malformed record, malformed or rewritten agent-mistake history, conflicting documentation, human-authored/formal requirements sources, existing/new/no-UI design routes, domain leakage, stale/partially removed workflow routing, large feature catalog, an overloaded local work ledger with semantic render drift, a neutral accreted rule/configuration system, broad .NET project variants, paginated PR feedback, unresolved/outdated threads, and a head that changes during collection.

Exit: script unit/fixture tests pass under PowerShell 7.

## Phase 6: apply the standard to this repository

Create/update:

```text
AGENTS.md
README.md
docs/index.md
docs/product/index.md
docs/product/capabilities.md
docs/roadmap.md
docs/architecture.md
docs/operations.md
docs/agent-mistakes.md
docs/decisions/0001-single-plugin-six-skill-architecture.md
docs/changes/2026-07-26-bootstrap-azure-workflow.md
.github/ISSUE_TEMPLATE/{feature,bug,task,decision}.yml
.github/ISSUE_TEMPLATE/config.yml
.github/pull_request_template.md
.github/workflows/verify.yml
```

Declare mode `development`, version `0.1.0-alpha.1`, stage `alpha`, release authority, and `Visual UI: absent` because this repository packages a workflow and has no visual application surface. Do not create an empty root `design/` for this repository. Apply the exact policy-placement contract. The bootstrap record maps retained principles/provenance from reference material while excluding source-project product policy and predecessor lifecycle machinery.

Write `docs/product/index.md` with the living product-requirements headings and do not create `operator-notes/`, `PRD.md`, or `FRD.md`. Classify `ref-files/` only as extraction evidence under its existing read-only rule; it is not product authority.

Exit: repository-standard validator and Docs/Full classification tests pass.

## Phase 7: extract and retire reference inputs

1. Inventory `ref-files/`, `.codex/`, and `hooks.json` in the bootstrap record.
2. Map every retained principle/source to its new skill/reference/standard/decision.
3. Record upstream provenance rather than vendoring complete documentation.
4. Prove no implementation/read path still depends on those inputs.
5. Run full checks and prepare the extraction-map evidence for the later actual-PR review.
6. Remove exact obsolete paths only after proof; report that ignored/untracked sources are not Git-recoverable unless separately backed up.
7. Re-run full checks/searches after removal.

Exit: no reference-source dependency, predecessor name/policy, stale hook, or `.codex` setup remains.

## Phase 8: scenario and installed validation

Run [the complete acceptance matrix](verification-and-acceptance.md), including:

- six-skill activation and stop boundaries in new threads, including explain-versus-review/plan/deliver/operate routing;
- standalone Docs-only plan PR, unpublished delivery prerequisite, open/merged plan-PR resumption, actual plan-PR review, and baseline drift;
- large feature-catalog conversion/triple parity;
- UI-bearing onboarding with an existing design system, UI-bearing onboarding requiring a new minimal design authority, and a no-visual-UI repository;
- coherent conversion of a clean partially removed repository-local plugin/agent/hook/task suite, plus dirty-tree refusal;
- coherent conversion of an overloaded repository-local work ledger, including active-state anomalies, source/parse/render parity, human-confirmed activation, no bulk issue import, and branch/worktree exclusion;
- implementation-level onboarding of an accreted rule/configuration system, including real call graphs, source roles, hotspots/churn, generated ownership, released-bridge lifecycle, and Windows/CI verdict equivalence;
- broad .NET profile activation across modern, legacy, web, worker, library, EF, Functions, and test variants, including proof that no framework/solution/architecture/package/analyzer/test-platform/Azure choice is imposed;
- layered feature/system/term/PR-comment/check explanation with current/intended/proposed separation, exact evidence, no persistent explainer tree, and zero mutation;
- Microsoft Learn call policy: material current-fact and explicit-user calls, scoped same-change reuse, drift-triggered refresh, independent-review refresh of decisive claims, irrelevant-task non-use, compact evidence, and decision-scoped failure;
- GitHub issue forms, universal-kind/additive-category conversion, private-form and Project-membership readback, and the portable Project core on an approved disposable/private repository, with unsupported view/workflow/auto-add/chart surfaces reported exactly;
- UI incremental and major-direction routes, one-token-source enforcement, and design-source/runtime synchronization;
- proportional tests/path-aware CI;
- actual-PR review, same-author COMMENT evidence, paginated feedback/thread/check collection, stable-head evidence-fingerprint invalidation, remediation, exact-head invalidation, and CI remediation;
- mode and non-synthetic-example policies;
- supplied-material permission/licensing authority with no invented PII/DPA/DPIA/privacy/retention/licensing gate, warning, substitution, or scope reduction;
- documentation impact declaration, same-PR maintenance, mechanical proof limits, read-only drift explanation, semantic exact-head review, and repair routing;
- material-agent-mistake admission, append-only incident history, copy-ready read-only handoff, correction/follow-up linking, and reusable plugin-improvement classification without automatic task/plugin creation;
- low-cognitive-load orientation and collaboration: plain-English current position, what matters now versus later, one evidence-based next action, one material question at a time, retained decisions, and no duplicate `NEXT.md`, dashboard, organizer skill, or persistent explainer tree;
- human-source and requirements roles: unclassified notes remain non-binding discovery input, explicit protected/controlled declarations survive, living PRD/functional-specification owners receive approved requirements once, controlled formal IDs/status remain traceable, and no default acronym files or traceability machinery appear;
- Azure MCP/Learn startup, Learn guidance routing, read-only inventory, and mutation stop.

Use plugin-creator cachebuster + reinstall between local package changes. Never claim Azure complete before a live scoped read succeeds.

Exit: every required scenario has recorded observed evidence or an exact external blocker.

## Phase 9: GitHub governance, review, and PR

1. Add/reuse the repository-linked Project and its exact Status/Priority/Horizon fields under the portable GitHub work-management contract; read back default workflow state and record optional UI-only enhancement gaps without adding a sync Action.
2. Create approved alpha milestone(s); do not import a speculative backlog.
3. Push the bootstrap branch and create the actual PR. On the personal Free/private target, use normal PR + `do-not-merge`; do not claim native draft support.
4. Monitor `verify` for the exact head and run the PR evidence collector to completion.
5. Invoke `$review-repository-pull-request` in a fresh context against the actual PR; remediate/re-prove/re-push and repeat complete review for every new head.
6. Probe ruleset availability. When supported and separately authorized, create `main-protection` after its check context exists, with PR required, zero mandatory human approvals, strict `verify`, no force push/deletion, and no auto-merge. On an unsupported personal/private GitHub Free repository, record the exact limitation without converting the account or requiring payment.
7. After a clean candidate, update the record to `ready`, push, confirm CI, obtain/publish a final clean exact-head `COMMENT` review, refresh all feedback, remove `do-not-merge`, and read back. Do not merge.

Exit: private personal-account repo, green exact-head-reviewed PR, clean scoped tree, and either active verified ruleset or exact plan-capability evidence explaining why protection is unavailable.

## Phase 10: alpha release after merge authority acts

The implementation agent stops at a review-complete PR. After a human/authorized process merges:

1. Re-run Full on `main`.
2. Tag immutable `v0.1.0-alpha.1`.
3. Create a prerelease with supported scope, known limitations, install/update/uninstall instructions, and evidence links.
4. Do not call it beta/stable until the gates in [versioning](../standards/versioning-and-release-stages.md) pass.

## Exit criteria

- One plugin, exactly six public skills, exact allowed resources, and one shared conditional .NET profile.
- Two MCP registrations; no hook, app, GitHub MCP, or workflow database.
- Planning pack, canonical docs, GitHub setup, manifest version, and release contract agree.
- Validators, fixtures, scenarios, installed smoke tests, CI, and fresh review pass.
- All six routes and the planning-prerequisite/resumption/review-remediation paths behave as specified.
- Supplied-material/licensing assumptions, the three-layer documentation-drift controls, the append-only agent-mistake evidence loop, low-cognitive-load collaboration, and human-source/requirements-role classification pass their fresh-thread scenarios without adding a skill, hook, scheduled bot, organizer state, duplicate requirements document, or ledger.
- Reference inputs/stale setup are absent only after mapped extraction proof.
- Normal implementation stops at a green exact-head-reviewed PR; alpha release waits for authorized merge.
