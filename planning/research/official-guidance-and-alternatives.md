# Official guidance and alternatives research

Research date: 2026-07-26

## Question

Should Azure Workflow be one monolithic skill, several focused skills, or another plugin suite—and how should its documentation, versioning, GitHub, MCP, and CI decisions follow current official guidance rather than aesthetic preference?

## OpenAI plugin and skill guidance

Current [OpenAI skill-building guidance](https://developers.openai.com/plugins/build/skills) says:

- a plugin may contain one skill or several related skills;
- each skill should focus on a recognizable user goal;
- workflows should split when triggers, inputs, or success criteria differ;
- `SKILL.md` should stay concise and route detailed policies/schemas/examples into references;
- assets are for reusable output templates;
- scripts are for deterministic operations that are more reliable than prose; and
- MCP is appropriate for current/live data and controlled external actions.

Consequence: plugin count and skill count answer different questions. One distribution plugin can correctly contain several focused user-goal skills.

## Agent Skills specification

The [Agent Skills specification](https://agentskills.io/specification) defines progressive disclosure:

```text
name + description loaded for discovery
              |
              v
selected SKILL.md loaded for the goal
              |
              v
direct references/scripts/assets loaded only when needed
```

It supports optional `references/`, `scripts/`, and `assets/` and recommends keeping `SKILL.md` below 500 lines. Consequence: a routing wrapper is good when it routes one coherent goal; it is not a reason to combine incompatible authorization endpoints.

## Cloudflare comparison

The current [Cloudflare skills repository](https://github.com/cloudflare/skills) contains a broad Cloudflare platform skill and separate focused skills. Its [top-level Cloudflare `SKILL.md`](https://github.com/cloudflare/skills/blob/main/skills/cloudflare/SKILL.md) is a compact decision-tree router into many product references.

What transfers well:

- concise top-level routing;
- direct conditional references;
- current live documentation/schema taking precedence over bundled guidance; and
- one coherent platform goal despite many products.

What does not transfer:

- treating “one broad Cloudflare router exists” as proof that onboarding, plan-only documentation, repository mutation, and live Azure mutation should share one skill;
- ignoring the separate specialized skills in the same repository; or
- combining two different stop/authorization boundaries merely to minimize a count.

The selected balance is one plugin with six skills. UI/UX/testing/documentation/GitHub remain routed concerns. Pull-request review is public because “review this existing PR without changing it” is a demonstrated standalone outcome with a read-only boundary and exact-head verdict. Plain-language explanation is public because “help me understand this feature/comment/check without changing it” is another demonstrated standalone outcome, but one that must not imply a review verdict. Technology-specific guidance such as .NET remains a conditional concern: one shared plugin-root reference can be linked directly by the relevant goal skills without inventing a technology skill or five drifting copies.

## Boundary alternatives

| Alternative | Benefit | Failure | Decision |
| --- | --- | --- | --- |
| One universal skill | Fewest visible entries | Matches almost every repository request; mixes documentation-only planning, product implementation, and live Azure approval | Reject |
| Three skills with plan/deliver selector | Compact | Planning and delivery have different trigger language, authorization, and completion | Superseded |
| Four skills with review hidden in delivery | Initially concise | Confuses pre-push implementation review with review of the actual PR; cannot safely route standalone review | Superseded |
| Five focused skills | Clear lifecycle endpoints with one installation and an independently invocable read-only review | No owner for standalone explanation; folding it into review or planning blurs the endpoint | Superseded after explicit explanation demand |
| Six focused skills | Adds one evidence-grounded read-only explanation endpoint while retaining one installation | Explanation must remain distinct from review verdict, planning, fixing, and routine communication | Select |
| UI/test/docs as public skills | Superficially modular | Competing triggers and fragmented ownership for one change | Reject until observed standalone demand |
| .NET as a public skill | Technology name is visible | Has no distinct authorization or endpoint; would duplicate onboard/plan/deliver/explain/review | Reject; use one shared conditional profile |
| Eight lifecycle plugins | Very explicit stages | Installation/discovery/state/ownership sprawl | Reject |

## Versioning research

[Semantic Versioning 2.0.0](https://semver.org/) defines release identity and compatibility through MAJOR.MINOR/PATCH plus prerelease/build syntax. It does not define organizational alpha/beta/RC entry gates. [PEP 440's prerelease model](https://peps.python.org/pep-0440/#pre-releases) confirms the common alpha/beta/release-candidate ordering but is not used as the plugin's package-version authority.

Decision: separate four fields:

```text
SemVer             immutable release/compatibility identity
maturity stage     evidence and reliance gate
roadmap horizon    Now/Next/Later/Not planned allocation
GitHub status      live work state
```

Initial plugin release is `0.1.0-alpha.1`; `1.0.0` is an explicit stable-contract decision, not a rename of “V1”.

## GitHub research

GitHub provides default [Feature, Bug, and Task issue types](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-types-in-an-organization) to organizations, not personal accounts. The portable baseline therefore uses repository `type:*` labels. On a compatible organization route, the plugin may use existing native types and represent Decision as Task + `decision`, but it never mutates organization-wide types automatically.

Current organization-level [issue fields](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-fields-in-your-organization) are also unavailable to the personal-account baseline and can duplicate Project fields. The selected taxonomy therefore requires one universal work kind and permits only registered additive facets. Current issue-form documentation also makes labels static, Project auto-add permission-dependent, and private form validation non-enforcing; owning workflows perform readback. The exact decision is in [GitHub issue taxonomy and forms](github-issue-taxonomy-and-forms.md).

GitHub's current model supports:

- repository [issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms);
- [sub-issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-sub-issues);
- native [issue dependencies](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-issue-dependencies);
- exact-release [milestones](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/about-milestones); and
- Project fields and single-select option updates through [Projects GraphQL](https://docs.github.com/en/graphql/reference/projects#updateprojectv2field).

The current GitHub CLI manual exposes `--type`, `--parent`, and dependency flags in [`gh issue create`](https://cli.github.com/manual/gh_issue_create), plus Project create/link/field commands. The installed CLI is currently `2.88.0` and its help lacks those issue flags, so the workflow capability-probes and gives `winget upgrade --id GitHub.cli --exact` rather than inventing a compatibility path.

Decision: use Git/`gh`/`gh api`; do not add GitHub MCP. The official [GitHub MCP Server](https://github.com/github/github-mcp-server) is useful, but Project administration still needs API/GraphQL and a second credential/tool path would not simplify this workflow.

## MCP and CI currency checks

- The [Azure MCP npm package](https://www.npmjs.com/package/%40azure/mcp?activeTab=code) and direct registry probe reported `3.0.0-beta.29` as the current dist-tag during this research. The plugin pins that exact prerelease and disables telemetry; it never commits `@latest`.
- Microsoft documents the Learn MCP endpoint as streamable HTTP at `https://learn.microsoft.com/api/mcp`, with no authentication, in the [Learn MCP reference](https://learn.microsoft.com/en-us/training/support/mcp-developer-reference).
- The official [`actions/checkout` repository](https://github.com/actions/checkout) now documents v6, so the Windows `verify` workflow uses `actions/checkout@v6`, not the stale v4 plan.

Local read-only preflight also confirmed that this workspace is not yet a Git repository, local Codex marketplace state requires revalidation before installation, and `az account show` currently fails on access to `.azure/cliextensions/account/azext_account/azext_metadata.json`. These are implementation prerequisites, not reasons to weaken the planned acceptance gates.

## Final architecture consequence

```text
ONE PLUGIN
|-- onboard       broad brownfield conversion endpoint
|-- plan          decision-complete no-implementation endpoint
|-- deliver       repository mutation through exact-head-reviewed PR
|-- review PR     read-only exact-head assessment of an existing PR
`-- operate       current/live Azure evidence and exact-approved mutation

CONDITIONAL REFERENCES
UI/UX | docs | GitHub | risk | testing/CI | versioning

EXTERNAL TOOLS
Azure MCP | Learn MCP | git/gh/gh api | repository-native toolchain

NO HOOKS, APP, GITHUB MCP, OR TASK DATABASE
```
