# Repository policy placement

## Placement rule

Put a rule where it can be authoritative without bloating every agent invocation:

```text
human business truth ----------------------> operator-notes/
short always-on routing or prohibition ----> AGENTS.md
canonical product/operational explanation -> docs/product/ or docs/operations.md
canonical visual/design authority ----------> design/ when Visual UI: present
universal workflow enforcement ------------> SKILL.md
detailed reusable decision matrix ---------> skill references/
shared conditional technology profile ----> plugin-root references/
deterministic enforcement -----------------> scripts and CI
```

The plugin owns the shape, routing, validation, and maintenance of `AGENTS.md` and canonical docs. It does not own or rewrite human-authored `operator-notes/` unless the user explicitly requests an operator-note change.

## Exact placement decisions

| Requirement | Primary placement | Supporting placement | Why |
| --- | --- | --- | --- |
| Windows environment; PowerShell; `az`, `azd`, workflow skills, Azure MCP | Root `AGENTS.md` and `docs/operations.md` | All six public skill bodies | Every agent must know the shell immediately; operations owns exact prerequisites and probes |
| Plain-English explanation for non-coders | `explain-repository/SKILL.md` read-only endpoint; concise global communication expectation | `code-and-system-explanation.md` and `github-feedback-explanation.md` | Ordinary responses should be understandable, but explicit “explain this” requests need an evidence and stopping contract without bloating every workflow |
| No "dev copy" or internal/weird wording in UI | Root `AGENTS.md` concise product rule; `docs/product/index.md` canonical invariant | Planning `ui-ux-planning.md` and delivery `ui-ux-delivery.md`/`implementation-quality.md` | Product authority is always visible while detailed state/copy checks load only for UI work |
| UI is self-explanatory; no narrating functions in prose | `docs/product/index.md` or relevant product-area contract | Planning and delivery UI references | Product intent is authoritative; plan and implementation both enforce it |
| Never expose internal Azure functions/resources/terminology to users | Root `AGENTS.md` and `docs/product/index.md` | Planning/delivery UI and review references | This is both an always-on prohibition and a user-facing product invariant |
| Style, imagery, logos, colour, typography/fonts, layout, motion, tokens, components, and patterns | Root `design/` with the source/runtime map | `docs/product/` owns behavior; UI planning/delivery references enforce use and proof | Visual authority and source assets need one obvious durable home without duplicating product behavior or runtime code |
| Development data is permissible; PII/DPIA/retention concerns out of scope | Root `AGENTS.md` safety boundary | `docs/product/index.md` or `docs/operations.md`, sourced from `operator-notes/` | Prevents agents inventing unwanted policy work while keeping the business decision visible |
| Logical names for functions, files, Azure services/resources | Delivery skill core | `implementation-quality.md`; concise root `AGENTS.md` rule | This is universal implementation behavior with detailed review criteria |
| Never create synthetic email/image/document/instruction fixtures | Root `AGENTS.md` safety boundary | `testing-and-ci.md` reference and `docs/operations.md` test-data section | Agents must see the prohibition before generating data; testing guidance defines what to do instead |
| Everything in `operator-notes/` is key truth | Root `AGENTS.md` authority section and `docs/index.md` | Onboarding `repository-policy-profile.md` reference | Authority must be visible before any planning; onboarding must preserve and route it |
| Development versus released behavior | Root `AGENTS.md` active-mode line and `docs/product/index.md` | Planning release reference and delivery `repository-modes.md` | Mode must be immediately visible, canonically defined, and mechanically applied |
| No pointless tests; Markdown changes do not run code checks | `docs/operations.md` and path-aware CI | Delivery `testing-and-ci.md` reference and canonical-check scripts | Detailed selection is operational and deterministic, not prose-only |
| Clean, maintainable, extendable, not over-engineered | Delivery skill core | `implementation-quality.md`, architecture/ADR when material | It guides every implementation but needs a concrete decision test rather than slogans |
| Future features must be factored in | `docs/product/`, `docs/roadmap.md`, and active ADR/change record | Planning, mode, and implementation-quality references | Future scope is retained canonically; skills allow exercised seams without dormant implementation |
| One GitHub work kind plus repository-specific categories | Root `AGENTS.md` one-line invariant; `docs/operations.md` registry | Onboarding `github-onboarding.md`, planning `github-planning.md`, delivery `github-delivery.md`, repository validator | Every agent sees the classification rule; detailed mutable taxonomy has one operational owner and deterministic validation |
| Broad .NET project guidance | Shared plugin-root `references/dotnet-projects.md` | Direct conditional links from onboarding, planning, delivery, explanation, and review; repository-specific facts in architecture/operations | The technology has no separate user endpoint. One shared profile prevents five drifting copies while each owning workflow retains its authorization boundary |

## Generated root `AGENTS.md` shape

The onboarding skill creates this section structure:

```markdown
# Repository instructions

## Authority
## Active mode
## Environment
## Repository map
## Workflow
## Validation
## Product and data constraints
## Local instructions
## Safety boundaries
```

The following policy text is included by default, with links and repository-specific values filled in:

```markdown
## Authority

- Read `operator-notes/` as key human-authored business authority whenever it exists or the task touches its subject. Do not edit, move, consolidate, or delete it unless the user explicitly requests that change.
- Use `docs/index.md` to resolve the remaining product, architecture, operations, and decision authorities.
- When `docs/product/index.md` declares `Visual UI: present`, use `design/README.md` as the visual-design, source-asset, token, component, and pattern authority.

## Active mode

- Mode: `development` or `released`; see `docs/product/index.md` for the declared value and consequences.
- Do not infer or change mode from a version string alone.

## Environment

- Work in Windows using PowerShell 7. Write commands for `pwsh`, not Bash.
- `az`, `azd`, Azure Workflow skills, and Azure MCP are expected tools, but probe authentication and availability before relying on them.

## Workflow

- Use the Azure Workflow skills for onboarding, planning, delivery, plain-English explanation, pull-request review, and Azure operation. Explanation is read-only and does not authorize a plan, fix, GitHub response, documentation write, or state change.

## Product and data constraints

- Never ship "dev copy", internal/weird wording, explanatory narration of obvious UI functions, or internal Azure function/resource terminology in user-facing areas. Prefer self-explanatory buttons, labels, and flows.
- Repository-provided emails, PDFs, documents, images, and data are permitted for development. Do not introduce PII, DPIA, retention, or similar policy work unless the user changes scope.
- Do not create synthetic emails, images, documents, or instructions as test data. Use only examples already provided in the repository.

## Safety boundaries

- Give functions, code files, Azure services, and Azure resources logical purpose-revealing names.
- Keep implementation clean and extendable without speculative abstractions or dormant future code.
- Give every workflow-owned GitHub issue exactly one work kind and use only project-specific categories registered in `docs/operations.md`; do not duplicate Project fields, milestones, assignees, or dependencies as labels.
```

The final generated file stays concise by linking detailed mode, testing, naming, and UI rules to canonical docs.

## `operator-notes/` handling

When present:

- Inventory every file relevant to the task, including nested files.
- Treat statements as key business authority unless the notes explicitly mark them obsolete or proposed.
- Preserve the directory byte-for-byte during ordinary onboarding and delivery.
- Never merge its contents into agent-generated docs and then delete the source.
- Canonical docs may summarize and route to it, but must not weaken or contradict it.
- If two operator notes conflict materially, record the conflict and ask the user; modification date does not choose a winner.
- If code or docs disagree with operator notes, record noncompliance instead of rewriting the notes.

## Skill-reference changes required

Add these references to the target skill design:

```text
onboard-azure-repository/references/
`-- repository-policy-profile.md

deliver-azure-repository-change/references/
|-- implementation-quality.md
|-- repository-modes.md
`-- testing-and-ci.md

plan-azure-repository-change/references/
|-- ui-ux-planning.md
`-- versioning-and-release-stages.md

onboard-azure-repository/references/
`-- ui-design-system.md

deliver-azure-repository-change/references/
`-- ui-ux-delivery.md

plugins/azure-workflow/references/
`-- dotnet-projects.md
```

The onboarding reference extracts repository-specific policy into `AGENTS.md` and canonical docs. Planning references turn relevant policies into requirements; delivery references enforce them. Explanation has its own read-only evidence/translation references rather than duplicating them across lifecycle skills. The shared .NET profile is directly linked by five skills and conditionally applies the appropriate goal stage without duplicating its technical rules. None hardcodes a repository's domain model into the plugin.
