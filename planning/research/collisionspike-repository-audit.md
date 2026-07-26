# CollisionSpike repository audit

Audit date: 2026-07-26

Scope: read-only examination of the original `collisionspike` repository as a brownfield onboarding case study. No target-repository files, branches, issues, pull requests, Projects, or Azure resources were changed.

This document records case-study evidence. It does not make the later choice between repositories, and no CollisionSpike-specific fact becomes a packaged plugin default.

## Corrected executive judgment

The earlier audit over-weighted the names of top-level folders, the volume of documentation, and the presence of operational checks. That was wrong. Those things demonstrate operational maturity and later containment work; they do not demonstrate a coherent or maintainable implementation.

The user’s description of the code as spaghetti-like is supported by the implementation evidence. Important behavior is spread across large orchestrators, several rule stages in two languages, JSON rule data, a large environment-gate object, direct environment reads outside that object, database-held settings, compatibility paths, retained Durable replay activities, status mappings, and deliberately materialized copies of Python engine code. Understanding whether one intake decision works requires reconstructing a distributed call graph and its historical exceptions.

The repository has strong evidence, deployment, and recovery practices because it is a real operational system. Some recent work has also centralized status evaluation and other decision points. Those are worthwhile safety improvements, but much of the governance and centralization arrived after intense implementation churn. They contain an accreted system; they do not make the original planning or internal architecture a model to copy.

The reusable lesson is:

> Brownfield onboarding must inspect the real runtime call graph, rule ownership, configuration ownership, compatibility paths, generated or materialized code, and change hotspots. A tidy folder tree or green CI cannot be treated as proof that the code is understandable.

## Inspected state

| Area | Observed state |
| --- | --- |
| Local branch | `fix/tkt-303-terminal-archive-retry-loop` at `1dace2d6`; clean and the exact head of open PR #165 |
| Linked worktrees | Three total, including two nested worktrees for other open pull requests |
| Tracked repository size | 4,127 files; GitHub reports roughly 733 MiB |
| Main language surfaces | 648 TypeScript, 85 TSX, 260 Python, and 107 SQL files |
| Intake orchestration | `services/orchestration/src/orchestrators/intakeOrchestrator.ts` is 867 lines, with 15 imports and more than 100 branch or catch lines |
| Central gate surface | `packages/domain/src/gates.ts` is 308 lines and exposes roughly 60 gate or configuration values |
| Rules engine | `engine.py` is 3,098 lines and is tracked in three identical code locations; `email_classifier.py` is 1,755 lines and is likewise triplicated |
| Other rule surfaces | A JSON triage rule set, Python classification and rules, TypeScript policy and unified-triage stages, an AI second-opinion stage, database code tables, orchestration special lanes, and UI/status mappings |
| Direct environment use | 127 distinct `process.env` names are read directly across 41 non-test source files, in addition to the central gate object; at least one mutable gate is database-backed |
| Historical coupling | 254 inspected source files contain ticket references, with 1,434 `TKT-` occurrences; code also contains many plan, ADR, parity, compatibility, and supersession annotations |
| Commit history | 950 commits, concentrated into roughly five weeks; the peak day contains 96 commits |
| Hotspot churn | The current intake orchestrator was touched by 37 commits and accumulated about 2,028 changed lines while remaining 867 lines; the Python engine was touched by 23 commits and accumulated about 3,814 changed lines |
| Verification | The source-size check passes by explicit ratchets for files over the nominal 800-line limit. The local Windows engine-materialization check fails on a clean exact head while GitHub’s Linux exact-head check reports green |
| Documentation/work state | 1,363 Markdown files under `docs/`; 298 local tickets and 15 local plans alongside GitHub pull-request state |
| Pull requests | Three open PRs (#165-#167); all contain unresolved review threads at the inspected snapshot |
| Releases/enforcement | Package version `0.0.0`; no SemVer releases or GitHub releases; no default-branch protection or ruleset |

## Representative runtime shape

This is a simplified map, not an exhaustive dependency graph:

```text
inbound item
    |
    v
867-line intake orchestrator
    |
    +--> special lanes: attachment/reply/PDF/retro/archive/readiness
    |
    +--> triageUnified.ts
    |       |
    |       +--> Stage A: JSON rules + Python email classifier
    |       |                 +--> 1,755-line classifier
    |       |                 `--> 3,098-line rules engine
    |       |
    |       +--> Stage B: TypeScript domain triage policy
    |       `--> Stage C: optional AI second opinion
    |
    +--> gates.ts + direct process.env reads + database-held setting
    |
    +--> data API / persistence / code tables
    |
    +--> status/readiness evaluator
    `--> retained legacy activities for replay or retro paths

same Python engine source
    +--> engine service copy
    +--> parser function materialization
    `--> OCR function materialization
```

The problem is not that every box is individually unjustified. The problem is that the current answer to “what controls this behavior?” is the graph, rather than one obvious rule authority with small adapters around it.

## What is genuinely strong

- The application is a real operational system, not a planning shell.
- Live-state claims and content-addressed evidence are more carefully distinguished from prose than in v2.
- Deployment, rollback, evidence, and ticket verification practices protect real operational risks.
- Some late centralization is real. For example, status/readiness evaluation now has a shared canonical module used through service and UI paths.
- The repository has executable checks for many fragile contracts, including materialized engine parity and agent-adapter parity.
- Human-owned working material is explicitly protected from agent authority.

These strengths are reasons to preserve product and operational truth. They are not reasons to preserve the implementation shape, every migration layer, or the surrounding governance machinery.

## Findings

### 1. Tidy top-level folders conceal an accreted implementation

The present monorepo has purpose-named roots, but critical files within those roots are very large and branch-heavy. The 867-line intake orchestrator coordinates classification, attachment and reply handling, PDF extraction, retrospective reconstruction, AI assistance, archive behavior, readiness, and retry behavior. The Python rules engine is more than 3,000 lines. Domain policy, retrospective case handling, UI controllers, and views also contain many 400-800-line hotspots.

The nominal 800-line source budget does not currently force these hotspots to be simplified: known oversized files have ratchets. A passing size check therefore means “no worse than the accepted exception,” not “the code is within the intended maintainability boundary.”

Plugin consequence: onboarding must produce a hotspot report using file size, branch concentration, import fan-out, caller count, and change churn. Folder naming alone is never an architecture verdict.

### 2. Rule and configuration ownership are fragmented

A representative intake outcome can be affected by JSON rules, Python regex and classification logic, TypeScript policy, an optional AI stage, central gates, direct environment access, a database setting, persistence/code tables, and orchestration-specific exceptions. The repository therefore does not offer one easily discoverable answer to:

- where a rule is declared;
- which stage has precedence;
- which callers exercise it;
- what turns it on;
- which test proves it; or
- which UI/status value exposes the result.

The central gate file improves naming but does not centralize configuration ownership. Direct reads of 127 distinct environment names remain spread across dozens of files, while a mutable operational gate has another data-backed route.

Plugin consequence: onboarding creates a **rule and configuration authority ledger** for behaviorally important decisions. Each row names the canonical declaration, precedence, readers, activation mechanism, persistence, tests, UI/operational exposure, and retirement rule. Planning a feature must update that ledger when it adds or changes a decision surface.

### 3. Materialization, compatibility, and historical-reference code blur what is live

The Python engine is intentionally copied into two Azure Function deployment trees as well as its source service. A parity/fingerprint check exists, so this is controlled materialization rather than accidental copy/paste. It still gives reviewers three apparent code locations and a generator/check contract they must understand.

The orchestration registry retains a superseded activity solely for in-flight Durable replay compatibility. A former classifier remains live for a retrospective path. The unified triage code reproduces legacy behavior to preserve gate-off parity. A `domain` package exports a large deduplication module labelled as a test-only reference contract and explicitly not the live resolver.

Each decision can be explained historically, but the combined effect makes “live, dead, reference, generated, or temporarily retained?” difficult to answer from location or export status.

Plugin consequence: onboarding classifies executable material as `live`, `generated/materialized`, `reference/test-only`, `compatibility/replay`, or `retirement candidate`. Development mode rejects compatibility and fallback paths. Released mode permits a bridge only with a supported contract, owner, activation scope, proof, removal trigger, and target removal version or date.

### 4. The implementation history shows planning-by-accretion and extreme churn

The repository contains 950 commits, with most work concentrated into a short period and as many as 96 commits in one day. Commit subjects include repeated waves of fixes, features, gates, parity/reconciliation work, review remediation, deployments, and later simplification. Only a small minority are explicitly described as refactors.

The intake orchestrator alone has about 2,028 lines of historical additions/deletions across 37 commits and remains very large. The current focused retry PR changes 21 files with more than 1,100 insertions, much of it evidence and governance material. Ticket, plan, ADR, date, and migration annotations are embedded throughout current code, forcing a maintainer to read project archaeology to infer current intent.

Plugin consequence: the workflow must plan the decision and ownership model before code, keep one change record per active outcome, and prevent speculative gates or fallback layers. Review includes a change-concentration check: if a feature repeatedly modifies the same orchestrator/rules hotspot or adds another decision stage, the plan must settle a smaller canonical boundary first.

### 5. Verification does not give one reproducible answer across environments

The exact PR head is green on GitHub. On the clean local Windows checkout, the repository’s engine-materialization checker reports fingerprint differences in both deployment copies. The local source-size check passes because of named oversize ratchets. The repository also has more than one broad verification entry point with different behavior when optional environments are absent.

This does not prove the GitHub run was false. It proves that a maintainer can follow plausible canonical checks on the same commit and receive materially different answers, with no immediate explanation of which result owns truth.

Plugin consequence: every repository declares one canonical verification command. Its supported platforms and prerequisites are explicit. Equivalent Windows and CI inputs must produce equivalent verdicts, or the platform difference is declared and tested. A skip, ratchet, or unavailable suite is reported as such and cannot be rendered simply as an unqualified pass.

### 6. Repository management became a second product after the code had already churned

The repository contains 298 ticket specifications, 296 change logs, 290 verification files, 142 operator notes, 15 plan IDs, 61 check scripts, multiple generated ledgers, and adapter copies for several agent tools. The workflow machinery is technically sophisticated but has a large learning and maintenance surface unrelated to understanding the product runtime.

The canonical `.agents/` material is replicated into `.claude/`, `.codex/`, and `.cursor/` as tracked files. A parity check reduces drift, but it does not remove the cost of understanding the adapter system. Some instructions call the copies “symlinked views” even though they are ordinary files.

This supports the user’s chronology: governance and containment grew later around an already fast-changing implementation. The governance did not prevent the original architectural churn.

Plugin consequence: retain repository-specific product/operational truth and deterministic high-value checks; move reusable procedure into the installed plugin; remove duplicated adapters and local workflow state only after route and claim parity is proven.

### 7. The local work ledger is structurally valid but operationally unclear

There are 37 items in Now, 40 in Verify, none in Next, several active plans whose member counts say they are complete, and one active plan with no tickets. The ledger does not make the next action simple.

This is not solved by importing all 298 tickets into GitHub. Onboarding must first separate durable capabilities, release allocation, active work, verification debt, completed evidence/history, and duplicated process artifacts. Only a small human-confirmed set of active outcomes becomes live GitHub work.

### 8. Passing document validators can conceal semantic defects

The ticket and documentation checks pass, but a YAML title containing `#102` is parsed as only `PR` because it is unquoted. Generated views preserve the truncated parse rather than the human’s intended title. A large review document also stores escaped Markdown that is technically link-valid but difficult to read.

Plugin consequence: generated human views require source/parse/render round-trip fixtures. Schema and link validity alone are insufficient.

### 9. CI is path-aware in name, but not fully proportional

The main workflow classifies changed paths, but an always-running hygiene job still installs multiple toolchains and runs broad repository checks for ordinary documentation changes. The workflow runs on pull requests and pushes to every branch, producing duplicate exact-head runs for open feature branches.

Plugin consequence: the portable default is one `verify` result on pull requests and default-branch pushes. Documentation scope stays genuinely cheap and does not install unrelated code, database, or Azure toolchains.

### 10. Green and mergeable do not mean reviewed

All three open pull requests have unresolved review threads. PR #165 is green and reports a clean merge state but still has four current actionable findings at the inspected snapshot. PR #166 has 24 unresolved threads, its latest review predates later head commits, and its multi-million-line addition makes ordinary review impractical.

Plugin consequence: completion requires a complete review of the exact final head, zero unresolved blocking threads, and no undismissed blocking review state. Checks and mergeability cannot substitute for review.

### 11. Version, maturity, release, horizon, and work state are not separated

The package remains `0.0.0`, alpha is expressed as an operational plan, and there are no SemVer releases or exact-release milestones. It is difficult to answer whether a capability is intended, implemented, verified, deployed, or supported.

The plugin’s separate SemVer, maturity, roadmap horizon, and GitHub work-state model addresses this ambiguity.

### 12. Visual authority is split by surface without an explicit map

The runtime application has real theme and asset sources. Repository-local design guidance describes corporate web/document branding while excluding the internal application. Logos and fonts are copied across runtime and agent-material paths.

Plugin consequence: root `design/` is UI-only and contains an applicability map naming each UI surface and the exact token/assets/runtime authority that applies. Existing runtime sources remain canonical until a deliberate change says otherwise.

### 13. A clean worktree is not a complete onboarding preflight

The root tree is clean, but its branch already belongs to PR #165 and nested linked worktrees belong to other active PRs. Reusing that branch would mingle onboarding with active work; traversing nested worktrees could mutate separate branches.

Plugin consequence: onboarding inspects branch purpose, default branch, open-PR relationship, and every linked worktree. It obtains an explicit neutral baseline and treats other worktrees as exclusion boundaries.

## Why the earlier judgment was wrong

The earlier audit inferred too much from three true observations:

1. the current top-level roots have logical names;
2. operational evidence and documentation are more mature than v2; and
3. many checks pass.

Those observations answer “is this a real, operated system with later safety controls?” They do not answer “can a maintainer easily locate the rule, understand precedence, change it once, and prove it consistently?” The implementation trace, hotspot/churn data, compatibility paths, and local/CI disagreement answer the latter question, and the answer is no.

## What the plugin must address

| Observed failure | Plugin response |
| --- | --- |
| Tidy folder names conceal giant, branch-heavy hotspots | Runtime call graph plus size/branch/fan-out/churn hotspot report |
| Rule behavior spread across languages, stores, and stages | Rule/configuration authority ledger with precedence, readers, activation, proof, and retirement |
| Live, copied, test-only, replay, and legacy code mixed together | Explicit source-role classification and released-bridge lifecycle |
| Extreme churn and historical annotations inside current code | Decision-complete planning, one active change record, small canonical ownership boundary |
| Green CI but different local canonical result | One declared command with Windows/CI determinism, explicit prerequisites, skips, and ratchets |
| Product truth mixed with live status and plans | Canonical product/capability/roadmap split; GitHub owns live work |
| Hundreds of local work artifacts | No bulk issue import; human-confirmed current outcomes only |
| Multiple repository-local workflow adapters | One installed plugin; retain only repository facts and valuable checks |
| False-green generated indexes | Semantic source/parse/render fixtures |
| Broad pre-commit/CI burden | One proportional path-aware `verify`; no hook by default |
| Green PRs with unresolved feedback | Exact-final-head complete review plus unresolved-thread gate |
| Unclear alpha/version meaning | Independent SemVer, maturity, horizon, and work state |
| Split UI/brand authority | UI-only root `design/` with surface applicability and runtime/source mapping |
| Clean but already-active branch/worktrees | Branch/PR/worktree-aware onboarding preflight |

## Decisions onboarding cannot make mechanically

The workflow can produce evidence and a recommendation, but a human must confirm:

- which currently duplicated decision surface should become canonical;
- which compatibility/replay paths remain supported and their retirement points;
- which of the 37 Now and 40 Verify items are genuinely active;
- the first supported version and current maturity declaration;
- the disposition of the 298-ticket/15-plan corpus after parity mapping;
- which visual rules and assets apply to each UI surface;
- the disposition of the active pull requests and nested worktrees; and
- which repository-specific checks protect enough real risk to keep.

## Audit conclusion

The corrected finding is not merely that the workflow is overgrown. The implementation itself is highly accreted, rule ownership is fragmented, and historical migration/replay concerns obscure the live path. The user’s complaint about poor planning, difficulty diagnosing behavior, and high churn is borne out by the repository.

The original repository should therefore be treated as a **failure-mode fixture and source of operational evidence practices**, not as the plugin’s code-architecture template. Acceptance needs a neutral “accreted rule system” fixture in addition to the existing overloaded-work-ledger fixture. That fixture must prove the plugin detects distributed rule ownership, giant hotspots, scattered configuration, generated/materialized copies, exported reference code, bridge paths without retirement metadata, and Windows/CI verification disagreement.

The completed [development-base comparison](collisionspike-development-base-recommendation.md) recommends v2 for forward product development while retaining this repository as the live operational/evidence source and emergency-fix target until cutover.
