# GitHub issue taxonomy and forms

Checked: 2026-07-26

## Conclusion

Every repository keeps four universal work kinds: `Feature`, `Bug`, `Task`, and `Decision`. A repository may add project-specific categories only as orthogonal, purpose-named facets. It may not silently replace the four kinds or create a competing fifth `type:*` value.

“Workflow-owned active issue” means an open issue that is in the linked delivery Project, linked by an active/planned change record or PR, is a parent/dependency of that work, or is created/updated by one of the plugin's owning workflows. Closed historical issues are inventoried for label impact but are not silently rewritten.

For the current personal-account baseline, repository labels are the portable encoding. Organization-native issue types and issue fields are capability branches, not requirements.

```text
one issue
   |
   +--> exactly one work kind --------> Feature | Bug | Task | Decision
   |
   +--> zero or more useful facets ---> area:* | component:* | approved namespace
   |
   +--> Project fields ---------------> Status | Priority | Horizon
   |
   +--> milestone --------------------> exact release
   `--> native relationships ---------> parent | sub-issue | blocked-by
```

Each fact has one owner. Labels do not recreate Project fields, milestones, or native relationships.

## Current GitHub facts

- GitHub documents native issue types as an organization feature. Organizations have default `Task`, `Bug`, and `Feature` types and may define up to 25 types. Personal repositories do not receive that organization-level configuration. See [Managing issue types in an organization](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-types-in-an-organization).
- GitHub's newer custom issue fields are also organization-level. They should not be designed into the personal-account portable baseline. GitHub also warns that duplicating the same concept in issue fields and Project fields can cause confusion. See [Managing issue fields in your organization](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-fields-in-your-organization).
- Labels are repository-scoped and can be applied to issues, PRs, and discussions. Creating/editing a label requires write access; applying/removing one requires triage access. See [Managing labels](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels).
- An issue form can statically apply existing labels, one organization-native type, and one or more Projects. A selected dropdown value cannot dynamically apply a corresponding label. The form's `projects` key works only when the issue opener has write permission to that Project. See [Syntax for issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms).
- Issue forms remain public preview. The current form-schema documentation marks `required` validation as public-repository-only, so the private-repository workflow must validate issue completeness itself rather than treating the web form as an enforcement boundary. See [GitHub form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema).
- Templates become available from the default branch. `blank_issues_enabled: false` hides blank issues from ordinary contributors, but maintainers still see a maintainer-only blank option. See [Configuring issue templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository).

These limitations mean the plugin must normalize issues it touches; templates alone cannot guarantee taxonomy, completeness, or Project membership.

## Universal work kinds

Exactly one semantic work kind is required for every active issue owned by the workflow:

| Kind | Meaning | Completion meaning |
| --- | --- | --- |
| `Feature` | User/operator outcome or product capability | The bounded outcome and its release/operator acceptance are complete |
| `Bug` | Observed behavior differs from intended or supported behavior | Intended behavior is restored and proved |
| `Task` | Bounded technical, documentation, operational, research, migration, or release work | The named output and proof are complete |
| `Decision` | A material human choice is required | The decision is made and recorded; follow-on implementation is separate work |

A research spike is a `Task`; an incident is normally a `Bug` or operational `Task`; UI, security, Azure, documentation, and data are facets or scope, not new work kinds.

Personal/fallback encoding:

```text
type:feature
type:bug
type:task
type:decision
```

Compatible organization encoding:

- use existing native `Feature`, `Bug`, and `Task` types;
- use an existing compatible native `Decision` type when present;
- otherwise encode Decision as native `Task` plus the `decision` label; and
- never create, rename, disable, or delete organization types automatically.

## Project-specific category policy

Project-specific categories are additive facets. The default namespaces are:

| Namespace | Cardinality | Use | New-label default color | Example |
| --- | --- | --- | --- | --- |
| `area:<slug>` | zero or more | Stable user/product/business area used for filtering or ownership | `#006B75` | `area:billing` |
| `component:<slug>` | zero or more | Stable technical/deployment component that changes routing or verification | `#5319E7` | `component:web-client` |
| `severity:<slug>` | zero or one; opt-in | A documented incident/bug impact scale that changes response behavior | declared scale: critical `#B60205`, high `#D93F0B`, medium `#FBCA04`, low `#C2E0C6` | `severity:critical` |

A repository may define another lowercase namespace only when all of these are true:

1. it answers a recurring operational question that existing metadata cannot answer;
2. it is backed by current canonical product, architecture, or operations structure;
3. it changes filtering, ownership, verification, or response behavior;
4. its values are mutually clear and have non-empty descriptions; and
5. the namespace and values are registered in `docs/operations.md`.

Colors are presentation defaults, never semantic authority. Preserve a compatible existing color; use the table only for a newly created label. A custom namespace declares one stable default color in its registry decision.

Do not create a category merely because a term appears in one plan. Do not pre-create labels for every future feature or source-code directory.

Forbidden category duplicates:

```text
status:*       Project Status owns this
priority:*     Project Priority owns this
horizon:*      Project Horizon owns this
version:*      milestone owns exact release
release:*      milestone owns exact release
phase:*        maturity/version/roadmap owns this
owner:*        GitHub assignee and CODEOWNERS/repository authority own this
blocked:*      native issue dependencies own this
```

The exceptional PR-only `do-not-merge` label and a justified `external-blocker` label are workflow controls, not issue categories.

### Labels that are not project categories

Repository/community annotations such as `help wanted`, `good first issue`, `duplicate`, `invalid`, `question`, `wontfix`, or `documentation`, plus integration-owned labels, may coexist when useful. They do not satisfy or replace the one-kind rule. The workflow preserves unknown/community/tool labels unless they conflict with a canonical kind or duplicate typed metadata; it never repurposes them silently.

GitHub's default `bug` and `enhancement` labels duplicate the canonical work-kind dimension. Onboarding maps their active use to `type:bug`/`type:feature` on the personal route, but rename/removal still follows the impact-preview approval rule. Closed historical use remains untouched unless included in an approved migration.

Only category labels the plugin applies, filters on, or treats as authority must use a registered namespace. An unknown non-category label is inventoried, not automatically rejected or deleted. If a repository depends on it for routing/filtering, onboarding registers or proposes a namespaced migration.

## Registry and authority

`docs/operations.md` owns a concise `GitHub work management` section:

```markdown
## GitHub work management
### Work kinds
### Project-specific categories
### Project fields, milestones, and relationships
### Issue and pull-request lifecycle
### GitHub capability limitations
```

Its category registry uses:

```markdown
| Label | Meaning | Applies to | Operational use | Authority |
| --- | --- | --- | --- | --- |
| `area:billing` | Billing user workflows | Issues and PRs | Filter and route billing changes | `docs/product/areas/billing.md` |
```

When there are no justified facets, the section contains the exact sentence `No project-specific categories are currently registered.` Do not create placeholder labels or an empty speculative table.

`AGENTS.md` contains only the invariant: use exactly one work kind, use only registered custom categories, and follow the detailed operations link. It does not duplicate the registry.

## Issue-form policy

The plugin always ships the four base assets. Onboarding may preserve or create additional target-repository forms only when their questions materially differ from every base form.

```text
candidate custom form
        |
        +-- only a shortcut for an area/component? --> do not create
        |
        +-- materially different repeated intake? --> map to one base kind
                                                     + static registered facets
                                                     + purpose-specific questions
```

Rules for every additional form:

- purpose-named filename and chooser name;
- exactly one base work kind;
- only existing, registered static labels;
- no duplicate Status/Priority/Horizon/release fields;
- no synthetic examples or repository-internal narration;
- no form per capability, folder, or planned feature; and
- direct registration in `docs/operations.md`.

An area dropdown may be added when it genuinely helps intake, but its submitted Markdown value is not assumed to set a label. The agent reconciles the answer to a registered label when it next triages/plans/delivers the issue. On a private repository it also checks all required semantic content itself.

## Onboarding conversion algorithm

```text
inventory forms + labels + usage counts + Project metadata + canonical areas
                              |
                              v
build taxonomy ledger: retain | map | create | retire-proposal | conflict
                              |
                              v
install four universal kinds + register justified facets
                              |
                              v
validate every active/touched issue has exactly one kind
                              |
                              v
preserve custom forms only when their intake is materially distinct
                              |
                              v
preview any rename/delete/bulk relabel with affected counts
                              |
                  explicit approval for destructive/bulk migration
```

The onboarding change may create missing canonical labels, correct their descriptions/colors, add the base forms, and normalize issues that onboarding itself creates or updates. It does not delete labels, rename an in-use label, remove a custom form, or bulk relabel existing issues without presenting the exact mapping and affected issue/PR counts for approval.

Prefer a one-to-one label rename over delete/recreate when an approved migration preserves meaning and GitHub associations. Conflicting or many-to-one labels remain until the user chooses the canonical meaning.

## Ongoing ownership

- Planning and delivery require their selected issue to have one work kind, registered facets only, required semantic content, and Project membership. They repair unambiguous in-scope metadata and ask one focused question when classification is ambiguous.
- PR review reports taxonomy drift that affects traceability but remains read-only.
- Re-running onboarding audits the full active issue set and proposes migrations; there is no daemon and no Project-synchronization Action by default.
- Issue-form `projects` entries are convenience, not the source of truth. Each owning workflow explicitly reads back/adds its issue and PR to the Project because collaborators may lack Project write access.

## Huge feature lists

The taxonomy does not turn a capability catalog into hundreds of issues. Capabilities remain in product documentation and roadmap allocation. Only approved `Now` outcomes become Feature parents; independently deliverable near-term work becomes just-in-time Bug/Task/Decision sub-issues.

```text
capability catalog --not--> one issue per row
        |
        `--> approved Now outcome --> Feature parent
                                      `--> just-in-time sub-issues
```

## Acceptance

The alpha disposable-repository scenario proves:

1. all four personal-account `type:*` labels and forms;
2. a registered `area:*` category and one valid custom form mapped to a base kind;
3. rejection of multiple/missing work kinds and workflow-used unregistered category namespaces while preserving unrelated community/tool labels;
4. rejection of labels duplicating Project fields or milestones;
5. preservation plus impact-counted migration proposal for existing labels/forms;
6. private-repository issue-content validation independent of form `required` behavior;
7. maintainer-created blank issue normalization;
8. explicit Project membership reconciliation when form auto-add is unavailable; and
9. no issue explosion from the large-feature-catalog fixture.
