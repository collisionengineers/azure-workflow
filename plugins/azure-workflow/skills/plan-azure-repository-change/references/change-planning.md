# Change planning procedure

## Inspect before asking

Resolve the exact change identity and inspect repository authority, current caller paths, configuration/rule owners, data/external effects, tests, operations, UI/design when applicable, GitHub state, and relevant history. Distinguish current, intended, proposed, and unknown.

## Decision interview

Ask only material questions. Good questions select between outcomes that change scope, observable behavior, supported contracts, ownership, architecture, data/failure/recovery, UI/UX, Azure, release, or acceptance. Lead with one recommended default and consequence; ask one at a time; preserve answers in the record.

Do not ask what the repository can prove, repeat settled questions, request code-level choices from a non-coder without translation, or solicit a complete future roadmap.

## Decision-complete gate

A plan is ready when another agent can identify:

- exact problem/outcome, included/excluded scope, authority, baseline, and conflicts;
- affected callers/owners/files/components and dependency order;
- observable behavior, data, failures, recovery, UI/UX, Azure, compatibility, and release decisions;
- acceptance criteria and proportional proof with exact known commands;
- documentation owners, GitHub identity, rollout/recovery, and stop boundary;
- every unresolved prerequisite and its owner.

Use `blocked` when a material decision remains. Do not hide it as an implementation detail or create placeholder architecture.

## Fresh plan review

Give a fresh context the request, authorities, current-state evidence, complete record, documentation-only diff, and risk. It checks missing decisions, internal contradictions, unexecutable steps, overengineering, hidden compatibility, weak acceptance, documentation drift, and scope leakage. Remediate the plan and repeat. If isolation is unavailable, provide a copy-ready packet and do not self-certify.

## Drift and resumption

Delivery compares the record's baseline and authorities with current base. Update and re-review only materially invalidated sections. Reuse the record; never create a second planning pack.
