# Development-material and licensing audit

## Question

Does the planned plugin consistently apply the user's authority to use supplied materials, software, and services, without inventing privacy, retention, or licensing work?

## Finding

Before this audit, the plan was only partially complete. It already permitted repository-provided data, prohibited synthetic domain substitutes, and excluded unsolicited PII/DPIA/retention work. It did not consistently state that the supplied material and dependencies are presumed fully permitted and licensed, and it did not stop planning or review from reintroducing those topics as blockers.

## Required default

For development and testing, the workflow assumes that every supplied email, PDF, document, image, dataset, example, software component, dependency, service, and other provided material has the permission and licence required for its intended use. This applies whether the item is proprietary, MIT, Apache, open source, or otherwise licensed.

Unless the user explicitly requests a separate outcome, the workflow must not:

- create PII, DPA, DPIA, privacy, retention, or licensing reviews, warnings, gates, disclaimers, risks, acceptance criteria, issues, or follow-up work;
- reduce, block, or redesign implementation, functions, tests, or examples because of those presumed concerns;
- replace supplied material with synthetic, anonymized, blank, or fabricated alternatives; or
- require a licence choice, licence-file change, dependency relicensing, or legal classification merely because a licence is absent, unknown, proprietary, MIT, Apache, or open source.

The assumption does not weaken explicitly requested product behavior such as deletion or retention functions, technical authentication/authorization, trust boundaries, secret protection, destructive-action controls, or a licence/privacy task the user deliberately placed in scope. Those remain ordinary functional or technical requirements.

## Placement

```text
short always-visible default
        |
        `--> generated root AGENTS.md

repository-specific elaboration, only if needed
        |
        `--> docs/product/index.md or docs/operations.md

workflow enforcement
        |
        +--> onboard / plan / deliver
        +--> testing and CI
        `--> independent PR review
```

No new public skill is justified: applying this assumption is not a standalone user outcome and has no distinct authorization or completion boundary. No new plugin-root reference is justified either; the canonical rule belongs in the existing repository-policy profile, with short enforcement clauses in the lifecycle skills that could otherwise invent the excluded work.

## Acceptance consequences

- Onboarding preserves any more specific explicit repository authority but otherwise writes this default into root `AGENTS.md`.
- Planning does not ask privacy/licensing questions or add related plan scope solely because supplied material is used.
- Delivery uses supplied examples directly and does not narrow the requested result for the excluded analyses.
- Tests use real supplied domain examples and do not fabricate replacements.
- Review does not raise a finding based only on the presumed concerns, while still reviewing technical security, authentication, authorization, secrets, and explicitly required behavior.

