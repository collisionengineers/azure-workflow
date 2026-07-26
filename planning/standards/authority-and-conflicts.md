# Authority and conflict handling

## Principle

The plugin owns documentation coherence, not undisclosed business truth. It establishes a declared authority map, distinguishes intended behavior from observed behavior, and asks the user only when a material conflict cannot be resolved safely.

## Default authority roles

The order is role-based rather than a blanket "code wins" or "docs win" rule.

| Question | Primary authority | Evidence or secondary authority |
| --- | --- | --- |
| What should the product do? | Current user-approved product authority, applicable `operator-notes/`, and `docs/product/` | Active change record and external contract |
| Why is architecture shaped this way? | Active ADR | `docs/architecture.md`, code history |
| What does the system currently do? | Executed caller path, code, and configuration | Tests and runtime evidence |
| How is it operated now? | Verified procedures in `docs/operations.md` | Scripts, CI, deployment configuration, observed Azure state |
| Is a change proven? | Caller-backed evidence plus canonical checks and independent review | Static inspection |
| What happened during an earlier change? | Merged change record and linked PR | Commit history |

Each onboarded repository replaces generic labels with real paths and owners in `docs/index.md`.

## Materiality test

A contradiction is material when choosing a side could change any of:

- User-visible behavior or product scope.
- Data meaning, retention, migration, or deletion.
- Authentication, authorization, identity, secrets, or trust boundaries.
- Public APIs, events, schemas, or external contracts.
- Azure tenant, subscription, region, resource topology, permissions, cost, resilience, or deployment behavior.
- Required validation, recovery, compliance, or operational ownership.

Cosmetic wording, clearly stale generated lists, and claims disproved by a safe executable check are normally non-material, but their correction still goes in the onboarding or change record.

## Conflict workflow

```text
Two claims disagree
       |
       v
Classify their roles and status
       |
       +--> different roles? --------> preserve both with clear wording
       |       example: intended behavior vs current implementation
       |
       +--> one superseded? ---------> retain history, route to active source
       |
       +--> executable current fact? -> verify, then correct stale operational claim
       |
       `--> same role + material? ----> assign DOC-CON-NNN and ask user
                                             |
                                             v
                                      incorporate answer
                                             |
                                             v
                                      rescan all affected sources
```

## Conflict record

Store conflicts in the active onboarding or change record; do not create a permanent contradictions subsystem.

```markdown
### DOC-CON-001: <short title>

- Source A: `<path>` — <verbatim-safe summary>
- Source B: `<path>` — <verbatim-safe summary>
- Authority role: <product | architecture | operation | evidence>
- Material impact: <specific consequence>
- Decision needed: <one exact question>
- Status: open | answered | incorporated
- Resolution: <answer or pending>
- Rescan: <paths and result or pending>
```

An answer is not complete until it is incorporated and the affected sources are rescanned.

## Default resolution matrix

| Conflict | Treatment |
| --- | --- |
| Product authority versus code | Product remains intended truth; record implementation noncompliance or ask if the requirement may be obsolete |
| Active ADR versus code | ADR remains intended architecture until explicitly superseded; delivery must fix code or create a reviewed superseding ADR |
| Architecture document versus executable code | Code proves current implementation; correct the current-state document and record any product/ADR noncompliance separately |
| Operations command versus actual script/package entry point | Execute the safe check; update stale operations text to the working entry point |
| IaC versus live Azure state | Record drift; neither side automatically wins; determine whether to reconcile live state or code |
| Two same-level product or policy documents | Ask the named owner/user; do not select by modification date |
| Old plan versus current canonical document | Plan is historical unless explicitly active; route to canonical document and retain only useful history |

## Interview discipline

- Ask one material decision at a time.
- State both sources, impact, and recommended default.
- Do not ask about facts that repository or Azure inspection can determine.
- Continue independent work that cannot be affected by the answer.
- Set the change record to `blocked` only when the unresolved decision prevents all safe progress.
