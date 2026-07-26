# GitHub Issues, Projects, milestones, and pull requests

## Decision

GitHub owns actionable work state. Repository documentation owns durable product truth and planning history.

```text
docs/product/ -------- settled behavior and boundaries
docs/roadmap.md ------ outcome sequence and release allocation
GitHub Issues -------- actionable work, discussion, owner, dependencies
GitHub Project ------- live workflow, priority, horizon state
GitHub milestones ---- exact release target
docs/changes/ -------- one selected change's plan and evidence
pull requests -------- reviewed proposed repository diff
```

The design follows GitHub's own guidance to keep a single source of truth and use issues, sub-issues, dependencies, milestones, and Project fields for work metadata. See [About issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/about-issues) and [Best practices for Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/best-practices-for-projects).

## Tooling decision

GitHub operations use `git`, `gh`, and `gh api`. The plugin does not add the GitHub MCP server in `0.1.0-alpha.1`.

Reasons:

- `gh` is already required for branches, PRs, checks, rulesets, releases, Issues, and Projects.
- The official CLI exposes core Project lifecycle, field and item operations plus authenticated API access; `gh api graphql` covers supported gaps such as safe field-option updates.
- Project configuration still requires CLI/GraphQL coverage even when GitHub MCP is present.
- Adding MCP would create a second GitHub authentication and tool-selection path without removing the CLI dependency.
- The official GitHub MCP is valuable for conversational GitHub access, but it is not necessary for this deterministic repository workflow. See [GitHub MCP Server](https://github.com/github/github-mcp-server).

This is a deliberate single-route decision, not a claim that MCP is inferior. Reconsider only if a later Codex host removes CLI access or GitHub MCP gains complete, testable Project administration that replaces `gh`.

## Current Projects automation boundary

As verified on 2026-07-26, the portable core is programmatic but the complete visual/automation configuration is not. The exact evidence and re-probe rules are in the [GitHub Projects capability audit](../research/github-projects-api-cli-capability-audit.md).

| Surface | Route | Required status |
| --- | --- | --- |
| Project create/reuse/edit/link/close, standard fields, items, custom field values | `gh project` | Portable required core |
| Status option preservation, iteration fields, field edits, collaborators, status updates, draft conversion | `gh api graphql` | Supported when the workflow actually needs it |
| Saved-view creation/configuration | Web UI or copied template | Optional unless repository policy requires it |
| Built-in workflow creation/configuration/enablement | Web UI or copied template | Default close/merge-to-Done state is audited; extras are optional |
| Auto-add workflows | Web UI only; not copied with templates | Optional; normal plugin-created work is added explicitly |
| Charts/insights | Web UI or copied template | Optional presentation surface |

The published GraphQL schema exposes views and workflows for reading, but no view mutations and only a delete mutation for workflows. It exposes no Project chart/insight mutation surface. Do not use fragile browser automation and then call the result deterministic Project provisioning.

Copying a compatible Project can preserve views, custom fields, non-auto-add workflows, and insights. It does not preserve items, collaborators, or repository/team links. A copied Project therefore still passes the same link, field, and readback reconciliation as a newly created Project.

## Owner and account capability routing

Projects can be owned by either a personal account (`User`) or an organization (`Organization`). The plugin supports both, but the required baseline is the personal-account route.

| Capability | Personal-account repository | Organization repository |
| --- | --- | --- |
| Repository issue forms and labels | Required baseline | Supported |
| Native issue types and organization issue fields | Unavailable | Use only when discovered and compatible |
| Linked owner Project | Supported | Supported |
| Copy an accessible Project | Supported | Supported |
| Mark/recommend organization Project templates | Unavailable | Organization-only optional enhancement |
| Rulesets on a private repository | Requires GitHub Pro | Requires GitHub Team or Enterprise |

GitHub Free supports rulesets for public repositories, but private-repository rulesets require a paid plan. See [available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets). Organization issue types are an organization feature; they are not a prerequisite for reliable issue handling. See [managing issue types](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-types-in-an-organization).

Onboarding resolves the owner and repository capability before rendering forms or proposing governance:

```powershell
$repository = gh repo view --json nameWithOwner,owner,visibility
$ownerLogin = $repository | ConvertFrom-Json | Select-Object -ExpandProperty owner | Select-Object -ExpandProperty login
$ownerType = gh api "users/$ownerLogin" --jq '.type'
```

Do not convert an account, create an organization, or recommend a paid plan as an automated remediation. If protection is unavailable, record the exact limitation and continue with the voluntary PR/CI workflow unless repository authority makes enforced protection a release gate.

## Preconditions

Onboarding and delivery run:

```powershell
gh --version
gh auth status
gh auth refresh -s project
gh repo view --json nameWithOwner,url,defaultBranchRef,hasIssuesEnabled
gh project --help
gh project field-create --help
gh project item-edit --help
```

Read-only discovery requires `read:project`; mutation requires `project`. The workflow verifies that the intended GraphQL mutations exist before use. It does not treat an authenticated `gh` session as proof that Projects scope or owner permissions are sufficient.

The minimum portable Project command/mutation probe is:

```powershell
$projectHelp = gh project --help | Out-String
$requiredProjectCommands = @(
    'create', 'edit', 'field-create', 'field-list', 'item-add',
    'item-edit', 'item-list', 'link', 'list', 'view'
)
$missingProjectCommands = @(
    $requiredProjectCommands | Where-Object { $projectHelp -notmatch "(?m)^\s+$([regex]::Escape($_)):" }
)

$schemaQuery = 'query { __schema { mutationType { fields { name } } } }'
$projectMutationNames = @(
    gh api graphql -f query=$schemaQuery --jq '.data.__schema.mutationType.fields[].name'
)
$requiredProjectMutations = @(
    'updateProjectV2Field',
    'updateProjectV2ItemFieldValue'
)
$missingProjectMutations = @(
    $requiredProjectMutations | Where-Object { $_ -notin $projectMutationNames }
)
```

Any non-empty missing list blocks Project-core mutation and is reported exactly. Optional operations such as template copy or iteration creation add their command/mutation to the probe only when selected.

The repository-scoped Actions `GITHUB_TOKEN` cannot access Projects. The default standard therefore does not add a Project-sync workflow. A GitHub App token or PAT and its secrets/workflows require an explicit separate decision.

The CLI must expose the required current flags:

```powershell
$issueCreateHelp = gh issue create --help
$issueEditHelp = gh issue edit --help

$requiredCreateFlags = '--label', '--parent', '--blocked-by'
$requiredEditFlags = '--add-sub-issue', '--add-blocked-by'
```

If a flag is absent, stop and give the Windows upgrade command:

```powershell
winget upgrade --id GitHub.cli --exact
```

Do not silently switch to an undocumented compatibility path. The current command contract is published in the [`gh issue create`](https://cli.github.com/manual/gh_issue_create) and [`gh issue edit`](https://cli.github.com/manual/gh_issue_edit) manuals.

## Issue types and categories

The canonical work-kind vocabulary is:

| Work kind | Use |
| --- | --- |
| `Feature` | User/operator outcome or product capability |
| `Bug` | Observed behavior differs from intended or supported behavior |
| `Task` | Technical, documentation, operational, research, migration, or release work |
| `Decision` | A material human choice that blocks or changes product, architecture, operations, or release behavior |

On a personal-account repository, forms apply the exact repository labels `type:feature`, `type:bug`, `type:task`, and `type:decision`. Labels are the single work-kind encoding; no custom Project work-kind field is added.

On an organization repository, onboarding first reads the available native issue types. If compatible `Feature`, `Bug`, and `Task` types exist, the forms use them; Decision uses an existing compatible native `Decision` when present or native `Task` plus `decision` otherwise. If the base types are unavailable or materially different, use the personal label route. Never create or alter organization-wide types automatically.

Every active issue owned or touched by the workflow must have exactly one semantic work kind. This means an open issue in the linked Project, linked from an active/planned record or PR, acting as its parent/dependency, or created/updated by an owning workflow. Closed historical issues are counted for migration impact but not silently rewritten. Missing or multiple personal-route `type:*` labels are invalid. Organization-native issues must have one compatible native type; Decision may use native Decision when already available or native Task plus `decision`.

Project-specific categories extend this base; they never replace it:

```text
exactly one kind:  Feature | Bug | Task | Decision
optional facets:  area:* | component:* | approved registered namespace
typed metadata:   Project Status/Priority/Horizon + milestone + relationships
```

The full evidence and conversion rationale is in [GitHub issue taxonomy and forms](../research/github-issue-taxonomy-and-forms.md).

## Exact repository labels

Required on a personal-account repository or organization fallback route:

| Label | Color | Meaning |
| --- | --- | --- |
| `type:feature` | `#1D76DB` | User/operator outcome or product capability |
| `type:bug` | `#D73A4A` | Observed behavior differs from intended behavior |
| `type:task` | `#0E8A16` | Bounded technical, documentation, operational, research, migration, or release work |
| `type:decision` | `#8250DF` | A material human decision is required |

Required on the compatible organization-native route:

| Label | Color | Meaning |
| --- | --- | --- |
| `decision` | `#8250DF` | Distinguishes Decision work encoded as native Task |

Conditional:

- `do-not-merge` (`#B60205`) is created when the repository cannot use native draft PRs. It is applied only while a normal PR is under workflow review and removed after the final exact-head gate; it is a warning, not enforcement.
- `area:<slug>` labels may be created only for stable product/business areas that users genuinely filter or route across.
- `component:<slug>` labels may be created only when a stable technical/deployment boundary changes ownership or verification.
- `severity:<slug>` is opt-in only when `docs/operations.md` defines a response-changing impact scale.
- Another lowercase namespace requires a recurring operational question, canonical authority, non-overlapping values, and registration in `docs/operations.md`.
- `external-blocker` may be created only when a blocker cannot be represented as a GitHub issue dependency.

For new labels, `area:*` defaults to `#006B75`, `component:*` to `#5319E7`, and an enabled four-level severity scale uses critical `#B60205`, high `#D93F0B`, medium `#FBCA04`, and low `#C2E0C6`. Preserve compatible existing colors. Colors aid scanning but never carry meaning without the label name and description.

Forbidden default label families:

```text
status:*
priority:*
horizon:*
version:*
release:*
phase:*
owner:*
blocked:*
```

Those values already have typed owners. `type:*` is required only on the personal/fallback route and forbidden on the compatible organization-native route. Project-specific labels the plugin applies, filters on, or treats as authority use lowercase `namespace:slug`, have a non-empty description, and appear in the `docs/operations.md` category registry before use.

Community annotations (`help wanted`, `good first issue`, `duplicate`, `invalid`, `question`, `wontfix`, `documentation`) and integration-owned labels may coexist but never satisfy the work-kind rule. Unknown labels are inventoried and preserved unless they conflict with a canonical kind/typed owner; the plugin does not repurpose or delete them silently. Default `bug` and `enhancement` are mapped to canonical kinds for active workflow work, with rename/removal still gated by impact preview and approval.

Onboarding builds a label/form usage ledger before mutation. It may create missing canonical labels and correct their description/color. Deleting or renaming an in-use label, retiring a form, or bulk relabelling existing issues requires an exact old-to-new mapping, affected issue/PR counts, and explicit approval. Prefer an approved one-to-one rename over delete/recreate so associations survive.

### Exact personal-route taxonomy commands

Inventory labels and every issue/PR label association with explicit pagination:

```powershell
$labels = gh label list --repo $repository --limit 1000 `
  --json name,color,description | ConvertFrom-Json

$itemPages = gh api --paginate --slurp `
  -H 'X-GitHub-Api-Version: 2026-03-10' `
  "repos/$repository/issues?state=all&per_page=100" | ConvertFrom-Json
$allItems = @($itemPages | ForEach-Object { $_ })
```

The ledger separates issues from PRs using the presence of each item's `pull_request` property and counts every target label before proposing a rename/delete.

Create or normalize the four canonical labels idempotently:

```powershell
gh label create 'type:feature' --repo $repository --color '1D76DB' --description 'User or operator outcome or product capability' --force
gh label create 'type:bug' --repo $repository --color 'D73A4A' --description 'Observed behavior differs from intended behavior' --force
gh label create 'type:task' --repo $repository --color '0E8A16' --description 'Bounded technical, documentation, operational, research, migration, or release work' --force
gh label create 'type:decision' --repo $repository --color '8250DF' --description 'A material human decision is required' --force
```

For one selected issue, calculate the current base labels, require the intended kind to be unambiguous, then make one scoped update and read it back:

```powershell
$editArguments = @(
  'issue', 'edit', [string]$issueNumber,
  '--repo', $repository,
  '--add-label', $intendedTypeLabel
)
if ($otherPresentTypeLabels.Count -gt 0) {
  $editArguments += @('--remove-label', ($otherPresentTypeLabels -join ','))
}
& gh @editArguments

gh issue view $issueNumber --repo $repository `
  --json number,url,labels,projectItems,milestone
```

Never pass an empty or guessed label. Registered facets use the same single-issue/readback pattern. Implementation re-probes [supported GitHub REST API versions](https://docs.github.com/en/rest/about-the-rest-api/api-versions) before pinning or upgrading the header.

Only after an approved impact preview may onboarding run:

```powershell
gh label edit $oldLabel --repo $repository --name $newLabel `
  --color $color --description $description

gh label delete $obsoleteLabel --repo $repository --yes
```

Deletion remains exceptional because it removes the label from every associated issue and PR. Bulk issue updates enumerate explicit issue numbers from the approved ledger; they never use a search result as an unchecked mutation stream.

## Exact issue-form tree

```text
.github/ISSUE_TEMPLATE/
|-- bug.yml
|-- decision.yml
|-- feature.yml
|-- task.yml
|-- <purpose-named>.yml    conditional repository-specific intake
`-- config.yml
```

The plugin packages only the four base forms. A target repository may retain/create an additional form only when it asks materially different, repeatedly useful questions. The form must map to exactly one base kind, apply only static registered labels, and be registered in `docs/operations.md`. Do not create a form merely as an area shortcut or one form per component/capability.

GitHub issue forms currently remain documented as public preview. Current form-schema documentation limits `required` enforcement to public repositories, and maintainers can still open a blank issue even when `blank_issues_enabled: false`. Repository validation therefore checks schema, while planning/delivery check semantic completeness themselves. Onboarding includes a live template-chooser probe before completion. See [Syntax for issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms) and [GitHub form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema).

### `feature.yml`

```yaml
name: Feature or capability
description: Propose a user or operator outcome.
title: "[Feature] "
labels:
  - type:feature
body:
  - type: textarea
    id: problem
    attributes:
      label: Problem or outcome
      description: What outcome is needed, and what is wrong or unavailable today?
    validations:
      required: true
  - type: textarea
    id: users
    attributes:
      label: Users and real workflow
      description: Who needs this and through which real entry point or workflow?
    validations:
      required: true
  - type: textarea
    id: acceptance
    attributes:
      label: Observable acceptance
      description: Describe successful, negative, and failure outcomes without prescribing implementation.
    validations:
      required: true
  - type: textarea
    id: constraints
    attributes:
      label: Constraints and authority
      description: Link operator notes, product sections, external contracts, examples, or boundaries that govern the request.
    validations:
      required: false
  - type: input
    id: capability_ids
    attributes:
      label: Capability IDs
      description: Existing stable IDs, if any. Do not invent an ID merely to submit the issue.
    validations:
      required: false
  - type: textarea
    id: evidence
    attributes:
      label: Evidence
      description: Add real examples, screenshots, documents, logs, or links already available. Do not fabricate repository test material.
    validations:
      required: false
```

### `bug.yml`

```yaml
name: Bug
description: Report behavior that differs from the intended or supported result.
title: "[Bug] "
labels:
  - type:bug
body:
  - type: textarea
    id: observed
    attributes:
      label: Observed behavior
      description: What happened through the real caller or user workflow?
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: Expected behavior
      description: What should have happened, and which authority supports that expectation?
    validations:
      required: true
  - type: textarea
    id: reproduction
    attributes:
      label: Reproduction
      description: Give the smallest repeatable path using available repository examples or real evidence.
    validations:
      required: true
  - type: textarea
    id: impact
    attributes:
      label: Impact and recovery
      description: Who or what is affected, and how can the operator recover or continue?
    validations:
      required: true
  - type: input
    id: version
    attributes:
      label: Version or commit
      description: Exact release, commit, environment, or branch where observed.
    validations:
      required: false
  - type: textarea
    id: evidence
    attributes:
      label: Evidence
      description: Attach available logs, screenshots, documents, or links with secrets removed.
    validations:
      required: false
```

### `task.yml`

```yaml
name: Task
description: Propose bounded technical, documentation, operational, migration, research, or release work.
title: "[Task] "
labels:
  - type:task
body:
  - type: textarea
    id: outcome
    attributes:
      label: Required outcome
      description: What must be true when this task is complete?
    validations:
      required: true
  - type: textarea
    id: reason
    attributes:
      label: Why now
      description: Link the parent feature, bug, release gate, decision, or operational need.
    validations:
      required: true
  - type: textarea
    id: acceptance
    attributes:
      label: Acceptance and proof
      description: State the observable evidence required; avoid implementation theatre or blanket test requests.
    validations:
      required: true
  - type: textarea
    id: constraints
    attributes:
      label: Scope and constraints
      description: Name included/excluded areas, authority, real callers, data limits, or recovery requirements.
    validations:
      required: false
```

### `decision.yml`

```yaml
name: Decision
description: Record a material choice that blocks or changes product, architecture, operations, or release behavior.
title: "[Decision] "
labels:
  - type:decision
body:
  - type: textarea
    id: decision
    attributes:
      label: Decision required
      description: State one decision precisely.
    validations:
      required: true
  - type: textarea
    id: why_now
    attributes:
      label: Why it is needed now
      description: Name the blocked outcome, issue, release, or irreversible consequence.
    validations:
      required: true
  - type: textarea
    id: evidence
    attributes:
      label: Known evidence and constraints
      description: Link authorities, repository evidence, external contracts, and already rejected assumptions.
    validations:
      required: true
  - type: textarea
    id: options
    attributes:
      label: Viable options
      description: Give materially different options and consequences, or explain why research is still required.
    validations:
      required: false
  - type: input
    id: affected
    attributes:
      label: Affected issues or capability IDs
      description: Add exact references.
    validations:
      required: false
```

### `config.yml`

```yaml
blank_issues_enabled: false
contact_links: []
```

The examples above are the personal-account baseline. On a compatible organization-native route, form generation replaces the `type:*` label with exact-case native `type: Feature`, `type: Bug`, or `type: Task`; Decision uses an existing native Decision or `type: Task` plus `decision`.

After a Project exists, onboarding adds its exact `OWNER/NUMBER` to the `projects` top-level key in all base and compatible custom forms. GitHub requires the issue opener to have Project write access for that auto-add path, so it is a convenience rather than the source of truth. Planning/delivery explicitly read back and reconcile Project membership for their issue. The forms never hardcode milestone, assignee, priority, or horizon.

## Target-repository taxonomy registry

`docs/operations.md` contains:

```markdown
## GitHub work management
### Work kinds
### Project-specific categories
### Project fields, milestones, and relationships
### Issue and pull-request lifecycle
### GitHub capability limitations
```

Custom categories use this table:

```markdown
| Label | Meaning | Applies to | Operational use | Authority |
| --- | --- | --- | --- | --- |
| `area:billing` | Billing user workflows | Issues and PRs | Filter and route billing changes | `docs/product/areas/billing.md` |
```

`AGENTS.md` states only the one-kind/registered-category invariant and links to operations. It does not duplicate the registry.

## Portable Project contract

One GitHub Project named `<Repository> delivery` is linked to the repository.

Required fields:

| Field | Type | Options |
| --- | --- | --- |
| `Status` | Existing single select, normalized without changing preserved option IDs | `Triage`, `Ready`, `In progress`, `In review`, `Done` |
| `Priority` | Single select | `P0 Critical`, `P1 High`, `P2 Normal`, `P3 Low` |
| `Horizon` | Single select | `Now`, `Next`, `Later` |

Use built-in fields rather than duplicates:

- Labels
- Assignees
- Milestone
- Parent issue
- Sub-issue progress
- Repository

Use built-in Type only on the compatible organization-native route. Do not add a custom work-kind field on the personal/fallback route; the exact `type:*` labels remain filterable in the Project.

Do not add iteration/sprint, story points, effort, start date, target date, confidence, risk, or team fields by default. Add one only when the repository declares an actual recurring decision that uses it.

On a new Project, preserve the IDs of the default `Status` options while renaming/expanding them through the documented `updateProjectV2Field` GraphQL mutation. Preserving IDs prevents field values and built-in close automation from being detached. See the [Projects GraphQL reference](https://docs.github.com/en/graphql/reference/projects#updateprojectv2field).

If a repository already has an active Project, onboarding maps its fields to this semantic contract and records the mapping. It does not destructively replace an existing personal- or organization-owned Project merely for uniform names.

The required completion boundary is the Project core above. A saved board/table view, extra built-in workflow, auto-add rule, or chart is an optional enhancement unless repository authority explicitly requires it. When required, use either a user-selected compatible Project template or a human completion card and report onboarding as partial until confirmed.

New Projects normally enable closed-item-to-Done and merged-PR-to-Done workflows. Onboarding queries their observed names/enabled state; it never assumes defaults are still active. Normal planning/delivery also explicitly adds and transitions its issue/PR, so auto-add is not required for correctness.

## Idempotent Project setup sequence

Use the repository owner—personal or organization—as the default Project owner. A different owner is a material scope decision.

```text
read owner type + owner Projects + repository links + exact capabilities
        |
        +-- exact compatible Project exists --> reuse and map IDs
        |
        +-- conflicting team Project exists --> preserve; ask before replacement
        |
        +-- approved compatible template exists --> copy, then relink/reconcile
        |
        `-- none --> create portable `<Repository> delivery` and link repository
                         |
                         v
                 read all built-in/custom fields
                         |
                         +--> normalize Status while preserving option IDs
                         +--> create/reuse Priority
                         `--> create/reuse Horizon
                         |
                         v
                 read back IDs/options/link
                         |
                         v
                 write OWNER/NUMBER to issue forms
                         |
                         v
                 audit default workflow state
                         |
                         +--> core verified --> onboarding core complete
                         |
                         `--> required UI-only enhancement --> exact human card / partial
```

CLI primitives:

```powershell
gh project list --owner <owner> --closed --limit 1000 --format json
gh project create --owner <owner> --title '<Repository> delivery' --format json
gh project link <number> --owner <owner> --repo <owner/repository>
gh project field-list <number> --owner <owner> --limit 100 --format json
gh project field-create <number> --owner <owner> --name Priority `
  --data-type SINGLE_SELECT --single-select-options 'P0 Critical,P1 High,P2 Normal,P3 Low' --format json
gh project field-create <number> --owner <owner> --name Horizon `
  --data-type SINGLE_SELECT --single-select-options 'Now,Next,Later' --format json
```

Do not rerun a create command when a semantic match already exists. The built-in Status field is updated through `gh api graphql` using `updateProjectV2Field`, supplying every existing/new option and preserving existing option IDs. Never delete/recreate Status merely to rename `Todo` to `Triage`, because that can detach existing item values and automation.

CLI list defaults are not completeness evidence. Use explicit limits and GraphQL pagination. A Project supports at most 50 fields and 50,000 active-plus-archived items; use filtered item queries rather than a full inventory for ordinary transitions. `gh project item-edit` sets one field per call, so a multi-field transition is sequential and ends with one readback.

### Optional Project enhancement routes

```text
portable core verified
        |
        +-- no enhanced presentation required --> complete
        |
        +-- compatible approved template used --> query views/workflows + verify copied state
        |
        `-- UI-only enhancement required --> show exact setup card
                                              |
                                              +-- human confirms + queryable readback passes --> complete
                                              `-- not completed/unverifiable --> partial, exact gap recorded
```

The setup card identifies each unsupported mutation and exact desired setting. It may link to the Project page but does not silently drive the browser. Chart evidence is human/visual because the current API cannot read or mutate chart configuration.

Store Project node ID, number, field IDs, and option IDs only in the onboarding change record/evidence while setup is active. Do not create a permanent repository JSON state file. Future runs discover live IDs again.

## Status lifecycle

```text
new issue
   |
   v
Triage -- rejected/duplicate/not planned --> closed with reason
   |
   +-- material decision --> decision issue / dependency
   |
   v
Ready -- delivery begins --> In progress -- PR created --> In review
                                                        |
                                                        +-- changes requested --> In progress
                                                        |
                                                        `-- merged/accepted task --> Done
```

Definitions:

| Status | Required state |
| --- | --- |
| `Triage` | Problem captured; authority, duplication, allocation, and actionability may be unresolved |
| `Ready` | Outcome and acceptance are clear, dependencies unblocked, correct type/priority/horizon/milestone set, and the next bounded change can be planned or implemented |
| `In progress` | Named owner, active change record, and branch or explicit local delivery exist |
| `In review` | PR exists and implementation awaits human merge/review or final external acceptance |
| `Done` | Issue is closed for its declared outcome; implementation tasks normally close on merge, parent Features close only after their outcome/acceptance is complete |

The plugin ends normal delivery with the implementation issue in `In review` and a green PR carrying a clean independent review for its exact final head. It does not mark the issue `Done` before merge.

### Standalone planning loop

Planning is work on the same issue, not a second planning-status system:

```text
Triage/Ready -- planning starts --> In progress
                                 |
                            plan PR
                                 v
                            In review
                                 |
                    plan PR review + plan gate clear
                                 v
                              Ready
                                 |
                    later implementation starts
                                 v
                           In progress
```

Returning to `Ready` means the outcome is implementation-ready even if the documentation-only plan PR still awaits human merge; delivery then either resumes that PR branch or, after merge, branches from updated default. An implementation PR stays `In review` until merge/acceptance because its next state is `Done`, not another implementation cycle.

## Priority

| Priority | Meaning |
| --- | --- |
| `P0 Critical` | Active production safety, data-loss, security, or service-restoration emergency |
| `P1 High` | Blocks the current release or a critical operator workflow |
| `P2 Normal` | Ordinary planned product/technical work |
| `P3 Low` | Useful but not currently important |

Priority does not encode horizon or issue type.

## Milestones and releases

- One milestone represents one exact intended release, for example `0.4.0-beta.1` or `1.0.0`.
- An issue has at most one milestone.
- `Later` or unallocated work has no milestone.
- A parent Feature may span multiple releases only if its sub-issues have exact milestones and the parent states the multi-release outcome. Prefer a smaller parent when possible.
- Closing a milestone requires the repository's release gate, not merely all code PRs merged.

GitHub milestones provide grouped progress and due-date metadata; they are not product requirements. See [About milestones](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones).

## Parent issues, sub-issues, and dependencies

Use hierarchy for decomposition and dependencies for order:

```text
Feature parent: operator can resolve post-report queries
   |
   +-- Task: settle query state and permissions
   +-- Task: implement Core use case
   +-- Task: implement UI states
   +-- Task: add operator acceptance evidence

Core use case task --blocks--> UI task
```

Rules:

- A parent issue is an outcome, not an umbrella for an entire product.
- Create sub-issues only when they are independently deliverable/reviewable or have different owners/dependencies.
- Keep normal hierarchy to parent plus one child level. A third level needs a clear programme reason.
- Use native `blocked by`/`blocking` relationships rather than prose dependency lists.
- Do not create placeholder sub-issues for distant Later work.
- Do not mirror every capability ID as an issue.

GitHub supports issue hierarchy and native blocking relationships; see [Adding sub-issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-sub-issues) and [Creating issue dependencies](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-issue-dependencies).

## When an issue is required

| Work | Issue rule |
| --- | --- |
| Backlog/roadmap idea | Feature issue required if it is promoted to actionable Triage; durable catalog entry may remain unallocated without an issue |
| Standard/high-risk plan | Create/reuse an issue when GitHub is available; absence does not invalidate a decision-complete local plan, but the work cannot enter Project `Ready` or delivery until the issue exists |
| Standard/high-risk delivery | Issue required; delivery may create it as an authorized normal step when none exists |
| Low-risk contained fix/docs/maintenance | Issue optional; PR and change record are enough unless repository policy says otherwise |
| `Not planned` boundary | No open issue; close any existing issue with reason and update product authority |
| Material unresolved decision | Decision form using the selected owner-aware work-kind encoding required when it blocks more than the current conversation/change |

A low-risk plan-only request does not automatically publish an issue unless the user supplied one or asked to add it. A standard/high-risk repository-persisted plan normally creates/reuses an issue; invoking the planning skill authorizes that repository-scoped creation unless the user explicitly says local-only/no GitHub. If GitHub is unavailable or excluded, the decision-complete record may still be `planned`, but its Issue field records the limitation and no Project `Ready` or delivery transition occurs. This keeps plan state separate from live-work state.

## Issue and change-record relationship

The issue and change record link both ways but do not duplicate content.

| Issue owns | Change record owns |
| --- | --- |
| Problem/outcome discussion | Baseline commit and inspected current state |
| Priority, horizon, milestone, assignee, dependencies | Decision-complete implementation plan |
| Live state and cross-work hierarchy | Exact implementation/proof/review evidence |
| User/team discussion | Deviations and ready-PR outcome |

The issue body receives one remote `Plan` link after the standalone plan branch is pushed (or when the delivery branch is first pushed). The change record header receives the canonical issue URL. Do not paste the full plan into the issue.

## PR relationship

- A standalone plan PR contains only the change record and already-settled canonical planning-document changes. Its body uses `Refs #N`, never a closing keyword. It runs Docs checks and stops ready without implementation.
- If implementation begins before that plan PR merges, delivery resumes the same branch/PR, restores native draft or `do-not-merge`, and changes the record to `active`. If it merged, delivery branches from the updated default branch.
- PR body links the change record and uses `Closes #N` only for an implementation task that is complete when merged.
- A PR that contributes to a wider Feature uses `Refs #N` for the parent and closes only its bounded sub-issue.
- Parent Feature issues remain open through operator/release acceptance when that is part of their outcome.
- The plugin never closes an issue merely because its own ready-PR endpoint was reached.

GitHub closing keywords take effect when a PR targeting the default branch is merged. See [Linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue).

## Actual pull-request review contract

Review occurs after the PR exists. A local implementation review, passing tests, or a diff examined before push does not satisfy the PR-review gate.

```text
candidate implementation + record
             |
             v
commit + push + create/update PR
             |
             v
checks + stable PR evidence snapshot
             |
             v
fresh $review-repository-pull-request context
             |
             +-- changes-required --> record -> fix -> prove -> push new head
             |                                            |
             |                                            `--> full PR re-review
             |
             +-- evidence-blocked --> remain under review
             |
             `-- clean --> final record commit -> final exact-head review
                                                   |
                                                   v
                                      publish COMMENT review + readback
                                                   |
                                                   v
                                                 complete
```

### Draft-capability branch

Draft PRs are capability-dependent. The personal GitHub Free/private baseline does not support them.

| Capability | Under-review representation | Completion transition |
| --- | --- | --- |
| Native draft supported | Draft PR | `gh pr ready` after all gates |
| Native draft unsupported | Normal open PR plus `do-not-merge` label and Project `In review` | Remove `do-not-merge` after all gates |

The fallback label is informational, not branch protection. Onboarding creates it with description `Review or required checks are incomplete; do not merge.` The workflow reads back `isDraft` or label state and never claims a draft/ready transition on an unsupported plan.

### Required evidence snapshot

Run the shared `Get-AzureWorkflowPullRequestEvidence.ps1` helper. It must exhaust pagination for files, commits, reviews, general comments, inline comments, and GraphQL review threads. It captures the starting and ending base/head OIDs and fails the snapshot if either changes during collection.

The reviewer additionally inspects the complete local diff:

```powershell
git diff --stat <baseRefOid>...<headRefOid>
git diff --check <baseRefOid>...<headRefOid>
git diff <baseRefOid>...<headRefOid> --
```

Both commit objects must exist locally. Fetching exact refs is allowed by the review skill, but checkout, branch switching, stashing, resetting, cleaning, and worktree creation are not.

### Review result and GitHub identity

The public review skill returns `clean`, `changes-required`, or `evidence-blocked`, bound to the exact `headRefOid`. The owning workflow may publish the returned content verbatim through:

```powershell
$reviewBody | gh pr review $pullRequest --repo $repository --comment --body-file -
```

The fixed body states the reviewed SHA and that this is a fresh Codex review using the current GitHub identity, not human or separate-account approval. GitHub prohibits PR authors from approving their own PRs; the workflow never calls `--approve` or `--request-changes` for a same-author agent review. See [Reviewing proposed changes](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/reviewing-proposed-changes-in-a-pull-request).

If GitHub explicitly rejects a same-author `COMMENT` review, publish the same unedited body once with `gh pr comment --body-file -` and describe it as a review-evidence comment. Do not retry as approval, hide the fallback, or treat a general comment as `reviewDecision`.

A native approval or requested-changes decision from another account remains authoritative GitHub review state. The plugin never impersonates that account, dismisses its review, or uses admin bypass.

### External feedback handling

Before remediation, collect and deduplicate:

1. submitted reviews;
2. general PR/issue comments;
3. inline review comments; and
4. GraphQL review threads with resolved/outdated state and all replies.

Classify every item against current code, authority, scope, and head:

| Classification | Required action |
| --- | --- |
| Actionable and in scope | Fix automatically under delivery authority; prove; reply with commit/path/check evidence; resolve after readback |
| Already addressed | Reply with exact current evidence; resolve only when unambiguous |
| Clarification needed or contradictory | Ask; leave unresolved |
| Scope expanding | Do not implement silently; propose a separate issue/decision |
| Incorrect | Keep correct behavior and respond with evidence; never change code for agreement theatre |
| Non-actionable | No reply required |

Resolution does not clear `CHANGES_REQUESTED`. When a distinct reviewer requested changes, delivery re-requests their review after remediation. The plugin never dismisses reviews. See [Incorporating feedback](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/incorporating-feedback-in-your-pull-request).

### Exact feedback-mutation route

Only the delivery/onboarding/planning owner runs these mutations, never the read-only reviewer. It first checks the collected `viewerCanReply`/`viewerCanResolve` fields and confirms the target IDs still match the current thread.

Reply to an inline review thread with evidence:

```powershell
$replyMutation = @'
mutation($threadId: ID!, $body: String!) {
  addPullRequestReviewThreadReply(
    input: {pullRequestReviewThreadId: $threadId, body: $body}
  ) {
    comment { id url }
  }
}
'@

$replyPayload = @{
  query = $replyMutation
  variables = @{ threadId = $threadId; body = $replyBody }
} | ConvertTo-Json -Depth 8 -Compress

$replyPayload | gh api graphql --input -
```

After readback proves the reply exists and the current code fully addresses the thread, resolve it:

```powershell
$resolveMutation = @'
mutation($threadId: ID!) {
  resolveReviewThread(input: {threadId: $threadId}) {
    thread { id isResolved resolvedBy { login } }
  }
}
'@

$resolvePayload = @{
  query = $resolveMutation
  variables = @{ threadId = $threadId }
} | ConvertTo-Json -Depth 8 -Compress

$resolvePayload | gh api graphql --input -
```

Re-request a distinct individual reviewer only after the remediation commit is pushed:

```powershell
$requestPayload = @{ reviewers = @($reviewerLogin) } |
  ConvertTo-Json -Depth 4 -Compress

$requestPayload | gh api --method POST `
  "repos/$repository/pulls/$pullRequest/requested_reviewers" --input -
```

The workflow verifies that `$reviewerLogin` is neither the PR author nor the authenticated agent identity. A general PR comment is answered with one evidence comment rather than pretending GitHub has a threaded general-comment reply. Every mutation is read back through the complete collector. If reply, resolution, or re-request fails, record the exact failure and leave the item unresolved; never continue by dismissing or bypassing the review.

### Re-review and final-head rules

- Any tracked code, test, config, IaC, migration, generated file, or documentation change invalidates the prior clean verdict.
- A re-review receives previous findings for disposition but independently checks the entire current diff.
- CI and review must refer to the same final head.
- The owner records remediation rounds and prepares the final change-record/status commit before the final attestation.
- No tracked change occurs after the final clean exact-head review. Its durable evidence lives on the PR to avoid a self-referential “record the review, then invalidate it” commit.
- Immediately before and after the ready/fallback-label transition, refresh head, checks, review decision, reviews, and unresolved threads. New blocking feedback returns the PR to under review.

## Onboarding mutations

An explicit full onboarding request authorizes repository-scoped GitHub setup after the agent presents the exact existing state and intended changes:

- enable Issues if disabled;
- add issue forms and PR template in the onboarding branch;
- create or reuse one linked Project;
- create required Project fields, the owner-route work-kind labels, justified registered facets, and conditional `do-not-merge` fallback label;
- create milestones only for approved exact releases; and
- populate issue-form Project references.

It does not authorize organization-wide issue-type changes, deleting/replacing an existing Project, deleting/renaming in-use labels or forms, bulk issue creation/relabelling, closing existing issues, or changing branch protection. Those need an exact impact preview and explicit user decision.

## Verification

1. Validate all YAML forms locally.
2. Confirm the forms appear on the default-branch template chooser after merge (or on a disposable validation repo before completion where branch timing prevents this).
3. Read back repository owner type, the selected exactly-one-kind encoding, registered category labels/forms, any native types used, milestones, Project ID, field IDs/options, and repository link.
4. Read back Project workflow names/enabled state and record whether the default close/merge-to-Done behavior is active.
5. If a template or human enhancement was used, read back queryable view/workflow state and distinguish any human-only chart evidence.
6. Create disposable base/custom-form and maintainer-blank validation issues only in an explicitly approved test repository; verify kind/facets/semantic completeness/Project membership, then close them with a clear test reason. Do not create test issues in the production work repository.
7. Verify an existing/safe sample hierarchy and dependency in the approved test repository.
8. Confirm labels/Project fields contain no duplicated kind/status/priority/horizon/release/relationship metadata, custom namespaces are registered, and all label/issue/Project/field queries exhausted pagination.
