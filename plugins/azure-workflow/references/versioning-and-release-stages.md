# Versioning, maturity, horizons, and work state

Keep four concepts separate:

| Concept | Question | Owner |
| --- | --- | --- |
| Version | Which immutable release/contract change? | package/manifest, tag, GitHub release |
| Maturity | Who may rely on it and which evidence gate passed? | `docs/product/index.md` and release decision |
| Horizon | When is the outcome considered? | `docs/roadmap.md` |
| Work state | What is happening now? | GitHub issue and Project |

## Version scheme

Default to Semantic Versioning `MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`:

- major: incompatible declared supported-contract change;
- minor: compatible functionality or supported deprecation;
- patch: compatible correction;
- prerelease: `alpha.N`, `beta.N`, or `rc.N` before the normal version;
- build: non-precedence build/cache metadata.

Define supported contracts broadly: user/operator behavior and terminology, external APIs/events/files/emails/integrations, persisted data/migration promises, promised deployment/configuration interfaces, and supported extension points. `1.0.0` requires an explicit supported-contract decision. Use another scheme only after documenting its ordering and compatibility meaning; never mix schemes in one release line.

## Maturity stages

| Stage | Meaning and gate |
| --- | --- |
| `prototype` | disposable experiment with scope/disposal boundary; learning determines removal, reference retention, or promotion |
| `alpha` | internal end-to-end development; real caller exists; limitations/decisions explicit; breaking changes expected without fallback promises |
| `beta` | intended shape substantially works for named evaluators with representative inputs, permissions, failures, recovery, UI/accessibility, and operations evidence |
| `release-candidate` | exact stable scope frozen; production-like deployment, migration, recovery, monitoring, security, rollback, and acceptance gates passed or named |
| `stable` | explicit authority accepts declared supported contracts and recovery evidence; SemVer compatibility applies |
| `maintenance` | stable line receives corrections only; replacement/support boundary declared |
| `retired` | consumers/data/resources/recovery responsibilities disposed or transferred |

Maturity labels do not prove their own gates. Prototype/alpha/beta/RC normally use repository mode `development`; only an explicit stable-release decision switches mode to `released`.

## Roadmap horizons and allocation

- `Now`: selected current-release outcome with target release/gate; issue only when activated.
- `Next`: likely next outcome with dependencies and activation condition.
- `Later`: retained problem/outcome with promotion condition; normally no detailed plan or issue.
- `Not planned`: explicit product boundary; no open implementation issue.

Allocate exact releases such as `0.4.0-beta.1`, or `unallocated`. Never use ambiguous `V1/V2/V3+`. One exact release maps to one milestone. Do not confuse release allocation with active work.

## Release checks

Before release, require agreement between product version/maturity/mode/support declarations, package/manifest, tags/releases, milestone, roadmap/capability allocations, and evidence gate. Never rewrite an already published version.
