# Repository instructions

## Purpose and current state

This repository develops `azure-workflow`, one installable Codex plugin for durable repository onboarding, planning, implementation, explanation, pull-request review, documentation stewardship, GitHub work management, and controlled Azure operations.

The repository is currently a decision-complete planning workspace. Plugin implementation has not started. Do not pretend that planned files, commands, skills, MCP servers, or validation already exist.

## Authority and repository map

Read [the planning index](planning/README.md) first.

- `planning/00-approved-plan.md` is the approved product and workflow contract.
- `planning/01-system-architecture.md` owns the selected architecture.
- `planning/02-plugin-file-tree.md` owns the exact intended package tree.
- `planning/standards/`, `planning/workflows/`, `planning/interfaces/`, and `planning/skills/` own their named details.
- `planning/research/` records evidence and case studies; it does not make the packaged plugin project-specific.
- `ref-files/` is read-only extraction material from earlier attempts. It is not current architecture, installable output, or a second specification.
- `.codex/` is workspace development configuration, not content to copy into the plugin or an onboarded repository.
- Root `hooks.json` is a retained legacy input. The approved alpha has no hooks; do not repair or treat this file as the target design. Follow `planning/interfaces/hooks.md`.

When two active planning documents conflict, do not blend them. Identify the conflict, determine the owning document, and update every affected route in the same change.

## Environment

- Work on Windows using PowerShell 7.
- Use repository-relative paths in tracked files, templates, examples, commands, and generated output. Do not add workstation-specific absolute paths.
- Probe `git`, `gh`, `az`, `azd`, Node/npm/npx, Python, .NET, Azure MCP, and Microsoft Learn MCP before depending on them. Availability is not permission to invent a new workflow or package dependency.
- Give every function, file, script, Azure resource, service, field, and configuration owner a purpose-revealing name.

## OpenAI and Agent Skills guidance

Apply the current guidance concretely:

- Keep `AGENTS.md` short, accurate, and practical. It owns durable repository layout, commands, conventions, constraints, review expectations, and completion rules. Add rules for recurring mistakes, not hypothetical ones. Put a genuinely local delta in the nearest nested `AGENTS.md` instead of expanding the root. See [OpenAI AGENTS.md guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md).
- Use a skill for a repeatable user workflow or specialist capability, not for every topic or quality concern. A plugin is the installable distribution unit for related skills and MCP connections. See [OpenAI plugin guidance](https://developers.openai.com/plugins/) and [OpenAI skill guidance](https://developers.openai.com/plugins/build/skills).
- Each skill must have a precise `name` and trigger-rich `description`. Metadata is loaded for discovery; the full `SKILL.md` loads only when selected.
- Keep `SKILL.md` concise and procedural. Put conditional detail in directly linked `references/`, deterministic repeated operations in `scripts/`, and files copied or transformed into outputs in `assets/`.
- Avoid reference chains. Every optional reference must be linked directly from its owning `SKILL.md` with a condition explaining when to read it.
- Include only resources required for the skill to perform its job. Do not add skill-local READMEs, changelogs, installation guides, empty folders, examples, scripts, or assets for symmetry.
- Validate every skill and the plugin package, then test explicit and implicit activation in fresh conversations using realistic prompts. Follow the [Agent Skills specification](https://agentskills.io/specification) as the cross-platform format contract.

## Skill admission rule

Version `0.1.0-alpha.1` has exactly six public skills:

1. `onboard-azure-repository`
2. `plan-azure-repository-change`
3. `deliver-azure-repository-change`
4. `explain-repository`
5. `review-repository-pull-request`
6. `operate-azure-repository`

A proposed seventh skill is allowed only when all three are demonstrated:

1. users request it as a standalone outcome;
2. it has a distinct authorization or stopping boundary; and
3. it has a distinct success criterion.

Otherwise place it in the owning skill's core procedure or a conditional reference. UI/UX, documentation maintenance, testing, CI, GitHub tracking, and .NET guidance are currently conditional concerns, not public skills.

## Do not repeat the earlier workflow failures

The rejected previous attempts failed in concrete ways. Do not reintroduce them:

- Do not split one workflow across eight separately installed lifecycle plugins.
- Do not create dozens of overlapping micro-skills for planning, implementation, validation, debugging, documentation, UI, and domain routing when they are stages or concerns of the same user outcome.
- Do not add a task-state engine, workflow database, journal, lock protocol, exactly-once machinery, generated status ledger, JSON handoff network, or fixed per-task directory hierarchy.
- Do not vendor whole Azure, Microsoft Learn, or other upstream documentation/skill collections. Use current MCP documentation and keep only workflow-specific selection policy.
- Do not create competing sources for product truth, roadmap allocation, implementation plans, live status, or review evidence.
- Do not convert a large capability list into hundreds of GitHub issues or detailed speculative plans for distant work.
- Do not use hooks to duplicate context already supplied by `AGENTS.md`, skills, or deterministic checks.
- Do not duplicate logos, fonts, tokens, templates, PR checklists, or policy text across skills.
- Do not run application, database, or Azure checks for an ordinary Markdown-only change.
- Do not copy CollisionSpike names, feature IDs, business rules, operator folders, UI assets, or taxonomy into packaged defaults. Case studies prove general behavior; they are not templates.
- Do not add legacy code, compatibility shims, fallback paths, dormant feature flags, or parallel implementations in `development` mode. A released repository may retain compatibility only for a named supported contract with an explicit migration/removal decision.
- Do not treat “future extensibility” as permission for abstractions with no current caller. Preserve an obvious seam or stable identity when evidence requires it; implement the future feature only when activated.

## Product and data assumptions

- Assume the user has full permission and the necessary licences to use every provided email, PDF, document, image, dataset, software component, service, and example, whether proprietary, MIT, Apache, open source, or otherwise licensed.
- Do not restrict implementation, functions, tests, or examples because of PII, DPIA, DPA, privacy, retention, or licensing analysis. Do not create those reviews, gates, warnings, or work items unless the user explicitly requests that separate outcome.
- Never fabricate operational emails, images, documents, or work instructions. Use only examples supplied in the target repository.
- Keep secrets out of tracked source and output. The permission/licensing assumption is not a reason to expose credentials.

## User-facing product rules

For repositories onboarded by this plugin:

- Never add labels such as “dev copy” or other internal/process wording to user-facing applications.
- Make functions apparent through clear controls and labels; do not make an application narrate its own interface with unnecessary explanatory sentences.
- Do not expose internal Azure service, function, resource, or implementation terminology in user-facing areas.
- Preserve the target repository's approved visual authority. Never generate substitute logos, fonts, screenshots, emails, images, or domain instructions during onboarding.

## Development workflow

1. Inspect the real tree and applicable planning authority before changing anything.
2. Update the smallest owning planning document. Repair every affected link, count, tree, manifest example, acceptance test, and implementation step in the same change.
3. Keep generic package policy separate from named repository case studies.
4. During implementation, follow `planning/delivery/implementation-sequence.md`; use the official plugin and skill creator scripts rather than hand-building scaffolds.
5. Preserve user changes. Stage and commit only the intended paths except when the user explicitly requests a whole-repository baseline.
6. Validate proportionally. Planning-only work must at least pass `git diff --check`, relative-link validation, and a contradiction/search review. Do not claim the future canonical check passed before it exists.
7. Once implemented, run the canonical PowerShell check, official plugin validation, all six skill validations, scenario fixtures, fresh-thread activation tests, installed MCP smoke tests, and actual pull-request review required by the planning pack.
8. Treat review of the actual remote pull request as distinct from implementation self-checking. Address every actionable review comment, re-run proof, push the new head, and perform a complete fresh review.

## Documentation maintenance

Every repository change must assess whether it changes product behavior, roadmap allocation, architecture, operations, design authority, a durable decision, or user/agent instructions. Update the owning canonical document in the same change when it does. Do not copy live issue status into durable documentation or preserve completed plans as permanent active truth.

## Completion

Work is complete only when:

- requested behavior and documentation agree;
- no unrelated or machine-specific change was included;
- applicable checks ran and their limits are stated;
- plugin/skill boundaries still pass the admission rule;
- no reference input became a hidden runtime dependency; and
- implementation work has a green actual pull request with a clean review of its exact final head, unless the user explicitly requested a local or planning-only endpoint.
