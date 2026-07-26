# Operations

## Supported environment and prerequisites

- Platform: Windows
- Shell: PowerShell 7
- Required for full development: Git, GitHub CLI, Python 3, Node/npm/npx, and Codex CLI.
- Conditional: Azure CLI/azd and usable Azure credentials for live Azure acceptance; .NET only for relevant target repositories.
- Creator helpers are resolved from `$env:CODEX_HOME` or the per-user `.codex` default at runtime; their workstation path is never tracked.

## Canonical verification

```powershell
pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1 -Scope Full
```

CI uses `-Scope Auto` with explicit base/head revisions. Missing or invalid comparison data selects Full.

## Local run, build, and test

```powershell
pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1 -Scope Docs
pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1 -Scope Full
pwsh -NoLogo -NoProfile -File ./tests/Test-RepositoryStandard.ps1
pwsh -NoLogo -NoProfile -File ./tests/Test-PullRequestEvidence.ps1
pwsh -NoLogo -NoProfile -File ./tests/Test-PluginPackage.ps1
```

The wrapper discovers plugin-creator and skill-creator validators when installed. Tests use contained repository fixtures and do not alter Git, GitHub, or Azure.

## Deploy

This package deploys to Codex, not Azure.

Initial local marketplace/install from repository root:

```powershell
codex plugin marketplace add .
codex plugin list --marketplace personal --available --json
codex plugin add azure-workflow@personal --json
codex plugin list --json
```

For an already installed local development version, run the plugin-creator `update_plugin_cachebuster.py` helper against `./plugins/azure-workflow`, read the marketplace name from `./.agents/plugins/marketplace.json`, then run `codex plugin add azure-workflow@personal --json`. The helper replaces one `+codex.<cachebuster>` suffix; it does not change the release version. Start a new Codex thread to test updated skills/MCPs.

The plugin owns no Azure deployment. Any target-repository Azure mutation follows `$operate-azure-repository`: read current scope, present an exact apply card, receive explicit approval, apply once, and validate.

## Configuration and secrets boundary

Tracked MCP configuration contains only server command/URL and telemetry setting. Azure credentials remain in the local Azure credential chain. Never print/store tokens, keys, connection strings, secret values, or full environment dumps.

## Monitoring and diagnosis

- Package/skill schema: canonical Full check and creator validators.
- Plugin discovery/install: `codex plugin list --available --json` and install result.
- Azure MCP startup: pinned package startup/tool-list probe, then an explicitly scoped read.
- Microsoft Learn: current official search/fetch smoke prompt in a fresh thread.
- GitHub PR review: evidence collector JSON, CI checks, comments/reviews/threads, exact head/fingerprint.

## Recovery

- Validation failure: fix the single owning source/reference/script and rerun focused then Full checks.
- Install cache mismatch: replace the cachebuster through the helper, reinstall from the configured local marketplace, and start a new thread.
- Broken marketplace registration: verify `codex plugin marketplace list`; remove/re-add only the exact local marketplace when necessary.
- Azure credential failure: repair the local Azure CLI/credential prerequisite outside the plugin, then rerun a read-only probe; never call failure an empty inventory.
- Interrupted repository change: resume by exact issue/record/branch/PR identity; never select latest or create a handoff subsystem.

## GitHub work taxonomy

- Personal repository owner: `collisionengineers`.
- Repository Project: [Azure Workflow](https://github.com/users/collisionengineers/projects/2).
- Universal work kinds use exactly one of `type:feature`, `type:bug`, `type:task`, or `type:decision`.
- Registered project-specific categories for this repository: none.
- Status: Triage, Ready, In progress, In review, Done. Priority: P0 Critical, P1 High, P2 Normal, P3 Low. Horizon: Now, Next, Later. Releases use milestones.
- `do-not-merge` represents under-review state when native draft PRs are unavailable.
- Saved Project views, charts, extra workflows, and auto-add behavior may require human setup/visual confirmation; do not claim them from incomplete API coverage.

### One-time Project setup card

The CLI/GraphQL route created and read back the private linked Project, Priority (`P0 Critical`, `P1 High`, `P2 Normal`, `P3 Low`), Horizon (`Now`, `Next`, `Later`), milestone, and bootstrap item values. GitHub rejected deletion of the built-in Status field (`Only custom fields can be deleted`), while the CLI exposes no status-option edit. To complete the intended single Status field in the Project UI:

1. Rename `Todo` to `Triage`.
2. Add `Ready` after Triage.
3. Rename `In Progress` to `In progress`.
4. Add `In review` after In progress.
5. Retain `Done`.

Do not create a second status field. Saved views/charts/workflows remain optional human enhancements and are not part of the alpha's queryable completion claim.

## Supported platforms and release operations

Development/validation is supported on Windows PowerShell 7. Releases follow SemVer/maturity gates in `plugins/azure-workflow/references/versioning-and-release-stages.md`. Alpha requires package/skill/fixture/routing/PR evidence. Beta/stable require cross-repository and live Azure evidence; tags/releases are immutable and created only after explicit release authority.
