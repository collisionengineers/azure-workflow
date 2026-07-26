# Exact target file tree

This is the intended tracked tree for the plugin repository after implementation. Every optional-looking folder shown here is required for `0.1.0-alpha.1`; no unlisted skill resource is created.

```text
azure-workflow/
|-- .agents/
|   `-- plugins/
|       `-- marketplace.json
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |   |-- bug.yml
|   |   |-- config.yml
|   |   |-- decision.yml
|   |   |-- feature.yml
|   |   `-- task.yml
|   |-- pull_request_template.md
|   `-- workflows/
|       `-- verify.yml
|-- AGENTS.md
|-- .gitignore
|-- README.md
|-- docs/
|   |-- index.md
|   |-- product/
|   |   |-- index.md
|   |   `-- capabilities.md
|   |-- roadmap.md
|   |-- architecture.md
|   |-- operations.md
|   |-- agent-mistakes.md
|   |-- decisions/
|   |   `-- 0001-single-plugin-six-skill-architecture.md
|   `-- changes/
|       `-- 2026-07-26-bootstrap-azure-workflow.md
|-- plugins/
|   `-- azure-workflow/
|       |-- .codex-plugin/
|       |   `-- plugin.json
|       |-- .mcp.json
|       |-- references/
|       |   |-- dotnet-projects.md
|       |   |-- risk-scaling.md
|       |   `-- versioning-and-release-stages.md
|       |-- scripts/
|       |   |-- Get-AzureWorkflowPullRequestEvidence.ps1
|       |   |-- New-AzureWorkflowChange.ps1
|       |   |-- Test-AzureWorkflowPlugin.ps1
|       |   `-- Test-AzureWorkflowRepository.ps1
|       `-- skills/
|           |-- onboard-azure-repository/
|           |   |-- SKILL.md
|           |   |-- agents/
|           |   |   `-- openai.yaml
|           |   |-- assets/
|           |   |   `-- repository/
|           |   |       |-- AGENTS.md.template
|           |   |       |-- agent-mistakes.md.template
|           |   |       |-- architecture.md.template
|           |   |       |-- docs-index.md.template
|           |   |       |-- operations.md.template
|           |   |       |-- product-index.md.template
|           |   |       |-- roadmap.md.template
|           |   |       |-- pull-request-template.md
|           |   |       |-- design/
|           |   |       |   |-- README.md.template
|           |   |       |   |-- brand/
|           |   |       |   |   |-- style.md.template
|           |   |       |   |   |-- imagery.md.template
|           |   |       |   |   `-- logos/
|           |   |       |   |       `-- README.md.template
|           |   |       |   |-- foundations/
|           |   |       |   |   |-- colour.md.template
|           |   |       |   |   |-- typography.md.template
|           |   |       |   |   |-- spacing-and-layout.md.template
|           |   |       |   |   |-- motion.md.template
|           |   |       |   |   `-- accessibility.md.template
|           |   |       |   |-- tokens/
|           |   |       |   |   `-- README.md.template
|           |   |       |   |-- assets/
|           |   |       |   |   |-- icons/
|           |   |       |   |   |   `-- README.md.template
|           |   |       |   |   `-- fonts/
|           |   |       |   |       `-- README.md.template
|           |   |       |   |-- components/
|           |   |       |   |   `-- index.md.template
|           |   |       |   |-- patterns/
|           |   |       |   |   `-- index.md.template
|           |   |       |   `-- references/
|           |   |       |       `-- README.md.template
|           |   |       `-- issue-forms/
|           |   |           |-- bug.yml
|           |   |           |-- config.yml
|           |   |           |-- decision.yml
|           |   |           |-- feature.yml
|           |   |           `-- task.yml
|           |   `-- references/
|           |       |-- authority-and-conflicts.md
|           |       |-- documentation-conversion.md
|           |       |-- feature-catalog-conversion.md
|           |       |-- github-onboarding.md
|           |       |-- repository-policy-profile.md
|           |       |-- repository-standard.md
|           |       `-- ui-design-system.md
|           |-- plan-azure-repository-change/
|           |   |-- SKILL.md
|           |   |-- agents/
|           |   |   `-- openai.yaml
|           |   |-- assets/
|           |   |   `-- change-record-template.md
|           |   `-- references/
|           |       |-- change-planning.md
|           |       |-- documentation-lifecycle.md
|           |       |-- github-planning.md
|           |       `-- ui-ux-planning.md
|           |-- deliver-azure-repository-change/
|           |   |-- SKILL.md
|           |   |-- agents/
|           |   |   `-- openai.yaml
|           |   `-- references/
|           |       |-- documentation-maintenance.md
|           |       |-- git-and-pr.md
|           |       |-- github-delivery.md
|           |       |-- implementation-quality.md
|           |       |-- repository-modes.md
|           |       |-- pr-review-remediation.md
|           |       |-- testing-and-ci.md
|           |       `-- ui-ux-delivery.md
|           |-- explain-repository/
|           |   |-- SKILL.md
|           |   |-- agents/
|           |   |   `-- openai.yaml
|           |   `-- references/
|           |       |-- code-and-system-explanation.md
|           |       `-- github-feedback-explanation.md
|           |-- review-repository-pull-request/
|           |   |-- SKILL.md
|           |   |-- agents/
|           |   |   `-- openai.yaml
|           |   `-- references/
|           |       |-- pr-evidence-collection.md
|           |       `-- review-contract.md
|           `-- operate-azure-repository/
|               |-- SKILL.md
|               |-- agents/
|               |   `-- openai.yaml
|               `-- references/
|                   |-- azure-evidence.md
|                   |-- azure-safety-and-approval.md
|                   `-- iac-and-drift.md
|-- scripts/
|   `-- Invoke-RepoCheck.ps1
`-- tests/
    |-- fixtures/
    |   |-- accreted-rule-system/
    |   |-- compliant-repository/
    |   |-- conflicting-documentation/
    |   |-- custom-issue-taxonomy/
    |   |-- design-existing-system/
    |   |-- design-new-system/
    |   |-- domain-leak/
    |   |-- dotnet-repository/
    |   |-- human-requirements-sources/
    |   |-- large-feature-catalog/
    |   |-- malformed-change-record/
    |   |-- missing-authority/
    |   |-- no-visual-ui/
    |   |-- overloaded-work-ledger/
    |   |-- stale-workflow-suite/
    |   `-- pull-request-evidence/
    |       |-- evidence-changed-with-stable-head.json
    |       |-- head-changed.json
    |       |-- stable-paginated.json
    |       `-- unresolved-threads.json
    |-- Test-PluginPackage.ps1
    |-- Test-PullRequestEvidence.ps1
    |-- Test-RepositoryStandard.ps1
    `-- scenarios.md
```

The planning pack and source inputs exist during bootstrap only. The final tracked release tree excludes `planning/`, `ref-files/`, `.codex/`, `.obsidian/`, and root `hooks.json` after their material decisions, links, and executable contracts have passed parity and remain recoverable through Git.

## Why resources live there

| Resource | Owner | Reason |
| --- | --- | --- |
| Repository spine and GitHub templates | Onboarding assets | They are copied/transformed during conversion; OpenAI guidance treats reusable output templates as assets |
| Agent mistake-log template | Onboarding asset | It becomes repository output; the standard supplies a stable append schema while no script, database, or incident-per-file machinery is justified |
| Conditional design spine | Onboarding assets | UI-bearing repositories need a predictable authority; templates contain schemas only and never a palette, logo, font, token values, or product copy |
| Change-record template | Planning asset | Planning creates the record; delivery reuses it and never owns a second copy |
| PR body | Target repository `.github/pull_request_template.md` | Onboarding establishes it; delivery reads it rather than packaging a duplicate |
| Deterministic helpers | Plugin-root `scripts/` | All skills share one tested implementation |
| PR evidence collection | Shared helper plus review fixtures | REST/GraphQL pagination and head stability are fragile enough to require deterministic code and fixtures |
| Shared lifecycle policy | Plugin-root `references/{dotnet-projects,risk-scaling,versioning-and-release-stages}.md` | Cross-stage rules have one owner and every consumer links them directly; goal-specific procedures remain skill-local |
| Explanation procedures | `explain-repository/references/` | Code/system tracing and GitHub-feedback translation are conditionally different evidence routes under one read-only understanding endpoint |
| Policies and decision procedures | Owning skill `references/` | Loaded only when the route requires them; no reference-to-reference chase |
| UI/UX planning vs delivery | Separate conditional references | Requirements/direction and implementation/proof have different stages, but UI remains part of one parent outcome |

Only the four universal issue forms are packaged. A purpose-specific form belongs to the onboarded target repository and is generated/adapted only after the taxonomy admission test; the plugin does not ship speculative per-domain form assets.

## Explicitly absent

These paths must not exist in `0.1.0-alpha.1`:

```text
plugins/azure-workflow/hooks.json
plugins/azure-workflow/.app.json
plugins/azure-workflow/assets/
plugins/azure-workflow/skills/ui-*
plugins/azure-workflow/skills/document-*
plugins/azure-workflow/skills/test-*
.repoplugin/
ref-files/
.codex/
.obsidian/
hooks.json
planning/
```

## Folder rules

- Every public skill has exactly one `SKILL.md` and one `agents/openai.yaml`.
- `SKILL.md` files are concise routing/orchestration contracts and remain below 500 lines.
- Every reference is directly linked by each consuming `SKILL.md`; references do not require further reference chasing. Goal-specific references are skill-local; the one shared .NET profile is plugin-root-owned.
- Assets contain only reusable files copied or transformed into repository output.
- The onboarding design templates are instantiated only when `Visual UI: present`; no binary/font/logo/token placeholder is packaged or synthesized.
- No individual skill has `scripts/`; shared deterministic helpers live at the plugin root.
- Plugin-root scripts ship with the plugin. Repository-root scripts/tests build and verify the plugin itself.
- Skills contain no README, changelog, installation guide, planning history, repository-specific feature facts, or generated state.
- The package validator compares the actual tree to this allowlist and fails on missing or unexpected resources.
- Repository-root package tests reject source-project terminology/assets and absolute workstation paths; the portable installed-plugin validator contains no source-project denylist.
