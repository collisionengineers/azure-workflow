# Skill specification: `onboard-azure-repository`

## Public purpose

Convert an existing Azure-oriented Git repository to the Azure Workflow documentation, planning, GitHub, review, and delivery standard without losing material product truth or existing capability identity.

## Exact folder

```text
skills/onboard-azure-repository/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
|-- assets/
|   `-- repository/
|       |-- AGENTS.md.template
|       |-- agent-mistakes.md.template
|       |-- architecture.md.template
|       |-- docs-index.md.template
|       |-- operations.md.template
|       |-- product-index.md.template
|       |-- roadmap.md.template
|       |-- pull-request-template.md
|       |-- design/
|       |   |-- README.md.template
|       |   |-- brand/
|       |   |   |-- style.md.template
|       |   |   |-- imagery.md.template
|       |   |   `-- logos/
|       |   |       `-- README.md.template
|       |   |-- foundations/
|       |   |   |-- colour.md.template
|       |   |   |-- typography.md.template
|       |   |   |-- spacing-and-layout.md.template
|       |   |   |-- motion.md.template
|       |   |   `-- accessibility.md.template
|       |   |-- tokens/
|       |   |   `-- README.md.template
|       |   |-- assets/
|       |   |   |-- icons/
|       |   |   |   `-- README.md.template
|       |   |   `-- fonts/
|       |   |       `-- README.md.template
|       |   |-- components/
|       |   |   `-- index.md.template
|       |   |-- patterns/
|       |   |   `-- index.md.template
|       |   `-- references/
|       |       `-- README.md.template
|       `-- issue-forms/
|           |-- bug.yml
|           |-- config.yml
|           |-- decision.yml
|           |-- feature.yml
|           `-- task.yml
`-- references/
    |-- authority-and-conflicts.md
    |-- documentation-conversion.md
    |-- feature-catalog-conversion.md
    |-- github-onboarding.md
    |-- repository-policy-profile.md
    |-- repository-standard.md
    `-- ui-design-system.md
```

There is no skill-local `scripts/` folder. Plugin-root scripts provide deterministic creation/validation. Shared .NET and version/release references live under `plugins/azure-workflow/references/`, outside this skill-local tree, and are linked directly from `SKILL.md`.

`product-index.md.template` contains the exact living product-requirements/PRD-role headings from the repository standard. `AGENTS.md.template` contains no fixed human-source path; onboarding inserts only actual protected boundaries discovered in the target. There is no `operator-notes/`, `PRD.md`, `FRD.md`, or traceability-matrix asset.

## `SKILL.md` frontmatter

```yaml
---
name: onboard-azure-repository
description: Audit and convert an existing Azure-oriented Git repository to the Azure Workflow standard: classify and preserve declared human/controlled-source authority, consolidate durable product requirements, design, and technical documentation, convert large plan/feature corpora, establish versioning and proportional CI, add GitHub issue/PR templates, review the actual conversion pull request at its exact final head, and stop before merge. Use when asked to onboard, adopt, standardize, normalize, or convert an existing repository.
---
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Onboard Azure Repository"
  short_description: "Convert an existing repository to the workflow standard"
  default_prompt: "Use $onboard-azure-repository to convert this repository to the Azure Workflow documentation, GitHub, planning, explanation, review, and delivery standard without losing material truth."

dependencies:
  tools:
    - type: "mcp"
      value: "microsoft-learn"
      description: "Current official Microsoft and Azure documentation"
      transport: "streamable_http"
      url: "https://learn.microsoft.com/api/mcp"

policy:
  allow_implicit_invocation: true
```

The dependency makes Microsoft Learn available; it does not make every call mandatory. Apply the central guidance gate: perform a scoped support/host currency pass for detected .NET and material Microsoft/Azure technology, and query for any conversion recommendation that depends on a current Microsoft fact. Do not call it for every source file or let it override repository authority. If official evidence is unavailable, block only the dependent decision. Read-only Azure evidence may route through `$operate-azure-repository`; onboarding never authorizes Azure mutation.

## Required `SKILL.md` body structure

```markdown
# Onboard Azure Repository
## Authorization and preconditions
## Inventory authority, implementation, plans, design, and GitHub
## Resolve material conflicts
## Convert documentation and feature catalogs
## Establish verification and GitHub routing
## Prove parity, review, and deliver
## Failure behavior
## Resources
```

Keep the body below 500 lines and route detail through direct references.

## Authorization contract

Invocation authorizes one scoped conversion branch/record, repository documentation/template/CI edits, removal of superseded tracked documentation after parity proof, narrow commits, push, capability-appropriate PR creation, CI/review remediation, review-evidence publication, and completion transition.

It does not authorize:

- Git initialization when no repository exists;
- edits, moves, or deletion outside a human-authored source/protected root's declared mutation rule;
- loss of a material claim or capability ID;
- organization-wide issue-type changes, destructive replacement of an existing Project, label/form deletion, in-use label renaming, bulk issue relabelling/creation, GitHub ruleset changes, account conversion/plan changes, or other destructive/external administrative mutation without the exact impact preview and explicit scope confirmation;
- Azure mutation; or
- merge, force-push, branch deletion, stash/reset/clean/worktree behavior.

Repository-owned issue forms, work-kind labels, and the PR template are ordinary onboarding changes. An explicit full onboarding request also authorizes idempotent setup/reuse of one repository-linked Project after the exact repository, owner type, capabilities, existing state, and intended changes are shown. It does not authorize an organization-wide or destructive change.

## Core instructions

1. Require a Git repository and clean worktree; list exact dirty paths and stop otherwise. Inspect the current/default branch, open-PR relationship, and `git worktree list --porcelain`; never repurpose a branch already serving another change and exclude every other linked worktree root.
2. Establish Azure-oriented scope from repository evidence or explicit user intent. A .NET project alone is insufficient. If neither source establishes Azure as a current or intended target, explain the unsupported scope and stop without mutation.
3. Read root/nearest instructions and inventory every relevant human-authored source/protected root before evaluating truth. Record content role and mutation rule separately; preserve an explicit local declaration, but treat an unclassified notes source as non-binding discovery input rather than authority inferred from its name.
4. From an unambiguous clean default-branch baseline, create `workflow/YYYYMMDD-onboard-azure-workflow`, create one onboarding change record, and call the real `update_plan` tool.
5. Work in Windows through PowerShell 7.
6. Load all seven skill-local references before making destructive consolidation decisions; use assets as fillable templates, never blind generic copy. Load the shared version/release reference, and, when .NET project/solution evidence is present, the shared .NET profile and only its applicable variant sections.
7. Inventory claim-level authority across docs and actual code/config/tests/CI/IaC/Azure routes. Trace real entry-point-to-owner call graphs; create a rule/configuration authority ledger; classify live, generated/materialized, reference/test-only, compatibility/replay, and retirement-candidate code; and report size/branch/fan-out/churn hotspots. Inventory every feature/capability ID, local ticket/plan/status ledger, allocation, generated view/source, generator side effect, repository-local workflow adapter, and existing agent incident/mistake/lesson log. Record declared state separately from evidence state. For a visual UI, inventory all brand/style sources, logos, colour/type/font/layout/motion/accessibility rules, tokens/themes, icons, components/patterns/examples, mockups/screenshots, design-source/runtime-asset paths, and the named surface each source governs. For .NET, perform the profile's solution/project/toolchain/host/configuration/package/test/support inventory.
8. Resolve repository mode, version scheme/current version, maturity stage, supported-contract boundary, release authority, and canonical verification command. Apply the Microsoft Learn call gate and record compact official evidence for current support/host facts or recommendations that materially affect conversion. For .NET, distinguish repository support authority from Microsoft lifecycle evidence; do not upgrade or modernize as an onboarding side effect. Ask only unresolved material decisions.
9. Assign `DOC-CON-NNN` to same-role material conflicts; incorporate each answer and rescan affected sources.
10. Create the canonical spine: `AGENTS.md`, `docs/index.md`, `docs/product/index.md` as the living PRD role with `Visual UI: present | absent`, conditional capabilities/functional product areas, `docs/roadmap.md`, architecture, operations, append-only `docs/agent-mistakes.md`, ADRs, and change record. Root `AGENTS.md` lists only actual protected boundaries and states the mistake admission/search/append/read-only-pending rule, low-cognitive-load communication behavior, and supplied-material permission/licensing policy. Preserve controlled formal requirements and their IDs/status where their artifact format remains required; do not create default duplicate PRD/FRD files. Preserve and map existing mistake evidence; create an empty Entries section rather than fabricating incidents. When visual UI is present, create the exact `design/` spine, retain one canonical token source, map every approved design source to runtime, and create no synthetic or placeholder assets.
11. Convert huge feature lists and local work ledgers into stable capability index rows, one canonical product section per behavior, exact-release/unallocated allocations, compact Now/Next/Later/Not planned outcomes, and retained historical proof. Detect active-at-100%, active-empty, overloaded active/verification, empty sequencing, and source/parse/render disagreement rather than trusting legacy states.
12. Do not create one issue per feature or local ticket. Present counts/mappings and ask the human to confirm the small genuinely active set; create parent/sub-issues only for explicitly activated work according to GitHub policy.
13. Build an issue-taxonomy ledger from forms, labels, usage counts, active issues, Project fields, milestones, and canonical areas/components. Establish exactly one universal kind per workflow-owned issue and register only useful orthogonal facets in `docs/operations.md`. Add/update the four base forms, `config.yml`, and PR template; retain/create a custom form only for materially distinct repeated intake and map it to one base kind. Treat private form requirements and form Project auto-add as non-enforcing. Preview and ask before any label/form deletion, in-use rename, or bulk relabelling. For approved live Project setup, verify the portable CLI/GraphQL core and report saved views, extra workflows, auto-add, and charts as template/human surfaces rather than fake automation.
14. Prefer the repository's native verification entry point. Add a thin wrapper only when needed; CI calls it and selects Docs vs Full by path with fail-safe Full fallback. The default workflow verifies pull requests and default-branch pushes without duplicate feature-branch push runs. Docs scope is genuinely cheap, and no validation/generation helper stages files.
15. Remove or relocate old plan/docs only after identifier, material-claim, and link/authority parity pass. Record every grouped source-to-destination mapping.
16. Run structure/link/YAML/path-classification checks, mistake-log schema/unique-ID/append-history checks, semantic source/parse/render checks for generated human views, and proportional native checks. Treat them as mechanical proof; require the fresh conversion-PR reviewer to compare canonical claims with real code/configuration/callers and block unresolved semantic documentation drift.
17. Commit narrowly, push, and create/update the actual conversion PR. Use native draft when supported or normal PR + `do-not-merge` on the personal Free/private fallback. Monitor CI for the exact head.
18. If onboarding makes or discovers a qualifying agent mistake, recover first, append the entry, and link its ID from the onboarding record. Do not backfill inferred incidents merely because legacy material was poor. A newly appended entry invalidates prior exact-head evidence.
19. Invoke `$review-repository-pull-request` in a fresh context with the PR, original corpus, ledgers, canonical result, removed-path diff, parity reports, and raw checks. If a fresh context is unavailable, retain draft or `do-not-merge`, emit a copy-ready review prompt, and stop. Otherwise remediate/re-prove/re-push and repeat complete PR review. After the final record commit, obtain and publish a clean exact-head `COMMENT` review, refresh all feedback/checks, transition the under-review marker, and stop. Do not merge. Return one next human action or an explicit waiting state.

## Output

- Canonical documentation spine and concise `AGENTS.md`.
- One append-only agent mistake log, with existing evidence preserved and no fabricated incident.
- Preserved capability identities and product truth with no competing plan authority.
- Exact version/maturity/mode/horizon declarations.
- For a visual UI, one canonical `design/` authority with style/imagery/logos/colour/typography-font/layout/motion/accessibility/token/component/pattern/reference routes and verified source-to-runtime mappings.
- Four universal repository issue forms, preserved justified custom forms/facets, PR template, and a Project setup result that distinguishes verified portable core, optional enhancements, and exact unsupported/manual gaps.
- One canonical path-aware verification command shared locally and in CI.
- One onboarding record with claim/capability/legacy-work/taxonomy ledgers, runtime/rule/configuration/source-role/hotspot evidence when applicable, affected GitHub-item counts, conflicts, parity, removed/retained paths, proof, review, and recovery.
- Green actual-PR-reviewed result for the exact final head when a GitHub remote is available.

No `.repoplugin/`, task folders, workflow JSON, archive-by-default, giant generated backlog, or second planning pack is created.

## References

| Reference | Contents |
| --- | --- |
| `authority-and-conflicts.md` | roles, materiality, `DOC-CON-NNN`, resolution and interview rules |
| `documentation-conversion.md` | claim ledger, canonical rewrite, duplicate retirement, inaccessible/external/generated source handling |
| `feature-catalog-conversion.md` | capability ledger, clause classification, release allocation, triple parity, giant-list conversion |
| `github-onboarding.md` | four universal work kinds, registered project-specific facets, form/type/label conversion, usage-impact ledger, private-form limitations, Project fields/milestones, idempotent portable core, template/manual enhancement boundary, auth limits, destructive/org-wide gates, CLI/GraphQL capability probes |
| `repository-policy-profile.md` | human-source/protected-root classification, living PRD/functional-specification routing, and generated Windows/mode/UI/supplied-material/licensing/non-synthetic/naming/testing, mistake-log, and low-cognitive-load collaboration root policies |
| `repository-standard.md` | exact spine/headings/links/ADR/change-record/mistake-log/human-navigation/verification schema |
| `ui-design-system.md` | visual-UI classifier, exact `design/` tree, authority, token/source-asset mapping, brownfield conversion, validation, and no-synthetic/no-duplicate rules |
| `versioning-and-release-stages.md` | SemVer, maturity gates, horizon rules, mode relationship |
| `../../references/dotnet-projects.md` | Conditional shared .NET discovery, proportional architecture, project/package/configuration/test/host variant, delivery, and review rules; loaded only when .NET evidence is present |

`github-onboarding.md` has this exact internal outline:

```markdown
# GitHub onboarding
## Owner, plan, CLI, and API capability probes
## Existing issue-form, label, and usage inventory
## Four universal work kinds
## Project-specific category registry and admission test
## Taxonomy mapping and affected-item ledger
## Base and purpose-specific issue forms
## Private-form and Project-auto-add limitations
## Project fields, milestones, and relationships
## Idempotent personal and organization routes
## Destructive, bulk, and organization-wide approval gates
## Readback and failure behavior
```

It contains the exact label/API/GraphQL commands and directly links GitHub's current primary documentation. It does not contain product-specific label values; those are discovered from the target repository and written to `docs/operations.md` only after passing the admission test.

## Assets

Repository assets are starting schemas. The skill fills repository-specific authority, commands, names, and exceptions. It never overwrites an existing file until its material content is mapped and preserved. `agent-mistakes.md.template` is copied as an empty append-only historical record and never receives a synthetic incident. Design templates are conditional on `Visual UI: present`; they contain no brand values, token values, logo/font/icon binaries, screenshots, product wording, or synthetic examples.

## Failure behavior

- No Git repository: stop and request explicit initialization authority.
- Dirty tree: stop with exact paths.
- Clean branch already serving another PR/purpose: stop before branch creation and request/identify the intended default-branch baseline.
- Linked worktree root: inventory and exclude it unless it is the explicitly selected target.
- Inaccessible source: record exclusion/impact; do not claim lossless conversion.
- Unresolved material conflict/mode/release authority: block only affected conversion and name the decision owner.
- Parity failure: retain legacy source as temporary authority and retain native draft or `do-not-merge`.
- Contradictory or overloaded local work ledger: preserve it, show the proposed mapping/counts, and ask for the genuinely active set; do not bulk-create issues or invent status.
- Unresolved design/token/source-asset authority: retain current sources and runtime paths, record the exact conflict, and do not introduce or delete a competing owner.
- GitHub CLI/API feature unavailable: keep repository files, record exact missing capability/upgrade command, and do not fake Project/type setup.
- No remote: complete verified local conversion only.
- Failed native check/review: keep status `active` or `blocked`; never mark ready.
