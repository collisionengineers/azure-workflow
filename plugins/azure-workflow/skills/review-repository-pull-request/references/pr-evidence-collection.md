# Pull-request evidence collection

## Prerequisites

Require authenticated `gh`, exact `OWNER/REPO`, and PR number. Resolve from the selected Git root; never choose newest. Capture local dirty paths separately and never checkout/switch/stash/reset/clean.

## Stable snapshot

Use plugin-root `scripts/Get-AzureWorkflowPullRequestEvidence.ps1 -RepositoryPath . -PullRequest N -Json`. It must collect start metadata, exhaust every connection/page, compute a deterministic fingerprint, then repeat head/update/check/feedback markers. Reject changed head or fingerprint.

Required evidence:

- PR URL/state/draft/author/review decision/base/head/update time;
- files and commits;
- all check runs/status contexts with identity/state/link/completion;
- requested reviewers and submitted reviews;
- all issue/general and inline review comments;
- GraphQL `reviewThreads`, resolved/outdated state, location, viewer capabilities, resolver, and every nested reply;
- pagination completion and local existence of base/head commit objects.

Normalize/deduplicate only by stable GitHub node/REST ID; never merge distinct comments. Hash base/head, check/review/request identities/states, comment update/body hashes, and thread/reply identity/state in stable order. Never output credentials or unavailable deleted bodies.

## Complete diff

With both objects local, inspect:

```powershell
git diff --stat <baseOid>...<headOid>
git diff --check <baseOid>...<headOid>
git diff <baseOid>...<headOid> --
```

Fetching exact refs without checkout is allowed when needed. Missing objects or incomplete pagination block claims that require them.

## Failure

Authentication, rate limit, GraphQL/REST partial page, pending decisive checks, or evidence changing twice produces `evidence-blocked` with the exact limit. Do not fall back to `gh pr view --comments` as if complete.
