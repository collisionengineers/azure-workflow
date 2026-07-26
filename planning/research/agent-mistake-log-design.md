# Agent mistake-log design

## Goal

Retain factual, reusable evidence about agent failures so the user can later improve the plugin, without creating another task engine, review ledger, or stream of low-value noise.

## Selected model

Every onboarded repository has one tracked file:

```text
docs/agent-mistakes.md
```

Qualifying incidents are appended oldest-to-newest using the exact contract in [the agent mistake-log standard](../standards/agent-mistake-log.md). The log is historical learning evidence. It is not product authority, a live backlog, a change record, a review finding list, or a substitute for correcting the mistake.

The useful unit is not “something went wrong.” It is:

```text
wrong agent action or claim
        + actual or credible potential consequence
        + evidence
        + concrete recovery
        + reusable prevention signal
```

## Admission decision

Record a mistake when it reveals a reusable plugin/workflow weakness or a material failure of the agent to follow existing authority. Examples include wrong repository/branch/resource scope, unauthorized mutation, false completion/evidence claims, lost user work, ignored source authority, incorrect routing, machine-specific tracked paths, forbidden synthetic material, unnecessary legacy/fallbacks, duplicated policy owners, or overengineered machinery.

Do not record every expected failing test, exploratory command error, transient service failure, considered-but-rejected option, human decision change, or ordinary implementation defect caught by the intended test/review before any completion claim. Those events produce volume without improving the plugin. A routine defect becomes log-worthy when it repeats, escapes a required gate, causes material rework, violates a declared rule, or exposes a missing/unclear plugin control.

User correction is evidence, not automatic blame. Record it when it identifies a concrete prior agent action/claim that was wrong under the authority available at the time. Do not call a newly supplied preference or changed decision a past mistake.

## Why one append-only Markdown file

| Option | Decision | Reason |
| --- | --- | --- |
| One repository Markdown log | Selected | Obvious, portable, diffable, searchable, and directly usable for later plugin analysis |
| One file per incident | Rejected | Creates folder and navigation churn for small factual records |
| GitHub issue per incident | Rejected | Pollutes actionable work and confuses evidence with live remediation |
| Generated JSON/database/telemetry | Rejected | Recreates the workflow-state machinery this plugin is meant to remove |
| General retrospective in every change record | Rejected | Duplicates history and encourages ceremonial entries even when no mistake occurred |
| Automatic plugin modification from the log | Rejected | A target-repository incident is evidence, not authority to change a shared plugin |

Append-only means existing incident blocks are not silently rewritten or deleted. A factual correction or later outcome is a new follow-up block referencing the original ID. This preserves what the agent believed and what changed without adding a database or lock protocol.

## Authorization boundary

```text
qualifying mistake recognized
          |
          +--> current workflow may write this repository
          |       `--> recover safely -> append entry -> validate -> continue
          |
          `--> current workflow is read-only or repository cannot be safely changed
                  `--> return copy-ready pending entry -> append in next authorized plan/delivery
```

Explanation and independent review remain genuinely read-only. Azure operation does not gain incidental repository-write authority. Onboarding, planning, and delivery append when their existing scope authorizes repository documentation changes. A pending entry must be clearly reported; it cannot be called durably recorded until it is committed through an authorized workflow.

## Making the evidence useful for plugin improvement

Every incident distinguishes:

- the repository-specific event and evidence;
- the workflow package/version in use, or an explicit `unknown`/`no-plugin` value;
- the existing authority that should have prevented it;
- the procedural cause, such as a trigger gap, missing core instruction, unclear reference, bad template, or absent deterministic check;
- whether the lesson transfers beyond this repository; and
- one candidate plugin improvement and one recurrence test.

The candidate is deliberately non-authoritative. Later plugin maintenance can compare multiple logs, validate recurrence, and choose the smallest general improvement. Repository-specific facts never become packaged defaults merely because one entry proposed them.

When the user later supplies incident entries for plugin improvement, triage them in this order:

1. group matching reusable lessons without erasing their repository evidence or IDs;
2. compare workflow package versions to distinguish a current defect from an already-corrected historical one;
3. decide whether the control was missing, ambiguous, not loaded, or clearly present but ignored;
4. choose the smallest justified layer: trigger, core workflow, reference, onboarding asset, deterministic validator, repository-only correction, or no plugin change;
5. add or update a recurrence scenario before changing the plugin; and
6. link the supporting incident IDs in the plugin change record and verify the neutral fix does not encode one repository's domain facts.

There is no automatic cross-repository collection or telemetry. The user chooses which tracked logs or entries to provide to the plugin repository.

## Skill/resource decision

There is no mistake-log skill. “Record a mistake” is a mandatory consequence inside an already selected workflow, not a distinct repository lifecycle outcome with its own authorization and success boundary.

The exact blank log is an onboarding asset because it is copied into repository output. Detailed admission, append, read-only, validation, and improvement rules live in the repository standard and the existing onboarding/planning/delivery documentation references. No script is added: Markdown append and validation are simple, while a generator or incident database would be disproportionate.
