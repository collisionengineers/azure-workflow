# Documentation maintenance

## Impact declaration

Before implementation, map each changed fact to its owner:

| Changed fact | Canonical owner |
| --- | --- |
| purpose, users, behavior, requirements, limitations | product index/area |
| capability existence/allocation | capabilities index |
| outcome horizon/release intent | roadmap |
| component/data/integration/rule/configuration ownership | architecture |
| UI brand/foundations/assets/components/patterns | design |
| build/deploy/monitor/recover/support | operations |
| hard-to-reverse decision | ADR |
| this change's plan/evidence/deviation | existing change record |
| qualifying agent mistake | append-only mistake log and record link |

Name affected paths/sections or give a specific reason none change. Any semantic documentation impact promotes compact delivery.

## Same-PR rule

Update every affected owner in the implementation PR. Do not leave intended behavior only in the record or open routine “update docs later” work. Keep links, source/generated declarations, capability allocation, issue/milestone, design/runtime map, and operations commands synchronized.

## Drift proof

Validators prove machine-checkable structure, links, IDs, schemas, path/casing, generated-view consistency, and append history. They do not prove statements are true. Fresh exact-head review compares canonical claims with implementation/configuration/callers. A semantic disagreement is required work.

## Mistake admission

Log only agent-caused violations of available authority, false completion/evidence, scope/authorization crossings, defects that escaped a required gate, or reusable workflow gaps. Recover first, append without changing earlier incident bodies/order, and link the ID. Do not log expected red tests, ordinary review findings, user decisions, or external failures.
