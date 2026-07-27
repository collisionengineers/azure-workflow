# Documentation lifecycle during planning

## Owners, not duplicates

The change record owns this change's decisions/evidence. Product requirements, capabilities, design, roadmap, architecture, operations, ADRs, and instructions remain canonical in their own documents. Planning may update settled intended facts, but it must not use the record as a permanent substitute.

Before implementation, list every affected owner or a specific reason none changes. `No docs` without a reason is invalid. Delivery updates affected owners in the same PR; future-doc follow-up is not an acceptable way to knowingly ship drift.

## Three drift controls

1. **Prevention:** authority routes, single owners, change-impact declaration, generated-source declarations, and same-PR maintenance.
2. **Mechanical detection:** links, headings, schemas, IDs, path/casing, generated-view consistency, and append-only mistake history.
3. **Semantic detection:** fresh exact-head review compares canonical claims with actual implementation/configuration/callers and intended authority.

Mechanical checks never claim semantic agreement. Scheduled drift bots, duplicated truth snapshots, and automatic rewrite loops are not part of the plugin.

## Mistake log

Plan append only when the planning agent itself qualifies: violated available authority, false completion/evidence, crossed scope/authorization, let a defect escape a required gate, or exposed a reusable workflow gap. Ordinary uncertainty, user changes, red tests, and findings caught by the intended review are not incidents. Recover first; append factual evidence and link the incident ID from the record.

## Stable capabilities and roadmap

Product documents own durable behavior. Capability IDs map to canonical sections and exact release or `unallocated`. Roadmap owns Now/Next/Later/Not planned outcomes, not task checklists or live status. GitHub owns actionable work. Update all affected owners atomically when allocation changes.
