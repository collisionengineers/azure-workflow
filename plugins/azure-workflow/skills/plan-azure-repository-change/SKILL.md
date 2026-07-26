---
name: plan-azure-repository-change
description: Inspect and plan one change in an onboarded Azure-oriented repository, resolve material decisions with the user, persist one decision-complete change record, publish it through a documentation-only pull request when GitHub is in scope, independently review that exact PR, and stop before implementation. Use for feature, fix, architecture, UI/UX, .NET, operations, migration, or other material planning requests. Do not use for implementation, Azure mutation, explanation only, standalone PR review, or a compact mechanical delivery that meets every low-risk condition.
---

# Plan Azure Repository Change

Produce a repository-grounded plan that another agent can implement without rediscovering intent. Planning is a real repository outcome, but it never implements the product change.

## Confirm the planning endpoint

1. Confirm the user asked for planning only. If they asked to build/fix/deliver, route to `$deliver-azure-repository-change`, which may invoke this skill as its prerequisite.
2. Require an Azure Workflow-onboarded, Azure-oriented Git repository. Otherwise route to `$onboard-azure-repository` or explain the non-Azure boundary.
3. Work in Windows with PowerShell 7. Resolve the Git root, default branch, remotes, current branch/PR, worktrees, and dirty paths. Stop on unrelated changes; never stash, reset, clean, or create another worktree.
4. Invocation authorizes one planning branch/record, settled canonical documentation updates, narrow commits, push, a documentation-only PR, Docs CI remediation, fresh review publication, and return to `Ready`. It does not authorize implementation, runtime/IaC/executable-CI changes, Azure mutation, merge, issue closure, or speculative backlog expansion.
5. Call the real `update_plan` tool immediately and keep at most one step in progress.

## Establish change identity and baseline

Read [change planning](references/change-planning.md), [documentation lifecycle](references/documentation-lifecycle.md), [GitHub planning](references/github-planning.md), [UI/UX planning](references/ui-ux-planning.md), [risk scaling](../../references/risk-scaling.md), and [versioning/release stages](../../references/versioning-and-release-stages.md). Load the [shared .NET profile](../../references/dotnet-projects.md) only when .NET code/project/build/package/test/persistence/host/deployment is materially affected.

Resolve or create exactly one change identity:

- baseline commit and inspected repository state;
- product/capability authority and stable IDs;
- issue URL when required;
- target version, maturity stage, and roadmap horizon;
- branch `workflow/YYYYMMDD-<slug>` and `docs/changes/YYYY-MM-DD-<slug>.md`.

Never choose the newest plan or PR when more than one could match. Ask for the exact identity.

## Inspect repository reality

Inspect before interviewing:

- root and nearest `AGENTS.md`, `docs/index.md`, declared requirements/evidence sources, product, roadmap, architecture, operations, active ADRs, and relevant history;
- real entry-point-to-owner call paths, configuration/rule ownership, dependencies, tests, deployment/IaC, failure and recovery behavior;
- related issues, Project state, milestones, open PRs, prior decisions, and plans;
- UI design authority and runtime mappings when visual behavior is affected;
- .NET project/TFM/host/configuration/package/test/support facts when applicable.

Separate current behavior, intended authority, and your proposal. Code proves current behavior; it does not automatically define intended behavior.

Use Microsoft Learn only when a material decision depends on a current Microsoft-controlled fact or recommendation. Record the official URL, UTC retrieval time, scope/version, whether it is a requirement/recommendation/example, and its decision effect. Do not query it for pure repository-owned logic or repeat valid scoped evidence without a drift signal.

## Interview material decisions

Ask only questions whose answers materially change scope, behavior, architecture, UI, compatibility, data, Azure, release, or acceptance. Ask one at a time in plain English, lead with a recommended default and its consequence, retain answered decisions, and explain technical terms at the point of use.

Do not ask the user to decide facts discoverable from the repository. Do not manufacture a question to prolong planning. When evidence selects a safe default, state the assumption and proceed.

## Select risk and conditional routes

- `low`: planning depth may be concise, but invoking this skill still creates a record because the user requested a durable plan.
- `standard`: complete behavioral, data/failure, dependency, test, documentation, rollout/recovery, and review decisions.
- `high`: add supported-contract, identity/security, schema/migration, Azure/cost, production resilience, destructive-action, and rollback gates.

For UI impact, define user goal, actions, states, error/recovery behavior, accessible interaction, content, viewport/responsiveness, design sources, tokens/assets, and functional/visual evidence. Major visual direction remains a human decision. User-facing UI must not narrate obvious controls or expose internal Azure names.

For future features, create only currently exercised extension seams. Record later work; do not build dormant layers. In `development` mode, plan removal of replaced paths rather than unreleased compatibility, fallbacks, aliases, or dual behavior. In `released` mode, every compatibility bridge needs a supported contract, owner, activation scope, proof, removal trigger, and target version/date.

Treat supplied materials/software/services as permitted and licensed. Do not add unsolicited PII/DPA/DPIA/privacy/retention/licensing analysis or replace repository examples with synthetic data.

## Write and review the change record

Create the record using `../../scripts/New-AzureWorkflowChange.ps1` and [the packaged template](assets/change-record-template.md). It must be decision-complete and include:

- problem/outcome, included/excluded scope, authorities, baseline, constraints, risk, mode, version/horizon;
- observable acceptance, implementation order by owner/caller, affected files/components, data/failure/recovery, UI/UX and Azure impact;
- documentation impact: every canonical owner affected, or a specific reason none changes;
- proportional verification commands/procedures, negative/failure/recovery cases, CI classification, rollout/recovery;
- dependencies, conflicts, decisions, GitHub identity, Microsoft evidence, and explicit implementation stop.

Review the plan content in a fresh context for missing decisions, contradictions, unexecutable steps, overengineering, hidden compatibility, unproved assumptions, documentation drift, and insufficient acceptance. If fresh context is unavailable, prepare a copy-ready handoff and keep the plan blocked rather than self-certifying.

## Publish the plan and stop

1. Update only settled canonical product/roadmap/architecture/design/ADR facts; do not change implementation, runtime configuration, IaC, migrations, or executable CI.
2. Run the repository's Docs check, validate links/YAML/record schema, and check the diff.
3. Create/reuse an issue for standard/high-risk plans when GitHub is available. A low-risk plan need not create one unless requested or required. Never create an issue per capability row.
4. Commit literal owned paths, push, and create a documentation-only PR. Use `Refs #N`, never a closing keyword.
5. Keep it under review using native draft when supported or `do-not-merge` otherwise. Invoke `$review-repository-pull-request` in a fresh context against the actual complete PR; remediate documentation findings and repeat.
6. After the final record commit, require green Docs CI and a clean exact-head review, publish the result as a labelled COMMENT review, read back state, set a linked Project item to `Ready` when applicable, and stop. Do not implement or merge.

Return a compact handoff: what was decided, what remains excluded, where the record/PR lives, proof status, and exactly one next action.

## Failure behavior

- Missing onboarding or non-Azure scope: route or stop without mutation.
- Dirty tree: list exact relative paths and stop.
- Ambiguous existing identity: ask for the exact record/issue/PR.
- Material decision unresolved: set the record `blocked`, name the owner and affected sections, and stop.
- Current official evidence unavailable: block only the dependent decision.
- GitHub unavailable/excluded: complete local planning documentation but do not claim the normal ready-PR/Project endpoint.
- Fresh reviewer unavailable: retain draft/`do-not-merge`, provide the review packet, and stop.

## Resources

- [change planning](references/change-planning.md)
- [documentation lifecycle](references/documentation-lifecycle.md)
- [GitHub planning](references/github-planning.md)
- [UI/UX planning](references/ui-ux-planning.md)
- [change-record template](assets/change-record-template.md)
- [risk scaling](../../references/risk-scaling.md)
- [versioning and release stages](../../references/versioning-and-release-stages.md)
- [conditional .NET profile](../../references/dotnet-projects.md)
