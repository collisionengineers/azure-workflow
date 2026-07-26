# GitHub, CI, marketplace, installation, and release

## Repository creation

```text
Owner: collisionengineers
Repository: azure-workflow
Visibility: private
Default branch: main
Issues: enabled
Wiki: disabled
```

After the local planning baseline exists:

```powershell
gh repo create collisionengineers/azure-workflow `
  --private `
  --source . `
  --remote origin `
  --push `
  --disable-wiki `
  --description "Codex plugin for durable Azure repository planning and delivery"
```

Do not create a release, environment, secret, deployment key, collaborator, ruleset, or Project in this command.

## Repository GitHub files

The bootstrap branch contains the exact four universal forms/config/PR template in [GitHub work management](../interfaces/github-work-management.md). Because the owner is personal, the forms use `type:feature`, `type:bug`, `type:task`, and `type:decision`. Blank issues are disabled for ordinary contributors; maintainer-created blank issues are normalized when the workflow touches them.

No project-specific category is pre-created for the plugin repository: none has yet passed the recurring filtering/ownership/proof test. `docs/operations.md` records that empty registry. Future categories are additive registered facets and require an ordinary reviewed change.

The same contract governs repositories later onboarded by the plugin.

## GitHub Project and milestone

After the repository exists and `gh` capability/auth probes pass:

- create/reuse one linked Project named `Azure Workflow delivery`;
- normalize Status to Triage, Ready, In progress, In review, Done while preserving existing option IDs;
- add Priority P0/P1/P2/P3 and Horizon Now/Next/Later;
- use personal-account `type:*` labels plus built-in Labels, Assignees, Milestone, Parent issue, Sub-issue progress, Repository;
- create milestone `0.1.0-alpha.1` only when its scope/gates are approved;
- create the workflow label `do-not-merge` for the private personal-account draft fallback;
- add the Project `OWNER/NUMBER` to all four issue forms as an owner convenience, while still reconciling membership explicitly because form auto-add depends on the opener's Project write access;
- create no speculative backlog issues.

Read back owner type, selected work-kind encoding, Project/field/option/milestone IDs, repository link, and default workflow enabled state after mutation. Organization-wide issue-type changes are not part of bootstrap.

This bootstrap requires only the portable Project core. Saved-view configuration, extra built-in workflows, auto-add, and charts are not supported mutation surfaces. They may come from a user-approved compatible Project template or an exact human enhancement card, but their absence does not block the plugin alpha unless this repository explicitly makes one mandatory.

Do not add a Project-sync GitHub Action: the repository `GITHUB_TOKEN` cannot access Projects, and introducing a GitHub App/PAT solely for presentation automation is outside the alpha baseline.

## CI workflow

Path: `.github/workflows/verify.yml`.

```yaml
name: verify

on:
  pull_request:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read

jobs:
  verify:
    name: verify
    runs-on: windows-latest
    timeout-minutes: 15
    steps:
      - name: Check out repository
        uses: actions/checkout@v6
        with:
          fetch-depth: 0
      - name: Run canonical repository check
        shell: pwsh
        run: >-
          pwsh -NoLogo -NoProfile -File ./scripts/Invoke-RepoCheck.ps1
          -Scope Auto
          -BaseRef "${{ github.event.pull_request.base.sha || github.event.before }}"
          -HeadRef "${{ github.event.pull_request.head.sha || github.sha }}"
```

`verify` always reports. Documentation-only changes run Docs checks; plugin/script/workflow/form/config/source/test/IaC/ambiguous changes run Full. No Azure secret is required.

## Main-branch protection

The initial target is a private repository owned by the personal `collisionengineers` account. First probe whether the current repository visibility and GitHub plan support private-repository rulesets. GitHub Free does not. Do not convert the account or require an upgrade.

When supported and separately authorized, create `main-protection` after a PR has emitted the `verify` context and before completing the bootstrap PR workflow.

| Rule | Exact setting |
| --- | --- |
| Target | `refs/heads/main` |
| Enforcement | active |
| Bypass | none |
| Pull request | required |
| Approving reviews | 0 |
| Code-owner/last-push approval | false |
| Status | `verify`, strict/up-to-date |
| Force push | blocked |
| Deletion | blocked |
| Auto-merge | disabled |

Verify with:

```powershell
gh ruleset list -R collisionengineers/azure-workflow
gh ruleset check main -R collisionengineers/azure-workflow
```

When unsupported, retain the green-PR workflow, record the exact GitHub capability response, and mark protection as `not enforceable on current plan` rather than installed or failed. If repository authority declares enforced protection mandatory, the release remains blocked pending a human visibility/plan decision.

## Pull-request lifecycle

```text
locally verified implementation + current record
          |
          v
push -> normal PR + do-not-merge -> Project In review -> verify exact head
                                                        | fail
                                                        +--> fix/prove/push
                                                        | pass
                                                        v
                                               fresh actual-PR review
                                                        | findings
                                                        +--> remediate/push/full re-review
                                                        | clean
                                                        v
                                         final record commit + verify + final review
                                                        |
                                                        v
                                      COMMENT attestation + remove do-not-merge
                                                        |
                                                        v
                                                       STOP
```

Bootstrap base `main`, head `feat/bootstrap-azure-workflow`. The current private personal GitHub Free target does not claim draft PR support. Do not merge automatically or set the issue Done before merge.

## Register and install

```powershell
codex plugin marketplace add C:\Users\PC\Documents\GitHub\a-workflow --json
codex plugin marketplace list
codex plugin add azure-workflow@personal --json
codex plugin list
```

Expected: marketplace `personal` resolves to the local repository and `azure-workflow@personal` is installed/enabled. Start a new Codex thread; an existing thread is not load proof.

## Development update loop

```powershell
python C:\Users\PC\.codex\skills\.system\plugin-creator\scripts\update_plugin_cachebuster.py `
  C:\Users\PC\Documents\GitHub\a-workflow\plugins\azure-workflow

python C:\Users\PC\.codex\skills\.system\plugin-creator\scripts\read_marketplace_name.py `
  --marketplace-path C:\Users\PC\Documents\GitHub\a-workflow\.agents\plugins\marketplace.json

codex plugin add azure-workflow@personal --json
```

Then use a new thread. Never edit Codex global configuration or marketplace metadata merely to force reload.

## Versioning and release

- First release: `0.1.0-alpha.1`.
- Local reload: `0.1.0-alpha.1+codex.<generated-cachebuster>`.
- Replace the previous cachebuster; never chain build suffixes.
- Build metadata is not a new release and does not change SemVer precedence.
- Any base/prerelease increment requires a change record, proof, fresh review, installed smoke test, and release-gate decision.
- MCP pin updates also require startup/tool-list/read-only/approval-stop tests.

The delivery workflow stops at a green exact-head-reviewed PR. After authorized merge and Full verification on `main`, create immutable tag `v0.1.0-alpha.1` and a GitHub prerelease. Do not present it as stable.

## Plugin-creator handoff

When implementation actually creates/updates the marketplace entry, the final implementation response must include the plugin-creator-required Codex app handoff with URL-encoded `View azure-workflow` and `Share azure-workflow` links for the absolute marketplace JSON path.
