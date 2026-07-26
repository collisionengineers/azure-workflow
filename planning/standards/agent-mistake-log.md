# Agent mistake-log standard

## Purpose and authority

`docs/agent-mistakes.md` is the repository's append-only historical record of qualifying agent mistakes and reusable prevention signals. It exists so later plugin improvement is based on evidence rather than vague recollection.

It does not own product behavior, architecture, roadmap allocation, live work state, review findings, or plugin changes. Correct those facts in their canonical owners; use the log only to retain the learning.

## Required path and routing

Every onboarded repository contains:

```text
docs/agent-mistakes.md
```

`docs/index.md` routes to it under historical evidence. Root `AGENTS.md` gives the concise admission/append rule and tells agents to search relevant entries before repeating similar work. Agents search by affected path, skill, failure class, or authority; they do not load the entire growing file into every task.

Onboarding preserves existing material mistake/incident/lesson logs, maps them into this file without inventing incidents, and retains their source until claim/link parity passes. An empty `## Entries` section is valid at onboarding.

## Admission test

Append an incident when all three are true:

1. an agent action, omission, route, or factual/completion claim was wrong under authority available at the time;
2. it caused actual impact or a credible material risk/rework; and
3. it supplies a reusable prevention signal for this repository or the shared plugin.

Always consider these qualifying classes:

- wrong repository, branch, worktree, tenant, subscription, environment, resource, issue, PR, or change identity;
- unauthorized, destructive, unrelated, or scope-expanded mutation;
- user work lost, overwritten, staged, committed, or represented as agent-owned;
- declared source of truth, active external/controlled requirement, protected-root mutation rule, active instruction, mode, supported contract, or explicit decision ignored;
- a check/review/evidence source skipped while completion or correctness was claimed;
- implementation presence, registration, documentation, desired state, or partial API results falsely represented as caller-backed/current/complete proof;
- forbidden synthetic material, machine-specific tracked path, leaked secret, internal user-facing wording, speculative legacy/fallback, duplicate authority, or disproportionate abstraction;
- wrong skill/endpoint routing or a read-only boundary crossed;
- a repeated defect, a defect that escaped its required gate, or a plugin instruction/reference/template/check that materially failed to prevent recurrence; or
- an explicit user request to record a concrete evidenced mistake.

Do not append solely for:

- an expected red test or compiler failure while implementing and before any pass/completion claim;
- a harmless exploratory command failure immediately corrected;
- authentication, network, provider, CI, or tool failure not caused or misrepresented by the agent;
- an option considered but not implemented;
- a human changing or newly supplying a decision;
- an unresolved reviewer preference or disagreement not established as an agent error; or
- an ordinary defect caught by the intended check/review before it caused material rework or a false claim.

When causation is uncertain, record the observed defect in its ordinary owner and do not attribute it to an agent. Never invent an incident to populate an empty log.

## Timing and authorization

1. Stop or contain harmful activity and recover safely before documenting.
2. Record the incident as soon as its facts and evidence are known; do not wait until a retrospective batch.
3. Onboarding, planning, or delivery appends within its already authorized branch/change and includes the entry ID in the change record.
4. Explanation and pull-request review remain read-only. They return a copy-ready `Pending mistake-log entry` and the reason it could not be persisted. The next explicitly authorized onboarding/planning/delivery workflow appends it after rechecking the evidence.
5. Azure operation reports a copy-ready pending entry and routes any repository append through delivery; mistake logging does not broaden Azure or repository mutation authority.
6. If an entry is added to a PR after checks or review, it changes the head. Re-run the selected Docs/Full check and every invalidated exact-head review gate.
7. If the worktree is dirty outside the current scope, do not bypass the clean-tree rule to write the log. Return the pending entry.

A conversation-only proposal is not described as recorded. A durable entry exists only after it is present on the scoped branch/PR and ultimately merged under the repository's normal workflow.

## Append-only rules

- Entries are oldest-to-newest under `## Entries`.
- Use `AM-YYYYMMDD-NNN`, where the date is UTC and `NNN` is the next unused sequence for that date.
- Never delete, reorder, or silently rewrite an existing incident block.
- Correct a factual error or record a later outcome by appending `Follow-up to AM-...` with its own ID.
- Do not paste chain-of-thought, hidden reasoning, credentials, secrets, full logs, or large source excerpts. Record the observable procedural cause and link compact evidence.
- Use repository-relative paths and direct GitHub/official URLs.
- Keep entries factual and blame-free. Name the workflow/skill and action, not a speculative model personality.
- Do not rotate, archive, summarize, score, or generate issues automatically. Revisit storage only when actual size creates a demonstrated usability problem.

## Exact repository asset

The onboarding asset at `skills/onboard-azure-repository/assets/repository/agent-mistakes.md.template` contains exactly this shape:

```markdown
# Agent mistake log

Purpose: retain evidence from material agent mistakes so repository and plugin workflows can improve.

This is append-only historical evidence, not product authority or a live backlog. Add factual corrections as follow-up entries; do not rewrite prior entries.

## What to record

Record only when an agent action, omission, route, or factual/completion claim was wrong under the authority available at the time, caused actual impact or credible material risk/rework, and provides a reusable prevention signal. This includes wrong scope/identity, unauthorized or unrelated mutation, lost user work, ignored authority, false proof/completion claims, crossed read-only boundaries, forbidden synthetic/machine-specific/legacy/duplicate machinery, or a repeated/escaped defect exposing a workflow gap.

An explicit user correction qualifies when it identifies a concrete evidenced prior agent mistake, not when the user newly supplies or changes a decision.

## What not to record

Do not record expected red tests, harmless exploratory failures, external tool/provider failures, considered-but-unused options, new human decisions, unresolved preferences, or ordinary defects caught by the intended gate before material rework or a false claim. Never invent an incident to populate the log.

Write-authorized workflows append qualifying entries. Read-only workflows return a copy-ready pending entry and do not edit this file.

## Incident template

## AM-YYYYMMDD-NNN — <short factual title>

- Recorded: `<UTC ISO-8601>`
- Detected by: `user | agent | test | CI | review`
- Workflow: `<skill name or no-plugin workflow>`
- Workflow package: `<plugin@version plus source revision when known | no-plugin | unknown>`
- Change/PR: `<relative change-record path, PR URL, or none>`
- Follow-up to: `<AM-YYYYMMDD-NNN or none>`
- State at recording: `corrected | recovery-pending`

### What happened

<wrong action, omission, route, or claim>

### Expected behavior and authority

<what should have happened and the relative instruction/authority path>

### Impact

- Actual: <observed consequence or none>
- Potential: <credible consequence>

### Detection and evidence

- `<relative/path:line>` or <URL/compact command result> — <what it proves>

### Correction

<immediate recovery, remaining work, and proof; use `pending` when unresolved>

### Plugin improvement signal

- Classification: `trigger | core-workflow | reference | asset-template | script-validator | repository-specific | no-plugin-change`
- Reusable lesson: <general lesson or repository-specific only>
- Candidate improvement: <smallest proposed change or none>
- Recurrence check: <scenario/check that would catch this next time or none>

## Entries
```

Agents copy the incident heading/fields beneath `## Entries`; they do not edit the displayed template.

## Change-record and GitHub relationship

The active change record contains `Agent mistake entries: <IDs or none>`. A qualifying incident is corrected in the current work before readiness where possible. Create a GitHub issue only when separate unresolved remediation is genuinely actionable; the log entry itself is not a task and does not alter Project status.

Candidate plugin improvements remain proposals until separately reviewed in the plugin repository. When later adopted, the plugin change links the supporting incident IDs without copying target-repository domain facts into packaged defaults.

## Validation

Repository validation checks:

- required path, title, purpose, `## Incident template`, and `## Entries`;
- unique, well-formed IDs and resolving follow-up references;
- required fields, workflow-package provenance, and classification values for every real entry;
- repository-relative tracked paths and absence of unresolved template placeholders in real entries; and
- when a base ref is available, existing incident IDs/order/body remain unchanged and new incidents are appended after them.

The log is Markdown, so changing only it selects Docs scope. Validation never creates, rewrites, scores, summarizes, or files work from an entry.
