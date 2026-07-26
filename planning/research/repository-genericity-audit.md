# Repository-genericity audit

## Question

Is `azure-workflow` a reusable Azure repository workflow plugin, or is it accidentally a plugin for one source project?

## Conclusion

The architecture is reusable because its public skills are divided by user goal and authorization boundary—onboard, plan, deliver, explain, review, and operate—not by product domain. Azure is the deliberate platform scope; no business domain, feature taxonomy, operator workflow, product wording, repository layout beyond the declared workflow spine, or source-project lifecycle is a plugin default.

The remaining overfitting risk is not the six-skill architecture. It is leakage through examples, copied assets, default labels, absolute workstation paths, or source-project policy embedded in packaged references. The controls below make that boundary testable.

## Fixed, selected, and discovered layers

| Layer | Fixed by plugin | Selected during onboarding | Owned by target repository |
| --- | --- | --- | --- |
| Workflow | Five skill routes, clean-tree rule, review and mutation boundaries | Risk depth, optional conditional routes | Named change, current human choices, local exceptions |
| Documentation | Document classes, routing, schemas, drift checks | Which conditional files/areas/design assets are needed | Product behavior, terminology, architecture, operations, decisions |
| GitHub | Four universal work kinds, portable field semantics | Personal-label versus compatible organization-native route; justified facets/forms | Actual labels, areas, milestones, issues, Project IDs |
| UI/design | Conditional `design/` contract and UI state/review method | Existing token/runtime system and asset locations | Brand, colour, type, logos, fonts, components, patterns, real examples |
| Azure | Read/approval boundaries and Microsoft evidence route | Tenant/subscription/environment and IaC owner | Actual services, resource names, topology, recovery, cost choices |
| Quality | Purpose-revealing names, proportional proof, path-aware CI | Repository canonical commands and supported contracts | Framework conventions, callers, tests, release gates |

Only the first column is packaged as a default. The other values are discovered and written into the target repository's authorities.

## Why it is not source-project-specific

1. No public skill name or trigger contains a product domain.
2. Large feature conversion accepts arbitrary identifiers and product areas; it does not assume a case, report, email, finance, or other domain model.
3. Human-authored sources are classified from explicit target evidence rather than their folder names; a repository-specific `operator-notes/` authority declaration is preserved without becoming a plugin default.
4. Project-specific issue categories are discovered and registered as orthogonal facets rather than shipped as defaults.
5. UI/design templates define slots and ownership, not a palette, logo, font, component set, copy style, or journey.
6. Azure resources are discovered from repository/IaC/current scope; no source-project topology is embedded.
7. Research case studies under `planning/research/` are evidence for design decisions and are never packaged into a skill or onboarding asset.

The plugin repository's publisher, homepage, initial private GitHub target, and personal-account capability evidence identify the plugin distribution. They do not constrain the owner or domain of a repository that later installs the plugin.

## Clean-room packaging boundary

```text
reference projects + case-study research
                  |
                  v
       extract general failure/decision rule
                  |
                  v
          planning specification
                  |
                  v
     package allowlist + domain-leak test
                  |
                  v
 generic skills/references/templates/scripts
                  |
                  v
 target facts discovered during onboarding
```

Allowed in `plugins/azure-workflow/`:

- platform/tool names required to execute the Azure workflow;
- generic schemas, placeholders, validation rules, and workflow decisions;
- neutral examples that cannot be mistaken for product defaults; and
- links to primary platform/specification documentation.

Forbidden in `plugins/azure-workflow/`:

- predecessor/source-project names, feature IDs, user roles, workflows, UI text, product areas, Azure resource names, or repository paths;
- copied operator notes, feature catalogs, screenshots, logos, fonts, emails, documents, or test data;
- a default area/component/severity taxonomy;
- absolute workstation paths; and
- migration/lineage wording that makes a target repository appear to descend from a reference project.

## Research quarantine

Named case studies may remain under `planning/research/` when they are clearly labelled research evidence, are not linked as target-repository authority, and are excluded from plugin packaging. General standards and workflow examples use neutral placeholder identifiers such as `<capability-id>` rather than case-study vocabulary.

Machine-specific setup evidence may remain only in repository implementation/delivery notes for this plugin itself. It must not appear in packaged skills or onboarding templates, and it must not be presented as a requirement for target repositories.

## Validation contract

Repository-root `tests/Test-PluginPackage.ps1`, not the shipped plugin runtime validator, owns the clean-room check. It:

1. compares `plugins/azure-workflow/` to the exact package allowlist;
2. scans packaged skills, references, templates, and scripts for source-project names/identifiers recorded by the extraction audit;
3. rejects absolute drive-letter, UNC, profile, or source-repository paths in packaged prose/templates;
4. rejects unresolved domain examples and non-template product values;
5. proves onboarding design/GitHub assets contain schemas but no brand, taxonomy, test data, or business facts; and
6. uses a mutation fixture with a neutral fake product marker to prove the check fails.

`Test-AzureWorkflowPlugin.ps1` remains portable and checks only generic installed-package invariants. It does not ship a denylist naming the repository from which the plugin was designed.

## Audit result and required corrections

The planned architecture passes, subject to these specification corrections in the same revision:

- replace domain-specific capability examples outside the quarantined case-study research;
- rename the large-catalog acceptance scenario generically;
- generalize references to excluded source-project policy in validators and implementation prose;
- keep local stale-marketplace repair outside the reusable plugin contract;
- add the exact conditional `design/` standard and neutral onboarding templates; and
- require package clean-room validation before implementation acceptance.

## Definition of reusable

The plugin is reusable when a fresh-thread onboarding test can apply it to at least:

1. a UI-bearing Azure repository with an existing design/token system;
2. a UI-bearing Azure repository without an existing design system; and
3. an Azure backend/IaC repository with `Visual UI: absent`;

without source-project terminology, copied product facts, invented assets, empty design bureaucracy, or a second canonical owner for existing repository truth.
