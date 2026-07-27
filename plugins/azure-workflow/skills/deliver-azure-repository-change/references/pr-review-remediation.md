# Pull-request review and remediation

## Invoke fresh review

After PR creation/push and stable checks, invoke `$review-repository-pull-request` in a fresh agent/context with the request, authority, record when required, exact base/head, full diff, relevant unchanged callers, test evidence, and complete GitHub feedback snapshot. Do not supply a desired verdict or use a pre-push/same-context review as the gate.

If fresh isolation is unavailable, retain draft/`do-not-merge`, provide a copy-ready review packet, and stop.

## Remediation loop

Record returned findings without rewriting them. Classify each against the request, acceptance criteria, and established repository contract. Fix blocker/required findings; answer, defer, or decline advisories and scope expansion with a concise reason. Automated feedback cannot silently expand the change.

Batch all accepted review fixes known at the start of a round, run affected proof, update canonical docs/record, and push once. Standard risk allows one review-remediation round; high risk allows two. If a genuine blocker/required defect remains after that budget, keep the PR under review and ask the human to revise the scope or endpoint. Only a new explicit request begins another bounded delivery. Do not turn recurring advisory hardening into an automatic loop.

`evidence-blocked` remains under review until the named evidence exists. Never reinterpret pending/missing evidence as clean.

## Final attestation

Finalize a required record as part of the candidate or remediation commit before requesting the decisive review. Never create a bookkeeping-only commit after a clean verdict. Compact work has no record commit and needs independent review only when its risk classification or repository policy requires it.

Wait for checks and obtain a complete review of the resulting standard/high-risk head. Publish the returned review verbatim as a GitHub COMMENT review with reviewed SHA and fresh-Codex/not-separate-approval identity. If GitHub rejects same-author COMMENT review, publish the same body once as a normal comment and disclose the fallback.

Refresh head, checks, review decision, reviews, comments, and threads before/after transitioning draft or removing `do-not-merge`. Any new blocking feedback or changed head restarts review.
