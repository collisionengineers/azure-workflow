# Git and pull-request discipline

## Preflight

Resolve Git root, remote/default branch, current branch, linked worktrees, current-branch PR, and exact staged/unstaged/untracked paths. Stop on unrelated changes. Never stash, reset, clean, switch branches, or create a worktree to hide the conflict.

Fetch the remote default branch without merging unrelated work. Create/resume only the named `workflow/YYYYMMDD-<slug>` identity. Preserve user changes and stage literal owned paths, never broad `git add .`.

## Commits and PR

Run focused/canonical checks and `git diff --check`, inspect staged diff, then create coherent narrow commits. Push without force. Use native draft if supported; otherwise use a normal PR plus `do-not-merge` and Project `In review` when applicable. Read state back.

PR body states outcome, scope, record or compact-lane reason, documentation impact, tests, review status, and issue relationship. Use `Closes #N` only when merge fully completes that bounded issue; use `Refs #N` otherwise.

Do not merge, auto-merge, delete the branch, close the issue, or mark Done. Final output is a green exact-head-reviewed open PR.

## Exact head

Any tracked change invalidates prior CI/review. The final reviewer/checks/comment/readback must all name the same 40-character head SHA. Make no tracked edit after the final clean attestation.
