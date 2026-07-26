# Repository policy placement

## Placement rule

Put a rule where it can be authoritative without bloating every agent invocation:

```text
approved human product truth -------------> docs/product/ or declared controlled authority
raw human notes/evidence -----------------> classified route in docs/index.md
short always-on routing or prohibition ----> AGENTS.md
canonical product/operational explanation -> docs/product/ or docs/operations.md
canonical visual/design authority ----------> design/ when Visual UI: present
universal workflow enforcement ------------> SKILL.md
detailed reusable decision matrix ---------> skill references/
shared conditional technology profile ----> plugin-root references/
deterministic enforcement -----------------> scripts and CI
```

The plugin owns the shape, routing, validation, and maintenance of `AGENTS.md` and canonical docs. It preserves every explicitly declared human-source/protected-root mutation boundary. No path name creates such a boundary by itself.

## Exact placement decisions

| Requirement | Primary placement | Supporting placement | Why |
| --- | --- | --- | --- |
| Windows environment; PowerShell; `az`, `azd`, workflow skills, Azure MCP | Root `AGENTS.md` and `docs/operations.md` | All six public skill bodies | Every agent must know the shell immediately; operations owns exact prerequisites and probes |
| Plain-English explanation, orientation, and one next-action recommendation for non-coders/low-cognitive-load use | `explain-repository/SKILL.md` read-only endpoint; concise global communication expectation | Its two existing references for code/system and GitHub evidence; README/docs index/GitHub own durable organization | Explicit understanding/orientation is one read-only endpoint, while persistence remains with its real owner; no organizer skill or third explanation reference is needed |
| No "dev copy" or internal/weird wording in UI | Root `AGENTS.md` concise product rule; `docs/product/index.md` canonical invariant | Planning `ui-ux-planning.md` and delivery `ui-ux-delivery.md`/`implementation-quality.md` | Product authority is always visible while detailed state/copy checks load only for UI work |
| UI is self-explanatory; no narrating functions in prose | `docs/product/index.md` or relevant product-area contract | Planning and delivery UI references | Product intent is authoritative; plan and implementation both enforce it |
| Never expose internal Azure functions/resources/terminology to users | Root `AGENTS.md` and `docs/product/index.md` | Planning/delivery UI and review references | This is both an always-on prohibition and a user-facing product invariant |
| Style, imagery, logos, colour, typography/fonts, layout, motion, tokens, components, and patterns | Root `design/` with the source/runtime map | `docs/product/` owns behavior; UI planning/delivery references enforce use and proof | Visual authority and source assets need one obvious durable home without duplicating product behavior or runtime code |
| Supplied materials/software/services are fully permitted and licensed; unsolicited PII/DPA/DPIA/privacy/retention/licensing work is out of scope | Root `AGENTS.md` safety boundary | `docs/product/index.md` or `docs/operations.md` only for repository-specific elaboration; onboard/plan/deliver/test/review enforcement | Prevents agents inventing legal/compliance gates, scope reductions, or substitute data while keeping the default always visible |
| Logical names for functions, files, Azure services/resources | Delivery skill core | `implementation-quality.md`; concise root `AGENTS.md` rule | This is universal implementation behavior with detailed review criteria |
| Never create synthetic email/image/document/instruction fixtures | Root `AGENTS.md` safety boundary | `testing-and-ci.md` reference and `docs/operations.md` test-data section | Agents must see the prohibition before generating data; testing guidance defines what to do instead |
| Human-authored sources and protected roots | Actual paths, content roles, canonical destinations, and mutation rules in `docs/index.md`; concise protected boundaries in root `AGENTS.md` | Onboarding `repository-policy-profile.md` reference | Authorship, authority, and editability are different properties; no `operator-notes/`/PRD/FRD filename convention may collapse them |
| Product and functional requirements | `docs/product/index.md` living PRD role and warranted `docs/product/areas/` functional specifications | Change record for one activated change; preserve controlled external/formal artifacts | Requirements remain complete and familiar without duplicating product truth into default `PRD.md` and `FRD.md` files |
| Development versus released behavior | Root `AGENTS.md` active-mode line and `docs/product/index.md` | Planning release reference and delivery `repository-modes.md` | Mode must be immediately visible, canonically defined, and mechanically applied |
| No pointless tests; Markdown changes do not run code checks | `docs/operations.md` and path-aware CI | Delivery `testing-and-ci.md` reference and canonical-check scripts | Detailed selection is operational and deterministic, not prose-only |
| Clean, maintainable, extendable, not over-engineered | Delivery skill core | `implementation-quality.md`, architecture/ADR when material | It guides every implementation but needs a concrete decision test rather than slogans |
| Future features must be factored in | `docs/product/`, `docs/roadmap.md`, and active ADR/change record | Planning, mode, and implementation-quality references | Future scope is retained canonically; skills allow exercised seams without dormant implementation |
| One GitHub work kind plus repository-specific categories | Root `AGENTS.md` one-line invariant; `docs/operations.md` registry | Onboarding `github-onboarding.md`, planning `github-planning.md`, delivery `github-delivery.md`, repository validator | Every agent sees the classification rule; detailed mutable taxonomy has one operational owner and deterministic validation |
| Broad .NET project guidance | Shared plugin-root `references/dotnet-projects.md` | Direct conditional links from onboarding, planning, delivery, explanation, and review; repository-specific facts in architecture/operations | The technology has no separate user endpoint. One shared profile prevents five drifting copies while each owning workflow retains its authorization boundary |
| Qualifying agent mistake history for later plugin improvement | `docs/agent-mistakes.md`; concise root `AGENTS.md` append/search rule | Existing onboarding repository asset/policy reference, planning/delivery maintenance, read-only pending-entry behavior, Docs validation | It is historical evidence produced inside the active workflow, not a separate user skill, task board, or database |
| Simple organization and clear order | README/docs index for durable navigation; GitHub for live order; one active change record | All skill communication, planning one-question rule, delivery handoff, explanation orientation | Organization must reduce competing owners rather than create `NEXT.md`, dashboards, hooks, or another Project field |

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

- Use `docs/index.md` to resolve product, external/controlled requirements, architecture, operations, decisions, and every declared human-authored source/protected root. Do not infer authority or editability from a filename; follow the recorded content role and mutation rule.
- When `docs/product/index.md` declares `Visual UI: present`, use `design/README.md` as the visual-design, source-asset, token, component, and pattern authority.

## Active mode

- Mode: `development` or `released`; see `docs/product/index.md` for the declared value and consequences.
- Do not infer or change mode from a version string alone.

## Environment

- Work in Windows using PowerShell 7. Write commands for `pwsh`, not Bash.
- `az`, `azd`, Azure Workflow skills, and Azure MCP are expected tools, but probe authentication and availability before relying on them.

## Workflow

- Use the Azure Workflow skills for onboarding, planning, delivery, plain-English explanation, pull-request review, and Azure operation. Explanation is read-only and does not authorize a plan, fix, GitHub response, documentation write, or state change.
- Lead with the current outcome, distinguish what matters now from what can wait, recommend one next action when evidence supports it, and ask one material decision question at a time. Do not ask the user to choose implementation details that repository inspection can settle.
- When an agent makes or discovers a qualifying evidenced mistake, follow `docs/agent-mistakes.md`: write-authorized workflows append it; read-only workflows return a clearly labelled pending entry. Search relevant prior entries before repeating similar work; do not load the entire log by default.

## Product and data constraints

- Never ship "dev copy", internal/weird wording, explanatory narration of obvious UI functions, or internal Azure function/resource terminology in user-facing areas. Prefer self-explanatory buttons, labels, and flows.
- Assume every supplied email, PDF, document, image, dataset, example, software component, dependency, and service has the permission and licence required for development and testing, whether proprietary, MIT, Apache, open source, or otherwise licensed.
- Unless explicitly requested as a separate outcome, do not create PII, DPA, DPIA, privacy, retention, or licensing reviews, warnings, gates, work items, test substitutions, or scope reductions.
- Do not create synthetic emails, images, documents, or instructions as test data. Use only examples already provided in the repository.

## Safety boundaries

- Give functions, code files, Azure services, and Azure resources logical purpose-revealing names.
- Keep implementation clean and extendable without speculative abstractions or dormant future code.
- Give every workflow-owned GitHub issue exactly one work kind and use only project-specific categories registered in `docs/operations.md`; do not duplicate Project fields, milestones, assignees, or dependencies as labels.
```

The final generated file stays concise by linking detailed mode, testing, naming, UI, mistake-admission, and documentation rules to canonical docs.

## Development-material and licensing boundary

The generated default is an authority assumption, not a prompt to inspect or classify licences. The owning workflows therefore:

- use supplied materials directly for the requested development and test purpose;
- do not anonymize, fabricate, blank, or replace them because of the excluded analyses;
- do not add privacy, retention, or licensing acceptance criteria/findings unless the user deliberately asks for that outcome; and
- continue to enforce explicit product behavior, technical authentication/authorization, trust boundaries, secret protection, destructive-action controls, and any deliberately requested privacy/licensing requirement.

This policy has no public skill and no dedicated reference tree. It is not a standalone endpoint. The concise default belongs in `AGENTS.md`; the existing repository-policy, planning, delivery/testing, and review contracts apply it where needed. See the [development-material and licensing audit](../research/development-material-and-licensing-audit.md).

## Human-source and requirements handling

When a human-authored source or protected root is present:

- inventory every relevant file and any existing status, approval, owner, contract, or instruction evidence;
- record content role and mutation rule separately;
- treat an unclassified source as preserved non-binding discovery input, not automatic product truth;
- map material claims and stable identifiers before consolidation;
- write each accepted durable requirement once to the living product index/area or route the active controlled artifact;
- never delete or rewrite a protected source outside its explicit mutation rule;
- resolve same-role material conflicts through the normal conflict workflow rather than modification date; and
- retire superseded sources only after claim, ID, link, and history parity.

The default product index performs the living PRD role and product areas perform functional-specification roles. Existing formal PRD/FRD/SRS/URS artifacts remain conditional controlled sources, not templates copied into every repository. See [the human-notes and requirements audit](../research/operator-notes-and-requirements-documentation-audit.md).

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
