# Repository modes

## Modes

Version `0.1.0-alpha.1` defines exactly two repository modes. These are implementation-support modes, not maturity stages:

- `development`: pre-release; no supported legacy contract exists unless explicitly named.
- `released`: at least one supported external, persisted, user, or operational contract exists.

The mode is declared in root `AGENTS.md` and `docs/product/index.md`. Do not infer it solely from semantic version numbers, maturity-stage labels, branch names, Azure environment names, or the existence of deployed resources.

## Mode resolution

```text
Read AGENTS.md + docs/product/index.md + operator-notes/
                  |
                  v
same declared mode? ---- yes ----> use it
        |
        no/missing
        v
Can explicit release/support evidence resolve it?
        | yes -> propose value and record evidence
        | no  -> ask user; block mode-sensitive design
```

## Development mode

Goal: keep the design clean while the product is still free to change.

Required behavior:

- Remove replaced code, configuration, tests, documentation, and routes in the same change.
- Do not add legacy code paths, compatibility adapters, dual reads/writes, deprecated aliases, old-schema support, fallback implementations, or feature flags whose only purpose is preserving unreleased behavior.
- Prefer a clear failure over a silent fallback.
- Breaking internal contracts is allowed when all callers are updated together.
- Schema or data reset is allowed only when repository authority confirms the affected development data is disposable; do not infer disposability from the mode alone.
- Keep one current path and one owner for each behavior.
- Tests assert current intended behavior, not removed legacy behavior.

Forbidden development-mode patterns:

```text
if new_path_fails -> silently call old_path
read new_schema OR old_schema forever
write both old and new stores "for now"
LegacyService / NewService pairs without an external contract
unused interfaces/services/queues/tables for a future feature
feature flags with no release/rollback need
```

## Released mode

Goal: evolve supported behavior without surprising existing users, callers, data, or operators.

Required behavior:

- Identify the exact supported contract before preserving compatibility.
- Use explicit, documented migrations for persisted or public contract changes.
- Time-bound deprecations, replay registrations, and compatibility adapters with the named supported contract, owner, activation scope, observability, removal condition, and target removal version or date.
- Use fallbacks only for a documented reliability/recovery requirement; make activation observable and test both primary and fallback behavior.
- Preserve recovery and rollback or state why forward recovery is the safe path.
- Remove dead internal code that is not part of a supported contract.

Released mode does not justify blanket legacy support. Compatibility exists only for a named contract and duration.

A bridge retained for in-flight workflow replay, persisted data, an external caller, or rollback is still executable production code. Its registration and source location must make that role obvious; “dead but retained,” “legacy parity,” or historical ticket prose without the lifecycle fields above is a finding.

## Future-feature factoring

Future features influence current design through documented seams, not speculative implementation.

```text
Known future feature
       |
       v
Does it impose a concrete current invariant or likely irreversible choice?
       | no  -> record as follow-up; build nothing
       |
       yes
       v
Can a small current boundary avoid a demonstrated rewrite?
       | no  -> document migration path; build current need simply
       |
       yes
       v
add the smallest exercised seam + test current behavior
```

Allowed examples:

- Put current policy behind an existing service boundary because a second caller is already planned and the boundary is exercised now.
- Choose an extensible schema discriminator when today's record already needs one.
- Record a future event consumer in an ADR while publishing only the event required today.

Forbidden examples:

- Empty services, projects, controllers, queues, database tables, feature flags, or interfaces with no current caller.
- Generic plugin systems for one concrete implementation.
- Configuration switches for hypothetical products.
- Abstract factories, repositories, or adapters introduced only because they might be useful later.

## Mode transition

`development` to `released` is a deliberate repository change requiring:

1. Explicit user approval.
2. A change record and active ADR.
3. Declared supported contracts and compatibility scope.
4. Canonical verification, deployment, monitoring, and recovery documented.
5. Clean independent review and green CI.

After transition, the repository does not switch back to `development` merely to make a breaking change easier. New unreleased functionality within a released repository can remain internally changeable, but existing supported contracts follow released-mode rules.

## Invariants unaffected by mode

Both modes require:

- Clean, purpose-revealing names.
- Proportional tests and caller-backed proof.
- Current documentation.
- Fresh independent review.
- Explicit Azure mutation approval.
- No speculative architecture.
- No synthetic repository-content fixtures when repository examples are required.
