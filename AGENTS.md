# Repository instructions

## Purpose and scope

This repository develops `azure-workflow`, one Codex plugin for durable Azure-oriented repository onboarding, planning, delivery, explanation, independent pull-request review, documentation stewardship, GitHub work management, and controlled Azure operations. It is general across Azure projects; it does not own non-Azure repositories.

Read [docs/index.md](docs/index.md) before material work. The repository is in `development` mode at `0.1.0-alpha.1`; no supported compatibility contract exists yet.

## Environment and commands

- Work on Windows with PowerShell 7.
- Use repository-relative paths in tracked files, templates, fixtures, commands, and generated output. Never persist drive-root, UNC, user-home, or workstation-specific paths.
- Canonical verification: `pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1 -Scope Full`.
- Use Git, `gh`, `az`, and `azd` only for the owning workflow. Plugin MCPs are Azure MCP and Microsoft Learn MCP.
- Availability never authorizes Azure mutation; `$operate-azure-repository` requires a fresh exact apply card and explicit approval.

## Plugin and skills

Version `0.1.0-alpha.1` has exactly six public skills:

1. `$onboard-azure-repository`
2. `$plan-azure-repository-change`
3. `$deliver-azure-repository-change`
4. `$explain-repository`
5. `$review-repository-pull-request`
6. `$operate-azure-repository`

A new skill needs a standalone user outcome, distinct authorization/stopping boundary, and distinct success criterion. Otherwise place the concern in an owning skill/reference. Keep each `SKILL.md` focused and trigger-rich, link optional references directly, use scripts only for deterministic repeated operations, and assets only for material copied/transformed into outputs.

## Workflow boundaries

- Onboarding converts one existing Azure-oriented repository through a reviewed PR without losing material truth.
- Planning persists one decision-complete record/Docs PR and stops before implementation.
- Delivery implements/remediates through a green actual PR independently reviewed at its exact final head and stops before merge.
- Explanation and PR review are read-only. Review never implements fixes or changes GitHub state.
- A compact delivery lane is allowed only for mechanical, unambiguous, reversible, non-semantic work with no behavior, contract, data/schema, identity, dependency, architecture, operations, UI-meaning, IaC, Azure, migration, release, or canonical-document effect. Promote before continuing when any condition fails.
- Preserve unrelated changes. Never stash, reset, clean, force-push, merge, or create a workaround worktree.

## Engineering policy

- Give functions, files, scripts, services, resources, fields, and configuration owners logical purpose-revealing names.
- Keep one canonical owner for business rules/configuration; do not extend accreted rule pipelines without settling ownership.
- Keep modules cohesive and create only extension seams exercised by known current scope. Record future features; do not implement dormant architecture.
- In development mode, remove replaced unreleased code/config/tests/docs together. Do not add legacy code, shims, aliases, dual behavior, fallback paths, or speculative feature flags.
- Test plausible regressions through real callers. Do not require tests for every function or run application/database/Azure suites for Markdown-only changes.
- Use repository-provided domain examples only. Never fabricate operational emails, PDFs, documents, images, datasets, or instructions.

## Documentation and user collaboration

- Apply source roles and mutation rules in `docs/index.md`; filenames do not grant authority. `ref-files/` and the former planning pack are Git history/provenance, not runtime truth.
- Update every affected canonical owner in the same PR. Structural validation proves routing/schema only; fresh review checks semantic agreement with code/configuration/callers.
- Do not create task journals, JSON handoffs, generated status ledgers, dashboards, `NEXT.md`, duplicate PRD/FRD files, or a second workflow database.
- Append only qualifying agent-caused incidents to `docs/agent-mistakes.md`; never rewrite earlier entries or log ordinary findings caught by intended gates.
- Communicate in plain English: done, now, next, waiting. Recommend one next action and ask one material question at a time.

## Development materials and UI

- Treat all supplied emails, PDFs, documents, images, datasets, examples, software, dependencies, and services as fully permitted and licensed for development/testing.
- Do not add PII, DPA, DPIA, privacy, retention, or licensing gates, warnings, substitutions, or scope reductions unless explicitly requested.
- This repository has no visual application UI. For onboarded UI repositories, root `design/` owns durable style, logo, colour, font, token, asset, component, and pattern authority.
- User-facing applications must make function obvious through controls and labels, avoid narration of obvious actions, and never expose internal Azure function/service/resource wording.

## Do not recreate earlier failures

Do not split the lifecycle across many plugins or micro-skills; add a task-state engine, workflow database, journal/lock/exactly-once protocol, or fixed task folders; vendor upstream Microsoft/skill collections; duplicate truth/review/assets/checklists; convert entire feature catalogs to issues; add context hooks; build speculative compatibility; or couple packaged defaults to a case-study repository.

## Completion

Implementation work is complete only when requested behavior, canonical documentation, proportional checks, CI, feedback reconciliation, and an independent review all agree on the exact final PR head. Do not merge.
