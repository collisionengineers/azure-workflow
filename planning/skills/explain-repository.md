# Skill specification: `explain-repository`

## Public purpose

Read repository, Git, GitHub, and official-source evidence to explain how a feature/system works, orient a user to the current project position and next sensible action, define technical terminology in context, identify implementation/documentation disagreement, separate current versus intended or proposed state, or translate a pull-request comment/review/check. Return a layered plain-English explanation and stop without changing anything.

## Why this is a public skill

It passes all three public-skill tests:

1. “Explain this feature/comment/check,” “where are we?”, and “what should I do next?” are standalone read-only understanding/orientation outcomes.
2. Its authorization is read-only and stops before planning, implementation, GitHub interaction, documentation writes, or Azure mutation.
3. Its success is accurate user understanding with decisive evidence, not a plan, review verdict, or changed repository.

## Exact folder

```text
skills/explain-repository/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
`-- references/
    |-- code-and-system-explanation.md
    `-- github-feedback-explanation.md
```

There is no skill-local `scripts/` or `assets/` folder. It uses repository-native read tools, `git`/`gh` for GitHub evidence, Microsoft Learn conditionally, and the shared plugin-root `references/dotnet-projects.md` only when a .NET-specific mechanism materially affects the explanation.

## `SKILL.md` frontmatter

```yaml
---
name: explain-repository
description: Explain and orient an Azure-oriented or Azure Workflow-onboarded repository in plain English using repository, GitHub, and official evidence. Use when the user asks how or why a feature, code path, architecture decision, configuration, plan, pull request, review comment, check failure, or technical term works; whether implementation and canonical documentation disagree; what is current versus intended or proposed; where the project stands; or what the next sensible action is. Use only for read-only understanding rather than a verdict, persisted plan, fix, documentation/GitHub change, or Azure operation.
---
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Explain Repository"
  short_description: "Explain repository work, position, and next actions plainly"
  default_prompt: "Use $explain-repository to explain this repository subject, orient me to what matters now, and recommend the next sensible action without changing anything."

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

The dependency makes Microsoft Learn available; it does not make every call mandatory. Apply the central guidance gate when the user requests Microsoft guidance or when a material part of the explanation depends on a current Microsoft-controlled fact. Do not call Learn for repository-owned business logic merely because it is implemented in .NET or deployed to Azure. If actual live Azure state is necessary, route the read-only evidence request through `$operate-azure-repository`; this skill never authorizes Azure mutation.

## Required `SKILL.md` body structure

```markdown
# Explain Repository
## Read-only authorization and endpoint
## Resolve the exact subject
## Establish authority and evidence type
## Trace and translate the mechanism
## Explain GitHub feedback
## Orient the user and recommend one next action
## Return the layered explanation
## Handoffs and stopping rules
## Failure behavior
## Resources
```

Keep the body below 500 lines. Put code/system tracing detail in `code-and-system-explanation.md` and GitHub item retrieval/translation detail in `github-feedback-explanation.md`.

## Authorization contract

Invocation authorizes:

- read repository instructions, declared active authorities, relevant discovery/evidence sources, canonical documents, source, configuration, tests, Git history, and existing permitted local artifacts;
- read exact GitHub issues, pull requests, diffs, checks, reviews, comments, and threads needed for the explanation;
- run non-mutating discovery and focused checks whose normal ignored caches/artifacts are permitted by repository instructions;
- query current official Microsoft guidance under the shared call policy; and
- return an evidence-linked explanation in the conversation.

It does not authorize:

- tracked or untracked file creation/edit/removal;
- branch switching/creation, checkout, staging, commit, push, merge, or history rewriting;
- GitHub comments/reviews/replies, thread resolution/dismissal, labels, issue/PR/Project state changes, or review requests;
- a correctness verdict on a whole PR;
- creation of a plan or change record;
- Azure mutation; or
- persistent explainer/FAQ/wiki documentation.

If the requested endpoint includes one of those actions, explain first only when useful and hand the evidence to the owning skill. Do not silently change authorization inside this skill.

## Core instructions

1. Confirm that the endpoint is read-only understanding or orientation. Route “is this PR/comment correct?” to `$review-repository-pull-request`; “choose/design/persist a plan” to `$plan-azure-repository-change`; “fix/address/write/organize persistently” to `$deliver-azure-repository-change`; and current live Azure diagnosis/operation to `$operate-azure-repository`.
2. Resolve the Git root and exact subject from a path/symbol, feature/capability ID, issue/PR/comment/check URL or number, error, term, unambiguous request, or the repository as a whole for orientation. Never choose the newest PR/comment or similarly named feature. Ask one focused question only if material ambiguity changes the answer.
3. Read root/nearest `AGENTS.md`, `docs/index.md`, the applicable declared product/external authorities and relevant discovery/evidence sources, and the minimum canonical architecture, operations, ADR, roadmap, change-record, and design material needed. Apply each source's recorded role; preserve every protected root and make no writes.
4. Classify the requested claims as current implemented behavior, intended product behavior, proposed change/feedback, current external state/guidance, or unknown. Do not treat documentation as caller proof or code as intended authority.
5. Select the minimum applicable reference. Load `code-and-system-explanation.md` for feature/code/data/configuration/architecture/term questions. Load `github-feedback-explanation.md` for a PR, review comment/thread, issue comment, or check. Load both only when the question genuinely crosses them. When .NET mechanics materially affect the answer, also load `../../references/dotnet-projects.md` and only its relevant sections.
6. For code/system behavior, trace the real trigger/entry point, canonical owner, important rule/configuration forks, persistence/external effect, visible outcome/failure/recovery, and focused proof. When asked about documentation drift, compare current code/configuration/callers with intended product/design authority and current architecture/operations, name each disagreement and its canonical owner, but issue no PR verdict. Show competing owners honestly when the implementation is fragmented.
7. For GitHub feedback, resolve the exact item and retrieve its relevant diff/file context, thread replies and state, linked request/record when needed, and check/log evidence when applicable. Explain what was observed, consequence, requested outcome, stated force, and proof of resolution. Do not expand one-comment translation into a complete PR verdict.
8. Apply the Microsoft Learn gate. Record compact official evidence when a current Microsoft fact is material. If actual Azure state is required, obtain it through the read-only operate route or state the exact gap; never guess from IaC or prose.
9. For orientation/“what next,” derive the recommendation from current authority, GitHub Status/Priority/Horizon/milestone, dependencies, active record/PR, and the user's stated goal. Prefer finishing/unblocking active work, then human action on review, then a blocking Decision, then one unblocked Ready/Now item. Do not activate Triage/Next/Later/unallocated work or persist the recommendation.
10. Write current position and the short answer first. Then show the smallest useful sequence/diagram, why it matters, what matters now, what can wait, decisive evidence, and exactly one recommended next action when one genuinely exists. Recommend a default before presenting at most two or three materially different options; ask one decision question only when evidence cannot select safely.
11. Define unavoidable jargon on first use and put deeper technical mechanics after the plain-English result. Use analogies only as support and never hide material branches, risks, permissions, cost, migration, uncertainty, or failure behavior for simplicity. Do not patronize or equate non-coder status with lack of decision authority.
12. Label inference and unknowns explicitly. Use repository-relative paths and line anchors plus direct GitHub/official URLs; do not dump large files, logs, threads, or documentation pages.
13. If this read-only context makes or recognizes its own qualifying mistake under `docs/agent-mistakes.md`, return a copy-ready `Pending mistake-log entry` and state that it was not persisted. Do not classify ordinary PR findings or uncertain prior authorship as agent mistakes.
14. Verify no state changed and stop. A later action request is a new handoff to its owning skill.

## Result schema

```markdown
# Plain-English explanation

## Current position
<conditional one-to-three-line orientation>

## Short answer
<one to three direct sentences>

## How it works
<small numbered sequence or ASCII flow when useful>

## Why it matters
<observable user, product, operational, or maintainability consequence>

## What the comment or check is asking
<conditional; observation, consequence, requested outcome, force, resolution proof>

## Current, intended, and proposed
<conditional; keep the states separate>

## What matters now
<conditional; the small active concern and what can safely wait>

## Evidence
- `<relative/path:line>` — <claim>
- <GitHub or official URL> — <claim>

## Recommended next action
<one evidence-based action and why, one decision question, or “No action is required.”>

## Pending mistake-log entry
<conditional copy-ready entry only when this read-only context made/recognized its own qualifying mistake; say not persisted>
```

Omit empty conditional sections. Do not produce a performative next-step list when the user only asked for a definition, and never manufacture work merely to fill the recommendation section.

## Handoff map

```text
understand only --------------------------> explain and stop
judge PR/comment correctness ------------> review PR
choose/design future behavior -----------> plan
edit/fix/respond/persist -----------------> deliver
inspect/diagnose actual Azure state ------> operate (read-only unless separately approved)
```

The skill may explain an owning skill's output, but existing skills do not invoke it merely to communicate normally. Plain language remains a global communication expectation.

## References

| Reference | Load/use |
| --- | --- |
| `code-and-system-explanation.md` | Evidence order, current/intended/proposed separation, real-caller tracing, data/control/failure flows, terminology, low-cognitive-load diagrams/layers, and repository orientation |
| `github-feedback-explanation.md` | Exact issue/PR/comment/check resolution, minimal GitHub reads, thread/diff/log context, reviewer-request translation, stated-force classification, one evidence-based response path, and non-mutation boundary |
| `../../references/dotnet-projects.md` | Conditional .NET project/host/configuration/tooling context when it materially affects the explanation |

### Exact `code-and-system-explanation.md` contents

```markdown
# Code and system explanation
## Authority and evidence order
## Current, intended, proposed, guidance, and unknown
## Resolve feature identity and real entry points
## Trace callers, rules, configuration, data, effects, and failures
## Compare current implementation with canonical documentation
## Explain architecture and terminology in repository context
## Orient a non-coder without hiding technical consequences
## Derive one current next action without creating work
## Select the smallest useful diagram
## Layer detail for technical and non-technical readers
## Evidence links and uncertainty
## Fragmented or contradictory implementations
```

### Exact `github-feedback-explanation.md` contents

```markdown
# GitHub feedback explanation
## Resolve exact repository, PR, issue, comment, thread, check, and run
## Retrieve relevant diff, file, thread, request, and log context
## Distinguish review comments, issue comments, check failures, and review state
## Translate observation, impact, requested outcome, force, and resolution proof
## Explain the one current human decision or response path
## Ambiguous, optional, scope-expanding, stale, outdated, or already-addressed feedback
## Boundary with independent PR review
## Read-only and partial-evidence failures
```

Neither reference authorizes mutation or creates a repository document.

## Failure behavior

- Ambiguous subject: ask for one exact identifier and perform no speculative external reads.
- Missing repository evidence: explain what is known and label the unproven portion unknown.
- Inaccessible GitHub item: state the exact repository/PR/item and authentication or permission failure.
- Partial thread/diff/check context: do not paraphrase the isolated text as complete; identify what context is missing.
- Unavailable current Microsoft evidence: use another official Microsoft primary source and record it; otherwise limit only the dependent claim.
- Live Azure state required but unavailable: state the scoped evidence gap or route to operate; do not infer live state from desired configuration.
- User requests a fix, reply, plan, document, or state change: stop and hand off to the correct skill with the gathered evidence.
