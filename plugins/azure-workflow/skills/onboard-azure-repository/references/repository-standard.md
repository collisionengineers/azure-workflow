# Azure Workflow repository standard

## Required spine

```text
AGENTS.md
docs/
  index.md
  product/index.md
  roadmap.md
  architecture.md
  operations.md
  agent-mistakes.md
  decisions/
  changes/
.github/
  ISSUE_TEMPLATE/{feature,bug,task,decision}.yml
  ISSUE_TEMPLATE/config.yml
  pull_request_template.md
```

`docs/product/capabilities.md` and `docs/product/areas/` are conditional. When capabilities exist, each table row has a unique stable ID, non-empty outcome, existing repository-relative canonical owner, and SemVer target release or `unallocated`. Root `design/` is required only for a visual UI, but an existing valid design directory may remain when UI is absent.

## Required document fields

- Product index: mode, maturity, version scheme/current version, release authority, visual UI, purpose/problem, users/outcomes, success measures, scope, requirements/invariants, quality constraints, supported contracts, limitations, open decisions.
- Roadmap: only Now/Next/Later/Not planned; exact release or `unallocated`.
- Architecture: system/context, components/ownership, entry points/callers, data/integrations, rule/configuration owner, generated/source roles, failure/recovery, deployment, boundaries.
- Operations: prerequisites/toolchains, canonical check, local run/build/test, deploy, configuration/secrets boundary, monitoring/diagnosis, recovery, GitHub taxonomy/Project notes, supported platforms.
- ADR: one numbered title matching a stable `NNNN-slug.md` filename, one ISO date, status `proposed|accepted|superseded|rejected|deprecated`, and exactly one Context/Decision/Consequences section.
- Change record: filename-matching ID; supported type/status/risk/mode; ISO created/updated dates; HTTPS-or-state issue/PR identity; full Git baseline or `unknown`; SemVer target or `unallocated`; known horizon; valid supersession IDs; and exactly one of every plan/evidence/review/documentation/outcome section.
- Agent mistakes: exact admission/exclusion/template/Entries shape, stable append marker, unique dated IDs, UTC timestamps, supported classification, every required non-empty evidence field, and append-only incident bodies.

## Navigation and paths

All tracked Markdown links resolve relative to their file. Tracked instructions/templates/fixtures never contain workstation-specific drive-root paths, UNC paths, tilde/profile-variable home paths, or `/home/<user>` and `/Users/<user>` paths. Commands run from repository root and use relative paths. Generated documents emit forward-slash repository-relative paths.

## Verification limits

Structural checks validate files, headings, links, records, taxonomy, mistake-log append history, generated-view consistency, and the fixed issue-form schema. Issue forms use YAML's strict JSON subset so the PowerShell validator can parse them without an undeclared YAML module. Structural checks must not claim semantic truth. Exact-head PR review compares canonical claims with current code/configuration/callers.
