# Path portability audit

Date: 2026-07-26

Status: decision incorporated into the active planning contract

## Question

Does the planned plugin or its development workflow embed filesystem paths that work only on the current workstation, and what path rules make the repository portable without weakening containment checks or the required Codex installation flow?

## Scope and method

The audit covered first-party repository instructions, active planning documents, planned package content, templates, examples, commands, and specified script output. It excluded:

- `ref-files/`, which is read-only historical extraction input and not package authority;
- `.obsidian/workspace.json`, which is editor state and must be preserved; and
- the three .NET/Microsoft Learn planning documents being audited independently.

The review searched for Windows drive-root and UNC literals, POSIX root-directory literals, user-profile expansions, file URIs, and prose that required absolute output. Every match was classified by where it would live and whether another machine would need to consume it.

```text
path-like value
     |
     +-- external URL or GitHub identity ----------> not a filesystem path
     |
     +-- quarantined evidence/negative fixture ----> retain, never package or copy
     |
     +-- runtime containment only -----------------> resolve in memory, do not emit
     |
     +-- Codex deeplink requires absolute value ---> resolve at response time only
     |
     +-- tracked command/template/output ----------> repository/skill-relative; fix
```

## Findings

Eighteen workstation-specific literals were present across four active planning files:

| Owner | Defect | Correction |
| --- | --- | --- |
| `delivery/implementation-sequence.md` | Plugin and skill creator scripts plus repository targets named one user's profile and checkout | Resolve creator roots from the Codex home contract; use `./plugins`, `./.agents`, and a relative skill root |
| `interfaces/plugin-manifest-and-marketplace.md` | Scaffold and validation examples required one checkout location | Run from the repository root, discover the creator script, and keep targets relative |
| `delivery/verification-and-acceptance.md` | Static validators named one user's installed system-skill paths | Discover both validator scripts from the Codex home contract and fail if unavailable |
| `delivery/github-and-installation.md` | Marketplace registration and the update loop named one checkout and profile | Register `.` and use discovered creator scripts plus repository-relative arguments |

One additional portability defect was implicit rather than literal: the repository validator specified an emitted absolute checked path, and the change generator did not constrain its output path to a relative form. Both output contracts now expose `.` or forward-slash repository-relative paths while retaining internally resolved roots for containment.

## Decision

### Repository and package paths

- Run repository development commands from the repository root.
- Store paths in tracked documentation, plugin content, assets, templates, fixtures, change records, mistake entries, and generated repository documents relative to the owning repository or skill root.
- Use `/` separators in serialized or generated path values. PowerShell command examples may use `./` or `.\` because the supported runtime is Windows PowerShell 7.
- Do not copy a resolved checkout, user-profile, skill-cache, temporary, or linked-worktree root into a tracked artifact.

### Installed creator skills

Creator commands resolve `plugin-creator` and `skill-creator` at runtime:

1. use `CODEX_HOME` when set;
2. otherwise use Codex's documented per-user `.codex` root;
3. when the active skill advertises another filesystem locator, use that discovered locator for the current session; and
4. fail clearly if the required script is absent rather than guessing another path or hand-building the scaffold.

This is environment discovery, not a compatibility implementation inside the plugin. The resolved location remains an in-memory command value.

### Internal absolute resolution

Deterministic scripts may resolve a caller-supplied root to an absolute path in memory to prove containment, reject traversal, and detect reparse-point escape. They must report or persist only the selected root as `.` and contained targets as repository-relative paths. A security check therefore remains exact without making its evidence machine-bound.

### Codex app handoff exception

The `plugin-creator` contract requires `View azure-workflow` and `Share azure-workflow` deeplinks to carry an absolute marketplace JSON path. This is the sole intentional output exception:

- resolve `.agents/plugins/marketplace.json` only when composing the final handoff;
- URL-encode it in the Codex deeplink;
- do not place it in a tracked document, template, fixture, log, change record, or generated repository file; and
- recompute it on every machine rather than reusing an earlier link.

The exception cannot break repository portability because it is an ephemeral link to that machine's installed local marketplace, not shared repository state.

## Intentional non-findings

- HTTPS documentation, package, and GitHub repository URLs are network identifiers, not filesystem paths.
- `../collisionspike_v2` in its named research audit is a repository-relative description of the evidence checkout and is not copied into the plugin.
- `ref-files/` contains three Windows drive-root literals: one negative path-validation test and two historical Azure CLI discovery candidates. They remain untouched because the folder is quarantined, read-only input and will be retired only through the extraction-proof phase.
- `.obsidian/workspace.json` was neither edited nor used as path authority.

## Prevention and acceptance

The canonical repository check must scan first-party development commands, package content, templates, and generated-document assets for drive-root, UNC, user-home, and other workstation-specific filesystem literals. Quarantined extraction inputs and explicit negative fixtures are the only allowlisted locations. Package mutation tests still prove that a workstation path added to installed plugin content fails validation.

This audit is accepted when:

- active first-party content outside the exclusions contains zero concrete workstation-specific filesystem paths;
- creator examples use runtime discovery and repository-relative targets;
- generated path fields are relative and use `/` when serialized;
- the runtime deeplink exception is never persisted;
- `git diff --check` passes; and
- `.obsidian/workspace.json` and `ref-files/` remain unchanged by the audit.
