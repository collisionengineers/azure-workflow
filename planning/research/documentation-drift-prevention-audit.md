# Documentation drift-prevention audit

## Question

Does the planned plugin keep durable repository documentation aligned with implementation, instead of merely creating a documentation structure during onboarding?

## Finding

The plan already has the correct foundation: one canonical owner per fact, a documentation update matrix, same-change maintenance, path-aware Docs checks, change-record tracking, and exact-head pull-request review. The missing precision was that mechanical validation and semantic truth were not clearly separated, and there was no explicit route for an on-demand read-only drift audit.

## Selected control model

Documentation drift is prevented and detected at three change boundaries:

```text
1. PLAN
   declare each affected canonical owner, or give a specific reason for none
          |
          v
2. SAME PULL REQUEST
   change implementation + owning docs + change record together
   run deterministic structure/link/schema/path-aware checks
          |
          v
3. FRESH EXACT-HEAD REVIEW
   compare request + real callers/config + canonical docs semantically
   drift is blocker/required work; remediate and review the new head again
```

The layers prove different things:

- Planning makes documentation impact deliberate before implementation.
- Deterministic Docs/Full checks prove structure, routing, links, schemas, IDs, generated-source mappings, and other machine-testable contracts.
- Fresh review proves semantic agreement by tracing current code/configuration/callers and comparing them with intended product truth and current architecture/operations. A link checker cannot prove this.

The historical change record is evidence of what was planned and delivered. It is not edited after merge merely to mirror current GitHub state or later implementation reality. Current facts stay in their canonical owners; a later correction uses a new change or a dated correction/supersession under the record contract.

## On-demand route

No seventh “documentation auditor” skill is justified. Existing endpoints cover the complete lifecycle:

```text
initial or non-conforming repository ----------> onboard-azure-repository
read-only current-vs-documented comparison ----> explain-repository
decision-complete remediation plan ------------> plan-azure-repository-change
correct discovered drift ----------------------> deliver-azure-repository-change
judge a candidate pull request ----------------> review-repository-pull-request
```

`explain-repository` may report where code/configuration and canonical documentation disagree, classify current versus intended truth, and identify the owner that needs correction. It remains read-only and issues no PR verdict. Mutation still requires planning or delivery.

## Why no default hook or scheduled bot

A hook cannot establish semantic truth and would add hidden execution to every interaction. A scheduled documentation bot creates status noise and still cannot decide whether code or intended product authority is wrong. The default therefore uses visible change-boundary enforcement. A repository may add a periodic audit only when it has a named consumer, cadence, scope, owner, and useful response to findings.

This follows current Codex guidance to keep `AGENTS.md` concise and practical, encode recurring errors, plan difficult work, and verify the result, while using skills for recognizable repeatable workflows with progressive disclosure. See [AGENTS.md guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md) and [Codex plugin skills](https://developers.openai.com/plugins/build/skills).

## Acceptance consequences

- Every change record declares documentation impact before implementation, including a specific reason when no canonical file changes.
- Every PR body says which canonical documents/design authorities changed or why none changed.
- Same-change document maintenance is required; a follow-up documentation issue is not normal completion.
- Docs checks remain cheap and deterministic; executable changes still receive Full checks.
- Semantic document disagreement blocks a clean exact-head review even when all mechanical checks pass.
- On-demand drift inspection is demonstrably read-only and routes any requested correction to delivery.

