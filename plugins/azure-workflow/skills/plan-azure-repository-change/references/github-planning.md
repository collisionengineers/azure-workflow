# GitHub planning

## Issue requirement

| Work | Rule |
| --- | --- |
| low-risk durable plan | issue optional; record/plan PR is sufficient unless requested/policy-required |
| standard/high-risk plan | create/reuse issue when GitHub available; local plan may be complete without it but cannot claim Project Ready/delivery readiness |
| backlog idea | create Feature only when promoted to actionable Triage |
| blocking material decision | Decision issue when it persists beyond this change/conversation |

Use exactly one owner-aware kind and only registered orthogonal facets. Do not create an issue per capability or speculative Later child issues.

## Planning state

```text
Triage/Ready -> planning starts: In progress
             -> plan PR: In review
             -> reviewed decision-complete plan: Ready
```

If the plan PR is still open when implementation begins, delivery resumes its branch/PR and returns it to the under-review marker. If merged, delivery branches from updated default.

## Plan PR

Contains only the record and already-settled canonical planning documents. Use `Refs #N`, not a closing keyword. The issue links to the plan; do not paste the full plan into it. Use native draft when available or normal PR plus `do-not-merge`; read the state back.

After Docs CI, fresh exact-head review, remediation, and final readback, transition the PR to ready/remove the fallback label and set the linked item Ready. Never merge or close the implementation issue during planning.

## Capability limitations

Projects, forms, views, workflows, and charts must be capability-probed. Do not claim saved-view/chart/automation state from an API that cannot read it. Planning may name the exact human setup step; it may not drive a browser silently or invent success.
