# Human notes and requirements-documentation audit

Research date: 2026-07-26

Status: decision incorporated into the active planning contract

## Question

Should a reusable repository workflow reserve `operator-notes/` as immutable business authority, and should every onboarded repository contain separately named PRD and FRD files?

## Conclusion

No to both defaults.

`operator-notes/` was a useful CollisionSpike v2 convention, but the directory name does not establish authority in an unrelated repository. The current plan accidentally promoted that case-study rule into a plugin-wide invariant. This conflicts with the plugin's genericity requirement and, more importantly, conflates three separate properties:

- who authored a source;
- whether its statements are approved, draft, evidence, or history; and
- whether an agent may edit, move, or delete it.

The plugin will instead discover and classify every relevant human-authored source or protected root. A target repository may still declare `operator-notes/` to be binding and human-edit-only, but that is a repository-specific rule recorded in its authority map, not behavior triggered by the folder name.

The repository documentation spine already performs the useful roles normally associated with PRDs and FRDs. It should make those roles obvious, add the few missing product-requirement fields, and avoid creating duplicate acronym-named documents:

```text
product-wide why / who / outcomes / success / scope
        -> docs/product/index.md                 living PRD role

durable behavior / rules / states / inputs / failures by area
        -> docs/product/areas/<area>.md          functional-specification role

one activated change's acceptance / design / proof / recovery
        -> docs/changes/YYYY-MM-DD-<slug>.md     change specification and history

live order / owner / dependency / status
        -> GitHub Issue + Project                work management
```

## What the external guidance establishes

- [ISO/IEC/IEEE 29148:2018](https://www.iso.org/standard/72089.html) defines requirements-engineering processes, information items, content, and format guidance across a system lifecycle. It is applicable across methodologies and project sizes; it does not make `PRD.md` or `FRD.md` universal repository filenames.
- [GOV.UK guidance on user needs](https://www.gov.uk/service-manual/user-research/start-by-learning-user-needs) recommends evidence-based needs in user language, keeping the list manageable, connecting user stories and acceptance criteria to those needs, and refining them as evidence changes.
- [Atlassian's PRD guidance](https://www.atlassian.com/software/confluence/templates/product-requirements) illustrates a common product-document role: purpose, objectives and success measures, assumptions, user stories, design context, scope, and open questions. It is a useful content model, not a mandatory universal structure.
- [The archived US Department of Justice FRD definition](https://www.justice.gov/archive/jmd/irm/lifecycle/appendixc14.htm) illustrates the more formal use of an FRD as a statement of an application's functional requirements. That form is valuable when a contract, controlled process, supplier handoff, or traceability regime requires it.
- [GitHub's planning guidance](https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/planning-and-tracking-work-for-your-team-or-project) separates repository orientation from live work planning: README communicates project information, while issues and Projects organize active work.
- [GitLab's documentation architecture guidance](https://docs.gitlab.com/development/documentation/site_architecture/folder_structure/) recommends linking to a single source of truth rather than duplicating the same information across files.

There is therefore no conflict between rigorous requirements engineering and a distributed, purpose-owned repository spine. Rigor comes from complete, testable, traceable, reviewed requirements—not from adding two acronyms to filenames.

## Correct authority model

Authority role and mutation rule are orthogonal.

| Property | Allowed values | Meaning |
| --- | --- | --- |
| Content role | approved product authority; active external/controlled requirement; draft/discovery input; evidence/reference; superseded/history | How statements may influence intended behavior |
| Mutation rule | workflow-maintained; human-edit-only; preserve-in-place; generated/do-not-edit | What an agent may change during ordinary work |
| Canonical destination | exact path or external URI; `none` while unresolved | Where an accepted durable claim is maintained |

Examples:

| Source | Role | Mutation | Consequence |
| --- | --- | --- | --- |
| Repository product index | approved product authority | workflow-maintained through reviewed changes | Canonical intended product behavior |
| Signed customer specification | active external/controlled requirement | preserve-in-place | Canonical constraint; repository product docs link or map to its clauses |
| `notes/ideas.md` | draft/discovery input | human-edit-only | Inspect for candidate claims; do not treat every statement as approved |
| Interview transcript | evidence/reference | preserve-in-place | Supports decisions but is not itself the decision |
| Old PRD | superseded/history | preserve or remove after proved migration | Never silently reactivated by its filename |

Neither human authorship nor immutability implies authority. An interview transcript can be valuable and untouchable without every speculative sentence becoming a requirement.

## Unclassified-source default

When no repository instruction, document status, approval record, contract, or current user answer establishes the role:

1. preserve the source during discovery;
2. classify it provisionally as non-binding discovery input;
3. extract material claims into the onboarding claim ledger;
4. compare them with active product authority and observed behavior;
5. ask one focused question only when accepting or rejecting a claim changes a material outcome; and
6. record the approved requirement in the canonical product document.

The workflow must not label the source "absolute truth" or rewrite it merely to resolve ambiguity.

## Onboarding and cleanup behavior

```text
human-authored source or protected root found
                  |
                  v
explicit role + mutation rule already declared?
        | yes                         | no
        v                             v
honour and record it          preserve as discovery input
        |                             |
        +-------------+---------------+
                      v
        map each material claim and stable ID
                      |
                      v
     conflict or approval changes intended behavior?
             | yes                 | no
             v                     v
       ask one question       continue conversion
             |                     |
             +----------+----------+
                        v
           write accepted durable requirement once
                        |
                        v
   retain / archive / remove source under its mutation rule
        and only after claim, ID, link, and history parity
```

New repositories do not receive an `operator-notes/` folder. Onboarding does not rename every notes folder into one. If a source remains useful evidence, it may stay at its declared protected path or move, when authorized, to a purpose-named `docs/reference/<category>/` destination. If its material content is fully incorporated and no contract/history requires retention, ordinary legacy-document parity rules may retire it—unless its declared mutation rule requires explicit human authorization.

## PRD role in this plugin

`docs/product/index.md` remains the required filename because it is the stable entry point for the product subtree. Its generated title and contents make the familiar role explicit:

```markdown
# Product requirements
## Purpose and problem
## Users and desired outcomes
## Success measures
## In scope
## Out of scope
## Requirements and invariants
## Quality attributes and constraints
## Supported contracts
## User-facing language and interaction
## Development materials, licensing, and test examples
## Product areas and capabilities
## Current limitations
## Open product decisions
```

This is a living repository-level PRD role, not a one-off launch proposal. It records intended product truth and never claims that every requirement is implemented.

## Functional-requirements role

Create `docs/product/areas/<area>.md` only when a real product area has enough durable behavior to justify a separate owner. Its shape is the lightweight functional specification:

```markdown
# <Product area>
## Authority, users, and desired outcomes
## Functional behavior and business rules
## Workflow, states, and transitions
## Inputs, outputs, data, and terminology
## Permissions and failure/recovery behavior
## Quality attributes and constraints
## Acceptance examples and evidence routes
## Boundaries, exclusions, and current limitations
```

Small products may keep these facts in the product index. Do not generate empty area files or one FRD per feature.

The active change record supplies change-specific acceptance, interfaces, data/control flow, failure/recovery, UI, verification, and ordered implementation detail. After delivery, durable intended behavior belongs in the product index/area, current structure in architecture, operations in the runbook, and the change record becomes history.

## Existing formal PRD, FRD, SRS, URS, or contract

Onboarding preserves its filename, requirement IDs, approval status, and traceability until migration parity is proved. Then:

- retain and route it as canonical when its format is itself a contractual, regulatory, supplier, or human-controlled deliverable;
- map its active clauses to the product index/areas without copying the full text when it is an external authority;
- consolidate it into the normal product spine when no separate controlled-artifact requirement exists; or
- classify it as superseded/history when an approved successor exists.

Do not create a second PRD/FRD merely to satisfy the plugin's preferred layout. Formal per-requirement IDs and traceability matrices are conditional on an existing contract, regulatory process, multi-team interface, or other demonstrated audit need. Stable capability IDs plus linked acceptance are sufficient by default.

## Plugin placement

This decision adds no public skill, hook, MCP, script, or new always-created directory.

- Onboarding's existing `repository-policy-profile.md` reference owns discovery, classification, preservation, and migration of human-authored sources.
- The existing product-index and product-area onboarding assets receive the revised headings.
- Planning reads authority through `docs/index.md`, updates the living requirements owner, and uses the existing change record for one activated change.
- Delivery maintains the same owners; review checks source-role/authority consistency and does not elevate an unclassified notes folder.
- `AGENTS.md` contains only actual target-repository protected roots and their concise mutation rules; it has no generic `operator-notes/` instruction.

## Acceptance

The design is correct when fresh-thread scenarios prove:

- an undeclared `operator-notes/` brain dump is preserved and mined for candidate claims but is not treated as approved authority;
- an explicitly declared binding `operator-notes/` root retains that repository-specific status and mutation rule;
- approved requirements land once in the product index/area with source traceability;
- the product index includes purpose, users, success measures, scope, requirements, constraints, contracts, limitations, and open decisions;
- detailed functional behavior is created only for warranted product areas;
- an existing controlled PRD/FRD/SRS retains its IDs and approval/contract role;
- no default `operator-notes/`, `PRD.md`, `FRD.md`, requirements database, traceability matrix, hook, or seventh skill appears; and
- superseded notes/specifications are retired only under their declared mutation rule and after claim, identifier, link, and history parity.
