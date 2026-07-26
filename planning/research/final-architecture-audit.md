# Final architecture audit

Date: 2026-07-26

## Verdict

The selected product remains one `azure-workflow` plugin with six public skills, two MCP servers, four deterministic PowerShell helpers, and no hooks or app connector. It is reusable across Azure-oriented repositories and contains no CollisionSpike product defaults.

Implementation must not begin from the earlier specification unchanged. This audit closes the remaining contradictions and removes three sources of avoidable ceremony.

## Azure scope

The supported repository scope is deliberately Azure-oriented rather than universal.

A repository qualifies when either:

1. repository evidence identifies Azure as a current or intended deployment or operations target; or
2. the user explicitly declares Azure as the intended target, including for a greenfield repository.

A .NET project alone does not establish Azure scope. Onboarding stops without mutation when neither evidence nor explicit intent establishes it. “General” means independent of any one product, company, architecture, language, or Azure service choice within this Azure-oriented scope.

## Proportional delivery

The previous plan required the complete durable change record for every edit. That would make typo, link, and formatting work need the same documentation envelope as a feature or migration.

Low-risk delivery may skip the durable change record only when all of these are true:

- no product behavior, API, supported contract, data/schema, authentication, dependency, architecture, operations, UI meaning, IaC, Azure, migration, or release effect;
- scope and expected result are unambiguous;
- the change is mechanical and readily reversible; and
- repository authority does not require a durable record.

The low-risk path uses a compact in-session scope/proof checklist, proportional checks, the normal pull request, and exact-head review. It creates no issue, Project item, or change record unless one is explicitly requested. The PR records `Change record: not required — low-risk mechanical change`.

Any expanded scope or material review finding promotes the work to standard risk before implementation continues. Onboarding and standard/high-risk delivery always use a durable change record. A standalone planning request retains the persisted planning endpoint.

## Planning-pack retirement

The planning pack is bootstrap authority, not part of the released repository documentation system. Keeping it beside `docs/product/`, architecture, operations, ADRs, skills, and tests would create a competing source of truth.

After implementation, map its material content as follows:

| Planning content | Final owner |
| --- | --- |
| Product scope and supported workflows | `docs/product/` |
| Current component ownership | `docs/architecture.md` |
| Installation, validation, MCP, and recovery | `docs/operations.md` and root `README.md` |
| Durable reasons | `docs/decisions/` |
| Workflow behavior | Plugin skills and direct references |
| Mechanical rules | Scripts, fixtures, and CI |
| Bootstrap evidence | Bootstrap change record, pull request, commits, and Git history |

Delete `planning/`, `ref-files/`, `.codex/`, `.obsidian/`, and root `hooks.json` only after decision parity, authority/link parity, executable-test parity, and Git recoverability pass.

## Skill and MCP corrections

- Keep the six public skills and their existing names.
- Limit plugin-level starter prompts to onboarding, planning, and delivery. Each skill keeps its own starter prompt.
- Declare Microsoft Learn in `agents/openai.yaml` for every skill that may require current Microsoft evidence. Availability does not bypass the call gate.
- Keep Azure MCP as a direct dependency only of `operate-azure-repository`; other skills route live Azure work through it.
- Move risk scaling and version/release guidance to shared plugin-root references and link them directly from every consumer.
- Retain the `mcpServers` companion shape accepted by the current creator validator and installed Codex plugins, then prove both servers through installed smoke tests.

## Review-context fallback

Onboarding, standard/high-risk plan publication, and delivery use this order:

1. Invoke a fresh reviewer/subagent context when the active Codex surface supports it.
2. Pass raw authority, request, exact pull request identity, stable base/head, complete diff, and evidence without a desired verdict.
3. If fresh context is unavailable, retain draft or `do-not-merge`, emit a copy-ready `$review-repository-pull-request` prompt, and stop.
4. Never substitute same-context self-review for the independent gate.
5. Invalidate the verdict after every tracked commit and repeat complete review.

## Hooks correction

Current OpenAI plugin documentation supports lifecycle hooks, while the installed creator validator still rejects a manifest `hooks` field. The plugin omits hooks because no demonstrated failure requires them, not because the platform lacks them.

Reconsider a hook only after a repeated real failure proves that `AGENTS.md`, skill procedures, deterministic validators, CI, and explicit Azure approval are insufficient, and after the installed hook path is proven portable and trusted.

## Alpha validation boundary

Release-blocking validation covers package/skill schemas, deterministic helpers, six route boundaries, low-risk escalation, one representative brownfield onboarding, actual pull-request evidence and remediation, personal-account GitHub behavior, both MCP registrations, an Azure read probe, the Azure mutation stop, and planning-pack retirement parity.

The wider scenario list remains a regression catalogue. A scenario becomes an alpha blocker only when it protects a supported contract, reproduces a real prior failure, or exercises code changed by the implementation.

## Current implementation baseline

- Local Git repository exists on `main` with planning baseline commit `061cc69`.
- No Git remote is configured.
- The current planning revision is uncommitted.
- `.obsidian/workspace.json` contains an unrelated user-owned modification and must not be staged in the planning closeout.
- Required toolchains are present, including `gh`, `az`, `azd`, Node/npm, Python, and .NET.
- Live Azure acceptance remains blocked by an access-denied error for the Azure CLI `account` extension metadata. Package construction may continue; an Azure-validated alpha may not be claimed until `az account show` succeeds.
