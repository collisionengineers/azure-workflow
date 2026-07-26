# Azure Workflow

`azure-workflow` is a planned Codex plugin that will take durable ownership of repository onboarding, documentation, feature planning, implementation, plain-English explanation, pull-request review, GitHub delivery, and explicitly approved Azure operations.

Status: **planning is decision-complete; plugin implementation has not started.**

## What this is

The intended product is one reusable plugin for Azure-oriented repositories. It should be installable into an existing repository, discover the repository's real authority and implementation, convert its documentation and work-management system without losing material truth, and then own a restrained plan-deliver-review workflow.

The plugin is general. CollisionSpike and CollisionSpike v2 appear only as brownfield research cases used to expose failure modes. Their product rules, names, feature taxonomy, `operator-notes` convention, and design assets are not plugin defaults.

## Public workflows

The alpha contains six justified public skills:

| Skill | Standalone outcome |
| --- | --- |
| `onboard-azure-repository` | Convert an existing repository to the durable standard through a reviewed PR |
| `plan-azure-repository-change` | Produce a decision-complete plan and stop before implementation |
| `deliver-azure-repository-change` | Implement one change through a green, exact-head-reviewed PR |
| `explain-repository` | Explain code, behavior, terminology, checks, or feedback in plain English without changing anything |
| `review-repository-pull-request` | Independently assess an actual pull request without fixing it |
| `operate-azure-repository` | Inspect live Azure state and perform only separately approved mutations |

UI/UX, documentation maintenance, GitHub work tracking, testing/CI, versioning, and .NET are routed concerns within those outcomes. They do not become skills merely to make the package look modular.

## Design summary

- One plugin, not one plugin per lifecycle stage.
- Exactly two packaged MCP connections: Azure MCP and Microsoft Learn MCP.
- GitHub uses Git, `gh`, and `gh api`; no second GitHub MCP path is packaged.
- No hook, app connector, workflow database, generated task ledger, or repository-local copy of upstream Microsoft documentation in the alpha.
- One change record per active change; GitHub owns live work state.
- Product truth, roadmap, current architecture, operations, decisions, design authority, and change evidence have separate durable owners.
- Large capability catalogs remain stable indexes and product contracts; only activated outcomes become issues.
- Markdown-only work receives documentation checks rather than unrelated application/database/Azure suites.
- Implementation ends at a real pull request reviewed at its exact final head. The plugin does not merge.

See [the approved plan](planning/00-approved-plan.md) and [system architecture](planning/01-system-architecture.md).

## What went wrong before

The previous workflow grew into eight installable plugins, dozens of overlapping skills, repository-local copies of third-party skills and documentation, a task-state system, generated ledgers, duplicate routing, duplicated UI assets, stale hooks, and validators coupled to those internals. It became difficult to identify which rule or component actually controlled behavior. Planning and governance arrived after implementation, creating churn and competing sources of truth.

This repository rejects those mechanisms explicitly. “Do not overengineer” here means:

- no lifecycle package explosion;
- no skill without a distinct user endpoint and stopping boundary;
- no state protocol where one ordinary change record and GitHub state suffice;
- no speculative future architecture, fallbacks, or dormant implementations in development mode;
- no duplicated policy, assets, checks, or external documentation; and
- no heavyweight verification unrelated to the changed paths.

The full rules are in [AGENTS.md](AGENTS.md).

## Repository map

```text
planning/     approved specification, workflows, standards, interfaces, and research
ref-files/    read-only source material from previous attempts; extraction evidence only
.codex/       local workspace configuration used while developing this repository
.obsidian/    shared Markdown workspace metadata
hooks.json    retained legacy input; not the approved plugin hook design
```

The future implementation will add the plugin, repository documentation, scripts, tests, GitHub forms/templates, and CI described by [the exact file-tree contract](planning/02-plugin-file-tree.md).

## Start here

Read in this order:

1. [Planning index](planning/README.md)
2. [Approved plan](planning/00-approved-plan.md)
3. [System architecture](planning/01-system-architecture.md)
4. [Exact plugin file tree](planning/02-plugin-file-tree.md)
5. The relevant skill, workflow, standard, or interface document for the change
6. [Implementation sequence](planning/delivery/implementation-sequence.md) when implementation begins

`ref-files/` is not part of the reading path unless a planning or implementation question needs provenance from an earlier attempt.

## How to develop it

All work is performed on Windows with PowerShell 7.

For planning changes:

1. inspect the real repository and owning planning document;
2. change the smallest canonical source;
3. update affected links, counts, file trees, examples, tests, and acceptance criteria;
4. keep case-study facts out of packaged defaults;
5. run `git diff --check`, validate relative Markdown links, and search for contradictions; and
6. report any validation that cannot run because implementation does not yet exist.

For implementation:

1. create the package with the built-in `plugin-creator` flow;
2. initialize each approved skill with `skill-creator`;
3. keep each `SKILL.md` concise and directly route conditional references;
4. use scripts only for deterministic/repeated operations and assets only for output material;
5. validate the manifest and all six skills;
6. run fixture and fresh-thread activation tests;
7. install through the local marketplace and test the two MCP routes; and
8. deliver through CI and a complete review of the actual pull request.

The detailed order and gates are in [plugin implementation sequence](planning/delivery/implementation-sequence.md).

## Guidance used

The design follows current published guidance rather than optimizing for the smallest visible skill count:

- [OpenAI: AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md) — keep durable repository guidance practical, concise, layered, and close to the code it governs.
- [OpenAI: Build skills](https://developers.openai.com/plugins/build/skills) — use recognizable task-specific workflows, precise descriptions, progressive disclosure, optional scripts/references, and representative testing.
- [OpenAI: Plugins](https://developers.openai.com/plugins/) — use a plugin as the installable bundle for related skills and MCP connections.
- [Agent Skills specification](https://agentskills.io/specification) — `SKILL.md` metadata and portable optional-resource structure.

## Repository assumptions

Provided emails, PDFs, documents, images, datasets, examples, software, and services are assumed to have the permissions and licences required for development and testing. The workflow does not create privacy, DPIA, retention, or licensing gates and does not fabricate replacement operational examples.

User-facing applications produced through this workflow must use purpose-revealing controls and labels, avoid narrating obvious functions, and never expose internal Azure resource or implementation terminology.

## Current verification boundary

There is no plugin build or canonical repository check yet. Until implementation creates it, do not claim package, skill, MCP, fixture, or installed-workflow validation. Planning changes can currently prove Markdown links, internal consistency, `git diff --check`, and direct inspection only.
