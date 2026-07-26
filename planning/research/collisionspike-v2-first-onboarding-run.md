# CollisionSpike v2 first onboarding run

Status: case-specific execution runbook for testing the generic `azure-workflow` onboarding design

Run date: after the plugin is implemented, validated, and freshly installed

This document does not add CollisionSpike rules to the plugin. It applies the generic [onboarding workflow](../workflows/onboarding.md) to one difficult repository so that the first run has an exact, reviewable boundary.

## Direct answer

Yes: committing the old workflow removal was the important repository prerequisite.

One small Git boundary remains. Local `main` is clean at `19a5231e6e899369683cad6da498f731894cf9eb` (`plugin/workflow removal`), while `origin/main` is one commit behind. Push that already-settled commit to `origin/main` before starting onboarding. Otherwise the cleanup becomes part of the onboarding pull request and the two changes are no longer independently reviewable.

The onboarding agent must not push directly to `main` on the user's behalf. This baseline synchronization is a human-owned prerequisite, not a new cleanup decision.

## Confirmed starting state

| Concern | Starting fact | Onboarding treatment |
| --- | --- | --- |
| Repository | `collisionspike_v2` | Target only this Git root. |
| Local baseline | Clean `main` at `19a5231e` | Accept as intentional; do not reopen or reconstruct the removed suite. |
| Remote baseline | `origin/main` is one commit behind local `main` | Synchronize before creating the onboarding branch. |
| Repository mode | Pre-release development | Record `development`; do not add compatibility, fallback, or legacy paths merely for hypothetical consumers. |
| Human authority | `docs/operator-notes/` | Read as key business authority and preserve byte-for-byte. |
| Product corpus | 213 stable feature IDs plus raw answers, allocations, and detailed plans | Convert losslessly; do not create 213 issues. |
| Application | .NET 10 modular monolith with Web, Worker, Core, Infrastructure, tests, and Bicep | Preserve the architecture; onboarding is not a framework or application rewrite. |
| User interface | Visual web UI exists | Declare `Visual UI: present` and create the required root `design/` authority. |
| GitHub owner | Private repository on the personal `collisionengineers` account | Use repository `type:*` labels and the personal Project route; do not require an organization conversion. |
| GitHub work state | Issues enabled, no current project-specific issue system | Establish the portable core without a bulk backlog import. |
| Current CI | One Windows job runs the monolithic repository check for every change | Retain valuable proof but route Docs and Full scope through one stable `verify` result. |
| Azure | Repository contains Azure/IaC material | Repository reads are in scope; no Azure resource mutation is authorized. |

The committed Azurite manifest, Obsidian setting, and every other file in `19a5231e` are baseline facts. Onboarding inventories them normally and does not relitigate why they were committed.

## Before invoking the skill

### 1. Synchronize the accepted baseline

Run from the CollisionSpike v2 repository:

```powershell
git switch main
git status --short
git fetch --prune origin
git rev-list --left-right --count origin/main...HEAD
```

Proceed with the direct push only when the tree is empty and the count is `0 1`, meaning remote has no commit absent locally and local contains only the accepted cleanup commit:

```powershell
git push origin main
git fetch --prune origin
git rev-list --left-right --count origin/main...HEAD
```

Required final result: `0 0`. If the first number is non-zero, stop and reconcile the newly discovered remote work; do not force-push.

### 2. Install the completed plugin

From the future `azure-workflow` plugin repository root:

```powershell
$workflowRepository = (Resolve-Path .).Path
codex plugin marketplace add $workflowRepository --json
codex plugin add azure-workflow@personal --json
codex plugin list
```

Then open a new Codex thread at the CollisionSpike v2 Git root. An existing thread is not plugin-load proof.

### 3. Use this exact first prompt

```text
$onboard-azure-repository Convert this repository fully to the Azure Workflow standard. Treat docs/operator-notes as immutable key business authority, preserve every material claim and every existing feature ID, establish the documentation, design, GitHub, CI, planning, delivery, explanation, and PR-review system, and deliver one fully reviewed onboarding pull request. Do not create a bulk feature backlog, change application behavior, mutate Azure, or merge the pull request. Ask me one material decision at a time and keep the next action obvious.
```

This is an explicit full-onboarding request. It authorizes the scoped branch, repository conversion, repository-owned GitHub templates and labels, one idempotent linked personal Project, narrowly necessary issues, commits, push, PR, CI remediation, and review-evidence publication within the [onboarding authorization contract](../skills/onboard-azure-repository.md). It does not authorize Azure writes, account changes, bulk issue creation, destructive Project replacement, force-push, or merge.

## Exact execution flow

```text
accepted cleanup commit on local main
                 |
                 v
human pushes it to origin/main -> local/remote count 0 0
                 |
                 v
fresh thread invokes $onboard-azure-repository
                 |
                 v
read-only preflight + authority/inventory snapshot
                 |
                 v
create workflow/YYYYMMDD-onboard-azure-workflow
                 |
                 v
create one onboarding change record + call update_plan
                 |
                 v
build claim/capability/work/rule/source/design/GitHub ledgers
                 |
                 v
material human choice? -- yes --> ask one question -> record -> rescan
                 | no
                 v
canonical docs + design + proportional CI + GitHub files
                 |
                 v
213-ID triple parity + material-claim/link/authority proof
                 | fail
                 +------> retain old source, correct conversion, re-prove
                 |
                 v
retire stale workflow and plan authority coherently
                 |
                 v
GitHub labels + linked Project + bounded active issues
                 |
                 v
commit -> push -> actual normal PR + do-not-merge
                 |
                 v
exact-head CI -> fresh complete PR review
                 | findings/comments
                 +------> address -> reply/resolve -> push -> full re-review
                 |
                 v
clean final exact-head COMMENT review + readback
                 |
                 v
remove do-not-merge and STOP before merge
```

## Stage 1: fail-safe preflight

The skill first runs only read-only discovery:

```powershell
git rev-parse --show-toplevel
git status --short
git branch --show-current
git worktree list --porcelain
git remote -v
git fetch --prune origin
git rev-list --left-right --count origin/main...HEAD
gh repo view --json nameWithOwner,owner,visibility,defaultBranchRef,url,hasIssuesEnabled
gh pr list --state open --json number,headRefName,headRefOid,baseRefName,url
```

It also probes, without changing configuration:

- PowerShell 7, Git, `gh`, .NET SDK, `az`, `azd`, Node, npm/npx, Python, SQL LocalDB, and Bicep availability;
- installed `azure-workflow` skill and MCP exposure;
- GitHub owner type, authentication scopes, Projects access, private-repository draft/ruleset capability, existing labels/forms/milestones/Projects; and
- the Microsoft Learn route needed for the scoped .NET support/host check.

The skill stops before edits when:

- any working-tree path is dirty;
- local and remote `main` differ;
- the selected branch already serves an unrelated PR or purpose;
- another linked worktree overlaps the selected mutation boundary;
- an authority source cannot be read; or
- the installed plugin cannot supply the required onboarding and review routes.

A missing optional tool blocks only the proof that needs it. It does not make unrelated inventory fail.

## Stage 2: branch, record, and live plan

From fetched `origin/main`, the skill creates exactly one branch:

```text
workflow/YYYYMMDD-onboard-azure-workflow
```

It creates one tracked record:

```text
docs/changes/YYYY-MM-DD-onboard-azure-workflow.md
```

The record begins with the baseline commit, branch, repository/owner, authority roots, scope exclusions, recovery route, and `active` status. The agent then calls the real `update_plan` tool. Markdown checkboxes do not substitute for the live plan.

The initial conversion is kept understandable through three logical commit groups:

1. canonical authority, product, roadmap, architecture, operations, decisions, and design;
2. GitHub templates and proportional verification; and
3. retirement of superseded workflow routes and old planning authority after parity.

Review remediation may add further narrow commits. The workflow does not force arbitrary squashing.

## Stage 3: complete, lossless inventory

The agent reads the real repository rather than trusting the current documentation map. It records the following ledgers in the one onboarding record, using grouped rows only where every source remains traceable:

| Ledger | CollisionSpike v2 evidence it must cover |
| --- | --- |
| Claim | Root instructions, questionnaire, operator notes, plans, ADRs, Azure docs, runbooks, evaluation reports, retrospectives, README, code/config/tests, and user-facing wording rules |
| Capability | All 213 IDs, labels, raw answers, allocations, owning plan links, permanent exclusions, conditional clauses, and proposed canonical destination |
| Legacy work | Plan folders, checkboxes, maturity/roadmap states, handoffs, completed evidence, open decisions, and anomalies such as giant future packs |
| Runtime and caller | Web and Worker entry points, Core policy owners, Infrastructure adapters, persistence/configuration, and real caller evidence |
| Rule/configuration | Every meaningful behavior/config owner, default/precedence, activation, caller, exposure, proof, and removal condition |
| Source role/hotspot | Live, generated, reference/test-only, compatibility, and retirement-candidate code, including large/churn/fan-out hotspots |
| Design source/runtime | Current Razor/CSS/assets, all supplied mockups, and approved logo/font/style sources recoverable from the pre-cleanup Git history without restoring the old plugin suite |
| GitHub taxonomy | Existing labels/forms/issues/PRs/milestones/Projects, usage counts, owner capabilities, proposed kinds/facets/fields, and affected-item counts |
| Verification | Every script/CI check, prerequisite, skip, false-green path, corpus boundary, and Docs/Full disposition |

Before and after conversion, the workflow hashes every tracked `docs/operator-notes/` file and requires the same relative path set and SHA-256 values. No ordinary onboarding edit, rename, normalization, or formatting is allowed there.

The inventory specifically tests the known stale boundaries instead of rediscovering them accidentally:

- `AGENTS.md`, `docs/README.md`, `docs/agent-guidance/agent-routing.md`, and `docs/agent-guidance/hooks.md` still route to deleted repository-local skills, agents, hooks, and task state;
- ADR-0007 and ADR-0008 describe superseded repository-local plugin designs;
- `scripts/Invoke-RepoCheck.ps1` and `scripts/validate_project_skills.py` still require deleted package paths; and
- current validation can report document success without proving that named workflow routes exist.

The agent does not restore those paths to turn checks green.

## Stage 4: bounded interview

The repository provides enough evidence for most conversion decisions. The agent asks only questions that change the durable result, one at a time.

### Question 1: version and release authority

The recommended starting proposal is:

- mode: `development`;
- maturity: `alpha`;
- current SemVer: `0.1.0-alpha.1`;
- release authority: the repository owner/user; and
- legacy `V0`, `V1`, `V1.x`, `V2`, `V3`, and `V3+` labels are not mechanically translated to SemVer.

The user confirms or replaces that proposal. Until confirmed, affected catalog rows remain `unallocated`; `Never` becomes `not-planned`, and unresolved conditional items remain `conditional`.

### Question 2: the one active product outcome

The agent presents a short evidence-backed choice from the existing implementation and roadmap and asks which single outcome is genuinely `Now`. The answer determines:

- one exact target release;
- the `Now` section and release gate;
- at most one parent Feature issue for that outcome; and
- the next change to plan after onboarding.

No answer means no product feature issue or release milestone is invented.

### Question 3: approved visual baseline

The agent presents the current runtime UI, the supplied UI directions/mockups, and the deduplicated historical logo/font/style asset set. The user identifies the approved baseline or explicitly labels all candidates reference-only.

The workflow preserves the working runtime either way. It does not choose a new shell, create a logo, invent colours, or restore a whole deleted plugin to recover a few legitimate source assets.

### Question 4: useful project-specific facets

After mapping the actual product areas, the agent proposes a small registry such as:

```text
area:accounts
area:intake-and-triage
area:casework
area:documents
area:communications
area:integrations
area:platform
area:ui-and-assistance
```

These are optional filter facets, not feature types or a second roadmap. The agent creates only the accepted, recurring categories and records each in `docs/operations.md`. It does not create one label per feature prefix.

Any additional material conflict receives `DOC-CON-NNN`, its affected scope is paused, the answer is incorporated into the canonical owner, and that scope is rescanned. The agent does not ask questions answerable from the repository.

## Stage 5: exact documentation conversion

The target authority spine is:

```text
AGENTS.md
README.md
docs/
|-- index.md
|-- product/
|   |-- index.md
|   |-- capabilities.md
|   `-- areas/
|       `-- <evidence-backed product areas>.md
|-- roadmap.md
|-- architecture.md
|-- operations.md
|-- decisions/
|   `-- NNNN-<decision>.md
|-- changes/
|   `-- YYYY-MM-DD-onboard-azure-workflow.md
|-- operator-notes/                 # byte-for-byte unchanged
`-- reference/                      # retained raw/history evidence only
design/
|-- README.md
|-- brand/
|-- foundations/
|-- tokens/
|-- assets/
|-- components/
|-- patterns/
`-- references/
```

Conversion rules for the current material are exact:

| Current source | Destination/disposition |
| --- | --- |
| Root `AGENTS.md` | Replace with the thin mandatory instruction/router contract; retain repository-specific Windows, authority, naming, UI wording, genuine-example, data/licensing assumption, development-mode, verification, and safety rules. |
| `docs/operator-notes/` | Keep at the same paths and bytes; route prominently from `AGENTS.md` and `docs/index.md`. |
| `PROJECT_DISCOVERY_QUESTIONNAIRE.md` | Move only after its settled clauses map to product authority; retain the raw source under `docs/reference/product-discovery/`. |
| `FEATURE_VERSIONING.md` and feature maturity map | Produce `docs/product/capabilities.md` with all stable identities and canonical product links; retain raw source as non-authoritative conversion evidence only when needed for auditability. |
| Detailed product behavior in `docs/plans/` | Move once into product-area contracts. |
| Release allocations and delivery roadmap | Convert to exact release or `unallocated` plus compact Now/Next/Later/Not planned outcomes. |
| Current implementation handoff and current architecture facts | Merge into `docs/architecture.md`; future implementation designs do not become current architecture. |
| Operational/Azure/runbook facts | Merge or route from `docs/operations.md`; retain a purpose-specific runbook only when a single operations file would become less usable. |
| Accepted technical ADRs | Preserve under `docs/decisions/` with links repaired. |
| ADR-0007 and ADR-0008 | Preserve as superseded history and link one new decision adopting the external single-plugin workflow. |
| Agent-routing, hook, plugin, marketplace, and task-state instructions | Replace with the six installed-plugin skill routes; remove stale repository-local routes after resolution proof. |
| Evaluation reports and retrospectives | Preserve as evidence/history, clearly non-authoritative for product intent. |
| Live work state and giant checklists | Do not copy into canonical docs; activate only the selected Now outcome in GitHub. |

There is no canonical `docs/plans/` after identifier, material-claim, and link/authority parity pass. If a clause or link is not yet accounted for, the relevant old source remains temporarily and the PR stays under review.

## Stage 6: UI and design conversion

CollisionSpike v2 receives the full [UI design-system spine](../standards/ui-design-system.md), but no new UI implementation.

The conversion must:

1. declare every visual surface and which authority governs it;
2. keep `src/CollisionSpike.Web/wwwroot/css/site.css` as the current runtime token source unless a confirmed existing source proves otherwise;
3. place approved canonical logo sources under `design/brand/logos/` and approved font sources under `design/assets/fonts/`, recovering only deduplicated user-approved assets from Git history when necessary;
4. map each source asset to its runtime/export consumer rather than copying all runtime assets;
5. move supplied mockups/concepts into `design/references/` with `approved`, `reference-only`, or `superseded` status;
6. map reusable Razor/CSS components and cross-component patterns through the design indexes; and
7. record colour, typography, spacing/layout, motion, and accessibility rules without inventing brand values or explanatory app copy.

No Storybook, theme engine, component-library rewrite, token generator, synthetic screenshot, logo, font, image, or user-facing Azure terminology is added merely to fill the folder.

## Stage 7: .NET and Microsoft Learn pass

The agent loads the shared .NET profile because the solution targets `net10.0`, the Web project uses the ASP.NET Core SDK, and the Worker uses the Azure Functions isolated worker packages.

It inventories the solution/project graph, SDK selection, package management, nullable/analyzer settings, configuration binding, Web/Worker host models, EF persistence/migrations, tests, publish/deploy routes, and Windows prerequisites. It calls Microsoft Learn only for current facts that can affect the conversion, specifically:

- .NET 10 support/lifecycle status;
- supported Azure Functions isolated-worker targeting/hosting for the detected stack; and
- any current Microsoft-host or tool behavior used in a recommended operations or CI command.

The result is compact evidence in the onboarding record and any relevant operations/architecture section. Onboarding does not upgrade packages, change target framework, replace the solution format, change test framework, or redesign the modular monolith.

## Stage 8: proportional verification

Retain `pwsh ./scripts/Invoke-RepoCheck.ps1` as the one human and CI entry point, but make it accept fail-safe `Auto`, `Docs`, and `Full` scope.

```text
changed paths
     |
     +-- only allowed Markdown/design-authority docs --> Docs
     |
     `-- code/config/scripts/workflows/IaC/assets/unknown --> Full
```

`Docs` runs only documentation structure, authority, relative links, change/ADR schemas, capability uniqueness/allocation/linking, design inventories, GitHub form/PR-template YAML, stale mandatory-route detection, and command probes that the changed documentation actually depends on.

`Full` additionally performs restore/build, Core/integration/architecture tests, applicable database prerequisites, Bicep compilation, and other demonstrated repository checks. Genuine corpus evaluation remains explicit through `-RequireCorpusEvidence`; onboarding never fabricates samples.

The conversion removes the deleted plugin/package/task-contract checks and retires `scripts/validate_project_skills.py` once no supported route needs it. It preserves valuable repository, architecture, genuine-input, caller, and feature-identity checks in proportionate form.

`.github/workflows/ci.yml` becomes one workflow/job whose reported name is `verify`. It always reports on pull requests and `main`, selects Docs or Full internally, and does not run Full application/toolchain checks for an ordinary Markdown-only change. Ambiguity selects Full.

Before old planning sources are retired, the conversion must prove:

- exactly 213 unique old IDs map to exactly 213 unique new IDs;
- each ID retains its exact label and trimmed raw answer in conversion evidence;
- each material clause has one canonical destination or an explicit retained-reference disposition;
- every old inbound link/authority route is replaced or intentionally historical;
- every mandatory skill/tool/check path resolves to a supported installed-plugin or repository owner;
- every operator-note path/hash is unchanged;
- every approved design source maps to one runtime/export destination or an explicit unused/reference state; and
- the canonical Docs and Full checks report their actual prerequisites, results, and limits.

## Stage 9: GitHub setup without a feature explosion

After presenting the zero/current counts and intended mutations, full onboarding establishes:

- repository labels `type:feature`, `type:bug`, `type:task`, and `type:decision`;
- conditional `do-not-merge` for the private personal-account review fallback;
- only the approved `area:*` facets;
- Feature, Bug, Task, and Decision issue forms plus `config.yml`;
- `.github/pull_request_template.md`;
- one linked personal Project named `collisionspike_v2 delivery`;
- Project fields `Status` (`Triage`, `Ready`, `In progress`, `In review`, `Done`), `Priority` (`P0 Critical` through `P3 Low`), and `Horizon` (`Now`, `Next`, `Later`); and
- one exact release milestone only after the user selects that release.

The default GitHub labels are preserved during this run unless a separate impact preview and approval authorizes rename/deletion.

The run creates at most:

1. one `type:task` issue for the onboarding conversion, linked to its change record and PR; and
2. one parent `type:feature` issue for the user-confirmed Now outcome.

A durable unresolved choice may receive one `type:decision` issue only when it outlives the current onboarding conversation. No issue is created for each of the 213 capabilities, each plan, each future phase, or each validation item.

The onboarding Task is placed at `In progress`, `P2 Normal`, `Now`, then moves to `In review` when the PR opens. The selected product outcome starts in `Triage` or `Ready` according to whether its decision-complete plan exists; onboarding does not pretend it is already being implemented.

Saved views, charts, additional Project workflows, auto-add rules, rulesets, and branch protection are reported truthfully as optional, UI-only, or unavailable on the current personal Free/private account. Their absence does not trigger an organization conversion or a custom automation token.

## Stage 10: actual pull-request review and remediation

The workflow publishes one normal pull request because the current personal/private route cannot rely on native draft state. It applies `do-not-merge` and links the onboarding Task.

A fresh `$review-repository-pull-request` context then reviews the actual remote PR, not merely the local diff. Its evidence includes:

- stable base and head object IDs plus the complete diff;
- original authority/capability sources and all conversion ledgers;
- operator-note hashes, 213-ID parity, removed/retained paths, and design mappings;
- raw Docs/Full checks and exact-head GitHub CI;
- every review, general comment, inline comment, thread, and current resolution state; and
- GitHub labels, Project fields/options/link, issues, milestone, templates, and known account limitations.

The reviewer checks product truth, current architecture/callers, rules/configuration ownership, .NET evidence, UI/design authority, documentation viability, security/safety boundaries, test value, CI routing, removals, and recovery. It publishes a GitHub `COMMENT` review naming the reviewed SHA. It does not impersonate a different human reviewer or call its own review an approval.

For every actionable PR finding, the delivery owner:

1. records the finding and intended response;
2. changes only the owning source;
3. runs focused and canonical proof;
4. replies with the concrete fix/evidence;
5. resolves a thread only when the current GitHub identity is allowed and the concern is actually addressed;
6. pushes the new head; and
7. requests a complete fresh PR review rather than reviewing only the patch since the last round.

Completion requires one clean review of the final exact head, green `verify` for that same SHA, no unresolved blocking thread or requested change, refreshed GitHub readback, and no tracked edit after the final attestation. The workflow then removes `do-not-merge`, leaves the Project item `In review`, and stops. It never merges or marks the issue/Project Done before merge.

## Expected state at the stop point

The user should see:

- one obvious documentation entry point and thin root instruction file;
- immutable operator notes still at identical paths and bytes;
- one stable 213-row capability index linked to readable product-area contracts;
- one compact Now/Next/Later/Not planned roadmap, not a giant task list;
- one active onboarding change record and at most one selected next Feature;
- current architecture and operations that describe reality rather than future plans;
- one root UI design authority containing approved style, logo, colour, typography/font, layout, motion, accessibility, token, component, pattern, and reference routes;
- no active repository-local workflow suite, hook, task-state engine, stale route, or workflow-suite validator;
- one path-aware local/CI verification command;
- four understandable issue forms, a PR template, a linked personal Project, and no 213-issue import;
- an actual PR with complete review/remediation history and a clean exact-head attestation; and
- no application feature change, Azure mutation, account conversion, branch protection claim, or merge.

The next obvious action is either `Review and merge the onboarding PR` or the exact named blocker with one human decision. After merge, the Project/Task may move to Done and the user can invoke `$plan-azure-repository-change` for the single selected Now outcome.

## Abort and recovery rules

- Dirty/diverged baseline: stop before branch creation; never stash, reset, clean, or force-push.
- Lost material claim/ID or broken route: retain the old source and keep `do-not-merge`.
- Unresolved product/release/design authority: pause only affected conversion and ask one question.
- Missing GitHub capability: keep repository files and record the exact live limitation; never fake installed setup.
- Failed check/review: remain `active` or `blocked`, remediate, and repeat complete proof.
- Azure write requested during onboarding: refuse/reroute to a separately approved `$operate-azure-repository` action.
- Recovery from removed tracked material: use Git history and the recorded baseline/rename map; do not maintain a parallel archive or restore the old plugin suite.

Every committed path, documentation link, configuration value, and command stored by onboarding is repository-relative. Runtime discovery may resolve an absolute path in memory, but no machine-specific absolute path is written into repository authority.
