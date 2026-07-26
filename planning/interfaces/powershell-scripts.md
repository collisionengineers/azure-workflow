# PowerShell helper contracts

All plugin-owned scripts target PowerShell 7, use `Set-StrictMode -Version Latest`, set `$ErrorActionPreference = 'Stop'`, accept literal repository paths, and never mutate Git or Azure state unless their contract explicitly says so.

## `New-AzureWorkflowChange.ps1`

Path: `plugins/azure-workflow/scripts/New-AzureWorkflowChange.ps1`

Purpose: create one change record from the packaged template. It creates a file only; it does not create branches, commits, issues, PRs, or workflow state.

Interface:

```powershell
param(
    [string]$RepositoryPath = '.',
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9]+(?:-[a-z0-9]+)*$')][string]$Slug,
    [Parameter(Mandatory)][string]$Title,
    [ValidateSet('onboarding', 'feature', 'fix', 'documentation', 'operations')]
    [string]$Type = 'feature',
    [ValidateSet('active', 'planned')]
    [string]$Status = 'active',
    [string]$Issue = 'none'
)
```

Behavior:

- Resolve `RepositoryPath` to an absolute path and require `docs/changes/` to exist.
- Use the current UTC date and create `docs/changes/YYYY-MM-DD-<slug>.md`.
- Copy `skills/plan-azure-repository-change/assets/change-record-template.md` and replace its declared placeholders.
- Set status from `-Status`, PR to `none`, and preserve the supplied issue string or URL. The plan-only route passes `-Status planned`; delivery passes `-Status active`.
- Refuse to overwrite an existing file.
- Reject path traversal and slugs outside the declared pattern.
- Print a compact JSON result containing `path`, `slug`, `type`, and `status`.

Exit codes: `0` success, `1` validation/refusal, `2` unexpected runtime failure.

## `Get-AzureWorkflowPullRequestEvidence.ps1`

Path: `plugins/azure-workflow/scripts/Get-AzureWorkflowPullRequestEvidence.ps1`

Purpose: collect one stable, complete, read-only GitHub pull-request evidence snapshot. It centralizes pagination and GraphQL thread handling so review does not rely on incomplete `gh pr view --comments` output.

Interface:

```powershell
param(
    [string]$RepositoryPath = '.',
    [Parameter(Mandatory)][ValidateRange(1, [int]::MaxValue)]
    [int]$PullRequest,
    [switch]$Json
)
```

Behavior:

- Resolve the literal Git root and `OWNER/REPOSITORY` through local Git plus `gh repo view`.
- Require authenticated read access and an open or closed PR with the exact requested number.
- Read PR metadata and capture starting `baseRefOid`, `headRefOid`, and `updatedAt`.
- Exhaust REST pagination for files, commits, submitted reviews, inline review comments, and issue comments.
- Exhaust GraphQL pagination for `reviewThreads` and every thread's comments; retain `isResolved`, `isOutdated`, `resolvedBy`, path/line, authors, timestamps, IDs, bodies, and URLs.
- Exhaust the check/status rollup and collect each context's stable identity, name, state/bucket, link, and completion time; do not rely on a truncated `statusCheckRollup` connection.
- Deduplicate by GraphQL node ID or REST ID without merging distinct comments.
- Build a deterministic fingerprint from the base/head, check identities/states, review identities/states, review requests, comment identities/update times/content hashes, and thread identities/resolution/outdated state/nested-comment identities/update times/content hashes. Normalize ordering by stable ID before hashing.
- Re-read the PR base/head/`updatedAt`, complete check rollup, and complete feedback identity/state markers after collection. If the base/head, PR update marker, or evidence fingerprint changed, discard the snapshot and exit `1` with reason `pull_request_changed_during_collection` or `pull_request_evidence_changed_during_collection`.
- Verify both commit objects exist locally so the reviewer can run `git diff <baseOid>...<headOid>` without checkout. Report missing objects; do not fetch or switch inside the script.
- Output no authentication token, secret, full environment, or deleted comment body unavailable to the caller.
- Perform no Git, GitHub, filesystem, or Azure mutation.

JSON output contains:

```text
valid, repository, pull_request, url, state, is_draft,
base_ref, base_oid, head_ref, head_oid, head_stable,
snapshot_started_at, snapshot_completed_at, pr_updated_at,
snapshot_fingerprint, feedback_stable, checks_stable,
review_decision, review_requests, checks,
files, commits, reviews, issue_comments, inline_comments, review_threads,
counts, pagination_complete, local_objects_available, errors, warnings
```

Exit codes: `0` stable complete snapshot, `1` incomplete/unstable/evidence finding, `2` invocation/runtime failure.

## `Test-AzureWorkflowRepository.ps1`

Path: `plugins/azure-workflow/scripts/Test-AzureWorkflowRepository.ps1`

Purpose: validate the structural documentation contract without executing arbitrary repository commands.

Interface:

```powershell
param(
    [Parameter(Mandatory)][string]$RepositoryPath,
    [switch]$Json
)
```

Checks:

- Required files and directories use exact casing.
- `AGENTS.md` contains the required routing sections and an exact canonical verification command.
- Every required onboarding/planning/delivery/explanation/review/operation route names the supported plugin skill and no mandatory route points to a missing repository-local plugin, skill, agent, hook, task-state, or marketplace path.
- `AGENTS.md` declares Windows/PowerShell, the active mode, `operator-notes/` authority, every other declared human-owned root/mutation rule, product/data constraints, and path-aware validation routing.
- `docs/index.md` declares an authority order and routes every canonical document.
- `docs/product/index.md` declares exactly one valid mode (`development` or `released`), one maturity stage, the versioning scheme, current version, supported-contract boundary, and release authority.
- `docs/product/index.md` declares exactly one `Visual UI` value (`present` or `absent`). When present, the required `design/` headings/files/routes exist; when absent, an existing design directory is validated if retained but is not required.
- `docs/roadmap.md` uses only `Now`, `Next`, `Later`, and `Not planned`, and allocations name an exact version or `unallocated`.
- Product-area, architecture, and operations documents contain their required sections. Architecture includes current rule/configuration ownership and source-role/generated-material headings; operations includes technology toolchains/supported platforms and the canonical command.
- `docs/product/capabilities.md`, when present, has unique stable IDs, one canonical product link per row, and an exact target release or `unallocated`; migrated `V1/V2/V3+` allocation values fail.
- ADR filenames and headings follow the decision contract.
- Every change record follows the filename, metadata, status, and section contract.
- All relative Markdown links inside the canonical spine resolve.
- Declared source-backed human views preserve semantic values through parsing and generation; quoted/special-character metadata cannot be silently truncated, and generated status/progress cannot contradict its declared members without a finding.
- Declared architecture/source-role mappings use resolving relative repository paths. Released compatibility/replay rows include named contract, owner, activation/observability, removal trigger, and target version/date; a declared generated/materialized row names one canonical source and command.
- For a visual UI, `design/tokens/README.md` declares one canonical relative token source or `none`; design asset inventories use resolving relative source paths and labelled generated/runtime destinations; required design files contain no unresolved placeholders or synthetic assets.
- Four universal repository-owned GitHub issue forms exist, parse as YAML, and each uses exactly one declared owner-aware work kind (`type:*` label for personal/fallback or compatible native organization type). Conditional custom forms map to one base kind, use only statically declared registered labels, and have a matching `docs/operations.md` entry.
- The GitHub taxonomy registry rejects missing/multiple base kinds, workflow-used unregistered category namespaces, and labels duplicating Status, Priority, Horizon, release/milestone, assignee, or native dependency ownership. It preserves unrelated community/tool labels and records that private form requiredness and form Project auto-add require workflow readback rather than static enforcement.
- Nested `AGENTS.md` files contain local deltas and do not claim to replace root authority.
- Forbidden legacy roots such as `.repoplugin/` are reported.
- Superseded repository-local workflow packages, source hooks/agents, and their active ADR/validator/documentation routes are reported after conversion; checking that a route string exists without resolving its supported owner is insufficient.

The script does not run the canonical check it discovers. Execution belongs to the delivery workflow after the user request and repository commands have been inspected.

Output:

```text
Repository standard: PASS
Checked: <absolute path>
Documents: <count>
Change records: <count>
Warnings: <count>
```

With `-Json`, return `valid`, `repository_path`, `errors`, `warnings`, and `counts`.

Exit codes: `0` valid, `1` findings, `2` invocation/runtime error.

## `Test-AzureWorkflowPlugin.ps1`

Path: `plugins/azure-workflow/scripts/Test-AzureWorkflowPlugin.ps1`

Purpose: validate the installed package's exact public surface.

Interface:

```powershell
param(
    [string]$PluginPath = (Split-Path -Parent $PSScriptRoot),
    [switch]$Json
)
```

Checks:

- Manifest name, version base, required metadata, skill path, and MCP path.
- Exact MCP server names, transports, URLs, Azure package version, and telemetry setting.
- Exactly six skill directories with matching names.
- Each skill has valid frontmatter and `agents/openai.yaml` with an explicit `$skill-name` default prompt.
- Exact required skill-local references/assets and the single plugin-root `references/dotnet-projects.md` exist; no placeholder files remain.
- Onboarding, planning, delivery, explanation, and review link the shared .NET profile directly with its conditional activation; operate does not load it by default.
- No `hooks.json`, `.app.json`, extra public skill, `repoplugin-*`, target-repository policy/data/asset, absolute workstation path, or TODO placeholder exists.
- Runtime scripts parse successfully under PowerShell 7.
- The PR evidence collector is read-only, exhausts all declared pagination routes, detects changing heads/checks/feedback markers, fingerprints the evidence set, and returns the exact documented JSON fields.

Exit codes match the repository validator.

## Repository canonical check

Path: `scripts/Invoke-RepoCheck.ps1`

Interface:

```powershell
param(
    [ValidateSet('Auto', 'Docs', 'Full')]
    [string]$Scope = 'Full',
    [string]$BaseRef,
    [string]$HeadRef = 'HEAD'
)
```

This repository-specific wrapper:

1. In `Auto`, computes changed paths from `BaseRef...HeadRef` and uses the exact classifier in the testing workflow. Missing or invalid comparison data selects `Full`.
2. In `Docs`, fails if any supplied changed path is outside the docs-only allowlist.
3. Always runs `Test-AzureWorkflowRepository.ps1` and `git diff --check`.
4. In `Docs`, runs only Markdown links, authority/ADR/change-record schemas, and documentation command probes affected by the diff.
5. In `Full`, runs `Test-AzureWorkflowPlugin.ps1`, repository-root `Test-PluginPackage.ps1` clean-room/allowlist tests, fixture tests, plugin-creator validation when available, and all six skill quick validations when available.
6. Prints selected scope and changed paths before executing checks.

The required local and CI invocation is:

```powershell
pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1 -Scope Full
```

CI uses `-Scope Auto` with explicit base and head SHAs. See [proportional testing and path-aware CI](../workflows/testing-and-ci.md).

## Safety rules shared by all scripts

```text
resolve absolute root
        |
        +--> path outside root? --------> fail
        +--> reparse-point escape? -----> fail
        +--> overwrite requested? ------> fail unless contract explicitly allows it
        +--> valid contained target? ---> perform the narrow operation
```

- Never use an unresolved environment variable as a write target.
- Never recurse outside the explicit repository or plugin root.
- Never write secrets or full environment variables to output.
- Never perform `git add`, commit, push, PR, Azure CLI, or MCP operations.
- Never stage as a side effect of generation or validation; the owning workflow alone stages reviewed literal paths.
