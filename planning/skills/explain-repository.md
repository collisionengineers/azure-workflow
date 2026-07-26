# Skill specification: `explain-repository`

## Public purpose

Read repository, Git, GitHub, and official-source evidence to explain how a feature/system works, what technical terminology means in context, what is current versus intended or proposed, or what a pull-request comment/review/check is saying. Return a layered plain-English explanation and stop without changing anything.

## Why this is a public skill

It passes all three public-skill tests:

1. “Explain this feature/comment/check to me” is a standalone user outcome.
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
description: Explain in plain English how a repository feature, code path, architecture decision, configuration, plan, pull request, review comment, check failure, or technical term works and why it matters. Use when the user asks what something means, how or why it works, what is current versus intended or proposed, or what technical feedback is asking them to do, and the requested endpoint is understanding rather than a correctness verdict, plan, fix, documentation change, GitHub response, or Azure operation. Inspect evidence as needed, cite decisive sources, and make no changes.
---
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Explain Repository"
  short_description: "Explain repository work and feedback in plain English"
  default_prompt: "Use $explain-repository to explain this repository feature, technical concept, or feedback in plain English without changing anything."

policy:
  allow_implicit_invocation: true
```

No MCP is unconditionally required. Apply the central Microsoft Learn guidance gate when the user requests Microsoft guidance or when a material part of the explanation depends on a current Microsoft-controlled fact. Do not call Learn for repository-owned business logic merely because it is implemented in .NET or deployed to Azure. If actual live Azure state is necessary, route the read-only evidence request through `$operate-azure-repository`; this skill never authorizes Azure mutation.

## Required `SKILL.md` body structure

```markdown
# Explain Repository
## Read-only authorization and endpoint
## Resolve the exact subject
## Establish authority and evidence type
## Trace and translate the mechanism
## Explain GitHub feedback
## Return the layered explanation
## Handoffs and stopping rules
## Failure behavior
## Resources
```

Keep the body below 500 lines. Put code/system tracing detail in `code-and-system-explanation.md` and GitHub item retrieval/translation detail in `github-feedback-explanation.md`.

## Authorization contract

Invocation authorizes:

- read repository instructions, `operator-notes/`, canonical documents, source, configuration, tests, Git history, and existing permitted local artifacts;
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

1. Confirm that the endpoint is understanding. Route “is this PR/comment correct?” to `$review-repository-pull-request`; “plan/design” to `$plan-azure-repository-change`; “fix/address/write/persist” to `$deliver-azure-repository-change`; and current live Azure diagnosis/operation to `$operate-azure-repository`.
2. Resolve the Git root and exact subject from a path/symbol, feature/capability ID, issue/PR/comment/check URL or number, error, term, or unambiguous request. Never choose the newest PR/comment or similarly named feature. Ask one focused question only if material ambiguity remains.
3. Read root/nearest `AGENTS.md`, relevant `operator-notes/`, and the minimum canonical product, architecture, operations, ADR, roadmap, change-record, and design authority needed. Preserve every human-owned root and make no writes.
4. Classify the requested claims as current implemented behavior, intended product behavior, proposed change/feedback, current external state/guidance, or unknown. Do not treat documentation as caller proof or code as intended authority.
5. Select the minimum applicable reference. Load `code-and-system-explanation.md` for feature/code/data/configuration/architecture/term questions. Load `github-feedback-explanation.md` for a PR, review comment/thread, issue comment, or check. Load both only when the question genuinely crosses them. When .NET mechanics materially affect the answer, also load `../../references/dotnet-projects.md` and only its relevant sections.
6. For code/system behavior, trace the real trigger/entry point, canonical owner, important rule/configuration forks, persistence/external effect, visible outcome/failure/recovery, and focused proof. Show competing owners honestly when the implementation is fragmented.
7. For GitHub feedback, resolve the exact item and retrieve its relevant diff/file context, thread replies and state, linked request/record when needed, and check/log evidence when applicable. Explain what was observed, consequence, requested outcome, stated force, and proof of resolution. Do not expand one-comment translation into a complete PR verdict.
8. Apply the Microsoft Learn gate. Record compact official evidence when a current Microsoft fact is material. If actual Azure state is required, obtain it through the read-only operate route or state the exact gap; never guess from IaC or prose.
9. Write the short answer first. Then show the smallest useful sequence or diagram, why it matters, conditional current/intended/proposed comparison, decisive evidence, and a next action only when one genuinely exists.
10. Define unavoidable jargon on first use. Use analogies only as support and never hide material branches, risks, permissions, or failure behavior for simplicity.
11. Label inference and unknowns explicitly. Use repository-relative paths and line anchors plus direct GitHub/official URLs; do not dump large files, logs, threads, or documentation pages.
12. Verify no state changed and stop. A later action request is a new handoff to its owning skill.

## Result schema

```markdown
# Plain-English explanation

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

## Evidence
- `<relative/path:line>` — <claim>
- <GitHub or official URL> — <claim>

## What happens next
<genuine choice/action, or “No action is required to answer this question.”>
```

Omit empty conditional sections. Do not produce a performative next-step list when the user only asked for a definition.

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
| `code-and-system-explanation.md` | Evidence order, current/intended/proposed separation, real-caller tracing, data/control/failure flows, terminology, diagrams, and layered output |
| `github-feedback-explanation.md` | Exact issue/PR/comment/check resolution, minimal GitHub reads, thread/diff/log context, reviewer-request translation, stated-force classification, and non-mutation boundary |
| `../../references/dotnet-projects.md` | Conditional .NET project/host/configuration/tooling context when it materially affects the explanation |

### Exact `code-and-system-explanation.md` contents

```markdown
# Code and system explanation
## Authority and evidence order
## Current, intended, proposed, guidance, and unknown
## Resolve feature identity and real entry points
## Trace callers, rules, configuration, data, effects, and failures
## Explain architecture and terminology in repository context
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
