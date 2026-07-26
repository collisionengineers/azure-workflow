# Explanation and education workflow

## Goal

Help a technical or non-technical user understand repository behavior, architecture, terminology, plans, pull requests, review feedback, or check failures accurately in plain English, then stop without changing anything.

Owner: `$explain-repository`.

## Route

```text
user asks to understand
         |
         v
identify exact subject and requested depth
         |
         v
resolve repository authority and evidence class
         |
         +--> code/feature ------> trace entry point -> owner -> effects -> proof
         |
         +--> term/architecture -> define in local context -> show relationships
         |
         +--> PR/feedback -------> exact PR/item -> diff/thread/check context
         |
         `--> current/intended --> separate authority/code/plan/guidance
         |
         v
current Microsoft fact needed? -- yes --> Learn gate
         |
         v
actual live Azure state needed? -- yes --> operate read-only route
         |
         v
translate in layers + cite decisive evidence
         |
         v
accuracy/boundary check
         |
         v
answer and STOP
```

## Step 1: classify the requested endpoint

The endpoint is explanation only when the user wants to know what something means, how it works, why it matters, or what another person/tool is asking.

Do not silently turn it into:

- a correctness review;
- a feature plan;
- an implementation or refactor;
- a reply to a reviewer;
- a thread resolution;
- a documentation edit; or
- an Azure operation.

If the request combines explanation with an explicitly requested action, explain first, then hand the evidence to the owning skill for the authorized action. Never use the educational tone as implied permission to mutate.

## Step 2: resolve the exact subject

Accept an exact path/symbol, feature/capability ID, issue/PR/comment URL or number, check name/run, error text, architecture term, or unambiguous natural-language subject.

If multiple subjects match and choosing one could materially change the answer, ask one focused question. Do not respond with a large discovery questionnaire. Do not select the newest PR/comment or a similarly named feature by guesswork.

## Step 3: establish authority and evidence type

Read root/nearest instructions, relevant `operator-notes/`, and the minimum canonical product/architecture/operations/ADR/change-record material needed for the subject.

Classify every material claim:

| Claim type | Primary evidence |
| --- | --- |
| Current implemented behavior | Actual entry point, real callers, canonical rule/configuration owner, persistence/external effect, and focused tests |
| Intended behavior | Current operator/product authority and active ADRs |
| Proposed behavior | Open change record, issue, PR, or review comment |
| Current GitHub state | Exact PR/issue/check/review/thread API result |
| Current Azure state | Read-only operate route and observed resource evidence |
| Current Microsoft behavior/guidance | Microsoft Learn gate and official source |

Documentation alone does not prove that a feature is implemented or called. Code alone does not prove that current behavior is intended.

## Step 4A: explain code, features, and system behavior

Load `code-and-system-explanation.md`.

Trace only the path needed to answer the question:

```text
user/operator trigger
       |
       v
real entry point
       |
       v
canonical business or application owner
       |
       +--> configuration/rule decision
       +--> persistence/external call
       `--> visible result/failure/recovery
       |
       v
focused proof
```

Name important forks, but do not dump a whole call graph when one route answers the question. When implementation is fragmented, say so and show the competing owners; do not invent a clean abstraction for explanation convenience.

## Step 4B: explain architecture or terminology

Define the term first in repository-specific language, then locate it in the actual system. Explain what it owns, what calls it, what it deliberately does not own, and why that boundary exists.

Use a generic definition only as supporting context. If the repository uses a term non-standardly, state both meanings rather than silently normalizing it.

## Step 4C: explain PR feedback or a check failure

Load `github-feedback-explanation.md`.

Resolve the exact PR and item. Retrieve enough surrounding evidence to avoid translating an isolated sentence incorrectly. For a review thread, include current resolution/outdated state and all materially relevant replies. For a check, inspect the failing job/step/log excerpt and affected change; do not infer the cause from the check name.

Return:

1. what was observed;
2. the consequence in product or maintainability terms;
3. what outcome is being requested;
4. whether it is stated as mandatory, optional, ambiguous, or scope-expanding;
5. what proof would demonstrate resolution; and
6. any missing context that prevents a faithful explanation.

Do not decide whether the reviewer is correct unless the user asks for a review. Do not reply, resolve, dismiss, request review, or change PR state.

## Step 5: apply external-evidence gates

Call Microsoft Learn when the user explicitly asks for Microsoft guidance or when the explanation materially depends on a current Microsoft-controlled version, support state, API, host, service, limit, migration, security, reliability, deployment, or tooling fact. Reuse valid scoped evidence for the same active question; do not call it merely because the repository contains C# or Azure-related files.

If actual Azure state determines the answer, use the read-only route of `$operate-azure-repository` after exact scope resolution. If the user has not identified a safe unambiguous scope, explain the repository-known portion and state the precise live-state gap rather than guessing.

## Step 6: write the layered explanation

Use this shape, omitting sections that add no value:

```markdown
# Plain-English explanation

## Short answer
<one to three direct sentences>

## How it works
<small numbered sequence or ASCII flow>

## Why it matters
<user/product/maintenance consequence>

## What the comment or check is asking
<conditional>

## Current, intended, and proposed
<conditional comparison when they differ>

## Evidence
- `<relative/path:line>` — <claim supported>
- <GitHub or official URL> — <claim supported>

## What happens next
<only a genuine decision/action, or state that no action is required>
```

Lead with outcome rather than implementation mechanics. Define jargon once. Prefer concrete nouns and actual component names. Use an analogy only after the real mechanism and label its limits when those limits matter.

## Step 7: accuracy and stop check

Before returning:

- every material claim is evidence-backed or clearly labelled inference/unknown;
- current, intended, proposed, and external guidance are not conflated;
- simplification has not removed a material branch, failure mode, permission, or consequence;
- no secret, unnecessary personal content, or large source/document excerpt is exposed;
- no repository, Git, GitHub, Azure, or external state was changed; and
- the answer does not manufacture a plan or next task.

Stop after the explanation. If the user subsequently asks to decide correctness, plan, fix, persist, or operate, route that new endpoint to review, plan, deliver, or operate respectively.

## Failure behavior

- Ambiguous subject: ask one focused identifying question.
- Missing repository or item: state exactly what could not be resolved.
- Insufficient code/caller evidence: explain the known portion and label the behavior unknown; do not substitute prose claims.
- Inaccessible GitHub item: report the exact repository/PR/comment and authentication or permission gap.
- Unavailable current Microsoft evidence: use another official Microsoft primary source; if none is reachable, limit only the dependent claim.
- Live Azure evidence required but unavailable: route or report the scoped gap; never infer resource state from intended IaC alone.
- Requested mutation: stop at explanation and hand off to the owning skill.
