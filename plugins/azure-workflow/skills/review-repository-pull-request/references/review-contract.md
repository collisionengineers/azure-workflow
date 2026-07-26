# Pull-request review contract

## Independence

Use a fresh context that did not author the implementation. The reviewer is read-only and does not receive a desired verdict. A same-account Codex review is evidence, not separate-account/human approval.

## Authority and completeness

Apply current user request, declared product/controlled requirements, ADR/design/architecture/operations authority, then current code/config/tests/CI/live evidence for current behavior. Review the whole exact diff plus relevant unchanged callers and policy owners. A changed file list alone is insufficient.

## Findings

- `blocker`: unsafe/destructive, authorization/scope violation, data/contract break, or result cannot meet the request.
- `required`: observable correctness, maintainability, test, documentation, UX, operation, or review-state defect that must be fixed.
- `advisory`: useful improvement that does not block the stated endpoint.

Each finding has ID, path/line or GitHub evidence, observable impact, testable outcome, and exact recheck. Avoid style preference without repo authority or impact.

## Complete-change checklist

Check request/issue/record/PR consistency; behavior and callers; negative/failure/recovery; security/permissions in actual scope; data/schema/migration; configuration/rule owner; dependency/public/package contracts; generated sources; UI/design/accessibility; Azure/IaC; tests/CI; canonical documentation; names; mode/version; scope; overengineering; supplied-material assumptions; and existing feedback.

Structural checks cannot prove semantic documentation truth. Do not invent privacy/licensing findings under the repository's full-permission assumption. Query current Microsoft evidence only when decisive.

## Verdict and invalidation

`clean`, `changes-required`, or `evidence-blocked`; bind it to exact head and fingerprint. Any tracked change invalidates it. A re-review checks earlier disposition and the complete new diff. Return one verdict-derived next action.

Do not create mistake incidents for ordinary defects caught by the intended review. If the reviewer itself qualifies, return a copy-ready pending entry without mutation.
