# Change: Harden onboarding after first live repository rollout

```yaml
id: 2026-07-27-first-live-onboarding-rollout-remediation
type: fix
status: active
risk: standard
created: 2026-07-27
updated: 2026-07-27
issue: https://github.com/collisionengineers/azure-workflow/issues/3
pull_request: https://github.com/collisionengineers/azure-workflow/pull/4
baseline: 1540464d3f6410e6222956a7d5dd204e3c4d05d9
target_release: 0.1.0-alpha.2
roadmap_horizon: Now
mode: development
supersedes: none
superseded_by: none
```

## Summary

The first live use of `0.1.0-alpha.1` onboarding exposed a gap between the
skill's written preservation rules and its actual execution. The agent did
substantial repository-grounded work and recovered several ordinary failures,
but it did not close documentation disposition scope before conversion and
draft publication, it used ambiguous progress language, and it marked phases
complete before canonical verification and independent review were complete.

This record is both the derived rollout report and the implementation-ready
remediation plan. The 2.4 MB raw JSONL remains local and untracked; the durable
record contains only bounded evidence needed to reproduce and correct the
workflow.

## Scope

### Included

- Add an explicit pre-mutation onboarding scope gate covering every material
  source's role, mutation rule, intended disposition, and user-owned Git
  ancestry.
- Tie progress and publication language to observable gates so inventory,
  conversion, local proof, exact-head CI, and independent review cannot be
  collapsed into one “complete” claim.
- Make the documented GitHub personal-account Project route capability-probed,
  owner-explicit, readback-driven, and safe around the built-in Status field.
- Add fresh-context regression scenarios for protected documentation,
  ambiguous “workflow” language, blocked local Full verification, user-owned
  commits, GitHub CLI/API capability differences, and interruption recovery.
- Reduce avoidable context and command churn through targeted inventory,
  bounded patching, and short polling/readback cycles.

### Excluded

- Completing, reviewing, merging, or otherwise changing CollisionSpike v2
  pull request 2.
- Reclassifying user-owned commits or supplied design work as agent failures.
- Changing any Azure resource, target-repository product behavior, data,
  schema, runtime, IaC, or GitHub repository visibility.
- Adding a rollout database, session journal, task engine, background process,
  new public skill, or a fifth package helper solely to summarize JSONL.
- Treating ordinary red checks caught and repaired during the run as incidents.

## Authorities, current state, and constraints

- Authorities: [product requirements](../product/index.md) own intended plugin
  behavior; [AW-CAP-001](../product/capabilities.md) owns the onboarding
  outcome; [architecture](../architecture.md) owns the instruction-only plugin
  boundary; the onboarding
  [skill](../../plugins/azure-workflow/skills/onboard-azure-repository/SKILL.md)
  and its directly linked references own procedure; the supplied rollout is
  observed execution evidence.
- Current implementation: onboarding requires inventory, source-role and
  mutation-rule classification, parity proof, proportional checks, a draft PR,
  exact-head CI, and fresh independent review. It does not currently state a
  single explicit scope-closure gate before dependent conversion or publication,
  nor prescribe the recovered personal-Project command path precisely enough
  to avoid known failed mutations.
- Evidence boundary: the local JSONL contains 706 rows from 01:41:06 through
  02:17:11 UTC and was copied at 02:17:13 UTC. Later repository state includes a
  02:20:59 UTC commit absent from the snapshot. The JSONL therefore proves the
  captured execution interval, not the final outcome of the still-active
  onboarding PR.
- Constraints: keep the plugin general across Azure repositories; retain the
  six-skill and four-helper architecture; preserve user-owned work; use no
  synthetic domain material; keep raw rollouts and workstation paths out of
  tracked files; do not weaken exact-head review or Azure authorization.
- Conflicts: none. The user clarified that commits `8c3919c` and `9af3733` were
  user-owned. They are explicitly excluded from the failure classification.

### Rollout evidence and findings

| ID | Severity | Evidence | Finding and consequence |
| --- | --- | --- | --- |
| FR-001 | required | The agent declared no blocking source conflict at 01:46:53, opened draft PR 2 at 02:10:00, then received repeated clarification from 02:10:30 to 02:13:15 that Azure Workflow should organize `docs/operator-notes/` and all repository documentation. | Documentation disposition was not made explicit before dependent conversion and publication. The safe preserve default was defensible, but the workflow failed to surface the material preserve-versus-reorganize choice early enough. |
| FR-002 | required | At 02:11:26 the agent answered a question about “the workflow” as GitHub Projects automation. At 02:12:00 the user corrected that they meant Azure Workflow. Earlier shorthand also left the user asking whether `docs/operator-notes/` existed. | The agent did not disambiguate two active meanings of “workflow” and compressed “exists but unchanged/protected” into wording the user could reasonably read as absence. This increased correction turns and obscured ownership. |
| FR-003 | blocker | At 02:09:27 the plan trace marked repository/GitHub conversion and verification complete even though the canonical local Full command was blocked by missing LocalDB, exact-head CI had not run, and independent review was pending. The user-facing 02:09:34 update was more accurate, but the internal phase state remained overstated. | Progress state was not evidence-bound. A resumed agent could treat an incomplete candidate as verified or ready for review. |
| FR-004 | required | The trace hit an unsupported `gh` JSON field, literal `@me` owner mismatch, attempted deletion of GitHub's protected built-in Status field, and accepted a successful Project item-add until readback showed zero items. Each was later recovered through compatible queries or GraphQL. | Capability probing occurred reactively. The documented personal-Project route lacks one tested read-before-write sequence and exact readback stop conditions. |
| FR-005 | required | In 36.1 minutes the snapshot records 150 tool operations, 24 patch calls, 15 failed tool/wait operations, one context compaction, and cumulative telemetry of 15.2 million tokens, including 14.7 million cached input tokens. Failures included large patch context mismatches, a PowerShell parser error, repeated structural-check repair, and a 124-second CI watch timeout. | The run was unnecessarily brittle and interruption-prone. Much of the churn came from broad reads, monolithic patches, and mutation attempts before capability details were settled rather than from hard repository ambiguity. |

### Corrections and non-findings

- Commits `8c3919c` and `9af3733`, including the design addition, were created
  by the user. Their presence and ancestry are not agent failures.
- The initial GitHub Actions billing/spending-limit block, missing local
  `sqllocaldb`, and ordinary documentation-link failures were external
  prerequisites or intended validation feedback. They matter to proof status
  but are not plugin defects by themselves.
- Making the target repository public was an explicit user instruction after
  the agent described the visibility consequence. It is not an authorization
  failure.
- The snapshot ending after a failed patch is not proof that the overall
  session failed: later Git/PR evidence shows continued work. It does prove that
  a raw rollout snapshot must never substitute for current branch, record, PR,
  CI, and review readback.

## Acceptance criteria

- After read-only inventory and before the first target-content edit or GitHub
  mutation, the onboarding record exists and lists every material source with
  content role, mutation rule, disposition
  (`preserve/link`, `convert in place`, `relocate/merge`, or `retain as
  history`), and any user-owned commits already in branch ancestry.
- Any disposition that conflicts with current authority is resolved through one
  focused user question before dependent work. Protected sources are preserved
  when no change is needed; onboarding never treats invocation alone as
  permission to rewrite them.
- The agent uses exact phase terms: `inventoried`, `scope settled`, `converted`,
  `locally checked`, `CI green`, and `independently reviewed`. It does not mark
  verification or completion complete while the canonical check, exact-head CI,
  or required review remains pending or blocked.
- Draft publication occurs only after scope is settled, Docs validation is
  green, the candidate diff is inspected, and any local Full blocker plus the
  exact remote adjudication path is recorded. Publication never claims the
  final onboarding endpoint.
- If “workflow” could mean Azure Workflow or GitHub Project automation, the
  response names both meanings or asks one focused clarification. Existence,
  mutation permission, and observed diff state are reported separately with
  paths/counts where available.
- GitHub setup resolves the authenticated login explicitly, probes supported
  CLI/API fields before mutation, updates the built-in Status field in place,
  treats command success without readback as unproved, and stops on a mismatch.
- CI monitoring uses bounded polling/readback intervals under 60 seconds and
  can resume by exact run/head identity after interruption.
- The representative fresh-context onboarding scenario completes without a
  context compaction, avoids failures from known static CLI/Project behavior,
  preserves the supplied user-owned commits, and stops before a false
  completion claim when Full proof or review is absent.
- The plugin remains one generic six-skill package with four read-only or local
  deterministic helpers, and the canonical Full repository check is green.

## Plan

1. In
   `plugins/azure-workflow/skills/onboard-azure-repository/SKILL.md`, make the
   order explicit: call `update_plan`; perform read-only repository/GitHub
   inventory; resolve the change identity; create the onboarding record; write
   the source-disposition table and user-owned ancestry into that record; close
   or block every material scope decision; only then permit target-content
   conversion or GitHub mutation. Add evidence-bound progress terms and a
   publication gate that cannot be described as completion. Creation and
   completion of the onboarding record are the gate mechanism, not prohibited
   target-content edits.
2. In `references/authority-and-conflicts.md` and
   `references/documentation-conversion.md`, add the disposition field and
   rules for protected sources: preserve/link is the safe default, but ask one
   early question when conversion intent materially depends on edit/relocation
   authority. Require claim-ledger closure before source retirement or PR
   publication.
3. In `references/github-onboarding.md`, specify the recovered personal-account
   sequence: resolve the actual login, probe supported fields, inventory current
   Project and built-in fields, present the bounded intended mutation, update
   Status in place, and read back labels/project/items/options after every
   mutation. Treat empty readback as failure and use bounded polling for CI.
4. Add explicit communication and verification semantics to the onboarding
   skill: disambiguate Azure Workflow from GitHub workflow/Project automation;
   report path existence, authority, diff, and proof independently; distinguish
   the canonical Full command from direct substitute checks and remote CI.
5. Extend `tests/scenarios.md` with one generic first-use regression containing
   protected operator notes, an approved external design source, user-owned
   commits, a missing local Full prerequisite, personal-account Project edge
   cases, and an interruption. The expected trace must meet every acceptance
   criterion without using case-study names inside the plugin package.
6. Add narrowly scoped package assertions only for stable structural contracts
   introduced by the change; do not create brittle tests for exact prose or a
   new state engine. Run the scenario in a fresh Codex context and record its
   trace-level pass/fail in this record.
7. Update product/roadmap authority, package/install cachebuster and prerelease
   metadata as required for `0.1.0-alpha.2`; reinstall into a new thread, run
   Docs then Full checks, publish one PR, wait for exact-head CI, and invoke a
   fresh independent review. Stop before merge.

## Data, failure, and recovery

- Data/schema: not applicable; the change affects instructions, references,
  scenarios, tests, documentation, and package metadata only.
- Failure behavior: unresolved source disposition blocks dependent conversion;
  unsupported GitHub capability or mismatched readback blocks only that GitHub
  setup slice; a local Full prerequisite remains an explicit proof blocker and
  never becomes green by substitution; changed PR head invalidates prior CI and
  review evidence.
- Recovery/rollback: revert the scoped remediation commit/PR to baseline
  `1540464d3f6410e6222956a7d5dd204e3c4d05d9`. No target-repository or Azure
  rollback is part of this change. Interrupted evaluation resumes from the
  exact issue, record, branch, PR head, and CI run rather than from the JSONL.

## UI/UX contract

Not applicable. The plugin has no visual application UI. The remediation may
classify and preserve design sources in an onboarded repository but creates no
visual asset, token, component, content, accessibility, or runtime UI change.

## Azure impact

None. No Azure read, deployment, credential action, resource mutation, cost, or
live-state claim is included. Availability of the Azure MCP does not broaden
this planning or later implementation authority.

## Decisions and conflicts

- Selected `0.1.0-alpha.2` in `Now`: this is a correction to the existing alpha
  onboarding outcome, not the materially different-repository exercise already
  allocated to `0.2.0-alpha.1`.
- Selected instruction/reference/scenario hardening over a new public skill,
  workflow database, rollout summarizer, or GitHub-mutating helper. The known
  scope is exercised by onboarding and fits its existing owners.
- Selected preserve/link as the default for protected sources, with an early
  question only when requested conversion materially depends on broader
  mutation authority. This preserves safety without silently narrowing the
  user's onboarding outcome.
- Selected exact readback and phase vocabulary rather than a numeric universal
  tool-call cap. The rollout metrics remain a regression signal; correctness
  gates must not be traded for fewer calls.
- Unresolved decisions: none.

## Implementation

- Status: not started; research and planning only.
- Deviations: none.
- Recovery actions: none.

## Verification

| Check | Scope | Expected | Observed |
| --- | --- | --- | --- |
| JSONL structured extraction | supplied snapshot | event/tool/message/failure counts and boundary established without committing the raw file | complete: 706 rows, 150 tool operations, 24 patches, 15 failed operations, one compaction; final captured event 02:17:11 UTC |
| live corroboration | target branch/PR read-only | distinguish later continuation from snapshot | complete: later head `4ac1cf2` exists; PR 2 remained draft with no review when inspected |
| user provenance correction | commits `8c3919c` and `9af3733` | exclude both from failure attribution | complete by explicit user direction |
| planning validation | Docs | valid record, links, schema, and documentation-only diff | green: repository standard, links/fences, path portability, and comparison whitespace passed |
| planning PR CI | exact head `82c93f7ad802bfdc955b3a997aac507308eedf3a` | green Docs workflow | green: `verify` completed successfully |
| implementation Full check | package/repository | `pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1 -Scope Full` green | not run — planning only |
| fresh-context regression | onboarding trace | all acceptance criteria pass without target-repository/Azure mutation | not run — implementation only |

## Independent review

- Plan review: candidate review at head `82c93f7ad802bfdc955b3a997aac507308eedf3a`
  returned `changes-required`; RVW-001 identified an impossible ordering between
  record creation and the pre-mutation gate. The plan now explicitly orders
  read-only inventory, record creation/population, scope closure, then
  target-content/GitHub mutation.
- Candidate PR review: not run — planning only.
- Final exact-head review: not run — planning only.
- Remediation rounds: one planning-review batch; no implementation remediation.

## Documentation and work tracking

- Documentation impact declared before implementation: product requirements,
  roadmap, onboarding skill, authority/conflict conversion references, GitHub
  onboarding reference, and fresh-context scenarios. Architecture changes are
  not expected because the six-skill/four-helper boundary remains unchanged.
- Agent mistake entries: none; this planning agent did not cause the reported
  rollout events, and ordinary findings belong in this evidence record.
- Product/capabilities: [product requirements](../product/index.md) require an
  explicit scope/verification invariant; AW-CAP-001 remains the stable owner and
  needs no new capability ID.
- Design system/assets: not applicable; the plugin has no visual UI and the
  user-owned target design commit is not changed.
- Roadmap/release: [roadmap](../roadmap.md) adds `0.1.0-alpha.2` first-use
  hardening to `Now`; package version/cachebuster updates occur during delivery.
- Architecture/ADR: no change expected; no new component, helper category,
  authorization boundary, or hard-to-reverse decision is introduced.
- Operations: no current procedure changes planned outside bounded CI polling
  language in the owning onboarding reference.
- GitHub issue/Project/milestone: [issue 3](https://github.com/collisionengineers/azure-workflow/issues/3)
  is open with `type:bug`; documentation-only [PR 4](https://github.com/collisionengineers/azure-workflow/pull/4)
  is draft; milestone is `0.1.0-alpha.2`; Project values are `P1 High`, `Now`,
  and `In Progress`. The existing Project Status options lack `In review` and
  `Ready`, so this plan does not claim those unavailable states.

## Outcome

The first-use problems are classified, corrected for user-owned provenance, and
converted into a decision-complete `0.1.0-alpha.2` remediation plan. No plugin
implementation or target-repository/Azure change has been made.

## Blocker or follow-ups

- Blocker: none.
- Follow-ups: none beyond implementing this record through the delivery skill.
