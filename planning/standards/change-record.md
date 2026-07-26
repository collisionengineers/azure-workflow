# Change-record contract

## Purpose

One Markdown file carries the durable plan, decisions, implementation evidence, review rounds, and ready outcome for onboarding and each standard/high-risk bounded change. It replaces task folders, JSON handoffs, journals, and separate planning/review/validation packs.

It is not the canonical product specification, roadmap, or live task board. Those facts remain in their owners and are linked from the record.

## Identity

```text
docs/changes/YYYY-MM-DD-slug.md
```

- Date is UTC creation date.
- Slug matches `^[a-z0-9]+(?:-[a-z0-9]+)*$`.
- The create script refuses duplicates and overwrites.
- Resume the same record across plan and delivery.
- A replaced request creates a successor and links both directions.
- Compact-lane delivery creates no record when the work is mechanical, unambiguous, readily reversible, and has no behavioral, contract, data/schema, identity, dependency, architecture, operations, UI-meaning, IaC, Azure, migration, or release effect. If any condition fails or scope expands, promote before implementation and create the standard record.

## Status values

| Status | Meaning |
| --- | --- |
| `active` | Planning or implementation is in progress |
| `blocked` | A named decision or external prerequisite prevents the requested endpoint |
| `planned` | Decision-complete and risk-appropriately reviewed; implementation has not started; standalone publication is normally a ready documentation PR |
| `ready` | Agreed implementation endpoint reached; normally a green exact-head-reviewed PR |
| `superseded` | A linked successor replaced this record |

GitHub owns finer live work state and post-merge Done/closure. `ready` does not mean merged.

## Type and risk

Types: `onboarding`, `feature`, `fix`, `documentation`, `operations`.

Risks:

- `low`: documentation/test/mechanical work with no material behavior, contract, data, security, Azure, or recovery impact.
- `standard`: normal feature/fix within known boundaries.
- `high`: supported contract, identity/security, data/schema/migration, Azure mutation, production behavior, resilience, compliance, destructive action, or material cost.

## Exact asset template

The implementation copies this body to `skills/plan-azure-repository-change/assets/change-record-template.md`.

```markdown
# Change: {{TITLE}}

Status: {{STATUS}}
Type: {{TYPE}}
Opened: {{OPENED_DATE}}
Last reviewed: {{LAST_REVIEWED_DATE}}
Repository: {{REPOSITORY}}
Base branch: {{BASE_BRANCH}}
Baseline commit: {{BASELINE_COMMIT}}
Issue: {{ISSUE}}
Pull request: {{PULL_REQUEST}}
Capability IDs: {{CAPABILITY_IDS_OR_NONE}}
Product authority: {{PRODUCT_AUTHORITY}}
Target release: {{TARGET_RELEASE_OR_UNALLOCATED}}
Roadmap horizon: {{NOW_NEXT_LATER_NOT_PLANNED_OR_NONE}}
Maturity impact: {{MATURITY_IMPACT_OR_NONE}}
Risk: {{RISK}}
Implementation owner: {{IMPLEMENTATION_OWNER}}
Independent reviewer: {{INDEPENDENT_REVIEWER}}
Supersedes: none
Superseded by: none

## Summary

{{SUMMARY}}

## Scope

### Included

- {{INCLUDED}}

### Excluded

- {{EXCLUDED}}

## Authorities, current state, and constraints

- User/operator and job: {{USER_AND_JOB}}
- Caller or entry point: {{CURRENT_CALLER}}
- Owning component: {{CURRENT_OWNER}}
- Observed behavior: {{CURRENT_BEHAVIOR}}
- Authorities: {{AUTHORITIES}}
- Repository mode and supported-contract effect: {{MODE_AND_CONTRACT_EFFECT}}
- Constraints and dependencies: {{CONSTRAINTS_AND_DEPENDENCIES}}

## Acceptance criteria

1. {{ACCEPTANCE_CRITERION}}

## Plan

| Step | Owner or path | Intended change | Dependency | Proof |
| --- | --- | --- | --- | --- |
| 1 | {{OWNER_OR_PATH}} | {{PLANNED_CHANGE}} | {{DEPENDENCY_OR_NONE}} | {{PLANNED_PROOF}} |

## Data, failure, and recovery

- Inputs/outputs/persistence: {{DATA_AND_INTERFACES}}
- Permissions/trust boundary: {{PERMISSIONS_AND_TRUST}}
- Failure/retry/conflict behavior: {{FAILURE_BEHAVIOR}}
- Rollback or forward recovery: {{RECOVERY}}

## UI/UX contract

{{UI_UX_CONTRACT_OR_NOT_APPLICABLE_WITH_REASON}}

- Design authority/token/source-runtime effects: {{DESIGN_EFFECTS_OR_NOT_APPLICABLE_WITH_REASON}}

## Azure impact

{{AZURE_IMPACT_OR_NOT_APPLICABLE_WITH_REASON}}

## Decisions and conflicts

- {{DECISION_OR_NONE}}

## Implementation

- Changed paths: {{CHANGED_PATHS_OR_NOT_STARTED}}
- Caller result: {{CALLER_RESULT_OR_NOT_STARTED}}
- Deviations from plan: {{DEVIATIONS_OR_NONE}}

## Verification

| Check | Command or procedure | Result | Evidence limits |
| --- | --- | --- | --- |
| Focused | {{FOCUSED_CHECK}} | {{RESULT}} | {{LIMITS}} |
| Canonical | {{CANONICAL_CHECK}} | {{RESULT}} | {{LIMITS}} |
| Product/caller | {{CALLER_CHECK}} | {{RESULT}} | {{LIMITS}} |
| UI/design/Azure/operations | {{CONDITIONAL_CHECK}} | {{RESULT}} | {{LIMITS}} |

## Independent review

| Round | Stage | Reviewer | Result | Findings | Resolution |
| --- | --- | --- | --- | --- | --- |
| 1 | {{PLAN_OR_IMPLEMENTATION}} | {{REVIEWER}} | {{RESULT}} | {{FINDINGS_OR_NONE}} | {{RESOLUTION}} |

## Documentation and work tracking

- Documentation impact declared before implementation: {{AFFECTED_OWNERS_OR_NONE_WITH_SPECIFIC_REASON}}
- Agent mistake entries: {{AM_IDS_OR_NONE}}
- Product/capabilities: {{UPDATED_OR_NOT_APPLICABLE_WITH_REASON}}
- Design system/assets: {{UPDATED_OR_NOT_APPLICABLE_WITH_REASON}}
- Roadmap/release: {{UPDATED_OR_NOT_APPLICABLE_WITH_REASON}}
- Architecture: {{UPDATED_OR_NOT_APPLICABLE_WITH_REASON}}
- Operations: {{UPDATED_OR_NOT_APPLICABLE_WITH_REASON}}
- Decisions: {{UPDATED_OR_NOT_APPLICABLE_WITH_REASON}}
- GitHub issue/project/milestone: {{UPDATED_OR_NOT_APPLICABLE_WITH_REASON}}

## Outcome

{{OUTCOME}}

## Blocker or follow-ups

- {{BLOCKER_FOLLOW_UP_OR_NONE}}
```

## Update rules

- Planning creates the record before onboarding or standard/high-risk implementation; delivery reuses it. Compact-lane delivery has no record unless the user or repository policy requires one.
- Before implementation, planning fills the documentation-impact declaration and every owner row with an affected path/section or a specific reason it is unchanged. “No docs” without a reason is invalid.
- Planning fills every decision/plan section, marks implementation checks `not run — planning only`, records the Docs check/review, sets `planned`, and—when standalone with a remote—publishes the documentation through a ready plan PR before stopping.
- Standard/high-risk planning records include a fresh plan-review round.
- Delivery changes status to `active` and records only checks actually run and observed.
- Delivery updates every affected canonical owner in the same pull request. It does not defer documentation drift as ordinary follow-up work.
- Record only qualifying mistake-log IDs associated with this work. `none` is normal; do not create ceremonial incidents. A pending read-only entry is not listed as durable until an authorized workflow appends it.
- Keep original scope and decisions visible; record deviations instead of rewriting history to make the result appear preplanned.
- Preserve every plan review and PR remediation round that precedes the final tracked record update. Link the PR as the durable owner of the final exact-head attestation.
- `blocked` names the exact decision/prerequisite, owner, affected endpoint, and safe next action.
- Prepare the final `ready` update only after all non-self-referential gates and a clean candidate PR review pass. Commit it as the final tracked change, then require one complete exact-head PR review and CI readback. If that final attestation fails, immediately return the record to `active` in the remediation commit; the workflow has not completed.
- Never edit the tracked record merely to copy the final exact-head review result back from GitHub: that would create a new unreviewed head. The final GitHub `COMMENT` review carries the reviewed SHA and is linked through the record's PR field.
- After the PR merges, the record is historical evidence. GitHub owns Done/closure; do not rewrite the record merely to mirror task state.
- After readiness/merge, only append a dated correction or supersession link; do not silently rewrite evidence.

## Compactness

When a record is required, every section remains present for reliable validation. `Not applicable — <specific reason>` is valid. A user-requested or policy-required low-risk record stays concise; high-risk work expands in the same file rather than spawning a second artifact hierarchy.
