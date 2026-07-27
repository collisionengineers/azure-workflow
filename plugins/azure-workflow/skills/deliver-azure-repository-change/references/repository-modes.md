# Repository modes

Every onboarded repository declares one mode in `AGENTS.md` and `docs/product/index.md`.

## Development

Use before an explicit stable supported release. Breaking internal/product changes are allowed within the approved scope. When behavior is replaced, remove old code, configuration, tests, docs, routes, aliases, and fallback branches together. Do not add legacy compatibility, dual reads/writes, migration shims, silent fallback, or unused extension layers for unreleased behavior.

## Released

Use only after release authority declares supported contracts. Preserve compatibility only for named active contracts. Every bridge/shim/replay/dual path must record:

- contract and consumers;
- owner and activation scope;
- observability and regression proof;
- removal trigger;
- target removal version/date.

Schema/data migration and fallback behavior require explicit planning, rollout, recovery, and review.

## Transition

Version/maturity strings alone do not change mode. A human/release authority decision updates product docs, supported contracts, version, roadmap/release evidence, and operations in one change.
