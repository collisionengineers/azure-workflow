# GitHub Projects API and CLI capability audit

Checked: 2026-07-26

Scope: current GitHub.com Projects, GitHub CLI, and the public GraphQL schema. Re-probe at implementation and onboarding time because CLI and schema coverage can change.

## Conclusion

The old description that GitHub Projects cannot be controlled through the CLI/API is no longer accurate. The portable operational core is controllable for personal and organization owners: project lifecycle, repository/team links, fields, items, field values, collaborators, and status updates all have supported CLI or GraphQL paths. Projects can also be copied; organization template designation remains organization-only.

There is still no supported mutation surface for creating or configuring saved views, configuring/enabling built-in Project workflows, or creating/configuring charts and insights. Auto-add workflows are configured in the web UI and are deliberately excluded when a Project is copied. The plugin must identify these as manual or template-owned surfaces rather than claiming full programmatic setup.

## Evidence

The local verification used GitHub CLI `2.88.0` and an authenticated token with the `project` scope. `gh project --help` exposed create, copy, edit, close, delete, link/unlink, template, field, and item commands. The published [`gh project` manual](https://cli.github.com/manual/gh_project) states that mutation access requires the `project` scope.

The live GitHub GraphQL mutation schema exposed these Project-specific mutations:

```text
addProjectV2DraftIssue
addProjectV2ItemById
archiveProjectV2Item
clearProjectV2ItemFieldValue
convertProjectV2DraftIssueItemToIssue
copyProjectV2
createProjectV2
createProjectV2Field
createProjectV2IssueField
createProjectV2StatusUpdate
deleteProjectV2
deleteProjectV2Field
deleteProjectV2Item
deleteProjectV2StatusUpdate
deleteProjectV2Workflow
linkProjectV2ToRepository
linkProjectV2ToTeam
markProjectV2AsTemplate
unarchiveProjectV2Item
unlinkProjectV2FromRepository
unlinkProjectV2FromTeam
unmarkProjectV2AsTemplate
updateProjectV2
updateProjectV2Collaborators
updateProjectV2DraftIssue
updateProjectV2Field
updateProjectV2ItemFieldValue
updateProjectV2ItemPosition
updateProjectV2StatusUpdate
```

This agrees with the current [Projects GraphQL reference](https://docs.github.com/en/graphql/reference/projects) and [GitHub's API guide](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-api-to-manage-projects).

## Capability matrix

| Surface | `gh project` | Supported GraphQL | Plugin treatment |
| --- | --- | --- | --- |
| Create/list/edit/close/delete Project | Yes | Yes | Automate and read back |
| Link/unlink repository or team | Yes | Yes | Automate with exact owner/repository |
| Copy an accessible Project | Yes | Yes | Optional target-owner copy route |
| Mark Project as organization template | CLI command exists | Yes | Organization-only; unavailable to a personal owner |
| Create text, single-select, date, number fields | Yes | Yes | Automate |
| Create iteration field | No | Yes | Use `gh api graphql` only when the repository genuinely needs iterations |
| Rename fields or replace single-select/iteration configuration | No dedicated CLI edit command | Yes | Use `updateProjectV2Field`; fetch the complete configuration first and preserve option IDs |
| Add/list/archive/delete issues, PRs, and draft items | Yes | Yes | Automate idempotently |
| Set custom item field values | Yes, one field per invocation | Yes | Automate, then read back |
| Set Assignees, Labels, Milestone, Repository | Not through `project item-edit` | Not through `updateProjectV2ItemFieldValue` | Mutate the underlying issue or PR through its own CLI/API contract |
| Convert a draft item to an issue | No dedicated `gh project` command | Yes | Use GraphQL when explicitly required |
| Project collaborators | No `gh project` command | Yes | Use GraphQL only under explicit access-administration scope |
| Project status updates | No `gh project` command | Create/update/delete | Optional GraphQL route; not required for repository onboarding |
| Read saved views | No structured view command | Yes | Audit names/layout/filter through GraphQL |
| Create/rename/delete/configure saved views | No | No published mutation | Web UI or copied template only |
| Read built-in workflows | No | Yes: name and enabled state | Audit through GraphQL |
| Create/update/enable/configure built-in workflows | No | No; only deletion is exposed | Web UI or copied template only |
| Configure auto-add workflows | No | No supported create/update mutation | Web UI only; copied Projects explicitly omit auto-add |
| Create/configure charts and insights | No | No Project chart/insight mutation surface | Web UI or copied template only |
| Curate recommended organization templates | No | No Project mutation | Organization web UI only |

The absence claims above are based on the current published and live schema: `ProjectV2View` and `ProjectV2Workflow` are queryable objects, but there are no view mutations and workflow mutation coverage is delete-only. No Project chart or insight type/mutation is exposed. These are schema-derived limitations and must be rechecked before implementation.

## Personal-account baseline

The initial target owner `collisionengineers` was verified as GraphQL/API type `User`, not `Organization`, and the user chose to keep it personal. The plugin must not treat that as a reduced or invalid installation mode.

| Concern | Personal baseline |
| --- | --- |
| Work kind | Repository-owned `type:feature`, `type:bug`, `type:task`, `type:decision` labels |
| Issue forms | Repository forms supported; personal route uses static `type:*` labels, private requiredness is not an enforcement boundary, and `projects` auto-add depends on opener Project write access |
| Project owner | The personal account |
| Project fields | Status, Priority, Horizon plus built-in Labels/Assignees/Milestone/relationships/Repository |
| Project presentation | Create/reuse core; optionally copy an accessible Project; no organization-template claim |
| Private branch rulesets | Capability-gated; unavailable on GitHub Free personal private repositories |

GitHub documents issue types as an organization feature in [Managing issue types in an organization](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-types-in-an-organization). GitHub documents rulesets for private repositories as available with GitHub Pro, Team, and Enterprise in [Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets). Neither limitation prevents the Project portable core from operating.

The exact one-kind/additive-category policy and form limitations are specified in [GitHub issue taxonomy and forms](github-issue-taxonomy-and-forms.md).

## Additional operational constraints

- GraphQL cannot add an item and update its field value in the same call. Add first, then update. GitHub documents this explicitly in the [Projects API guide](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-api-to-manage-projects).
- `gh project item-edit` updates one Project field per invocation. Multi-field transitions are sequential and require a final readback.
- Read scope is `read:project`; mutation scope is `project`. A GitHub App may also need repository permissions for linked content.
- The repository-scoped Actions `GITHUB_TOKEN` cannot access Projects. [GitHub's Actions guidance](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/automating-projects-using-actions) requires a GitHub App token or personal access token instead.
- A Project supports at most 50 total fields, including system and organization issue fields, and 50,000 total active plus archived items. See [issue-field limits](https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields/about-issue-fields) and [Project item limits](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-items-in-your-project/adding-items-to-your-project).
- Auto-add workflow count depends on the GitHub plan. The current documented limits range from one on GitHub Free to twenty on Enterprise. See [Adding items automatically](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/adding-items-automatically).
- CLI list commands default to 30 results. Onboarding must use explicit limits/pagination, detect when a requested ceiling is reached, and must not mistake a truncated list for complete state.

## Reliable plugin design

### Required portable core

Every onboarded repository can receive a Project without a browser-driven setup:

```text
create/reuse Project
        |
link repository
        |
normalize Status with preserved option IDs
        |
create/reuse Priority and Horizon
        |
write exact Project reference to issue forms
        |
explicitly add/update work through plan/delivery workflows
        |
read back owner, link, fields, options, and item state
```

New Projects already enable the close-to-Done and merge-to-Done built-in workflows by default according to [GitHub's built-in automation documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-built-in-automations). Onboarding must query and record their observed state rather than assume they remain enabled.

The portable core does not add a GitHub Action merely to synchronize Project state. Repository issue forms attempt Project auto-add only for openers with Project write access; planning/delivery explicitly read back and add/transition their issues and PRs. This avoids a new secret or GitHub App solely to work around the `GITHUB_TOKEN` boundary.

### Optional target-owner Project copy

If the user selects an accessible compatible Project, onboarding may use `gh project copy`. GitHub states that copying preserves views, custom fields, configured workflows other than auto-add, and insights; it does not preserve items, collaborators, or repository/team links. The plugin must therefore relink the repository, reconcile fields, and read everything back. See [Copying an existing project](https://docs.github.com/en/issues/planning-and-tracking-with-projects/creating-projects/copying-an-existing-project).

The plugin must not hardcode a source-project- or organization-specific Project. The source is an optional accessible resource selected or approved by the user. A personal Project copy is not described as an organization template.

### Manual enhancement card

When no suitable template exists, the plugin may offer an exact optional setup card for UI-only enhancements such as one saved delivery view, extra built-in workflows, auto-add, or charts. It must:

1. distinguish required core from optional enhancement;
2. state which setting has no supported mutation;
3. provide the exact intended UI values and Project URL;
4. avoid browser automation as a claimed reliable dependency;
5. read back queryable view/workflow state after the user completes it; and
6. record unqueryable chart confirmation as human evidence, never API proof.

The portable core may be declared complete without these optional enhancements. If a repository explicitly makes a UI-only enhancement mandatory, onboarding remains partial until the human step or a compatible template is confirmed.

## Re-probe contract

Implementation and every full onboarding run must inspect:

```powershell
gh --version
gh auth status
gh repo view --json nameWithOwner,owner,visibility
gh project --help
gh project field-create --help
gh project item-edit --help
```

It must also verify the exact GraphQL mutations it intends to call. Capability is based on observed commands/schema, not a pinned assumption from this research note.
