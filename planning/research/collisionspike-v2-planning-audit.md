# CollisionSpike v2 repository and planning audit

Audit date: 2026-07-26

Repository inspected read-only: sibling checkout `../collisionspike_v2` and [private GitHub repository](https://github.com/collisionengineers/collisionspike_v2).

No CollisionSpike file, Git state, GitHub state, corpus item, or Azure resource was changed.

## Executive judgement

CollisionSpike v2 has a good application foundation inside a bad repository-workflow shell.

The .NET solution is already the kind of implementation the new plugin should preserve: a small modular monolith, clear Core/Infrastructure/Web/Worker boundaries, Bicep, meaningful core/integration/architecture tests, genuine-input separation, strong operator-note authority, and explicit distinction between plans and caller evidence.

The repository-management layer is the problem. The accepted cleanup commit removes the failed multi-plugin implementation, but the remaining instructions, documentation, validators, and CI still require it. Planning truth is carefully written but spread across permanent plan packs, a 213-row worksheet/map pair, a questionnaire, maturity/version buckets, roadmaps, handoffs, UI packs, and future implementation designs. GitHub has almost no usable work-management structure.

The new plugin addresses these failures if onboarding is lossless and starts from the accepted cleanup checkpoint without restoring the removed suite.

## Live baseline

The original audit inspected the old committed head and the then-uncommitted cleanup separately. The user has now committed that cleanup. The current readback is:

- clean local branch `main`;
- accepted local head `19a5231e6e899369683cad6da498f731894cf9eb`, `plugin/workflow removal`;
- private personal-account repository with issues and Projects enabled; and
- remote `origin/main` one commit behind the accepted local head at the time of readback.

The accepted commit contains the previously audited cleanup:

| State | Count | Main scope |
| --- | ---: | --- |
| Deleted | 983 | `.agents/` 1, `.codex/` 878, `plugins/` 77, `repoplugin/` 27 |
| Baseline additions | 2 | `package.json`, `package-lock.json` for pinned Azurite `3.36.0` |
| Baseline modification | 1 | `.obsidian/app.json` |

The cleanup choice is settled and the local tree is clean. The only remaining sequencing requirement is to push this accepted baseline before branching, so the cleanup does not appear in the onboarding pull request. The detailed procedure is the [first onboarding run](collisionspike-v2-first-onboarding-run.md).

## What is already strong and should survive

### Application structure

- `CollisionSpike.slnx` contains Core, Infrastructure, Web, and Worker projects plus core, integration, and architecture test projects.
- Business policy has a named Core owner and real Web caller; Worker is honestly described as not yet having a business caller.
- Infrastructure adapters, EF persistence/migrations, development SQLite guard, SQL integration route, and Bicep are explicit rather than hidden behind speculative services.
- The architecture is a restrained modular monolith rather than a premature microservice platform.

### Authority and evidence

- `docs/operator-notes/` is clearly identified as immutable human business authority.
- `docs/agent-guidance/source-of-truth.md` correctly separates direct instruction, operator truth, settled product decisions, ADRs, executable evidence, retrospectives, and references.
- `corpus/` is ignored, local, immutable, and separated from generated `artifacts/`.
- Documentation distinguishes planned, implemented, called, locally verified, deployed, live verified, and accepted.
- The feature worksheet/map validation proves 213 exact unique ID/label/answer triples.

### Useful product material

- Stable feature IDs and explicit Never/Conditional boundaries are valuable.
- Product and UI plans contain detailed actors, states, failure behavior, permissions, evidence, and deferred-scope boundaries.
- The UI direction work honestly labels all three shell candidates unapproved.
- Azure inventory/replacement material and accepted ADRs provide a strong conversion source.

Onboarding must preserve these facts and identities. It must not “simplify” by deleting the corpus of truth or creating 213 GitHub issues.

## Structural findings

### 1. The removed workflow suite still owns the repository

The parent of the accepted cleanup commit contained:

- eight `repoplugin-*` workflow packages plus one vendored `microsoft-docs` package;
- 9 plugin manifests;
- 28 `SKILL.md` files across `plugins/` and `repoplugin/` alone;
- 878 tracked `.codex/` paths, including copied Azure/Microsoft skills and custom agents/hooks; and
- task-state, marketplace, routing, design-asset, and validation machinery.

The accepted cleanup commit deletes those package/source paths, but present files still route to them:

- root `AGENTS.md` names planning, implementation, review, documentation, UI, domain, and Azure skills that no longer exist physically;
- `docs/agent-guidance/agent-routing.md`, `hooks.md`, and `docs/README.md` point to removed skills, agents, hooks, marketplace, and `.repoplugin/tasks`;
- active ADR-0008 says the eight-package suite is the decision;
- `scripts/Invoke-RepoCheck.ps1`, `Test-Documentation.ps1`, and `validate_project_skills.py` require the deleted suite; and
- the canonical check ends by calling a deleted task-contract test script.

All eleven workflow paths directly required by the current check are absent at the accepted head. `Test-RepositoryStructure.ps1` still reports success, and the previously audited `Test-Documentation.ps1` run reported 127 Markdown files, 772 links, 213 feature triples, and 21 assertions passing, because those validators check route text/shape rather than whether the named skill/package actually exists. The full repository check cannot complete after the deletions. This is a false-green boundary the new plugin must test explicitly.

### 2. `AGENTS.md` is useful but overloaded and currently false

Root `AGENTS.md` is 102 lines and 5,770 bytes. With `docs/AGENTS.md`, the always-applicable instruction chain is 7,036 bytes.

It mixes:

- thin authority/safety rules worth retaining;
- detailed product lifecycle invariants that belong in canonical product authority;
- architecture rules that belong in architecture/ADR guidance;
- long workflow/tool routes that now point to deleted packages; and
- repository-specific plugin implementation detail.

The result is expensive context and stale mandatory behavior. The new generated `AGENTS.md` should retain only always-on routes, prohibitions, mode/environment, validation, and immutable boundaries; detailed business meaning remains in operator/product docs and workflow procedure remains in the installed plugin.

### 3. Planning is disciplined but permanently over-specified

The current `docs/plans/` corpus contains:

- 49 Markdown files;
- 5,385 lines;
- 301 Markdown checkboxes;
- 213 unique feature IDs; and
- 6 UI mockup PNGs in addition to the Markdown.

The allocation map reports:

| Allocation | Rows |
| --- | ---: |
| V0 pre-alpha | 10 |
| V1 alpha gate | 116 |
| V1.x before V2 | 1 |
| Pre-V1 gate | 2 |
| V2 beta | 29 |
| V3 release work | 9 |
| V3+ release work | 13 |
| Never | 30 |
| Conditional / Unclear | 3 |
| Total | 213 |

The size alone is not the failure. The same overall corpus owns or repeats:

- settled product behavior;
- raw direct answers;
- feature identity and release allocation;
- horizon ordering;
- current implementation gaps;
- detailed future architecture/implementation designs;
- open decisions and activation conditions;
- UI requirements, candidate directions, mockups, and traceability; and
- document-level readiness/status.

The plan index carefully describes these boundaries, but agents still have to traverse several large overlapping surfaces before knowing what to do next. `V1` is a 116-capability umbrella rather than a small actionable release outcome. Detailed plans for V2/V3/V3+ exist long before activation, making future assumptions costly to maintain.

### 4. Version, maturity, horizon, and status are conflated

There are no Git tags, GitHub releases, or milestones. The repository uses `V0`, `V1`, `V1.x`, `V2`, `V3`, and `V3+` simultaneously as product generations, release gates, and planning horizons, while also calling V0 pre-alpha, V1 alpha, V2 beta, and V3 release work.

The feature map's distinction between allocation and implementation evidence is good, but the allocation vocabulary is not an immutable version contract. The new workflow must preserve every raw answer, then require human release authority to map selected outcomes to exact SemVer releases or `unallocated`. It must not mechanically translate `V1` to `1.0.0`.

### 5. Visual UI authority and assets have no durable owner

CollisionSpike is a visual UI repository, but no root `design/` exists.

Current design facts are split between:

- 11 UI/UX planning Markdown files and six unapproved/historical raster concepts;
- runtime Razor and `wwwroot/css/site.css` tokens/components;
- a now-deleted `.codex/skills/collision-engineers-design/` source containing logos, many fonts, previews, and design guidance; and
- a now-deleted UI plugin containing another style reference, two logos, and four Futura files.

At least six logo/font files were stored twice as byte-identical Git blobs—12 tracked paths and about 1.1 MB across the duplicate copies. Runtime CSS also contains a palette/token set that is not mapped to the deleted internal-app token reference. Candidate shell direction remains explicitly unapproved.

The new `design/` standard directly addresses this:

- retain one approved logo/font source and inventory all other provided assets before any removal;
- make brand/style, colour, typography, layout, motion, accessibility, component, and pattern authority visible;
- declare one token source and map it to `site.css` or a later generated output;
- move supplied mockups to an approved/reference/superseded inventory; and
- keep shell selection as a human decision rather than treating current code or a raster as intent.

### 6. Validation is valuable but too coupled and too expensive

Current validation includes useful link, authority, feature-parity, structure, architecture, genuine-input, and caller-oriented checks. Those should be preserved where they still protect a real regression.

But the default `Invoke-RepoCheck.ps1` is 258 lines, the documentation validator is 1,151 lines, and every invocation requires or attempts:

- repository/documentation structure;
- .NET restore and Release build;
- all core, integration, and architecture tests;
- SQL LocalDB;
- Bicep compilation through Azure CLI;
- copied skill/plugin validation; and
- task-contract validation.

The GitHub workflow has no path classifier. The latest documentation-only planning commit triggered a roughly five-minute full Windows run. This directly conflicts with the desired rule that Markdown-only work should receive documentation checks rather than unrelated code/toolchain gates.

The plugin's stable `verify` check with internal Docs/Full selection fixes this without discarding the valuable full gate.

### 7. GitHub is enabled but not functioning as the work system

Live GitHub state on 2026-07-26:

- private personal-account repository, default branch `main`;
- issues enabled but zero issues;
- only the nine GitHub default labels;
- no issue forms, PR template, milestones, or CollisionSpike-linked Project found;
- one merged PR; and
- subsequent planning/plugin documentation committed directly to `main`.

The only accessible personal Project is an unrelated plugin-triage Project. It must not be reused for CollisionSpike.

PR 1 did receive Codex `COMMENT` reviews, but the final reviewed commit received a P2 finding and was later merged with no newer commit or final clean exact-head review. This is evidence that “review happened” is not the same as a review-complete PR gate.

Branch-protection readback returns GitHub's 403 requiring GitHub Pro or a public repository. That is an account capability, not repository failure. The plugin should retain the agreed personal-account fallback: PR discipline, stable `verify`, and exact-head review evidence without falsely claiming protection.

### 8. Local/editor/tooling state is mixed with repository authority

Tracked Obsidian configuration and plugin implementation produce working-copy churn; the only substantive current modified file is `.obsidian/app.json`. A local `.codex/config.toml`, ignored `node_modules/`, and untracked Azurite package files also exist.

These may be intentional tools, but they need an explicit owner:

- repository-required developer dependency: track the minimal manifest/lock and document the command;
- personal/editor state: ignore it; or
- repository documentation tool: retain only stable shared settings and keep generated/vendor state out.

The plugin should inventory this state but not decide or delete it automatically.

## Conversion map

```text
operator-notes/ ------------------------------> preserve byte-for-byte; top product authority
PROJECT_DISCOVERY_QUESTIONNAIRE + settled rules
                                              -> docs/product/index.md + areas/*.md
213-row feature worksheet/map ----------------> docs/product/capabilities.md with IDs/raw authority retained
V0/V1/V2/V3 allocations ----------------------> exact release or unallocated + Now/Next/Later/Not planned
delivery roadmap -----------------------------> compact docs/roadmap.md outcome/gate route
current implementation handoff ---------------> current docs/architecture.md + docs/operations.md facts
accepted technical ADRs ----------------------> active docs/decisions/ records
ADR-0007/0008 + stale hooks/routes -----------> one superseding workflow-conversion ADR + removal after proof
current selected deliverable -----------------> one docs/changes/YYYY-MM-DD-slug.md
future detailed plan packs -------------------> product contract, cheap roadmap entry, or reference/history
UI requirements/style/assets -----------------> root design/ + product UI behavior + reference inventory
live work/status -----------------------------> GitHub issues + Project + exact-release milestones
full monolithic check ------------------------> path-aware Docs/Full wrapper retaining valuable focused proof
```

## What the plugin fixes and what still needs a human

| Problem | Plugin coverage | Human decision still required |
| --- | --- | --- |
| Eight-package workflow and stale routes | Full: single external plugin, exact route rewrite, stale-path validation, superseding ADR | Cleanup checkpoint is approved; only genuinely repository-required local tooling needs classification |
| 213 capabilities and plan sprawl | Full lossless conversion with triple parity; no issue-per-row | Exact SemVer release allocation and any true product conflict |
| Unclear next work | Compact Now/Next/Later plus activated parent issue and one change record | Select the next outcome/release |
| UI assets/design drift | Full `design/` authority and source/runtime mapping | Select the shell direction and resolve any approved-asset ambiguity |
| Monolithic CI | Full path-aware Docs/Full routing | Decide whether any existing expensive gate remains mandatory for all executable changes |
| Empty GitHub work system | Forms, labels, portable Project core, milestones, PR/review lifecycle | Approve Project setup and any custom project facets |
| Personal private branch rules unavailable | Truthful fallback and readback | Upgrade or make public only if the user later wants enforced rules |
| Product/operator contradictions | Detect, isolate, interview one at a time | User/operator authority decides; plugin never invents the answer |
| Local baseline ahead of remote | Detect and stop before branching | User pushes the accepted cleanup commit so the onboarding PR remains isolated |

## Safe high-level sequence

The detailed executable sequence is now specified in [CollisionSpike v2 first onboarding run](collisionspike-v2-first-onboarding-run.md). Its prerequisite order is:

```text
clean accepted local main at 19a5231e
        |
        v
push accepted baseline to origin/main
        |
        v
clean branch based on an intentional committed state
        |
        v
plugin onboarding inventory + claim/capability/design/workflow ledgers
        |
        v
canonical conversion + parity + path-aware CI + GitHub files
        |
        v
actual conversion PR + CI + complete exact-head review
        |
        v
STOP before merge
```

Do not branch until local and remote `main` match, do not restore the deleted suite merely to make old validators pass, and do not make the accepted cleanup part of the onboarding pull request.

## Audit conclusion

CollisionSpike v2 is not structurally beyond repair and does not need another rewrite to solve these repository-management problems. Its application boundary is substantially better than its workflow layer. The new plugin addresses the observed failure modes if it proves the partially removed workflow suite, preserves all 213 identities/material clauses, creates a real design authority, and starts from the accepted cleanup rather than restoring it. The completed [development-base comparison](collisionspike-development-base-recommendation.md) recommends v2 for forward development.

The generic executable conversion procedure remains [large feature-catalog conversion](../workflows/feature-catalog-conversion.md); this audit is case-study evidence, not packaged plugin policy.
