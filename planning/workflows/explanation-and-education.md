# Explanation and education workflow

## Goal

Help a technical or non-technical user understand repository behavior, architecture, terminology, plans, pull requests, review feedback, check failures, current project position, and the next sensible action accurately in plain English, then stop without changing anything.

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
         +--> current/intended --> separate authority/code/plan/guidance
         |
         `--> where/what next ---> live state + dependencies -> one recommendation
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

The endpoint is explanation when the user wants to know what something means, how it works, why it matters, what another person/tool is asking, where the repository currently stands, what matters now, or the next sensible action without persisting a decision or organization change.

Do not silently turn it into:

- a correctness review;
- a feature plan;
- an implementation or refactor;
- a reply to a reviewer;
- a thread resolution;
- a documentation edit; or
- persistent backlog/Project/document organization; or
- an Azure operation.

If the request combines explanation with an explicitly requested action, explain first, then hand the evidence to the owning skill for the authorized action. Never use the educational tone as implied permission to mutate.

## Step 2: resolve the exact subject

Accept an exact path/symbol, feature/capability ID, issue/PR/comment URL or number, check name/run, error text, architecture term, or unambiguous natural-language subject.

If multiple subjects match and choosing one could materially change the answer, ask one focused question. Do not respond with a large discovery questionnaire. Do not select the newest PR/comment or a similarly named feature by guesswork.

## Step 3: establish authority and evidence type

Read root/nearest instructions, `docs/index.md`, applicable declared product/external authorities and relevant discovery/evidence sources, and the minimum canonical architecture/operations/ADR/change-record material needed for the subject. Apply each source's recorded content role rather than inferring authority from its name.

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

For broad orientation, also read the minimum README/docs index, roadmap/capability allocation, active GitHub Project/Issues, active change record/PR, dependencies, and required human decisions. Do not dump the full backlog.

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

## Step 4D: orient and recommend one next action

For “where are we?” or “what next?” synthesize rather than persist:

1. state the current outcome/change and whether it is `In progress`, `In review`, blocked, ready, or absent;
2. separate what matters now from ideas safely left in Next/Later/unallocated;
3. recommend finishing/unblocking active work first, then any genuine human review action, then a blocking Decision, then one unblocked Ready/Now item;
4. use recorded priority, target release, dependencies, and the user's goal rather than issue age or volume; and
5. when two candidates remain materially tied, recommend a default and ask one concrete question.

Do not auto-activate Triage/Next/Later work, create a plan, change GitHub state, or turn the answer into a giant ordered backlog.

## Step 5: apply external-evidence gates

Call Microsoft Learn when the user explicitly asks for Microsoft guidance or when the explanation materially depends on a current Microsoft-controlled version, support state, API, host, service, limit, migration, security, reliability, deployment, or tooling fact. Reuse valid scoped evidence for the same active question; do not call it merely because the repository contains C# or Azure-related files.

If actual Azure state determines the answer, use the read-only route of `$operate-azure-repository` after exact scope resolution. If the user has not identified a safe unambiguous scope, explain the repository-known portion and state the precise live-state gap rather than guessing.

## Step 6: write the layered explanation

Use this shape, omitting sections that add no value:

```markdown
# Plain-English explanation

## Current position
<conditional orientation>

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

## What matters now
<conditional current concern and what can wait>

## Evidence
- `<relative/path:line>` — <claim supported>
- <GitHub or official URL> — <claim supported>

## Recommended next action
<one genuine evidence-based action and why, one decision question, or no action required>

## Pending mistake-log entry
<conditional copy-ready entry; explicitly not persisted>
```

Lead with current position/outcome rather than implementation mechanics. Define jargon once, put deeper mechanics later, and prefer concrete nouns and actual component names. Use an analogy only after the real mechanism and label its limits when those limits matter. Do not patronize a non-coder or hide architecture, failure, security, cost, migration, or uncertainty consequences.

## Step 7: accuracy and stop check

Before returning:

- every material claim is evidence-backed or clearly labelled inference/unknown;
- current, intended, proposed, and external guidance are not conflated;
- simplification has not removed a material branch, failure mode, permission, or consequence;
- no secret, unnecessary personal content, or large source/document excerpt is exposed;
- no repository, Git, GitHub, Azure, or external state was changed; and
- any recommended next action follows current evidence and is not persisted, represented as decided, or expanded into manufactured work;
- at most one material decision question is asked; and
- any qualifying mistake made/recognized by this read-only context is returned as a pending entry rather than silently written.

Stop after the explanation. If the user subsequently asks to decide correctness, plan, fix, persist, or operate, route that new endpoint to review, plan, deliver, or operate respectively.

## Failure behavior

- Ambiguous subject: ask one focused identifying question.
- Missing repository or item: state exactly what could not be resolved.
- Insufficient code/caller evidence: explain the known portion and label the behavior unknown; do not substitute prose claims.
- Inaccessible GitHub item: report the exact repository/PR/comment and authentication or permission gap.
- Unavailable current Microsoft evidence: use another official Microsoft primary source; if none is reachable, limit only the dependent claim.
- Live Azure evidence required but unavailable: route or report the scoped gap; never infer resource state from intended IaC alone.
- Requested mutation: stop at explanation and hand off to the owning skill.
