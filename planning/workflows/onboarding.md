# Onboarding workflow

## Outcome

Convert a brownfield Git repository into the Azure Workflow standard and deliver the conversion as a green exact-head-reviewed PR without losing a material claim, capability identifier, or human authority.

## End-to-end flow

```text
Git root + clean tree + neutral branch/worktree baseline + instructions
          |
          v
create scoped branch + onboarding record + update_plan
          |
          v
inventory authority/docs/plans/features/work ledgers/runtime graph/rules/config/source roles/hotspots/tests/CI/IaC/GitHub/Azure
          |
          v
claim ledger + capability ledger + legacy-work ledger + existing-link graph
          |
          v
same-role material conflict? -- yes --> ask one decision -> incorporate/rescan
          |
          v
declare mode + version/maturity + release authority + verification command
          |
          v
write canonical docs/product/roadmap/architecture/operations/decisions
          |
          v
when Visual UI: present, write design/ authority + source/runtime map
          |
          v
write issue forms + PR template + path-aware CI
          |
          v
identifier parity + material-claim parity + link/authority parity
          | fail
          +----> keep legacy source and correct conversion
          |
          v
remove superseded duplicates -> full rescan/check -> commit/push actual PR
                                                       |
                                                       v
                                            CI + fresh actual-PR review
                                                       | findings
                                                       +--> remediate/push/re-review
                                                       |
                                                       v
                                      final exact-head attestation -> STOP
```

## Stage 1: preflight

Read-only probes include:

```powershell
git rev-parse --show-toplevel
git status --short
git branch --show-current
git worktree list --porcelain
git remote -v
gh repo view --json nameWithOwner,defaultBranchRef,url 2>$null
gh pr list --state open --json number,headRefName,headRefOid,baseRefName,url 2>$null
gh --version
```

- Resolve the actual Git root; do not assume the current folder.
- Any staged/modified/deleted/renamed/untracked path is dirty.
- Do not stash, reset, clean, switch over changes, or create a worktree.
- Resolve default branch from GitHub or `refs/remotes/origin/HEAD`; ask when unavailable/conflicting.
- A clean tree is not enough: if the current branch is non-default, already backs an open PR, or has an unrelated declared purpose, report it and obtain the intended clean baseline instead of repurposing or switching it.
- Resolve every linked worktree and treat each worktree root as a separate repository mutation boundary. A linked worktree nested below the selected root is inventoried and excluded from recursive reads/writes/checks unless explicitly selected as the onboarding target.
- Create `workflow/YYYYMMDD-onboard-azure-workflow` from fetched remote default branch. Resume only when its record unambiguously matches.
- Create the onboarding record and call the real `update_plan` tool before edits.

## Stage 2: complete inventory

When .NET project/solution evidence is present, load the shared `.NET` profile before completing this stage. Its requirements supplement the generic inventory and do not authorize modernization. Perform the scoped Microsoft Learn currency pass required by the MCP contract for detected framework/SDK and specialised Microsoft-host support; record the result without expanding onboarding into a generic best-practices rewrite.

Inventory:

- root/nested `AGENTS.md` and repository-local agent/plugin instructions;
- repository-local plugins, skills, agents, hooks, marketplaces, workflow/task-state directories, validators, and every inbound route to them, including paths already deleted in the working candidate but still required by present instructions/scripts;
- every relevant human-authored source/protected root—including existing PRD/FRD/SRS/URS/contract/notes material—with content role, approval/status evidence, canonical destination, and mutation rule recorded independently; unclassified notes remain preserved non-binding discovery input;
- README/docs/wiki exports/ADRs/RFCs/plans/roadmaps/feature lists/runbooks/generated docs and existing agent mistake/incident/lesson logs, including their source owner, generator, generated destinations, staging behavior, and source-to-view round-trip behavior;
- every stable capability/requirement ID, product clause, allocation, checkbox, dependency, and cross-link in large planning corpora;
- every local work ledger, ticket/status directory, plan membership/status/completion field, generated board/index, historical evidence link, and the count in each active/verification/backlog/completed state;
- application entry points, real callers, components/owners, interfaces, schemas, persistence, configuration, flags, and the entry-point-to-policy-owner call graph for behaviorally important flows;
- rule/configuration ownership and precedence, including declarations, readers, defaults, activation, persistence, UI/operational exposure, tests, and removal conditions;
- live, generated/materialized, reference/test-only, compatibility/replay, and retirement-candidate source roles, including generator/parity commands and bridge lifecycle metadata;
- implementation hotspots using file size, branch concentration, dependency/import fan-out, caller count, recent churn, and repeated modification by one feature area;
- every plausible canonical verification entry point, its prerequisites/skips/ratchets, and whether equivalent Windows and CI inputs produce equivalent verdicts;
- when .NET is detected, every solution/project/global SDK/build/package/analyzer/test/host/persistence artifact and the applicable variant inventory from the shared .NET profile;
- for visual UI repositories: existing style/brand guidance, imagery, logos and variants, colour values, typography/font files, spacing/layout/motion/accessibility rules, tokens/themes/CSS variables, component/pattern/example systems, supplied screenshots/mockups, and every design-source/runtime-asset root;
- build/test/lint/format/migration commands and actual value of existing tests;
- CI/release/deployment/IaC/environment/monitoring/recovery;
- GitHub issue forms/types/labels/milestones/Projects/rules/templates/open issues/PRs and discoverable owners;
- Azure service, identity, subscription/environment, and operational references; and
- evidence for mode, version/maturity, supported contracts, release authority, UI/test/naming policies, the supplied-material permission/licensing default, and any explicitly requested exception.

### Claim ledger

| Source/heading | Claim | Role | Status | Owner | Canonical destination | Action/evidence |
| --- | --- | --- | --- | --- | --- | --- |

Roles: product, roadmap, architecture, operation, decision, evidence, history.

### Capability ledger

| Existing ID | Name | Source clauses | Intended behavior destination | Existing allocation | New release/horizon | Disposition | Issue relationship |
| --- | --- | --- | --- | --- | --- | --- | --- |

Grouped rows are allowed only when they remain traceable; every unique material claim and ID must map.

### Legacy-work ledger

| Existing item/plan | Declared state | Evidence state | Durable capability/claim | GitHub disposition | Historical destination | Anomaly/decision |
| --- | --- | --- | --- | --- | --- | --- |

The declared state is evidence, not authority. Flag at least: an active plan whose members are all complete, an active plan with no members, an empty sequencing horizon, work simultaneously treated as active and historical, generated display text that differs from parsed source meaning, and a live-work count too large to provide a credible next action.

### Rule and configuration authority ledger

| Behavior/setting | Canonical owner | Real callers | Precedence/default | Activation/persistence | Proof/exposure | Lifecycle/removal |
| --- | --- | --- | --- | --- | --- | --- |

### Source-role and hotspot ledger

| Path/component | Role | Canonical source/generator | Callers/fan-out | Size/branches/churn | Bridge or retirement metadata | Disposition |
| --- | --- | --- | --- | --- | --- | --- |

These ledgers are proportional: a small straightforward repository may need only a few rows. A large or multi-stage rule system does not get a waiver because its top-level folders have logical names.

## Stage 3: authority and decisions

Apply the role-based authority contract. Distinguish intended behavior from observed implementation rather than forcing one to overwrite the other.

Apply the Microsoft Learn guidance gate before making a conversion recommendation that depends on current Microsoft support, version, tool, host, service, migration, or deployment behavior. Registration of the MCP is not evidence that it was consulted; record each material source/result explicitly.

Ask one question only when two active same-role sources conflict materially or mode/release/product authority cannot be determined. Record `DOC-CON-NNN`, consequence, recommended default, decision owner, answer, incorporation, and rescan.

Do not infer approval or protection from names such as `operator-notes/`, `PRD.md`, or `FRD.md`. For each unclassified human-authored source, preserve it, map material claims/IDs, and ask only when accepting or rejecting a claim changes intended behavior. Existing controlled requirement artifacts retain their IDs, approval history, and format until the owner approves consolidation and claim/identifier/link/history parity passes.

## Stage 4: canonical rewrite

Write in this order:

1. `docs/index.md` authority and routes.
2. `docs/product/index.md` as the living PRD role: purpose/problem, users/outcomes, success measures, scope, requirements/invariants, quality constraints, contracts, mode/version/maturity/release authority/policies, including `Visual UI: present | absent`.
3. `docs/product/capabilities.md` and functional-specification `areas/` only when the inventory warrants them; do not create a default `PRD.md`, `FRD.md`, or one area file per feature.
4. `docs/roadmap.md` with release gates and Now/Next/Later/Not planned outcomes.
5. When `Visual UI: present`, the exact root `design/` spine: brand style/imagery/logo inventory, colour/typography/layout/motion/accessibility foundations, one token-source route, icon/font inventories, component/pattern indexes, and approved-reference inventory.
6. `docs/architecture.md` from current executable reality, including runtime call paths, rule/configuration ownership, and live/generated/reference/compatibility source roles when the system is non-trivial.
7. `docs/operations.md` with verified Windows/PowerShell procedures, exact technology toolchains/platforms, and one canonical command whose skips/ratchets/prerequisites are explicit.
8. Required active/historical ADRs.
9. Append-only `docs/agent-mistakes.md`, preserving mapped existing evidence and creating no synthetic incident when none exists.
10. Root `AGENTS.md` and only justified nested deltas, including conditional design, concise supplied-material/licensing, mistake-log, and low-cognitive-load collaboration rules.
11. Human README with one obvious documentation/live-work route and no duplicate next-action/status file.
12. GitHub issue forms/PR template and canonical CI routing.

Templates are filled with repository facts. Existing compatible material is merged; it is never blindly overwritten.

Repository-local workflow suites are conversion sources, not automatic target architecture. Classify each element before changing it:

| Element purpose | Target disposition |
| --- | --- |
| Repository/product/operational knowledge | Canonical repository docs or conditional `design/` authority |
| Reusable planning/delivery/review/onboarding procedure | Installed plugin route |
| Deterministic check protecting a demonstrated repository risk | Retain behind the canonical check when proportionate |
| Generated adapter or duplicate procedure for another agent tool | Retire after every supported route maps successfully |
| Genuinely distinct specialist capability | Preserve only with a named trigger, owner, and acceptance boundary |

Remove stale skill/hook/task-state/marketplace paths, active ADR claims, validators, and inbound documentation routes only as one coherent mapped change. A partially removed suite fails onboarding preflight rather than being silently restored or treated as complete. No generator or helper may stage files; the owning workflow stages literal reviewed paths.

For a visual UI, preserve the existing working runtime and token system by default. Each design rule/source asset is moved or linked to one canonical owner and mapped to its runtime consumer/export. Do not create a palette, logo, font, screenshot, token values, Storybook, component library, theme engine, or CSS architecture during conversion merely to fill the structure. Superseded visual/design copies remain until their links, runtime callers, generated outputs, and recovery are proved.

## Stage 5: large feature and plan conversion

For each clause/row:

```text
intended product behavior? ---> product area + capability index
release outcome/allocation? --> roadmap + exact version/unallocated
active work? ----------------> existing/new parent issue only when activated
implementation design? ------> active change record only when work is planned
durable reason? -------------> ADR
historical evidence? --------> retain as reference or Git history
duplicate/process noise? ----> remove after parity
```

Do not create hundreds of issues or detailed future plans. Preserve IDs and behavior once; use parent issues and just-in-time sub-issues for Now work.

For an existing local ticket/plan/status system:

1. map stable product IDs and material intended behavior to product/capability authority;
2. map release allocation to the roadmap without copying live status;
3. retain completed evidence/history through change records, PR/Git history, or a labelled reference destination;
4. separate verification debt from unimplemented work;
5. surface contradictions such as `active` plus 100% complete, active zero-member plans, zero Next with an overloaded Now, and generated index/source disagreement;
6. ask the human to confirm the small set of outcomes that is genuinely active now; and
7. create/update GitHub items only for that confirmed set under the normal issue-required matrix.

The workflow never mechanically maps legacy `Now`, `active`, `verify`, or checkbox values to new GitHub state. It proposes a disposition with counts and traceability, and bulk mutations require their normal separate approval.

Retire old planning authority only after:

1. identifier parity;
2. material-claim parity; and
3. link/authority parity.

If any fails, keep the legacy source, record the gap, and retain native draft or `do-not-merge`.

## Stage 6: GitHub work system

Repository PR includes:

```text
.github/ISSUE_TEMPLATE/feature.yml
.github/ISSUE_TEMPLATE/bug.yml
.github/ISSUE_TEMPLATE/task.yml
.github/ISSUE_TEMPLATE/decision.yml
.github/ISSUE_TEMPLATE/config.yml
.github/pull_request_template.md
```

Forms are Feature, Bug, Task, and Decision. A personal-account repository uses `type:feature`, `type:bug`, `type:task`, and `type:decision` labels. A compatible organization repository may use native Feature/Bug/Task types, with Decision represented by an existing compatible native Decision or Task + `decision`. Every active workflow-owned issue has exactly one semantic kind.

Before changing taxonomy, build a ledger of existing forms, labels, descriptions, usage counts, issue mappings, Project fields, milestones, and canonical product/technical areas. Preserve useful project-specific categories as registered orthogonal facets. Create a custom form only when its intake questions are materially different from the four bases; it still maps to one base kind and static registered labels. Do not create one form per area/capability.

Blank issues are disabled for ordinary contributors unless authority records why, but maintainers can still open them. Private-repository form `required` fields and form Project auto-add are not treated as enforcement. The workflow validates issue content and explicitly reconciles Project membership whenever it owns an issue.

Creating missing canonical labels and correcting their descriptions/colors is part of full onboarding. Before renaming/deleting an in-use label, removing a form, or bulk relabelling, present the exact mapping and affected issue/PR counts and obtain explicit approval.

External setup is separate:

1. Probe repository owner type, visibility/account capabilities, `gh` commands, Projects scope/permissions, and the exact GraphQL mutations to be used.
2. Present repository/owner type, selected label/native-type route, taxonomy ledger, proposed registered facets/custom forms, any destructive or bulk migration counts, existing Project/copy choices, exact core fields/options, milestones, unsupported UI-only surfaces, ruleset availability, and any organization-wide consequence.
3. Under an explicit full onboarding request, reuse a compatible Project, copy a user-approved compatible Project, or create one portable repository-linked Project idempotently. Ask separately before replacing an existing Project or changing organization types/rules.
4. Preserve IDs and existing values when updating Project single-select fields; use explicit limits/GraphQL pagination for discovery.
5. Verify the portable core by reading back owner/link/fields/options and default workflow state.
6. Treat saved-view configuration, extra built-in workflows, auto-add, and charts as optional template/human enhancements. If repository authority makes one mandatory, emit an exact setup card and report partial until confirmed.

Do not add a Project-sync Action by default: repository `GITHUB_TOKEN` cannot access Projects. Any GitHub App/PAT automation is a separate credential and workflow decision.

No bulk issue import occurs by default. Only activated Now outcomes receive parent issues.

## Stage 7: verification and retirement

- Prefer existing native verification; add one thin wrapper only when needed.
- CI always reports `verify`; Markdown-only runs Docs, executable/ambiguous runs Full.
- For every supported local/CI platform, run or fixture-test equivalent canonical inputs. A clean exact commit that is green remotely but fails the declared local check is an onboarding finding until the difference is explained, normalized, or explicitly supported as a tested platform branch.
- Validate required paths/headings/links, capability uniqueness/allocation/linking, roadmap vocabulary, issue-form YAML/types, exactly-one-kind/category registry rules, PR template, ADR/record schemas, mistake-log title/template/entry IDs/fields/append history, the supplied-material/licensing and non-synthetic policies, and that every mandatory workflow/skill/hook route resolves to the new supported owner. For source-backed generated human views, compare source text, parsed semantic value, and generated/rendered value, including YAML-special-character cases. When `Visual UI: present`, also validate the complete design spine, surface applicability, the repository's one declared token-source route, relative source/runtime mappings, and absence of placeholder/synthetic assets.
- Treat those checks as structural proof only. The conversion PR review must independently compare canonical product/design/current-system claims with real code, configuration, callers, and procedures; unresolved semantic documentation drift blocks completion.
- Validate that material rules/settings have one named authority, generated/materialized paths trace to one source, reference/test-only modules are not presented as live owners, and every released bridge has complete lifecycle metadata. For .NET, validate the detected project variant without forcing a target/framework/solution/package/test-platform migration.
- Reject self-referential fixed-point ledgers and generated inventories unless each output protects a named risk, has one source owner, is lossless/reproducible, and remains proportionate to its consumer.
- Run the repository's proportional native checks.
- After triple parity, remove superseded sources with literal paths and rescan all links/authorities/search references.
- Record removed paths, recovery through Git history, and any intentionally retained non-authoritative reference.

## Stage 8: actual PR, independent review, and completion

1. Commit the checked conversion narrowly, push, and create/update the actual PR. Use native draft when supported or normal PR + `do-not-merge` on the personal Free/private route.
2. Wait for required CI on the exact head and collect the complete PR evidence snapshot.
3. Invoke `$review-repository-pull-request` in a fresh context. The reviewer receives the actual PR, original sources, claim/capability/taxonomy/rule-configuration/source-role-hotspot ledgers, the design-source/runtime ledger when applicable, the .NET profile result when applicable, affected GitHub-item counts, conflicts/answers, resulting canonical tree, removed-path diff, parity reports, GitHub setup plan/result, checks, reviews/comments/threads, and raw local checks. It independently spot-checks old-to-new claims/IDs/design assets, runtime owners, taxonomy mappings, and every removal.
4. Remediate blockers/required findings, re-prove, append/link any qualifying agent mistake made or discovered during the authorized conversion, update the record, push, and repeat the complete PR review for the new head. Ordinary review findings are not automatically mistake incidents.
5. After a clean candidate, commit the final `ready` record update, wait for CI, and obtain a final clean exact-head review. Make no later tracked change.
6. Publish the exact review result as a labelled `COMMENT` review, refresh head/checks/feedback, transition native draft to ready or remove `do-not-merge`, read back, and stop. Do not merge. State one next human action or the exact waiting condition.

## Failure behavior

- No Git/repository authority: stop with exact missing prerequisite.
- Inaccessible source or external wiki: record the gap; do not claim lossless conversion.
- Dirty tree: stop without cleanup/stash/worktree.
- Current branch already belongs to another open PR or purpose: stop before branch creation and request/identify the intended clean default-branch baseline; do not mingle conversions.
- Nested or separate linked worktree: report and exclude it; do not recurse into or mutate another worktree as part of the selected target.
- Conflict unanswered: block affected section only and preserve both sources.
- Overloaded or contradictory legacy work ledger: preserve it, publish the proposed mapping/counts, and ask which small outcome set is genuinely active; do not bulk-create issues or invent status.
- Parity or link failure: retain legacy source and keep native draft or `do-not-merge`.
- Ambiguous visual authority, token owner, or asset mapping: retain the existing design/runtime source, record the conflict, and do not create or delete a competing copy.
- Partially removed workflow/plugin suite: stop on the dirty tree; after a human-owned clean checkpoint, convert all policy/checks/routes coherently and fail if an old mandatory route or validator survives without its target.
- GitHub feature/API unavailable: retain file-based templates, record the exact core or enhancement limitation/upgrade path, and do not claim unsupported Project setup. A verified portable core may complete even when an optional UI-only enhancement is absent.
- No remote: deliver a verified local conversion and report that PR/CI gates remain unavailable.
