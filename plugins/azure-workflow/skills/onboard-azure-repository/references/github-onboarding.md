# GitHub onboarding

## Capability probe first

Read repository owner type, visibility, Issues state, authenticated identity/scopes, current forms/templates, labels with usage counts, issues, milestones, Projects, fields/options, workflows/views, and API/CLI errors. Personal-account repositories cannot use organization-only issue types. Use `type:*` labels for the universal work-kind fallback.

GitHub Projects support a portable CLI/GraphQL core for creating/linking a user-owned project, items, fields, and option values. Saved views, charts, some built-in workflows, auto-add behavior, and UI-only settings may not be fully queryable/mutable. Apply portable pieces, produce an exact setup card for the rest, and distinguish human visual confirmation from API readback. Never claim unsupported control.

Issue-form availability/enforcement can vary with repository visibility/plan. Keep forms in the repository, probe actual behavior, and do not treat private-form requiredness or Project auto-add as an enforcement guarantee.

## Taxonomy

Every workflow-owned issue has exactly one base kind: Feature, Bug, Task, or Decision. On personal/fallback repositories encode these as exactly one `type:feature`, `type:bug`, `type:task`, or `type:decision` label.

Project-specific categories are allowed when they represent a repeated routing/query need, have a documented namespace and allowed values, are orthogonal to kind/status/priority/horizon/release/assignee/dependency, and have an owner. Preserve unrelated community/tool labels. Preview deletion, in-use rename, or bulk relabelling and ask for approval.

## Project fields

Portable baseline:

- Status: Triage, Ready, In progress, In review, Done;
- Priority: P0 Critical, P1 High, P2 Normal, P3 Low;
- Horizon: Now, Next, Later;
- Target release: milestone rather than duplicate text when possible.

Do not add a Next-action field, duplicate status labels, or a generated dashboard. Discover live IDs each run; do not persist a Project-state JSON file.

## Issues and hierarchy

Create issues only for activated work. A parent Feature is a bounded outcome; children exist only when independently deliverable or differently blocked/owned. Use native sub-issues and blocking relationships where available. Never create placeholder Later issues or mirror every capability ID.

## Safe mutation boundary

Full onboarding authorizes repository forms/templates, required labels, and idempotent setup/reuse of one repository-linked Project after presenting exact state and intended changes. It does not authorize deleting/replacing an existing Project, organization-wide changes, branch protection, destructive/in-use taxonomy changes, bulk issue creation, closing existing work, or chart/view claims without confirmation.

Read every mutation back. Store transient node/field/option IDs only in onboarding evidence, not a permanent state file.
