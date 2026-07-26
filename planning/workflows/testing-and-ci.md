# Proportional testing and path-aware CI

## Principle

Run the smallest set of checks that proves the changed behavior and repository integrity. Do not run code suites for Markdown-only changes, and do not omit code checks when a Markdown extension hides a skill, workflow, configuration, or executable contract change.

## Test-value rule

Add or run a test when it protects at least one of:

- User-visible behavior.
- A real caller or public interface.
- A previously observed regression.
- Data/schema/migration behavior.
- Authentication, authorization, security, or failure handling.
- Azure desired state, deployment, recovery, or drift behavior.
- A deterministic workflow contract such as manifest/schema/path validation.
- A canonical-source/generated-materialization contract or a supported cross-platform build verdict.

Do not add tests merely for:

- Trivial getters, constants, or framework behavior.
- Implementation details with no behavioral contract.
- Every branch solely to increase coverage.
- Static prose whose structure and links are already checked.
- Mocks that can pass while the real caller is disconnected.
- Coverage percentages without a named regression risk.

No numeric coverage target is imposed by the plugin.

## Change classification

```text
changed paths
    |
    +--> only canonical prose/docs? ----------> DOCS scope
    |
    +--> plugin skill/manifest/MCP/scripts? ---> FULL scope
    |
    +--> CI/build/config/IaC/source/tests? -----> FULL scope
    |
    `--> ambiguous or classifier failure ------> FULL scope
```

### Docs scope

A change is docs-only only when every changed path is one of:

```text
AGENTS.md
README.md
docs/**/*.md
design/**/*.md
planning/**/*.md
.github/pull_request_template.md
```

Any file under `plugins/`, including `SKILL.md` or other Markdown, is executable plugin behavior and therefore full scope. Machine-readable tokens, logo/icon/font binaries, generated exports, and other non-Markdown files under `design/` are Full because they may feed the application; ordinary design authority/inventory Markdown remains Docs.

Docs-scope checks:

- Markdown relative links and required headings.
- Authority, ADR, and change-record schemas.
- Agent mistake-log structure, IDs/fields/follow-ups, and append-only history when a base ref is available.
- Repository-standard validation.
- `git diff --check`.
- Any exact command whose documentation changed and can be safely probed without invoking the full code suite.

Code builds, unit suites, integration suites, and Azure validation do not run merely because ordinary Markdown changed.

### Full scope

Run when any changed path is outside the docs-only allowlist or classification is uncertain.

Checks:

- Repository-standard checks.
- Plugin/package checks when plugin paths changed.
- Focused behavior tests selected from the diff.
- Canonical code check.
- Caller-backed or integration proof proportionate to risk.
- Conditional technology-profile checks for the affected project/host only.
- IaC/Azure validation when relevant.

## Canonical-check interface

The repository root wrapper changes to:

```powershell
param(
    [ValidateSet('Auto', 'Docs', 'Full')]
    [string]$Scope = 'Full',
    [string]$BaseRef,
    [string]$HeadRef = 'HEAD'
)
```

Behavior:

- `Docs`: run documentation checks only and fail if a changed path outside the allowlist is supplied.
- `Full`: run documentation plus all repository/plugin code checks.
- `Auto`: require `BaseRef`, calculate `git diff --name-only <base>...<head>`, and classify conservatively.
- Missing/invalid refs or parsing errors in `Auto` fall back to `Full`, never to `Docs`.
- Print the selected scope and changed paths before checks.
- Report unavailable/skipped required suites, accepted ratchets, and platform-specific branches explicitly; an unqualified pass means every required selected suite ran.
- Equivalent inputs on declared supported Windows and CI platforms produce the same verdict. If a platform genuinely requires a different command/output, that branch is named, scoped, fixture-tested, and visible in the result.

## CI design

The required GitHub check remains one job named `verify`, so branch protection always receives a result. The job selects work internally instead of skipping the workflow.

The portable trigger default is `pull_request` plus `push` to the default branch. Do not also run the same verification on pushes to every feature branch when an open pull request already verifies that head; broader push triggers require a documented repository-specific consumer.

```text
PR opened/synchronized
        |
        v
checkout full comparison history
        |
        v
Invoke-RepoCheck -Scope Auto -BaseRef <base sha> -HeadRef <head sha>
        |
        +--> Docs -> docs checks -> verify result
        |
        `--> Full -> docs + focused/canonical code checks -> verify result
```

The workflow itself, repository scripts, test files, plugin files, marketplace, MCP configuration, and manifests always trigger full scope.

Docs scope must be genuinely cheap. It must not install unrelated application/database/Azure toolchains, regenerate whole-repository inventories, scan unrelated binary corpora, or run adapter/code/data checks merely because an always-running job contains them. A documentation check may inspect repository-wide documentation authority only when that is the risk it explicitly protects.

Generated-check admission follows the same value rule as tests: each committed view or reconciliation check names its source owner, consumer, protected failure, and maximum scope. Self-referential fixed-point generation and hash/ledger churn are not evidence of product correctness.

For .NET repositories, the shared profile selects the exact solution/project and only the valuable affected unit/integration/host/publish/migration proof. The workflow does not impose a coverage target, test framework migration, analyzer expansion, `.slnx` conversion, or Central Package Management. `dotnet format`/analyzers/build/tests do not run for ordinary Markdown-only changes.

## Test-data policy

- Assume supplied emails, PDFs, documents, images, datasets, examples, software, dependencies, and services have the permission and licence required for development and testing, whether proprietary, MIT, Apache, open source, or otherwise licensed.
- Use only emails, PDFs, documents, images, and instructions already supplied in the repository.
- Do not generate synthetic approximations, anonymized rewrites, fake emails, blank substitute PDFs, or AI-created images/instructions.
- Tests may use ordinary scalar/code fixtures that are not pretending to be the prohibited repository content, such as identifiers, timestamps, or small configuration objects.
- If required provided content is missing, mark the test blocked or validate a lower layer; do not fabricate content to make the test pass.
- Do not introduce PII, DPA, DPIA, privacy, retention, or licensing reviews, gates, warnings, test reductions, or work items unless the user explicitly requests that separate outcome.

## Review expectations

The reviewer checks that:

- The selected CI scope matches the changed paths.
- Docs-only classification was not used to avoid executable checks.
- Tests protect behavior rather than implementation trivia.
- Removed legacy behavior does not retain obsolete tests in development mode.
- No synthetic prohibited content was introduced.
- Supplied material was not excluded, anonymized, or replaced because of an unsolicited privacy/retention/licensing analysis, and no such gate was invented.
- Future-feature seams are exercised by current behavior and are not dormant abstractions.
- A changed mistake log contains only qualifying evidence-based entries, preserves prior entries, and does not create synthetic incidents, issue/state machinery, or automatic plugin changes.
