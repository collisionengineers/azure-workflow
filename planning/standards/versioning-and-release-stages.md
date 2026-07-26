# Versioning, maturity stages, and roadmap horizons

## Decision

The workflow uses four separate concepts. They must never be collapsed into one `V1/V2` column or one ambiguous `status` field.

| Concept | Answers | Canonical owner |
| --- | --- | --- |
| Semantic version | Which immutable software release is this, and what compatibility change does it represent? | Manifest/package metadata, Git tag, GitHub release |
| Maturity stage | Who may rely on it and which evidence gate has passed? | `docs/product/index.md` and release decision |
| Roadmap horizon | When are we considering the outcome? | `docs/roadmap.md` |
| Work state | What is happening to an actionable item now? | GitHub issue and Project |

Example:

```text
Capability:       <capability-id> <concise outcome>
Target release:   0.4.0-beta.1
Maturity stage:   beta
Roadmap horizon:  Next
Work state:       no issue yet
```

This is valid. A feature can have a release allocation without pretending that implementation work has started.

## Semantic Versioning default

The default scheme is [Semantic Versioning 2.0.0](https://semver.org/):

```text
MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]
```

- `MAJOR`: an incompatible change to a declared supported contract.
- `MINOR`: backward-compatible functionality or a supported-contract deprecation.
- `PATCH`: a backward-compatible correction.
- `PRERELEASE`: an unstable release before the corresponding normal version, such as `alpha.1`, `beta.2`, or `rc.1`.
- `BUILD`: non-precedence build metadata. Plugin development cachebusters use this position.

SemVer requires a declared public API. For an internal application, the workflow defines the public API broadly as the supported contract on which another party relies:

- operator-visible behavior and terminology;
- external HTTP, event, file, email, MCP, or integration contracts;
- persisted data and migration promises;
- deployment/configuration interfaces promised to operators; and
- supported extension points.

Internal refactoring that does not change a supported contract does not require a major version.

SemVer says `0.y.z` is initial development and that its API is not stable; `1.0.0` declares the supported public API. It permits prerelease labels but does not define organizational entry/exit gates for alpha, beta, or release candidate. This standard defines those gates below.

## Exact maturity stages

| Stage | Meaning | Entry gate | Allowed change | Exit gate |
| --- | --- | --- | --- | --- |
| `prototype` | Disposable learning artifact; not a supported release | Explicit experiment scope and disposal boundary | Anything within the experiment | Learning recorded; artifact removed, retained as reference, or promoted deliberately |
| `alpha` | Internal end-to-end development with real representative inputs | Critical workflow slice has a real caller; known limitations and active decisions are explicit | Breaking changes are expected; no compatibility/fallback promise | Intended beta scope, architecture owner, data model, failure behavior, and test strategy are settled enough for broader evaluation |
| `beta` | Intended release shape is substantially present and usable by named evaluators | Major user journeys work through real callers; representative data, permissions, failure states, recovery, UI/accessibility, and operational evidence exist | Breaking changes remain possible but must be explicit and recorded | Release scope is frozen; no unresolved blocker to production proof; known limitations are accepted |
| `release-candidate` | Candidate for the exact stable release | Scope freeze; production-like deployment, migration, backup/restore, monitoring, security, rollback, and acceptance procedures have passed or have named final gates | Release blockers only; new features return to a later release | No known release blocker and explicit release authority approves GA |
| `stable` | Supported normal use, also called GA | Supported contracts declared; release and recovery evidence accepted; operator/user authority approves | SemVer compatibility rules apply | Superseded by a later stable release or formally retired |
| `maintenance` | Stable line receives corrections but no planned feature growth | Replacement path and support boundary declared | Patch/security/required compatibility work | Retirement criteria and migration complete |
| `retired` | No longer supported or operated | Consumers, data, resources, and recovery evidence disposed or transferred deliberately | No new behavior | Terminal |

The canonical prerelease spelling is `alpha`, `beta`, and `rc`. The common alpha -> beta -> release-candidate -> final order is also standardized by packaging schemes such as [PEP 440](https://peps.python.org/pep-0440/#pre-releases), but the evidence gates above are repository policy rather than SemVer syntax.

## Default version progression

For a new product or plugin:

```text
0.1.0-alpha.1
       |
       +-- fixes/new alpha slices --> 0.1.0-alpha.2
       |
       +-- next compatible alpha scope --> 0.2.0-alpha.1
       |
       v
0.x.0-beta.1
       |
       v
1.0.0-rc.1
       |
       v
1.0.0
       |
       +-- compatible feature --> 1.1.0
       +-- compatible fix -----> 1.0.1
       `-- breaking contract --> 2.0.0
```

The exact numeric step is selected from the contract change, not from elapsed time or issue count.

## Plugin release gates

`azure-workflow` begins at `0.1.0-alpha.1`.

| Plugin stage | Required evidence |
| --- | --- |
| Alpha | Package validates; all six skills trigger correctly in fresh threads; fixtures prove documentation and stop boundaries; actual-PR review and GitHub workflow can be exercised in a disposable repository |
| Beta | At least two materially different existing Azure repositories have been onboarded; plan -> deliver -> independent review has completed end to end; explanation has been exercised on both code/system and PR-feedback cases; feature-catalog conversion has been exercised on one large catalog; Azure MCP read-only inventory and approval-stop tests pass |
| Release candidate | Upgrade/uninstall/reinstall paths pass; no unresolved required finding; GitHub issue/Project setup, UI/UX route, path-aware CI, and Azure apply gate all pass against representative environments |
| `1.0.0` stable | Explicit user acceptance; documented supported plugin contract; recovery from an interrupted change has been demonstrated; no known release blocker |

Local Codex reloads append only build metadata:

```text
0.1.0-alpha.1+codex.<cachebuster>
```

Build metadata never substitutes for a released version change.

## Repository mode relationship

Maturity and repository mode are related but not inferred silently:

```text
prototype / alpha / beta / rc
              |
              `--> normally mode: development

explicit stable-release decision
              |
              `--> mode changes to released and version becomes 1.0.0 or later
```

The user or declared release authority must approve the mode transition. A version string alone does not activate legacy support, migrations, retention, or fallbacks. See [repository modes](repository-modes.md).

## Roadmap horizons

The only horizons are:

| Horizon | Meaning | Required detail |
| --- | --- | --- |
| `Now` | Selected outcome for the current active release | Named outcome, target release/milestone, release gate, parent issue when activated |
| `Next` | Likely next outcome after named dependencies | Problem/outcome, dependency, activation condition; detailed implementation plan is optional and usually absent |
| `Later` | Worth retaining but not committed | Problem, reason to retain, and condition that would promote it |
| `Not planned` | Explicit product boundary, not backlog | Boundary and authority; no open implementation issue |

`docs/roadmap.md` is outcome-level. It does not contain implementation checklists, assignees, live status, or hundreds of feature rows.

## Release allocation rules

- Use the full release identifier when a release exists: `0.4.0-beta.1`, not `V2`.
- Use `unallocated` when no release decision exists. Do not invent a distant version merely to sort a list.
- A specific target release belongs in one GitHub milestone.
- `Now`, `Next`, and `Later` do not imply issue state.
- `Not planned` items are closed or absent from GitHub Issues and retained as product boundaries.
- A release allocation is revised in the capability index/roadmap and issue milestone together in the same planning change.
- Never rewrite historical tags or published release contents. SemVer explicitly treats a released version as immutable.

## Release planning example

```text
docs/product/capabilities.md
  <capability-id> -> target 0.4.0-beta.1 -> canonical product section

docs/roadmap.md
  Next -> "Resolve post-report queries" -> gate: stable case lifecycle

GitHub milestone
  0.4.0-beta.1
      |
      `-- parent Feature issue created only when activated
              |
              `-- sub-issues created just in time
```

## Alternative schemes

CalVer or another scheme is permitted only when the repository records why SemVer does not communicate its release contract. The scheme, ordering, compatibility meaning, prerelease syntax, and stable-release rule must be written in `docs/product/index.md` before use.

Do not mix SemVer and CalVer in one release line. Do not use branch names, Azure environment names, or roadmap labels as version identifiers.

## Acceptance checks

1. `docs/product/index.md` declares versioning scheme, current version, maturity stage, repository mode, supported contracts, and release authority.
2. `docs/roadmap.md` uses only the four horizons and names exact releases where allocated.
3. Capability rows contain an exact target release or `unallocated`; vague `V1/V2/V3+` values fail validation after migration.
4. Git tags, manifest/package versions, milestone names, and release records agree.
5. No open issue represents a `Not planned` boundary.
6. No prerelease is presented as stable or as satisfying stable compatibility promises.
