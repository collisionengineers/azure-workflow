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

`docs/product/capabilities.md` and `docs/product/areas/` are conditional. Root `design/` is required only for a visual UI, but an existing valid design directory may remain when UI is absent.

## Required document fields

- Product index: mode, maturity, version scheme/current version, release authority, visual UI, purpose/problem, users/outcomes, success measures, scope, requirements/invariants, quality constraints, supported contracts, limitations, open decisions.
- Roadmap: only Now/Next/Later/Not planned; exact release or `unallocated`.
- Architecture: system/context, components/ownership, entry points/callers, data/integrations, rule/configuration owner, generated/source roles, failure/recovery, deployment, boundaries.
- Operations: prerequisites/toolchains, canonical check, local run/build/test, deploy, configuration/secrets boundary, monitoring/diagnosis, recovery, GitHub taxonomy/Project notes, supported platforms.
- ADR: status/context/decision/consequences; stable numbered filename.
- Change record: required metadata and all plan/evidence/review/documentation/outcome sections.
- Agent mistakes: exact admission/exclusion/template/Entries shape and append-only incident bodies.

## Navigation and paths

All tracked Markdown links resolve relative to their file. Tracked instructions/templates/fixtures never contain workstation-specific drive roots, UNC paths, or user-home paths. Commands run from repository root and use relative paths. Generated documents emit forward-slash repository-relative paths.

## Verification limits

Structural checks validate files, headings, links, records, taxonomy, mistake-log append history, generated-view consistency, and the fixed issue-form schema. Issue forms use YAML's strict JSON subset so the PowerShell validator can parse them without an undeclared YAML module. Structural checks must not claim semantic truth. Exact-head PR review compares canonical claims with current code/configuration/callers.
