# Azure Workflow planning pack

Status: decision-complete specification; implementation has not started

Revised: 2026-07-26 after checking current OpenAI plugin/skill guidance, the Agent Skills specification, Semantic Versioning, GitHub's current issue/Project model, the Cloudflare skills repository, design-token/accessibility guidance, current Microsoft .NET guidance, and implementation-level evidence from two named brownfield repository case studies.

This folder specifies `azure-workflow`: one Codex plugin that owns brownfield onboarding, durable repository documentation, feature planning, implementation, plain-language explanation, independent review, GitHub delivery, and explicitly approved Azure operations.

The implementation must follow this pack. `ref-files/` is source material only and is not a second specification.

## Reading order

1. [Approved plan](00-approved-plan.md)
2. [System architecture](01-system-architecture.md)
3. [Exact plugin file tree](02-plugin-file-tree.md)
4. Research evidence:
   - [Official guidance and alternatives](research/official-guidance-and-alternatives.md)
   - [GitHub Projects API and CLI capability audit](research/github-projects-api-cli-capability-audit.md)
   - [GitHub issue taxonomy and forms](research/github-issue-taxonomy-and-forms.md)
   - [GitHub pull-request review capability audit](research/github-pull-request-review-capability-audit.md)
   - [Repository-genericity audit](research/repository-genericity-audit.md)
   - [CollisionSpike v2 planning audit](research/collisionspike-v2-planning-audit.md)
   - [CollisionSpike v2 first onboarding run](research/collisionspike-v2-first-onboarding-run.md)
   - [CollisionSpike repository audit](research/collisionspike-repository-audit.md)
   - [CollisionSpike development-base recommendation](research/collisionspike-development-base-recommendation.md)
   - [Microsoft .NET project guidance](research/dotnet-project-guidance.md)
   - [Translator and educator workflow placement](research/translator-educator-placement.md)
5. Core design decisions:
   - [Skill boundaries and progressive disclosure](standards/skill-boundaries.md)
   - [Documentation and planning lifecycle](standards/documentation-lifecycle.md)
   - [Versioning, maturity, and roadmap horizons](standards/versioning-and-release-stages.md)
6. Package and external interfaces:
   - [Plugin manifest and marketplace](interfaces/plugin-manifest-and-marketplace.md)
   - [MCP servers](interfaces/mcp.md)
   - [GitHub work management](interfaces/github-work-management.md)
   - [Hooks](interfaces/hooks.md)
   - [PowerShell scripts](interfaces/powershell-scripts.md)
7. Public skills:
   - [Onboard Azure Repository](skills/onboard-azure-repository.md)
   - [Plan Azure Repository Change](skills/plan-azure-repository-change.md)
   - [Deliver Azure Repository Change](skills/deliver-azure-repository-change.md)
   - [Explain Repository](skills/explain-repository.md)
   - [Review Repository Pull Request](skills/review-repository-pull-request.md)
   - [Operate Azure Repository](skills/operate-azure-repository.md)
8. Repository standards:
   - [Repository documentation](standards/repository-documentation.md)
   - [Authority and conflicts](standards/authority-and-conflicts.md)
   - [Change record](standards/change-record.md)
   - [Policy placement](standards/policy-placement.md)
   - [Repository modes](standards/repository-modes.md)
   - [UI and design system](standards/ui-design-system.md)
   - [.NET project profile](standards/dotnet-projects.md)
9. Executable workflows:
   - [Onboarding](workflows/onboarding.md)
   - [Feature-catalog conversion](workflows/feature-catalog-conversion.md)
   - [Feature planning](workflows/feature-planning.md)
   - [UI/UX](workflows/ui-ux.md)
   - [Change delivery](workflows/delivery.md)
   - [Explanation and education](workflows/explanation-and-education.md)
   - [Independent pull-request review](workflows/independent-review.md)
   - [Azure operations](workflows/azure-operations.md)
   - [Proportional testing and path-aware CI](workflows/testing-and-ci.md)
10. Building and releasing this plugin:
   - [Implementation sequence](delivery/implementation-sequence.md)
   - [Verification and acceptance](delivery/verification-and-acceptance.md)
   - [GitHub and installation](delivery/github-and-installation.md)

## Locked decisions

- One plugin named `azure-workflow`; no plugin-per-stage suite.
- Six focused public skills: onboard, plan, deliver, explain repository, review pull request, and operate.
- Planning is a standalone skill because it authorizes documentation-only repository delivery, forbids implementation, and has a distinct reviewed plan-PR endpoint.
- A standalone plan normally ends as a Docs-only review-complete PR; delivery planning is an unpublished prerequisite on the same implementation branch, so one request never creates two PRs.
- Pull-request review is a public read-only skill because it is a standalone user goal with a different authorization and exact-head verdict. Onboarding, planning, and delivery invoke it in a fresh context after their PR exists.
- Plain-language explanation is a public read-only skill because understanding a feature, term, PR comment, or check is a standalone endpoint. It separates current/intended/proposed facts and stops without verdict, plan, fix, persistent documentation, GitHub response, or Azure mutation.
- UI/UX, documentation maintenance, GitHub tracking, testing, and CI are conditional routes inside the skill that owns the requested outcome.
- .NET is one shared conditional technology profile consumed directly by onboarding, planning, delivery, explanation, and PR review. It adds no separate technology skill, MCP, hook, prescribed architecture, or automatic framework migration. The skills explicitly call the existing Microsoft Learn MCP for current Microsoft-dependent decisions or explanations, reuse scoped evidence when applicable, refresh on drift or decisive independent review, and avoid ceremonial calls for ordinary repository-owned logic.
- A repository with `Visual UI: present` has one root `design/` authority for brand style, imagery, logos, colour, typography/fonts, layout, motion, accessibility, tokens, components, patterns, and approved references. It maps to rather than duplicates runtime UI code/assets. Backend-only repositories do not receive empty design structure.
- The repository owns durable truth; GitHub owns live work state.
- Product behavior lives under `docs/product/`; release outcomes live in `docs/roadmap.md`; one active change is planned in `docs/changes/`; current implementation and operation live in architecture/operations documents.
- Large feature lists become a stable capability index plus product-area contracts and release allocations. They do not become hundreds of issues or permanent implementation plans.
- SemVer, maturity stage, roadmap horizon, and issue state are four separate fields.
- The plugin starts at `0.1.0-alpha.1`.
- GitHub uses four universal work kinds (`Feature`, `Bug`, `Task`, `Decision`), one Project field model, exact-release milestones, parent issues, just-in-time sub-issues, and explicit dependencies. Personal-account repositories encode exactly one work kind with repository labels; compatible organization repositories may use native issue types without the plugin changing organization-wide configuration. Repository-specific categories are additive registered facets, never replacement types or duplicate state/priority/release fields.
- GitHub Project onboarding has a fully scriptable portable core for both personal and organization owners. Saved-view configuration, built-in workflow configuration, auto-add rules, and charts remain copied-template- or human-owned because the current supported API has no mutation surface for them.
- GitHub work uses `git`, `gh`, and `gh api`; no GitHub MCP is packaged.
- Exactly two MCP servers are packaged: Azure MCP and Microsoft Learn MCP.
- No hooks or app connector exist in `0.1.0-alpha.1`.
- PowerShell 7 on Windows is the workflow runtime.
- A clean worktree is mandatory but not sufficient. Onboarding also inspects branch/open-PR purpose and all linked worktrees, never repurposes an active branch, and treats other worktree roots as exclusion boundaries. The plugin never stashes, resets, cleans, or creates a worktree around unrelated changes.
- The normal implementation endpoint is a green pull request with a fresh complete review of the actual PR at its exact final head. The plugin does not merge and never presents a same-author agent review as GitHub approval.
- Azure research, reads, validation, and what-if may run automatically; every Azure mutation requires fresh, single-use approval for the exact operation.
- `operator-notes/`, when present, is immutable key business authority unless the user explicitly requests an edit. Other repository-declared human-owned roots are discovered, assigned an explicit authority/mutation role, and preserved rather than hard-coded by product name.
- Repositories declare `development` or `released` mode. Development mode carries no speculative compatibility, legacy, dual-path, or silent fallback code.
- Released compatibility/replay bridges name their supported contract, owner, activation scope, observability, removal trigger, and target removal version or date. A retained bridge without that lifecycle is a finding.
- User-facing UI is self-explanatory and never exposes internal/development wording or internal Azure implementation names.
- Repository-provided data is permitted for development. The workflow does not invent PII/DPIA/retention work and never fabricates domain emails, images, documents, PDFs, or instructions for tests.
- Tests and CI are proportional. Markdown-only changes receive documentation checks; executable or ambiguous changes receive full checks, while GitHub still reports one stable `verify` status.
- Onboarding removes superseded documentation only after claim-level and capability-level parity proves that no material truth was lost.
- Packaged skills, references, templates, and scripts contain no source-project domain facts, assets, paths, or taxonomy defaults. Named case studies remain quarantined research and repository-root acceptance tests enforce the clean-room boundary.
- The initial target is the private, personal-account-owned repository `collisionengineers/azure-workflow`. GitHub Free limitations are reported as capability gaps; they do not trigger account conversion or a paid-plan requirement.

## Change control

If a locked decision changes, update every affected contract in the same planning change and append a dated decision note to [the approved plan](00-approved-plan.md). Do not leave competing specifications. Implementation must not begin while the pack contains contradictory counts, paths, states, versions, or ownership rules.
