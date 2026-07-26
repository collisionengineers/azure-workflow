# GitHub delivery

## Identity and state

Standard/high-risk delivery requires one exact issue with exactly one owner-aware kind and registered facets, explicit Project membership when Projects are used, a change record, branch, and PR. Compact delivery needs only branch/PR unless policy/request says otherwise.

Transitions:

```text
Ready -> In progress -> In review -> human merge/accepted outcome -> Done
                    ^      |
                    `------+ changes requested/remediation
```

Delivery stops at In review. Merge/closure automation or a human performs Done.

## Feedback mutations

Collect submitted reviews, general comments, inline comments, and all GraphQL review threads/replies with resolved/outdated state. Deduplicate by GitHub ID. Before replying/resolving, verify viewer capability and current thread identity.

- actionable in-scope: fix, prove, reply with path/commit/check evidence, read back, then resolve;
- already addressed: reply with current evidence; resolve only when unambiguous;
- clarification/contradiction: ask and leave open;
- scope expansion: propose separate issue/decision;
- incorrect: retain correct behavior and answer with evidence;
- non-actionable: no reply required.

Resolution does not clear a distinct reviewer's `CHANGES_REQUESTED`; re-request that reviewer after the remediation commit. Never dismiss a review or impersonate approval.

## Personal-account capability

Use `type:*` labels rather than organization-only issue types. Project view/chart/workflow enhancements may require a human setup card. Do not persist live Project IDs in repository state or claim unreadable UI settings.
