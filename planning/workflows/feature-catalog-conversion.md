# Large feature-catalog conversion workflow

## Purpose

Convert an existing large feature list or plan hierarchy into durable product authority, a compact versioned roadmap, and a bounded GitHub work system without losing stable IDs or creating hundreds of inert issues.

This workflow is used by `onboard-azure-repository` when a repository contains feature matrices, requirements spreadsheets, large plan directories, or overlapping future-work documents.

The current project-specific evidence and recommendation are recorded separately in the [CollisionSpike v2 planning audit](../research/collisionspike-v2-planning-audit.md). The packaged skill reference contains only the generic procedure below and no CollisionSpike-specific facts.

## Target model

```text
OLD
feature map + roadmap + remaining requirements + 40 detailed plans + status prose
                                  |
                                  v
NEW
docs/product/capabilities.md  (all stable IDs exactly once)
docs/product/areas/*.md       (settled intended behavior)
docs/roadmap.md               (small outcome/release sequence)
GitHub Issues/Project         (only actionable work)
docs/changes/*.md             (only just-in-time detailed plans)
docs/reference/...            (retained evidence/history where needed)
```

## Classification model

Every source clause is classified before files move:

| Class | Destination |
| --- | --- |
| Settled user/operator outcome or business rule | `docs/product/areas/<area>.md` |
| Stable feature/requirement identity and release disposition | `docs/product/capabilities.md` |
| Current/next/later outcome sequence and activation gate | `docs/roadmap.md` |
| Material unresolved decision | GitHub Decision-form Task (`decision` label); product docs state only the current conservative boundary |
| Current actionable implementation work | GitHub Feature/Task/Bug issue and Project |
| Decision-complete plan for selected work | `docs/changes/<date>-<slug>.md` |
| Current implemented boundary | `docs/architecture.md` |
| Current run/deploy/recover procedure | `docs/operations.md` |
| Significant accepted architecture choice | `docs/decisions/` |
| Historical review, superseded proposal, source worksheet, or evidence | Preserve source or move to `docs/reference/` with status/successor |
| Duplicate process narration or stale implementation prediction | Remove after parity proof; Git history and onboarding record preserve recovery |

## End-to-end conversion

```text
inventory every source and stable ID
              |
              v
extract clause ledger without rewriting meaning
              |
              v
classify each clause by canonical owner
              |
              v
same ID or rule conflicts? ---- yes ---> one material user question
              |                              |
              no <----------------------------+
              |
              v
write product areas + one capability index
              |
              v
translate V1/V2-style allocations to exact release or unallocated
              |
              v
write compact Now/Next/Later/Not planned roadmap
              |
              v
select only approved Now outcomes for GitHub parents
              |
              v
create sub-issues just in time, not from every row
              |
              v
triple-parity review + link validation
              |
              v
remove or mark old plan pack non-authoritative
```

## Stage 1: freeze and inventory

- Require a clean worktree and record the exact base commit.
- Preserve `operator-notes/` byte-for-byte and every other declared human-owned root according to its explicit mutation rule.
- Inventory every file, heading, table row, checkbox, link, status label, plan membership/completion field, stable ID, generated view/source, and stated authority in the legacy planning surfaces.
- Record counts in the onboarding change record so the conversion can prove completeness.
- Do not infer that the newest file is most authoritative.
- Record declared work state separately from evidence state. Flag completed-but-active, active-empty, overloaded Now/Verify, empty Next, and generated/source disagreement instead of silently normalizing them.

Create a temporary in-record clause ledger with:

| Source | Heading/row | Stable ID | Safe summary | Existing allocation | Existing primary owner/link | Classification | Destination | Conflict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

The ledger is migration evidence inside the onboarding change record, not a permanent second catalog.

## Stage 2: normalize identity

- Preserve every valid existing stable ID.
- Never renumber IDs for aesthetics.
- Where multiple rows express the same ID, determine whether they are duplicate wording, sub-requirements, or a genuine conflict.
- A feature ID identifies an outcome/contract, not an implementation task.
- New IDs are created only under the repository's declared prefix/sequence policy.
- If a source has no IDs, create them only when ongoing traceability justifies a catalog; otherwise use product headings.

## Stage 3: separate settled truth from allocation

For each feature:

1. Move the full settled intended behavior into one product-area section.
2. Keep one concise row in `capabilities.md` linking to that section.
3. Translate the old maturity/version value:

| Legacy value | New treatment |
| --- | --- |
| `V0`, `V1`, `V1.x`, `V2`, `V3`, `V3+` | Map to an explicitly approved SemVer release/maturity stage; otherwise `unallocated` and a proposed roadmap horizon |
| `Never` | `not-planned` product boundary; no open issue |
| `Conditional` | `conditional` with exact activation authority/gate |
| `Unclear` | `conditional` plus a Decision-form Task only if resolving it is now actionable |
| `Implemented`, `called`, `deployed`, `accepted` | Remove from catalog; prove through code, architecture, operations, PR/release evidence |
| Explicitly removed/retired supported capability | `retired`, preserve the stable ID and link the retirement authority/release |

Do not mechanically turn `V1` into `1.0.0`. The user must settle release contract and stage gates first.

## Stage 4: compress the roadmap

Group capability rows into outcomes a user/operator would recognize. A target release normally has five to ten top-level outcomes, not one line per ID.

Example:

```text
0.3.0-alpha.1 outcome: Accept definitive QDOS intake into one incomplete case
    capability IDs: CAP-001, CAP-002, INT-004, OPS-003, UI-006
    gate: durable source custody + allocator + staff identity
```

The roadmap links to the capability rows/product sections and to one parent Feature issue only after activation.

## Stage 5: create bounded GitHub work

Do not bulk-create 213 issues.

```text
213 catalog rows
      |
      +--> not-planned/conditional/later remain documentation only
      |
      +--> Next remains outcome-level roadmap unless research is active
      |
      `--> approved Now release
               |
               +--> 5-10 parent Feature issues
                         |
                         `--> bounded sub-issues created when ready
```

Issue-creation rules:

- Create one parent Feature per independently acceptable outcome, not per product area and not per feature row.
- Link all covered capability IDs in the parent body.
- Create a child Task/Bug only when it is independently actionable, has a distinct owner/dependency, or is a reviewable PR-sized deliverable.
- Create Decision issues only for material decisions that are now blocking or scheduled for research. On an organization route without native Decision, encode them as native Task plus `decision`.
- Give every created issue exactly one semantic work kind. Apply only registered additive area/component facets; never create a new type or category for each capability row.
- Leave Later capability rows without issues until their activation condition is met.
- Use native dependencies for order and milestones for exact releases.

The onboarding request authorizes preparation of the proposed issue set. Bulk creation requires the user to approve the exact Now release and issue count before the agent writes GitHub state.

Legacy `Now`, `active`, `verify`, checkbox, and plan-progress values do not activate GitHub work mechanically. The human confirms a small current outcome set after seeing the mapping and counts; the remaining material becomes product authority, roadmap allocation, verification debt, or history as appropriate.

## Stage 6: UI/UX migration

Legacy UI plan packs are classified rather than copied whole:

- settled user journeys, roles, terminology, states, and interaction rules move to product-area docs;
- the supported viewport/accessibility/design-system contract moves to `docs/product/index.md` or the relevant area;
- unapproved visual directions remain reference evidence with an explicit `unapproved` status;
- the selected direction becomes a decision/change record when approved;
- future screen-by-screen implementation detail is removed and recreated just in time through the [UI/UX workflow](ui-ux.md).

## Stage 7: triple-parity gate

The old plan pack may stop being authoritative only when all three pass:

### Identity parity

- Every legacy stable ID exists exactly once in the capability index or has an explicit documented invalid/duplicate disposition.
- Counts reconcile.

### Contract parity

- Every unique material product rule, boundary, open decision, architecture choice, operation, and evidence source has one destination.
- No removed file contains unique active authority.

### Routing parity

- Every capability row links to a canonical product owner.
- Every allocated Now outcome links to an exact release and, when activated, a parent issue.
- Every retained historical/reference file states its non-authoritative role and successor.
- All repository links pass validation.
- Human-facing generated views preserve the parsed source value, including YAML/Markdown special characters, and status/progress views agree with their declared members or carry an explicit unresolved disposition.

One fresh reviewer receives the old source inventory, clause ledger, new catalog/product/roadmap, proposed removals, and exact counts. Any missing or changed claim blocks conversion.

## Stage 8: retire the old plan hierarchy

After parity:

| Old material | Action |
| --- | --- |
| Pure duplicate/stale plan/process text | Remove |
| Source worksheet/interview evidence still valuable | Preserve in place if human-owned or move to `docs/reference/requirements/` with status |
| Historical review snapshot | Move to `docs/reference/reviews/` or retain with historical status |
| Unapproved UI concept | `docs/reference/ui-concepts/` with explicit non-authority |
| Active detailed plan for current work | Convert to one change record and link its issue |

Do not create a generic `docs/archive/` dumping ground. Use named reference categories only when a human or agent has a real retrieval reason.

## Validation

- Duplicate/missing capability-ID check.
- Allowed disposition and SemVer syntax check.
- No live-status or checkbox columns in capabilities/roadmap.
- Every canonical link resolves.
- Every open Now parent issue has a release milestone and capability link.
- No Later, conditional, or not-planned row was bulk-created as an issue.
- Old-to-new counts and clause dispositions are recorded in the onboarding change record.
