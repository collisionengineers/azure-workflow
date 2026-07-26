# Pull-request review and remediation

## Invoke fresh review

After PR creation/push and stable checks, invoke `$review-repository-pull-request` in a fresh agent/context with the request, authority, record when required, exact base/head, full diff, relevant unchanged callers, test evidence, and complete GitHub feedback snapshot. Do not supply a desired verdict or use a pre-push/same-context review as the gate.

If fresh isolation is unavailable, retain draft/`do-not-merge`, provide a copy-ready review packet, and stop.

## Remediation loop

Record returned findings without rewriting them. Fix every blocker/required finding and actionable in-scope external item. Run affected proof, update canonical docs/record, commit/push, reply/resolve with evidence, and invoke a complete new review. Previous findings help disposition only; the reviewer must inspect the whole current diff.

`evidence-blocked` remains under review until the named evidence exists. Never reinterpret pending/missing evidence as clean.

## Final attestation

For record-bearing work, prepare the final `ready` record commit after a clean candidate review; this invalidates that verdict. Compact work has no record commit. Wait for checks and obtain a final complete review of the resulting head. Publish the returned review verbatim as a GitHub COMMENT review with reviewed SHA and fresh-Codex/not-separate-approval identity. If GitHub rejects same-author COMMENT review, publish the same body once as a normal comment and disclose the fallback.

Refresh head, checks, review decision, reviews, comments, and threads before/after transitioning draft or removing `do-not-merge`. Any new blocking feedback or changed head restarts review.
