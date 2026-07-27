# Change: Bootstrap Azure Workflow plugin

```yaml
id: 2026-07-26-bootstrap-azure-workflow
type: onboarding
status: ready
risk: high
created: 2026-07-26
updated: 2026-07-26
issue: https://github.com/collisionengineers/azure-workflow/issues/1
pull_request: https://github.com/collisionengineers/azure-workflow/pull/2
baseline: 3be34e8e586178945dd2cbf330b9c6ecfb79f5fa
target_release: 0.1.0-alpha.1
roadmap_horizon: Now
mode: development
supersedes: none
superseded_by: none
```

## Summary

Implement the approved Azure Workflow design as one installable Codex plugin, convert this repository to its own durable standard, validate/install it, retire bootstrap-only planning/reference inputs after parity, and deliver it through an independently reviewed pull request without merging.

## Scope

### Included

- Six focused skills and their direct references/assets.
- Exactly Azure MCP and Microsoft Learn MCP.
- Deterministic record, repository, package, and PR-evidence PowerShell helpers.
- Canonical repository documentation, GitHub issue/PR templates, path-aware CI, fixtures, and tests.
- Private personal-account GitHub repository/Project bootstrap and exact-head review evidence where supported.
- Preservation of the user's local `.obsidian/workspace.json` state while removing workspace metadata from tracked product scope.

### Excluded

- Merge, stable release, non-Azure workflow ownership, hooks/apps, automatic Azure mutation, background state, or a deployed Azure service.
- Case-study product rules/assets and vendored upstream documentation.
- Repair of unrelated workstation Azure CLI state unless separately authorized.

## Authorities, current state, and constraints

- Authorities: the approved planning checkpoint at `3be34e8` and current user request to implement; material decisions are now mapped into canonical docs/package/tests.
- Current implementation: package, skills, references, assets, helpers, canonical documentation, GitHub intake/CI, and source retirement are complete on `workflow/20260726-bootstrap-azure-workflow`; final exact-head review remains.
- Constraints: Windows/PowerShell 7; preserve unrelated `.obsidian/workspace.json`; private personal GitHub account; stop before merge; live Azure validation depends on working local credentials.
- Conflicts: none unresolved.

## Acceptance criteria

- Package manifest/MCP/marketplace and all six skills validate with official creators and repository checks.
- Skills route standalone goals correctly, enforce compact/standard/high boundaries, and satisfy fresh representative tests.
- Helpers are deterministic, contained, portable, non-staging, and covered by fixtures.
- Repository docs/GitHub/CI meet the onboarding standard with no planning/reference runtime dependency.
- Plugin installs from the local marketplace; both MCP registrations start/discover as far as workstation prerequisites allow.
- Actual bootstrap PR has green required CI and a clean independent review for its exact final head; it remains unmerged.

## Plan

1. Freeze/commit planning and create the private repository/implementation branch.
2. Scaffold via plugin-creator and skill-creator; implement six skill entry points, shared/skill references, and neutral assets.
3. Implement deterministic PowerShell helpers and canonical repository docs/GitHub/CI/tests.
4. Validate package/skills/scripts/fixtures/routing and forward-test skills in fresh contexts.
5. Install through the explicit local marketplace and smoke-test MCP routes.
6. Prove material-decision/link/test parity, retire bootstrap-only inputs while preserving local workspace files, and rerun Full checks.
7. Create/update GitHub issue/Project/PR, monitor CI, independently review/remediate the actual PR, publish exact-head evidence, and stop.

## Data, failure, and recovery

- Data/schema: no product/customer schema. Repository-provided planning/reference material is development input and remains recoverable in Git history.
- Failure behavior: any schema/script/fixture/install/CI/review failure keeps status active and the PR under review; incomplete Azure evidence is reported precisely.
- Recovery/rollback: revert scoped implementation commits or reinstall the previous plugin cache; never rewrite main/history or delete the unmerged branch.

## UI/UX contract

Not applicable — this repository packages workflows and has `Visual UI: absent`. Conditional UI standards/templates are included for onboarded visual applications and contain no fabricated brand assets or values.

## Azure impact

The plugin registers a local Azure MCP process but deploys/mutates no Azure resource. Acceptance attempts a read-only scoped probe only. Any future mutation requires the operate skill's exact apply card and explicit approval.

## Decisions and conflicts

- One Azure-oriented plugin, six goal-based skills, two MCPs, no hooks/apps.
- Package server IDs are `azure-workflow-azure` and `azure-workflow-microsoft-learn` so existing global MCP registrations cannot silently shadow the pinned plugin definitions.
- Compact delivery has no issue/record by default and promotes on any material effect.
- Shared plugin-root references own risk, version/release, and conditional .NET routing.
- Repository documentation uses a living product index rather than default PRD/FRD/operator-notes conventions.
- Planning/reference/workspace inputs retire after parity and remain in Git history.
- No unresolved material decision.

## Implementation

- Status: complete and ready for final exact-head review.
- Deviations: the two MCP server IDs were namespaced after installation proved that a pre-existing global `azure` registration could shadow the plugin's pinned definition. The services and two-server boundary did not change.
- Recovery actions: removed the invalid prior `collisionspike-v2` marketplace registration that prevented every Codex plugin list/install command; no repository or plugin files at that source path were removed.
- Review remediation: rejected change-record reparse traversal and used atomic creation; made invalid comparison refs fall back safely; enforced exact canonical casing, one policy-consistent repository mode, and parsed issue-form schemas; required explicit PR identity and stable-ID evidence deduplication; added caller-level regression cases; corrected the documented reinstall sequence; and reconciled all six existing review threads.

## Source retirement parity

The bootstrap commit tracks 1,043 files that are not part of the released runtime/documentation surface: 56 under `planning/`, 979 under `ref-files/`, three under `.codex/`, four under `.obsidian/`, and root `hooks.json`. They remain recoverable at baseline `3be34e8e586178945dd2cbf330b9c6ecfb79f5fa`. Local editor state is preserved when its tracked copy retires.

| Bootstrap source | Count | Material outcome | Canonical destination or explicit disposition |
| --- | ---: | --- | --- |
| `planning/` root | 4 | approved architecture, package tree, decision log, reading map | `README.md`, `docs/product/`, `docs/architecture.md`, ADR 0001, this record, package tree validators |
| `planning/delivery/` | 3 | build order, acceptance, installation/GitHub endpoint | `docs/roadmap.md`, `docs/operations.md`, `scripts/Invoke-RepoCheck.ps1`, `.github/workflows/verify.yml`, tests, this record |
| `planning/interfaces/` | 5 | manifest, two MCPs, no hooks, GitHub surface, helper contracts | plugin manifest, `.mcp.json`, marketplace manifest, four package scripts, `.github/`, `docs/operations.md` |
| `planning/research/` | 18 | evidence and rationale for GitHub, docs, .NET, UI, portability, permissions, mistakes, cognition, and the final design | applicable decisions in `AGENTS.md`, product/architecture/operations/ADR docs, shared and skill references; named case-study facts intentionally excluded from the reusable package |
| `planning/skills/` | 6 | six public user outcomes and boundaries | exactly six packaged skill entry points plus direct references/assets and routing metadata |
| `planning/standards/` | 11 | repository, authority, record, policy, mode, UI, .NET, documentation, version, mistake, and skill rules | root `AGENTS.md`; canonical docs; onboarding assets/references; shared risk, release, and .NET references; validators |
| `planning/workflows/` | 9 | onboarding, catalog conversion, planning, UI, delivery, explanation, review, Azure, and testing sequences | owning skill procedures/references, deterministic helpers, path-aware check, fixtures, and scenario tests |
| `ref-files/skills/` | 862 | upstream examples and skill-authoring evidence | not vendored; the six goal-focused skills follow current creator guidance and package only directly needed material |
| `ref-files/plugins/` | 77 | upstream plugin examples and packaging evidence | not vendored; official creator output, manifest/MCP declarations, and local marketplace are the maintained implementation |
| `ref-files/repoplugin/` | 39 | earlier workflow attempt and failure evidence | replaced by one plugin, six bounded skills, no hidden state/hooks, and the explicit anti-pattern rules in `AGENTS.md` and ADR 0001 |
| `ref-files/hooks/` and root `hooks.json` | 2 | hook examples and old registration | deliberately absent in `0.1.0-alpha.1`; manifest/tree tests enforce no hooks |
| `.codex/` | 3 | workstation-local prior install/config state | untracked and ignored; package marketplace/MCP files are the portable source |
| `.obsidian/` | 4 | workstation-local editor state | untracked and ignored; no product claim, identifier, or runtime route depends on it |

Parity conditions before retirement:

- Capability identity is preserved by `AW-CAP-001` through `AW-CAP-006`, each mapped to one public skill and release in `docs/product/capabilities.md`.
- Active work is represented once by issue 1, personal Project 2, milestone 1, and this change record; the large source catalogs are not converted into issue noise.
- GitHub taxonomy is represented by four `type:*` labels, four issue forms, the PR template, milestone, Project fields, and the exact manual Status-card limitation in `docs/operations.md`.
- UI material is explicitly not applicable to this non-visual repository; the onboarding asset contains the complete conditional `design/` structure without fabricated logos, colours, fonts, or imagery.
- Runtime routes are the manifest, six skills, two MCP declarations, four helpers, root check, CI, and tests. None reads `planning/`, `ref-files/`, `.codex/`, `.obsidian/`, or root `hooks.json`.
- Removal occurs only after Full validation, creator validators, fresh forward tests, JSON/YAML/link/path checks, and a tracked-file dependency scan pass. Git history is the recovery path.

## Verification

| Check | Scope | Expected | Observed |
| --- | --- | --- | --- |
| planning checkpoint validation | Docs | links/fences/diff valid | passed before `3be34e8`; no broken relative links or unbalanced fences |
| plugin/skill creator scaffolds | Full | valid initial package shape | passed; scaffolders created plugin and six skills |
| canonical Full check | Full | all package/docs/scripts/fixtures valid | passed: repository/package/tests plus official plugin and six skill validators |
| installed plugin/MCP smoke | Full | reviewed plugin discovered; two MCP routes tested | passed again after remediation in fresh read-only Codex processes: installed `0.1.0-alpha.1+codex.20260727001208`; `azure-workflow-microsoft-learn` called official documentation search; `azure-workflow-azure` called read-only `subscription_list` successfully |
| bootstrap-source retirement | Full | 1,043 inputs untracked/removed after parity; local editor files preserved | passed: no retired path remains tracked, dependency scan is clean, Full validation passes, and the local `.obsidian/workspace.json` hash was unchanged by untracking |
| candidate PR remediation | Full | all findings fixed, green CI, stable complete evidence, zero unresolved threads | passed at `a2b696ae76a3c59df45c687d56819352986609fd`; CI `verify` succeeded; evidence fingerprint `4c646f8c8599a28b31d308edef7f67ab2d11c69764baaa2d75d343541bf2553b`; 1,164 files, five commits, six resolved/zero unresolved threads |
| final PR CI/review | Full | green and clean exact final head | pending after this required record commit |

## Independent review

- Plan review: completed through the sequential audits recorded in the planning checkpoint.
- Candidate PR review: `changes-required` at `3cb10d39ba664527ea2d2bcda89640d9d163b930`; it found reparse escape, invalid-ref fallback, repository-standard enforcement, evidence identity/deduplication, and stale live-review reconciliation defects. The existing GitHub review also contained six unresolved threads, including the already-fixed optional file-property defect.
- Final exact-head review: pending.
- Remediation rounds: one. Commit `a2b696ae76a3c59df45c687d56819352986609fd` fixed all candidate and live-thread findings; focused/Full checks and exact-head CI passed; each thread received an evidence reply, was read back, and was resolved. This record commit deliberately invalidates that candidate verdict and creates the head for one fresh whole-PR review.

## Documentation and work tracking

- Documentation impact declared before implementation: root instructions/README; product/capability/roadmap; architecture; operations; ADR; bootstrap record; package skill/reference/assets; GitHub templates/CI; tests.
- Agent mistake entries: none; the defects were found by the intended pre-completion review gate and did not escape a required gate or produce false completion.
- Product/capabilities: `docs/product/index.md`, `docs/product/capabilities.md`.
- Design system/assets: not applicable — visual UI absent; neutral conditional onboarding templates only.
- Roadmap/release: `docs/roadmap.md`, manifest `0.1.0-alpha.1`.
- Architecture/ADR: `docs/architecture.md`, `docs/decisions/0001-single-plugin-six-skill-architecture.md`.
- Operations: `docs/operations.md`.
- GitHub issue/Project/milestone: [issue 1](https://github.com/collisionengineers/azure-workflow/issues/1), [personal Project 2](https://github.com/users/collisionengineers/projects/2), and [milestone 1](https://github.com/collisionengineers/azure-workflow/milestone/1). Portable fields/item values were read back; the built-in Status option edit remains the exact manual setup card in `docs/operations.md` because GitHub rejected deleting the built-in field and the CLI has no option-edit command.

## Outcome

Implementation, documentation conversion, source retirement, validation, installation, MCP read acceptance, candidate review remediation, CI, and feedback reconciliation are complete. The open unmerged PR is ready for one fresh final whole-PR review of the exact record-bearing head; no tracked edit may follow a clean verdict.

## Blocker or follow-ups

- Blocker: none for repository/package implementation or MCP read acceptance.
- Follow-ups: beta cross-repository evidence is allocated on the roadmap and is not part of this alpha bootstrap.
