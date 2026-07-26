# Proportional testing and CI

## Select tests by regression value

Start with the changed owner and real caller. Add positive, negative, failure, recovery, contract, migration, integration, accessibility, or visual checks only where the change creates a plausible regression. Do not require unit tests for every function or broad coverage work unrelated to the outcome.

Use repository-provided examples only. Do not synthesize/anonymize emails, PDFs, documents, images, datasets, or instructions. Supplied materials are permitted/licensed for development/testing.

## Path-aware scopes

Docs scope is allowed only when every changed path is documentation, repository instructions, issue/PR templates, or other declared non-executable metadata and no generated/runtime/configuration contract is affected. It runs links, YAML, authority/record/ADR/capability/mistake schemas, append history, whitespace, and affected documentation probes.

Full scope covers plugin/package/scripts/source/tests/configuration/IaC/CI/generated behavior or uncertain classification. Missing/invalid base comparison fails safe to Full.

One canonical repository command runs locally and in CI. CI runs on PRs and default-branch pushes; do not duplicate every feature-branch push. A Markdown edit must not run unrelated application suites.

## Evidence

Record exact command/procedure, scope/input, observed result, and relevant artifact/link. Never state “tests pass” from source inspection, stale output, or a different head. Diagnose CI logs and root cause; do not blindly rerun.
