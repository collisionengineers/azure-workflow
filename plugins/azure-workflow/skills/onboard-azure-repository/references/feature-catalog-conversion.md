# Feature catalog conversion

## Separate durable product truth from live work

Convert each material feature claim into one of:

- canonical product requirement/behavior;
- stable capability row with ID, canonical link, target release or `unallocated`;
- roadmap outcome in `Now`, `Next`, `Later`, or `Not planned`;
- activated GitHub issue only when work is actually actionable;
- historical evidence.

Do not create an issue for every row or preserve vague `V1/V2/V3+` buckets. Deduplicate aliases while retaining source IDs in the onboarding ledger.

## Ledger diagnostics

Do not trust legacy status at face value. Detect active work reported as 100%, empty active queues, overloaded `active`/`verification`, missing sequencing, duplicate owners, and disagreement between source data, parser output, and rendered human views. Trace any generator and its side effects.

## Activation

Present the small proposed active set with reason, dependencies, release/horizon, and suggested issue kind. Ask the human to confirm activation. Create parent Feature plus bounded child Tasks/Bugs/Decisions only when independently deliverable or dependency-bearing. Keep normal hierarchy to one parent/child level and use native dependencies for order.

`Not planned` is a product boundary, not a backlog state. Close/avoid issues for it and retain the reason in product/roadmap authority.
