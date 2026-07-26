# Approved plan: Azure Workflow repository lifecycle plugin

Approved foundation: 2026-07-26

Research revision: 2026-07-26

## Outcome

Build one Codex plugin, `azure-workflow`, that can be installed into an existing Azure-oriented repository and then own its repository workflow from conversion through planning, implementation, plain-language explanation, review, GitHub delivery, and controlled Azure operation.

The plugin is deliberately one distribution unit with six user-goal skills:

1. `onboard-azure-repository`
2. `plan-azure-repository-change`
3. `deliver-azure-repository-change`
4. `explain-repository`
5. `review-repository-pull-request`
6. `operate-azure-repository`

This split follows current [OpenAI skill-building guidance](https://developers.openai.com/plugins/build/skills): split workflows when triggers, inputs, or success criteria differ, then use concise `SKILL.md` routing and conditionally loaded references. It also follows the [Agent Skills specification](https://agentskills.io/specification) progressive-disclosure model. The [Cloudflare skills repository](https://github.com/cloudflare/skills) supports a routing-wrapper pattern for one coherent goal, but it also contains separate goal-specific skills; it is not evidence that unrelated authorization boundaries should be collapsed into one monolith.

## Package contract

- Plugin path: `plugins/azure-workflow/`.
- Marketplace path: `.agents/plugins/marketplace.json`.
- Initial version: `0.1.0-alpha.1`.
- Local development reload: `0.1.0-alpha.1+codex.<cachebuster>`.
- No hooks, app, workflow database, JSON task state, handoff protocol, or vendored Azure-document corpus.
- One shared plugin-root `references/dotnet-projects.md` is conditionally consumed by onboarding, planning, delivery, explanation, and review; it is not a separate .NET skill.
- PowerShell 7 is the only plugin-owned script runtime.
- Azure credentials stay with Azure CLI/identity tooling and are never stored by the plugin.

## Exact MCP and tool contract

The plugin packages exactly two MCP servers:

1. Azure MCP: `@azure/mcp@3.0.0-beta.29` via `npx`, telemetry disabled. This exact pin matched the npm `latest` dist-tag during the 2026-07-26 planning check; committed configuration never uses `@latest`.
2. Microsoft Learn MCP: `https://learn.microsoft.com/api/mcp` using streamable HTTP.

GitHub is handled through repository-native Git plus `gh`/`gh api`. No GitHub MCP is added because it would duplicate credentials and tool paths without eliminating the need for GitHub Projects GraphQL operations.

Registration is not treated as invocation. The lifecycle skills explicitly call Microsoft Learn when the user requests Microsoft guidance or when a current Microsoft-controlled version, support, host, API, service, deployment, migration, security, reliability, or tooling fact can materially affect the outcome. Onboarding makes a scoped support/host currency pass for .NET repositories; planning records reusable evidence; delivery refreshes only for drift, contradiction, missing evidence, or a new Microsoft-dependent decision; explanation calls it when current Microsoft facts are material to understanding; independent review refreshes decisive current claims; Azure operations call it when current platform guidance affects the operation. Pure repository-owned logic, formatting, and ordinary documentation work do not trigger a ceremonial query. The exact call, reuse, refresh, evidence, and failure rules are in [the MCP server contract](interfaces/mcp.md).

## Repository documentation contract

An onboarded repository receives this canonical spine:

```text
AGENTS.md
README.md
docs/
|-- index.md
|-- product/
|   |-- index.md
|   |-- capabilities.md          # when capability count justifies an index
|   `-- areas/                   # only for real product areas
|       `-- <area>.md
|-- roadmap.md
|-- architecture.md
|-- operations.md
|-- decisions/
|   `-- NNNN-title.md
`-- changes/
    `-- YYYY-MM-DD-slug.md
design/                           # required when docs/product declares Visual UI: present
|-- README.md
|-- brand/                       # style, imagery, logo authority/source mapping
|-- foundations/                 # colour, typography, layout, motion, accessibility
|-- tokens/                      # one canonical token source or an explicit none
|-- assets/                      # icon/font source inventories
|-- components/
|-- patterns/
`-- references/
```

Ownership is exact:

| Question | Canonical owner |
| --- | --- |
| What should the product do? | `operator-notes/` where applicable, then `docs/product/` according to the declared authority map |
| What outcomes are Now/Next/Later/Not planned? | `docs/roadmap.md` |
| What work is live and who owns it? | GitHub Issues, Project, and milestones |
| How will this one approved change be implemented? | One `docs/changes/` record |
| What does the system do now? | Code/config plus `docs/architecture.md` and `docs/operations.md` |
| What visual language/assets/components/patterns should the UI use? | `design/`, when `Visual UI: present` |
| Why was a durable choice made? | Active ADR in `docs/decisions/` |
| What happened historically? | Merged change record, PR, commits, and release |

There is no canonical general-purpose `docs/plans/` directory and no giant roadmap checklist. Existing plan folders may remain only during conversion until triple parity passes.

## Large feature-catalog contract

Onboarding a repository with a large feature corpus does not turn every feature row into an issue or detailed plan.

```text
large feature corpus
      |
      v
stable capability IDs + intended behavior
      |
      +--> docs/product/capabilities.md
      +--> docs/product/areas/<area>.md
      |
      v
exact release or unallocated + Now/Next/Later/Not planned
      |
      +--> docs/roadmap.md
      |
      v
only activated Now outcomes become parent GitHub issues
      |
      v
sub-issues and change records are created just in time
```

Conversion retires the old corpus only after identifier parity, material-claim parity, and link/authority parity all pass. `Not planned` is a durable product boundary, not an open backlog issue.

## Version and release contract

Use [Semantic Versioning 2.0.0](https://semver.org/) for immutable releases, with declared supported contracts. Keep these independent:

- semantic version: compatibility/release identity;
- maturity stage: prototype, alpha, beta, release-candidate, stable, maintenance, or retired;
- roadmap horizon: Now, Next, Later, or Not planned;
- work state: Triage, Ready, In progress, In review, or Done in GitHub.

Alpha/beta/RC names do not themselves prove readiness. Each has the evidence gates in [versioning and release stages](standards/versioning-and-release-stages.md). `1.0.0` requires an explicit supported-contract and stable-release decision.

## GitHub contract

- Repository issue forms: `feature.yml`, `bug.yml`, `task.yml`, `decision.yml`, plus `config.yml` disabling blank issues for ordinary contributors by default. Maintainers can still open blank issues, and private-repository form validation is not treated as an enforcement boundary.
- Canonical work kinds are Feature, Bug, Task, and Decision. On a personal-account repository, the forms apply `type:feature`, `type:bug`, `type:task`, and `type:decision`. On a compatible organization repository, Feature/Bug/Task may map to native issue types and Decision to Task + `decision`; the plugin never mutates organization-wide types automatically.
- Every active workflow-owned issue has exactly one semantic work kind. Repository-specific categories are optional registered facets such as `area:*` or `component:*`; they do not create a fifth type. Labels do not duplicate Status, Priority, Horizon, milestones, assignees, or native dependency relationships. The `type:*` family exists only on the personal/fallback work-kind route.
- Project fields: Status, Priority, and Horizon. Use GitHub's built-in Labels, Assignees, Milestone, Parent issue, Sub-issue progress, and Repository fields; use built-in Type only when native organization issue types are available. Do not create a duplicate custom work-kind or target-release field.
- The portable Project core—lifecycle, repository link, fields, items, and status transitions—is created and verified through `gh` plus GraphQL. Saved views, built-in workflow configuration, auto-add, and charts are not falsely claimed as programmatic: use an optional user-selected template or an explicit human enhancement card.
- Do not add a Project-synchronization Action by default. The repository `GITHUB_TOKEN` cannot access Projects; any continuous Project automation would require a separately approved GitHub App or PAT.
- Milestones name exact releases such as `0.4.0-beta.1`, never `V1` or `Phase 2`.
- One activated outcome is a parent Feature issue. Sub-issues are created just in time for independently deliverable work. Dependencies use native blocked-by/blocking relationships when available.
- Planning may update/create an issue only under the issue-required matrix. It never creates one issue per capability row.
- Delivery links the PR with a closing keyword only when the PR fully satisfies the issue. Partial PRs use non-closing links.
- An explicit full onboarding request authorizes one repository-scoped Project setup after current state, owner type, account capabilities, and exact changes are shown. Organization-wide issue-type changes, destructive Project replacement, branch-protection changes, and bulk issue mutations require separate explicit scope.

## Onboarding workflow

1. Require a Git repository and clean worktree, then inspect the current/default branch, open-PR relationship, and every linked worktree before selecting an onboarding baseline. A clean branch already serving another pull request is not repurposed.
2. Inventory instructions, `operator-notes/`, every repository-declared human-owned root, all documentation/plan/feature/work-ledger sources and generators, runtime call paths, rule/configuration owners, source roles, hotspots/churn, code, tests, every verification entry point, CI, deployment, IaC, Azure references, GitHub setup, and ownership evidence. For a visual UI, also inventory surface-specific style guidance, tokens/themes, components, logos, icons, fonts, screenshots/mockups, and runtime asset roots. For .NET, load the shared profile and inventory its actual project/toolchain/host variants without automatic modernization.
3. Establish repository mode, versioning/maturity declaration, authority order, and canonical verification command.
4. Build a claim ledger, legacy-work ledger, rule/configuration authority ledger, source-role/hotspot ledger, GitHub form/label/taxonomy ledger with affected-item counts, and, for large feature corpora, a capability ledger.
5. Resolve same-role material conflicts one question at a time.
6. Write the canonical spine and GitHub taxonomy registry. When `Visual UI: present`, also create the canonical `design/` spine, preserve the existing working token/runtime system as the default owner, and map each approved design source to runtime. Install the four universal issue forms, retain/register justified purpose-specific forms/categories, propose impact-gated retirement for the rest, add the PR template, and establish path-aware CI routing.
7. Convert capability/roadmap/local-work-ledger material using the parity gates above. Do not trust legacy `Now`, `active`, or completion fields mechanically and do not bulk-import local tickets; only a small human-confirmed set of active outcomes becomes GitHub work.
8. Remove superseded copies only after their material facts have a canonical destination and recovery remains available through Git history.
9. Run deterministic validation and proportional repository checks, commit narrowly, push, and create the conversion PR using native draft state when supported or the documented normal-PR fallback.
10. Invoke a fresh `review-repository-pull-request` context against the actual PR, monitor CI, remediate/re-prove/re-push, and repeat complete PR review until the exact-head gate passes. Do not merge.

## Planning workflow

Planning is a public skill and a hard implementation stop boundary. It:

1. Inspects repository authority and actual callers before asking questions.
2. Establishes baseline commit, capability/product link, target release/horizon, risk, scope, exclusions, current state, data/control flow, failure/recovery, UI contract and `design/` effects where relevant, Azure impact, proof, and documentation effects.
3. Uses the real Codex `update_plan` tool for in-session work.
4. Interviews only for unresolved material choices and asks one blocking question at a time.
5. Writes one decision-complete `docs/changes/` record, normalizes its selected issue to exactly one work kind/registered facets/explicit Project membership, and updates only the canonical product/capability/roadmap/ADR documents whose already-settled intended facts changed.
6. Obtains fresh read-only plan review for standard/high risk and runs the documentation-only canonical check.
7. For a standalone remote-backed plan, commits the documentation paths, pushes a scoped branch, opens a plan PR using native draft state when supported or the documented normal-PR fallback, monitors cheap Docs CI, and obtains the required exact-head PR review for standard/high risk. It sets the record to `planned`, transitions the PR out of its under-review marker, and stops without implementation, runtime configuration, IaC, executable CI changes, Azure mutation, or merge. Local-only is an explicit fallback.

When delivery has already been requested, delivery invokes the same planning content/review gate as a prerequisite and continues the same branch/record without creating a separate plan PR.

## Explanation workflow

Explanation is a public read-only skill and a hard no-mutation boundary. It:

1. Resolves the exact feature, path/symbol, architecture term, issue/PR/comment/thread/check, or other subject rather than guessing from similar names or recency.
2. Reads the minimum repository authority and actual code/caller/GitHub/official evidence needed, distinguishing current implemented behavior, intended product behavior, proposed changes, current external guidance/state, and unknowns.
3. Traces real triggers, owners, rules/configuration, effects, failures, and proof for feature/system questions; for feedback, retrieves the exact diff/thread/check context and explains the observation, consequence, requested outcome, stated force, and resolution evidence.
4. Leads with a short ordinary-language answer, then uses a small sequence/diagram, impact, decisive evidence, and next action only when one genuinely exists.
5. Calls Microsoft Learn only under the shared current-guidance gate and routes actual live Azure-state dependence to the read-only operate path.
6. Stops without a PR correctness verdict, plan, implementation, documentation write, GitHub response/state change, or Azure mutation. Those endpoints hand off to review, plan, deliver, or operate.

The default explanation remains in the conversation. The plugin does not create a parallel explainer, FAQ, education, or wiki documentation tree.

## Delivery workflow

1. Require an onboarded clean repository, resolve exact change identity, and normalize the selected issue's one work kind, registered facets, semantic content, and Project membership.
2. Reuse the supplied planned record. If its plan PR is merged, branch from the updated default branch; if it is still open, resume that branch/PR and restore its supported under-review state (native draft or `do-not-merge`). Otherwise invoke planning as an unpublished prerequisite on the delivery branch.
3. Compare baseline drift, set status `active`, create/resume the scoped branch, and call `update_plan`.
4. Implement through real callers with clean purpose-revealing ownership, proportional tests, canonical documentation updates, and no speculative future machinery.
5. In development mode, remove replaced behavior; do not add legacy paths, compatibility shims, dual reads/writes, or silent fallbacks.
6. For UI work, implement the planned state matrix, action-to-owner mapping, wording, accessibility, supported viewport/input boundary, any canonical `design/`/token/source-asset updates, and proportional visual/functional proof.
7. Run focused proof and the canonical path-aware check.
8. Stage literal owned paths, commit narrowly, push, and create/update the PR using native draft state when supported or the documented normal-PR fallback. Set Project Status `In review` and monitor required checks.
9. Invoke a fresh `review-repository-pull-request` context with the actual PR, complete diff, exact base/head, checks, reviews, comments, and threads. Remediate every blocker/required finding, re-prove, push, and repeat a complete review of the new head.
10. Commit the final record/evidence update, obtain one last exact-head PR attestation with no later tracked changes, publish it as a clearly labelled `COMMENT` review, refresh checks/feedback/head, remove the under-review marker, and stop. Do not merge.

## Azure workflow

- Reads, official research, non-mutating validation, and what-if are automatic after identity/scope preflight.
- Prefer repository-owned IaC and route its edits through delivery.
- Before every live mutation, show the exact tenant, subscription, environment, resources, command/tool action, expected effect, required permission, cost/security/reliability impact, recovery, and validation.
- Require fresh explicit approval for that exact operation. Any scope/action change invalidates approval.
- Apply once, verify actual resource state and the real application caller, then reconcile IaC and canonical documentation.
- Fail closed on authentication failure, ambiguous scope, missing recovery, or partial failure. Never log secrets.

## Policy placement

- Short always-on prohibitions and routes belong in `AGENTS.md`.
- Repository-specific product meaning belongs in `docs/product/`.
- Exact commands/check selection belongs in `docs/operations.md` and scripts/CI.
- Reusable workflow rules belong in skill references.
- Deterministic structural requirements belong in validators.
- `operator-notes/` remains immutable key human authority by default.

The Windows/PowerShell, UI wording, internal-Azure-language, permissible-development-data, non-synthetic-example, logical-naming, development-mode, proportional-testing, maintainability, extendability, and non-overengineering rules are placed according to [policy placement](standards/policy-placement.md), not copied wholesale into every skill.

## Build and acceptance

Implementation proceeds through the exact phases in [implementation sequence](delivery/implementation-sequence.md). Acceptance requires:

- one valid plugin and all six valid skills;
- exact tree/reference/assets with no forbidden paths;
- two working MCP registrations;
- deterministic script and documentation-conversion fixtures, including semantic source/parse/render round trips;
- clean-room package tests plus UI-bearing repositories with and without an existing design system, and a no-UI repository;
- a partially removed repository-local workflow-suite fixture proving dirty-tree refusal, coherent policy/check extraction, stale-route/ADR/validator removal, and supported route resolution;
- an overloaded repository-local work-ledger fixture proving lossless capability/history mapping, active-state anomaly detection, human-confirmed activation, and no bulk issue import;
- a neutral accreted-rule-system fixture proving real-call-graph, rule/configuration-authority, source-role, hotspot/churn, bridge-lifecycle, and local/CI reproducibility findings;
- a broad .NET fixture proving conditional profile activation without imposing framework upgrades, `.slnx`, Clean Architecture, Central Package Management, exhaustive tests, or Azure hosting;
- fresh-thread routing/stop tests for all six skills, including explain-versus-review/plan/deliver/operate boundaries;
- feature-catalog, UI/UX, GitHub, path-aware CI, review-remediation, and interrupted-resumption scenarios;
- installed-plugin proof in a new Codex thread;
- a green ready bootstrap PR plus either verified `main` protection or exact evidence that the repository visibility/account plan does not support it; and
- live read-only Azure evidence before the Azure route is called fully proven.

## Decision note: 2026-07-26 research revision

The earlier three-skill `PLAN/DELIVER/REMEDIATE` selector is superseded. Planning is now its own public skill because official guidance and the actual authorization/completion boundary support that split. The plugin count remains one. The documentation, versioning, GitHub, feature-catalog, and UI/UX contracts above are added as normative requirements.

## Decision note: 2026-07-26 personal GitHub baseline

The initial owner `collisionengineers` is a personal account and remains personal. The portable baseline therefore uses repository-owned issue forms and `type:*` labels, a user-owned linked Project, and capability-gated branch protection. Organization-only issue types, organization fields/templates, and private-repository rulesets are optional capability branches rather than installation requirements.

## Decision note: 2026-07-26 actual pull-request review

The user confirmed that local implementation review is not a substitute for reviewing the actual GitHub pull request. `review-repository-pull-request` is added as the fifth public skill because it is a standalone read-only goal with an exact-head verdict. Owning workflows now create the PR before independent review, collect all checks/reviews/comments/threads, repeat full review after every tracked change, and never describe a same-author Codex review as GitHub approval.

The gate distinguishes four things that must not be conflated: implementation self-check, a fresh read-only assessment of the actual PR, durable publication as a GitHub `COMMENT` review, and native approval by a distinct GitHub identity. Delivery always requires the middle two; repository rules may additionally require the fourth.

## Decision note: 2026-07-26 GitHub Projects capability audit

The Project contract now distinguishes a portable programmatic core from unsupported configuration surfaces. Current CLI/GraphQL can own the core, including safe field-option updates, but cannot create/configure views, create/update/enable built-in workflows, configure auto-add, or create charts. A compatible target-owner template is optional; otherwise UI-only enhancements are explicitly human and non-blocking unless repository policy makes one mandatory. The plugin does not add credential-heavy Actions to conceal this boundary.

## Decision note: 2026-07-26 issue taxonomy

The user confirmed that project-specific categories extend rather than replace a universal base. Every active workflow-owned issue therefore has exactly one `Feature`, `Bug`, `Task`, or `Decision` kind. Repository-specific classifications use registered orthogonal label namespaces and are created only when they change filtering, ownership, proof, or response behavior. Status/Priority/Horizon remain Project fields, exact releases remain milestones, and parent/blocking structure remains native GitHub relationships. Forms are intake aids rather than enforcement: private form requirements, maintainer blank issues, and Project write-permission limits are normalized by the owning workflow.

## Decision note: 2026-07-26 reusable boundary and UI authority

The plugin remains Azure-specific but repository- and product-domain-neutral. Public skills divide work by authorization/endpoint rather than source project. Named case studies stay under planning research and no product name, feature ID, business role, UI copy, brand asset, taxonomy default, Azure topology, or workstation path may enter the packaged plugin. Repository-root package tests enforce that clean-room boundary.

For an onboarded repository that declares `Visual UI: present`, the root `design/` directory is mandatory. It owns brand style/imagery, logo sources, colour, typography and font inventory, spacing/layout, motion, accessibility foundations, the route to exactly one token source, component/pattern indexes, and approved references. It links to existing runtime code/assets rather than duplicating them. A no-UI repository does not receive empty design machinery.

## Decision note: 2026-07-26 corrected brownfield implementation and ledger audit

The original-repository case study first appeared stronger than v2 because its present top-level roots, operations evidence, and documentation are mature. Implementation-level inspection corrected that judgment. Critical behavior crosses giant orchestrators, multiple rule stages and languages, central and scattered configuration, database settings, materialized engine copies, replay/compatibility paths, and exported test-only reference code. Extreme hotspot churn and a clean local commit producing a different materialization verdict from exact-head CI confirm that neat folders and green checks do not prove maintainability or reproducibility.

Onboarding now inspects the actual runtime call graph, creates rule/configuration authority and source-role ledgers, reports size/branch/fan-out/churn hotspots, records generated/materialized ownership, and requires explicit released-bridge retirement metadata. It also continues to detect overloaded live-work ledgers, semantic truncation, completed-but-active plans, duplicated adapters, and unresolved PR findings. The original code architecture is a failure-mode fixture, not a template.

For visual repositories, authority is also surface-specific: a website/document brand kit cannot silently govern an internal application that it excludes. CI defaults to pull requests plus pushes to the default branch, and Docs scope must not install or run unrelated whole-repository systems.

## Decision note: 2026-07-26 broad .NET profile

Current Microsoft guidance supports proportional architecture rather than one mandatory .NET layout: small applications may remain simple, non-trivial applications benefit from explicit separation/dependency direction, and distributed services carry additional cost. The plugin therefore packages one shared `references/dotnet-projects.md` profile directly loaded by onboarding, planning, delivery, explanation, and review only when .NET evidence is present and material to the selected goal.

The profile inventories SDK/TFM/support, solution/project graphs, composition roots, options/configuration, DI lifetimes, packages/analyzers, rule ownership, generated code, tests, persistence, hosting, and exact commands. It does not add a public skill, MCP, hook, automatic upgrade, `.slnx` migration, Clean Architecture scaffold, microservices, Aspire, Central Package Management, test framework, warnings policy, or coverage target. The existing Microsoft Learn MCP is actively routed by the lifecycle skills under the shared call policy; it refreshes material current version, support, host, and tooling facts without being called for every .NET change. Local repository authority controls whether a migration is requested.

## Decision note: 2026-07-26 plain-language explanation

The user confirmed a standalone translator/educator workflow for understanding features, technical concepts, pull-request feedback, and check failures. `explain-repository` is added as the sixth public skill because it has a recognizable trigger, read-only no-mutation boundary, and evidence-linked understanding endpoint distinct from review, planning, delivery, and Azure operation. It has two conditional skill-local references, no scripts/assets/state, conditionally consumes the shared .NET profile, and creates no persistent explainer-document hierarchy by default.
