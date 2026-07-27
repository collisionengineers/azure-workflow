# Risk scaling

Classify the requested outcome before creating workflow artifacts. Risk changes depth, not the obligation to understand and prove the result.

## Compact delivery lane

Use the compact lane only when every statement is true:

- the edit is mechanical, unambiguous, and readily reversible;
- it changes no observable behavior or supported contract;
- it has no data/schema, identity/authentication, dependency, architecture, operations, UI-meaning, IaC, Azure, migration, or release effect;
- it needs no product/architecture/design decision;
- canonical documentation has no semantic update;
- repository policy does not require an issue or record.

Examples can include a spelling correction, a non-semantic formatting fix, or a mechanically proven path/reference repair. File type alone never makes work compact.

Keep an in-session checklist with scope, exclusions, proportional proof, documentation reason, and promotion trigger. Create no issue, Project item, or change record by default. The PR states `Change record: not required — low-risk mechanical change` and records the same proof.

Require proportional checks and green required CI. Independent review is optional unless the user or repository requires it or a promotion signal appears; do not create a review loop for a change whose compact classification still holds.

Promote before continuing if implementation reveals ambiguity, behavior, a decision, semantic documentation impact, a qualifying agent mistake, or any excluded effect. Create/reuse the normal issue and record; do not conceal scope expansion to preserve the compact label.

## Standard risk

Normal feature/fix work inside understood boundaries. Require one issue, one change record, repository-grounded planning, affected-document declaration, caller-backed tests, path-aware CI, an actual PR, feedback remediation, and independent exact-head review.

Cover behavior, failure/recovery, dependencies, configuration, data effects, UI/UX when applicable, documentation, rollout, and acceptance. Add only evidence relevant to plausible regressions.

Use one complete candidate review and at most one batched review-remediation round. Classify all known feedback before that batch and push the accepted fixes together. If a genuine blocker/required defect remains after the budget, keep the PR under review and ask the human to revise the scope or endpoint. Only a new explicit request begins another bounded delivery; do not continue an automatic hardening loop.

## High risk

Use high risk for supported-contract breaks, identity/security boundaries, schema/data migrations, Azure mutation, destructive actions, production behavior, resilience, compliance explicitly in scope, or material cost/downtime.

Add explicit approval points, blast radius, negative/failure/recovery proof, migration/rollback or forward-recovery procedure, observability, production-like validation, and named release/operation authority. High risk does not justify speculative frameworks or duplicate documents.

Allow at most two batched review-remediation rounds. Additional reviewer suggestions are dispositioned without implementation unless the human explicitly expands scope; an unresolved genuine blocker still prevents completion.

## Reclassification

Risk can rise as evidence appears. Record the reason and apply the stronger unfinished gates. Never lower risk merely because a deadline is close or tests are inconvenient.
