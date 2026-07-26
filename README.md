# Azure Workflow

Azure Workflow is one Codex plugin that takes durable ownership of Azure-oriented repository onboarding, documentation, planning, implementation, plain-English explanation, pull-request review, GitHub work management, and explicitly approved Azure operations.

Current version: `0.1.0-alpha.1`.

## What it provides

| Skill | Outcome |
| --- | --- |
| `onboard-azure-repository` | Convert an existing Azure repository to the documentation/GitHub/workflow standard through a reviewed PR |
| `plan-azure-repository-change` | Create a repository-grounded, decision-complete plan and stop before implementation |
| `deliver-azure-repository-change` | Implement or remediate one change through a green exact-head-reviewed PR |
| `explain-repository` | Explain code, architecture, failures, GitHub feedback, current position, and one next action in plain English |
| `review-repository-pull-request` | Independently review the complete actual PR without fixing or mutating it |
| `operate-azure-repository` | Inspect live Azure and apply only a separately approved exact mutation |

The package includes exactly two MCP connections: the pinned Azure MCP and Microsoft Learn MCP. GitHub uses Git and `gh`; there is no GitHub MCP, hook, workflow database, or background organizer.

## Workflow

```text
existing Azure repository
        |
        v
onboard -> canonical docs + GitHub routing + proportional CI -> reviewed PR
        |
        +--> plan -> one decision-complete record -> reviewed Docs PR -> STOP
        |
        +--> deliver -> implementation + docs + CI -> actual PR review/remediation -> STOP
        |
        +--> explain -> plain-English understanding + one next action (read-only)
        |
        +--> review PR -> exact-head findings/verdict (read-only)
        |
        `--> operate Azure -> read evidence -> exact apply card -> approval -> apply/readback
```

Truly mechanical, reversible, non-semantic delivery can use a compact lane with no issue/change record. Any behavior, contract, data, identity, dependency, architecture, operations, UI meaning, IaC, Azure, migration, release, or canonical-document impact promotes it to the normal plan-bearing route.

## Repository documentation model

- [Product requirements](docs/product/index.md) own intended behavior and constraints.
- [Capabilities](docs/product/capabilities.md) provide stable IDs and release allocation without creating issues for every idea.
- [Roadmap](docs/roadmap.md) owns Now/Next/Later/Not planned outcomes.
- [Architecture](docs/architecture.md) owns current components, callers, and rule/configuration boundaries.
- [Operations](docs/operations.md) owns commands, release/install, GitHub, and recovery procedures.
- [Decisions](docs/decisions/) own durable hard-to-reverse choices.
- [Change records](docs/changes/) own one change's plan and evidence, then become history.
- [Agent mistake log](docs/agent-mistakes.md) is append-only evidence for future plugin improvement.

GitHub owns actionable/live work. Large feature lists become product/capability/roadmap truth first; only a small activated set becomes issues.

## Develop and verify

All supported development runs on Windows in PowerShell 7.

```powershell
pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1 -Scope Full
```

`Docs` scope validates documentation/schema/routing only. `Full` also validates the package, skills, scripts, fixtures, and deterministic helpers. `Auto` classifies changed paths and fails safe to Full.

The plugin follows current OpenAI guidance: one installable plugin for related capabilities; task-specific skills with precise descriptions; concise procedural `SKILL.md` files; direct progressive-disclosure references; scripts for deterministic operations; assets for copied output; practical layered `AGENTS.md`; and fresh representative skill tests.

## Install during alpha development

From the repository root, first validate, then register this repository as a personal marketplace and install/update `azure-workflow` using the current Codex plugin CLI. See [operations](docs/operations.md) for the exact commands and cachebuster/reinstall procedure.

Azure live acceptance requires working local Azure authentication. A repository or product implementation request never authorizes a live Azure change; the operate skill always presents the exact scope and mutation for separate approval.

## Boundaries

The plugin is for Azure-oriented repositories established by repository evidence or explicit user intent. .NET alone is not Azure evidence. UI/UX, .NET, testing, documentation maintenance, versioning, and GitHub are conditional concerns inside the six user workflows, not extra skills.

It deliberately excludes the failure modes of earlier attempts: lifecycle plugin proliferation, overlapping micro-skills, task-state protocols, generated ledgers, copied upstream documentation, duplicate policy/assets, speculative architecture/fallbacks, hundreds of issues created from feature catalogs, and expensive checks unrelated to changed paths.
