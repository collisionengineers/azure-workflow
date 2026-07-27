# Product requirements

- Repository mode: `development`
- Maturity stage: `alpha`
- Version scheme: `Semantic Versioning 2.0.0`
- Current version: `0.1.0-alpha.1`
- Release authority: repository owner (`collisionengineers`)
- Visual UI: `absent`

## Purpose and problem

Azure Workflow gives Codex one reliable, understandable way to own an Azure repository from brownfield onboarding through planning, implementation, independent PR review, and controlled Azure operations. It replaces fragmented lifecycle plugins, duplicated truth, improvised task state, and late governance with a small set of explicit user outcomes and durable repository owners.

## Users and outcomes

The primary user may understand product and architecture concepts but not write code. The plugin must inspect reality, organize work, translate technical material plainly, ask only material questions, keep decisions/evidence durable, and make the next action obvious.

Users can:

- convert an existing Azure-oriented repository without losing material truth;
- plan one material change and stop before implementation;
- deliver or remediate one change through a green exact-head-reviewed PR;
- understand repository behavior and GitHub feedback in plain English;
- receive an independent read-only PR verdict; and
- inspect Azure state and perform only a separately approved exact mutation.

## Success measures

- One installable plugin exposes exactly six correctly routed skills and two MCP registrations.
- Brownfield conversion preserves material claims/IDs/links/history and produces the canonical documentation/GitHub/CI spine.
- Planning creates one decision-complete record rather than parallel packs; compact mechanical delivery creates none.
- Delivery and review operate on the actual PR and exact final head, including existing feedback and CI.
- Markdown-only changes avoid unrelated code/Azure suites.
- A non-coder can understand current position and one next action without a generated organizer system.
- No live Azure mutation occurs without an exact post-evidence approval.

## Scope

### Included

- Azure-oriented repositories established by repository evidence or explicit user intent.
- Repository documentation, product/capability/roadmap conversion, GitHub issue/Project/PR routing, UI/UX conditional routes, general .NET routing, proportional CI, implementation, review remediation, explanation, and Azure operations.
- Windows and PowerShell 7 development with Git, `gh`, `az`, and `azd` where applicable.

### Excluded

- Universal ownership of non-Azure repositories; .NET alone is insufficient evidence.
- Automatic merge, branch deletion, broad backlog reorganization, or organization-wide GitHub mutation.
- Background agents, hooks, dashboards, task databases, generated status ledgers, or session journals.
- Vendored Microsoft/third-party documentation or case-study product policy.
- Unsolicited PII/DPA/DPIA/privacy/retention/licensing analysis.

## Requirements and invariants

- The public surface remains one plugin and six goal-based skills unless a new standalone outcome, authorization boundary, and success criterion are proven.
- Onboarding, planning, delivery, explanation, review, and operation retain distinct stopping/authorization boundaries.
- Durable truth has one owner per fact; filenames do not infer authority.
- Planning uses the real `update_plan` tool, repository evidence first, one material question at a time, and one change record for onboarding/standard/high risk.
- Development mode contains no unreleased legacy/fallback/shim/dual behavior; future scope creates only exercised seams.
- Testing is proportional to plausible regressions and real callers.
- Supplied materials/software/services are assumed fully permitted/licensed; repository-provided domain examples are the only test examples.
- UI work uses a root design authority, clear controls/labels, no interface narration, and no internal Azure wording in user-facing areas.
- Standard/high-risk delivery stops before merge with a clean independent review and green CI for the exact final PR head; compact delivery stops with proportional green proof when its classification still holds.
- Review is proportional: compact work does not create a mandatory review loop; standard work permits one batched remediation round and high-risk work two. Only defects tied to the request, acceptance criteria, or established repository contract block completion; every material comment is classified, but advisories do not silently expand scope.
- Azure mutations require an exact apply card followed by explicit approval and readback.
- Tracked/template paths are portable and repository-relative.

## Quality constraints

- Maintainable and easy to trace: no hidden state engine, duplicate policy, reference chains, or speculative abstraction.
- Safe around unrelated work and destructive operations.
- Deterministic scripts emit stable machine-readable output and do not stage/commit/push or mutate Azure.
- Skill descriptions make routing reliable; skill bodies remain focused with conditional detail in direct references.
- Documentation drift prevention combines owner declarations, structural checks, and semantic exact-head review.

## Supported contracts

No stable public compatibility contract exists before `1.0.0`. The alpha contract under evaluation is the six skill names/outcomes, canonical repository spine, two MCP server names, script interfaces, and review/approval stop boundaries.

## Functional areas

The six public skill specifications are canonical inside `plugins/azure-workflow/skills/`. Stable capability IDs are in [capabilities.md](capabilities.md). Separate area documents are not warranted while each skill already owns its focused procedure and references.

## Limitations

- Azure live validation depends on a working local credential/CLI path and an explicitly identified subscription scope.
- GitHub personal-account Projects expose a portable CLI/GraphQL core, while some saved views, charts, workflows, and private-form behavior require human/template confirmation.
- Same-author Codex review evidence is not a human or separate-account GitHub approval.
- Alpha readiness does not imply beta/stable cross-repository evidence.

## Open decisions

None for the alpha implementation. Beta/stable promotion remains an explicit evidence-based release decision.
