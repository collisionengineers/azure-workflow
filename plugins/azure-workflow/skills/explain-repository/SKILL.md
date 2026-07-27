---
name: explain-repository
description: Explain an Azure-oriented or Azure Workflow-onboarded repository, feature, architecture, code path, technical term, failure, GitHub issue, pull request, review comment, or check result in plain English without changing anything. Use when a non-coder wants to understand how something works, what feedback means, where the repository currently stands, or what the single sensible next action is. Do not use for correctness verdicts, planning, fixes, documentation persistence, GitHub replies, Azure mutation, or unsupported non-Azure repository ownership.
---

# Explain Repository

Turn repository evidence into a layered plain-English explanation. This route is read-only and leaves no organizational artifacts behind.

## Read-only authorization and endpoint

Invocation authorizes reading repository files/history/instructions, GitHub metadata and feedback, known non-mutating checks, and current official Microsoft guidance when material. It does not authorize edits, commits, comments, issue/Project changes, thread resolution, planning, implementation, or Azure mutation.

Work in Windows with PowerShell 7. Resolve the repository and exact subject. If a PR, issue, comment, check, feature, or file is ambiguous, ask for its identity; never select the newest item. Read root/nearest instructions and `docs/index.md` before assigning authority.

## Establish authority and evidence type

Read [code and system explanation](references/code-and-system-explanation.md) for features/architecture/failures and [GitHub feedback explanation](references/github-feedback-explanation.md) for PRs, reviews, comments, and checks. Load the [.NET profile](../../references/dotnet-projects.md) only when .NET-specific behavior materially affects the explanation.

Label each claim as one of:

- **current:** observed in current code, configuration, test, CI, GitHub, or live read-only evidence;
- **intended:** stated by active product/design/architecture/operations/decision authority;
- **proposed:** an issue, plan, comment, or option not yet implemented;
- **unknown:** evidence is missing or contradictory.

Never use code alone to claim intended behavior, or documentation alone to claim current implementation. Treat unclassified notes as discovery input, not truth by filename.

Use Microsoft Learn when the user explicitly asks for Microsoft guidance or a material part of the answer depends on a current Microsoft-controlled version, support state, API, Azure service/limit, migration, security, reliability, deployment, or tooling fact. Reuse valid scoped evidence for the same active question. Do not query Learn for pure repository-owned logic merely because it uses .NET or Azure.

If actual Azure state is necessary, route a read-only evidence request to `$operate-azure-repository`; this skill never authorizes a write.

## Trace and translate the mechanism

1. Start from the user-visible/operator-visible trigger.
2. Trace the real entry point, caller chain, policy/configuration owner, storage/external boundary, output, and failure/recovery path.
3. Explain cause and effect before file names or frameworks.
4. Introduce each technical term once, with a short definition at the point of use.
5. Name relative repository paths only when they help the user verify or navigate.
6. State contradictions and confidence plainly. Do not smooth over missing evidence.

For a feature, cover what it does, why it exists, what starts it, the main steps, where its rules/data live, what happens when it fails, and what is not implemented. For architecture, explain ownership and boundaries. For a failure, separate observed symptom, likely cause, proven cause, impact, and safe evidence-gathering step.

## Explain GitHub feedback

Translate a PR comment/review/check into:

- what the reviewer or check is saying;
- why it matters in observable terms;
- whether it asks for a code change, evidence, clarification, or scope decision;
- what would satisfy it;
- what remains uncertain.

Do not decide whether the reviewer is correct unless the user asks for a review verdict; route that to `$review-repository-pull-request`. Do not reply or fix; route an explicit action request to `$deliver-azure-repository-change`.

## Orient the user and recommend one next action

When asked "where are we?" or "what next?", derive - not store - one recommendation from existing owners:

1. continue/unblock the single current `In progress` change;
2. perform a genuine waiting human action on an `In review` item;
3. resolve a Decision blocking an activated Now outcome; otherwise
4. select one unblocked `Ready` item already in Now using priority, target release, dependencies, and the user's stated goal.

Never choose by issue age alone, activate Triage/Next/Later work, or create `NEXT.md`, a dashboard, a duplicate status field, or an organizer state file. If two options are materially tied, recommend a default and ask one focused question.

## Return the layered explanation

Use this shape, omitting empty sections:

```markdown
## Plain-English answer
<direct answer first>

## How it works
<short cause-and-effect sequence>

## Current, intended, and proposed
<only distinctions that matter>

## Why this matters
<user/operator impact>

## Evidence
- `relative/path:line` - <what it proves>
- <GitHub or official Microsoft URL> - <what it proves>

## Next action
<exactly one evidence-based action or explicit waiting/no-action state>
```

## Handoffs and failure behavior

- Correctness verdict requested: route to `$review-repository-pull-request`.
- Plan requested: route to `$plan-azure-repository-change`.
- Fix, persistence, comment reply, or CI remediation requested: route to `$deliver-azure-repository-change`.
- Azure change requested: route to `$operate-azure-repository` for an approval-gated operation.
- Missing/contradictory evidence: state the exact uncertainty and the one evidence item needed; do not invent an answer.
- Non-Azure and not onboarded: explain that this plugin does not own the repository; a one-off read-only explanation may proceed only if the user explicitly wants it without claiming workflow coverage.

## Resources

- [code and system explanation](references/code-and-system-explanation.md)
- [GitHub feedback explanation](references/github-feedback-explanation.md)
- [conditional .NET profile](../../references/dotnet-projects.md)
