# Architecture

## System context

```text
user + target Azure repository + GitHub + Azure
                       |
                       v
             Codex Azure Workflow plugin
                       |
       +---------------+----------------+
       |               |                |
   six skills     deterministic     Azure + Learn
   (user goals)     helpers             MCPs
       |
       v
canonical target-repo docs + GitHub issues/Project/PR + reviewed change
```

The plugin is an instruction/tool bundle executed by Codex. It has no daemon, database, task engine, hook, or hosted service.

## Components and ownership

| Component | Owner | Responsibility |
| --- | --- | --- |
| plugin manifest | `plugins/azure-workflow/.codex-plugin/plugin.json` | package identity, public metadata, skill/MCP routes |
| MCP registration | `plugins/azure-workflow/.mcp.json` | namespaced `azure-workflow-azure` pinned Azure MCP and `azure-workflow-microsoft-learn` remote Microsoft Learn MCP |
| six skill entry points | `plugins/azure-workflow/skills/*/SKILL.md` | routing, authorization, sequence, endpoint |
| skill references/assets | each owning skill | conditional procedures and neutral output material |
| shared lifecycle profiles | `plugins/azure-workflow/references/` | risk, version/release, and conditional .NET and architectural-style policy |
| deterministic helpers | `plugins/azure-workflow/scripts/` | record creation, package/repository validation, PR evidence collection |
| repository development check | `scripts/Invoke-RepoCheck.ps1` | Docs/Full path classification and test orchestration |
| fixtures/tests | `tests/` | deterministic contract regression evidence |
| target repository | its canonical docs/GitHub/IaC | durable product truth and live work/desired state |

## Entry points and callers

Codex discovers a skill from its frontmatter and `agents/openai.yaml`, loads that `SKILL.md`, then loads only directly linked relevant references. Onboarding/plan/delivery invoke the public read-only review skill in a fresh context after a PR exists. Delivery routes live Azure effects to the operate skill; operate routes IaC source changes back to delivery.

Scripts are called by skills or the root verification wrapper. They never stage, commit, push, merge, update GitHub, or mutate Azure.

## Data and integrations

- Repository files and Git history are the durable evidence store.
- GitHub Issues/Projects/PRs own actionable/live work and review evidence; Git/`gh`/GraphQL provide access.
- Microsoft Learn MCP supplies current official guidance when a decision depends on it.
- Azure MCP and `az`/`azd` supply observed Azure state; credentials remain in the local Azure credential chain.
- No user/domain data is copied into the plugin package.

## Rule and configuration ownership

Public routing/authorization lives in each skill entry point. Detailed procedures live once in the nearest direct reference. Cross-workflow lifecycle rules live once under plugin `references/`. Target-repository policy belongs in its `AGENTS.md` and canonical docs; the package supplies only neutral standards/templates.

No second workflow state or hidden configuration owner exists. GitHub identifiers are discovered at runtime rather than persisted in repository JSON.

## Source roles and generated material

| Path | Role | Canonical source/generator | Consumer |
| --- | --- | --- | --- |
| `.agents/plugins/marketplace.json` | local marketplace source | plugin-creator scaffold and reviewed edits | Codex plugin CLI |
| `plugins/azure-workflow/skills/*/assets/` | neutral source templates | reviewed package source | onboarded repository files |
| `docs/changes/*.md` | durable change evidence | change-record template plus owning workflow | humans and delivery/review |
| plugin installation cache | generated local material | Codex plugin CLI from this marketplace | new Codex threads |

The retired planning/reference corpus remains recoverable in Git history only and is not a runtime source.

## Failure and recovery

- Missing/ambiguous authority, identity, or scope stops the owning workflow with one focused question.
- Dirty unrelated paths stop mutation without stash/reset/clean.
- Missing current Microsoft evidence blocks only the dependent decision.
- GitHub incomplete/unstable evidence produces `evidence-blocked`; no partial clean verdict.
- Azure authentication failures are explicit blockers, not empty resource results.
- Azure apply failure stops automatic retry, preserves observed state, and requires a new recovery approval card.
- Plugin installation is recoverable by validation, cachebuster replacement, remove/add, and a new thread.

## Deployment topology

The repository is the public source marketplace. Codex installs a local cached plugin copy. Azure MCP starts locally through pinned `npx`; Microsoft Learn uses remote streamable HTTP. The plugin itself deploys no Azure resource.

## Architecture boundaries

No hooks, apps, background process, database, task-state engine, generated dashboard, vendored documentation corpus, repository-specific product rules/assets, or automatic merge/Azure write. A seventh public skill requires a genuinely new user endpoint and boundary.
