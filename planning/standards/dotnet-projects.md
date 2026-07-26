# .NET project profile

## Status and ownership

This is a conditional technology standard for repositories containing .NET projects. It supplements the normal onboarding, planning, delivery, explanation, review, mode, documentation, and testing contracts; it does not replace them.

Packaged owner: `plugins/azure-workflow/references/dotnet-projects.md`.

Direct consumers:

- `$onboard-azure-repository` when any .NET project or solution is detected;
- `$plan-azure-repository-change` when the requested outcome affects .NET source, project/build/package configuration, tests, persistence, hosting, or deployment;
- `$deliver-azure-repository-change` for the same implementation scope;
- `$explain-repository` when .NET project, host, configuration, dependency-injection, persistence, test, or tooling mechanics materially affect the requested explanation; and
- `$review-repository-pull-request` when the PR contains or behaviorally affects those paths.

`$operate-azure-repository` does not load this profile merely because an Azure resource runs .NET. It reads it only through an owning delivery/review handoff when repository code or publish behavior is in scope.

## Activation

Activate the profile when inventory finds one or more of:

```text
*.csproj  *.fsproj  *.vbproj  *.sln  *.slnx  *.slnf
global.json  Directory.Build.*  Directory.Packages.props
```

Do not activate it solely because documentation mentions .NET or an Azure resource happens to use a .NET runtime.

Apply the central [Microsoft Learn call policy](../interfaces/mcp.md#availability-is-not-invocation). The repository remains authoritative for its present supported behavior; current Microsoft support data is external evidence, not automatic migration authority.

Exact lifecycle behavior:

- **Onboard:** perform one scoped Microsoft Learn currency pass for the detected target frameworks/SDK family and each specialised Microsoft host whose support status matters. Record supported/end-of-support state and material migration risk; do not turn the pass into a generic architecture rewrite.
- **Plan:** query Microsoft Learn when the proposed design selects or changes a Microsoft-controlled version, project/tooling behavior, hosting model, API, package/test platform, deployment, migration, or official pattern whose current guidance materially affects the decision. Pure domain logic with unchanged platform contracts does not require a query.
- **Deliver:** reuse the plan’s scoped evidence unless a drift signal, contradictory tool/runtime behavior, or new Microsoft-dependent decision appears. Query then, not ceremonially at the start of every implementation.
- **Explain:** load only the project/host sections needed to explain the actual mechanism. Query Microsoft Learn when current support/tool/API/host behavior is material to understanding; do not query it merely because the subject is written in C#.
- **Review:** independently refresh any current Microsoft claim that determines a blocker/required finding. Do not repeat background sources that cannot change the verdict.

Every used result records the official URL, retrieval time, exact product/version/host scope, whether it is a requirement/recommendation/example, and its decision effect.

## Inventory contract

### Toolchain and build

Record:

- exact solution/project entry points and whether each is `.sln`, `.slnx`, `.slnf`, or project-only;
- SDK selection from `global.json` and actual `dotnet --info`/`dotnet --list-sdks` evidence;
- project SDK style, language, target frameworks, runtime identifiers, workloads, tool manifests, and publish targets;
- `Directory.Build.props`, `Directory.Build.targets`, `Directory.Packages.props`, `NuGet.Config`, lock files, and imported props/targets;
- nullable, implicit usings, language version, analyzer level/mode, `.editorconfig`, warning suppression, and warnings-as-errors behavior;
- canonical restore/build/test/format/publish commands, configurations, prerequisites, and supported platforms; and
- CI’s exact SDK/toolchain setup and whether the same commit receives the same verdict in Windows PowerShell and CI.

### Runtime and ownership

Build a current project/call/decision map:

```text
host entry point / trigger / UI action
               |
               v
application or rule owner
               |
       +-------+-------+
       v               v
 infrastructure     configuration/gates
       |               |
       v               v
 persistence/API    typed declaration + validation
```

For every material rule or configuration surface record:

| Field | Required evidence |
| --- | --- |
| Canonical owner | Relative source path and symbol/section |
| Real callers | Entry points and intermediate call path |
| Precedence | Relationship to other rules/defaults/overrides |
| Configuration | Typed declaration, binding source, default, validation, reload/lifetime semantics |
| Persistence/external effects | Database, queue, file, network, or service boundary |
| Proof | Valuable unit/integration/caller/deployment evidence |
| Exposure | API/UI/status/log/health behavior visible to consumers/operators |
| Lifecycle | Current, generated, reference/test-only, compatibility/replay, or retirement candidate |

Also record file size, branch concentration, dependency fan-out, and recent churn for behaviorally central files. A tidy solution folder is not evidence of a tidy runtime dependency graph.

## Architecture rules

1. Preserve the smallest coherent architecture that satisfies current behavior.
2. A small application may remain one project with clear internal folders/namespaces. A multi-project split requires an actual compile-time dependency, ownership, testability, packaging, deployment, or replacement boundary.
3. Do not introduce microservices, Aspire, a mediator, CQRS, repositories, domain events, plugin loaders, or additional hosts without a present requirement whose value exceeds the added operational/indirection cost.
4. Business rules have one current owner and do not live independently in controllers, endpoints, Functions triggers, UI components, SQL, and worker handlers.
5. Hosts and UI/infrastructure adapters translate inputs/outputs and invoke the rule owner. Composition roots wire dependencies; they do not become second rule engines.
6. Use .NET DI with explicit appropriate lifetimes. Do not hide dependencies behind global service providers, service location, or scattered static access.
7. Use interfaces at real boundaries or substitution points. Do not create one interface per concrete class by habit.
8. Use strongly typed options for related behaviorally important configuration. Bind and validate at the host boundary; use startup validation when invalid settings must prevent service start.
9. Direct `Environment.GetEnvironmentVariable`, `IConfiguration[...]`, or equivalent reads outside host/configuration owners are findings when they control behavior or duplicate an existing option owner.
10. Every feature flag/gate records purpose, default by mode/environment, typed owner, readers, activation proof, dependencies, and removal trigger/version. Development mode rejects speculative or compatibility flags.
11. Generated/materialized code records one source owner, exact deterministic command, destinations, exclusion from hand editing, and parity proof. Platform-dependent output is either normalized or explicitly separated and tested.
12. Reference/test-only code is kept in a clearly named non-production/test location and is not exported as the live domain contract. Released replay/compatibility code follows the repository-mode retirement contract.

## Project and package rules

- Preserve SDK-style project defaults and implicit includes; do not add redundant file declarations.
- Keep existing `.sln`/`.slnx`/`.slnf` format unless a separately justified tool-compatibility or maintainability outcome requires migration.
- When more than one solution/project exists, canonical commands name the intended file explicitly.
- Use `global.json` for a reproducible accepted SDK range when the repository/CI needs it. Use repository-relative configuration and a documented roll-forward policy; never encode a workstation SDK path.
- Use `Directory.Build.props` only for properties genuinely shared by its subtree. Avoid hidden target logic that makes an individual project impossible to understand.
- Use Central Package Management only when multiple projects genuinely share version ownership. Do not add it to a simple single-project repository for fashion.
- Preserve a legacy/non-SDK/.NET Framework package/build model during onboarding unless the user separately authorizes modernization. Record its Visual Studio/MSBuild/Windows prerequisites and risks.
- A package or framework upgrade is an explicit change with compatibility, transitive dependency, compile/test/publish, and deployment evidence. Do not batch unrelated upgrades into feature delivery.

## Variant routes

| Detected variant | Additional required decisions/evidence |
| --- | --- |
| ASP.NET Core | `Program.cs`/composition root; endpoint-to-owner path; options validation; middleware ordering where affected; focused request-pipeline integration proof; meaningful health/readiness consumers |
| Worker/console | host lifecycle, cancellation/shutdown, retry/idempotency where applicable, scoped dependency creation, configuration validation, actual invocation proof |
| Library/NuGet package | supported target frameworks, public API/compatibility contract, package metadata/versioning, consumer-facing configuration/DI conventions, pack and representative-consumer proof |
| Desktop (WPF/WinForms/MAUI) | UI-thread/state ownership, platform target/workloads, packaging/update path, and UI design authority; do not apply ASP.NET assumptions |
| EF Core | model-versus-database source of truth, `DbContext`, migration/startup project, migration owner/name, generated migration inspection, deployment/apply authority, rollback/recovery |
| Azure Functions | runtime version, isolated/in-process model, worker package compatibility, trigger-to-owner path, binding/configuration, local Functions tooling, deploy/caller proof; in-process support risk is explicit |
| .NET Framework/non-SDK | exact framework/Visual Studio/MSBuild/NuGet prerequisites; preserve first, then plan modernization separately if requested |
| Test project | test framework/runner, unit versus integration role, external dependencies, discovery configuration, and canonical invocation |

## Planning contract

A .NET-affecting change record includes, when applicable:

- exact solution/project and target framework scope;
- current entry point-to-rule-owner call path and intended changed path;
- project-reference/dependency-direction effect;
- rule/configuration authority rows added or changed;
- public API, serialized contract, package, schema/migration, host, or deployment compatibility;
- mode-specific removal or released bridge lifecycle;
- options/DI lifetime and failure-at-start behavior;
- focused unit/integration/real-caller proof selected by regression value;
- analyzer/format/build/test/publish commands affected; and
- current Microsoft support evidence for any version-specific decision.

The plan rejects “make extensible” as sufficient justification for an extra project/interface/service/flag. It names the known future feature and the smallest seam exercised by current behavior, or defers the seam.

## Delivery contract

Deliver through the actual entry point and canonical owner:

```text
project/config/schema contract
            |
            v
single owning rule/application behavior
            |
            v
actual host caller/adapter
            |
            v
failure + recovery + observability
            |
            v
focused tests -> canonical .NET/repository command
```

- Do not leave old and new decision paths in development mode.
- Do not hand-edit generated/materialized outputs; run their declared generator and prove parity.
- Do not widen analyzer/warning/format scope beyond the change unless the plan explicitly owns that migration.
- Review generated EF migrations before testing/applying them. Azure/database apply remains governed by separate operation authority.
- Update `docs/architecture.md` when project boundaries, call paths, configuration ownership, persistence, hosts, or deployment change; update `docs/operations.md` when SDK/tooling/build/test/publish/migration/runtime procedures change.

## Proportional verification

Choose tests by protected behavior:

- pure business rule: focused fast unit tests, including valuable boundary/failure cases;
- ASP.NET request/middleware/DI/config integration: focused `WebApplicationFactory` or existing equivalent tests;
- persistence/EF behavior: focused integration against the repository’s declared meaningful provider strategy plus migration inspection;
- worker/Function behavior: rule-level tests plus the smallest valuable host/trigger/binding integration proof;
- package/library contract: pack plus representative consumer/public API/compatibility proof;
- UI behavior: normal UI/UX route plus underlying .NET owner tests.

Do not require a coverage percentage, getter/wiring tests, or integration permutations with no plausible regression. Unit and integration suites are separately invocable when they have materially different cost or prerequisites.

The canonical command:

- identifies the exact solution/project when discovery would be ambiguous;
- uses the repository-declared SDK and package source/lock behavior;
- produces an unqualified pass only when required suites actually ran;
- reports skipped/unavailable suites, analyzer ratchets, and platform limitations explicitly; and
- agrees between supported local Windows and CI environments for equivalent inputs, or documents and tests a deliberate platform-specific branch.

Markdown-only changes do not restore/build/test/format .NET unless the Markdown changes executable examples, generated source authority, package metadata, or another declared code risk.

## Review additions

For an affected PR, the independent reviewer checks:

1. the exact project/reference graph and real host caller reach the intended owner;
2. no second business-rule or configuration authority was created;
3. DI lifetimes and option binding/validation are coherent;
4. public API, serialization, package, schema/migration, and host compatibility match repository mode;
5. generated/materialized code has one source and deterministic parity;
6. test-only/reference/replay/compatibility code is classified and not mistaken for the live owner;
7. tests protect meaningful regressions without coverage theatre;
8. analyzer/format/build/test/publish scope is proportional and every claimed suite ran;
9. current support/version claims were refreshed from Microsoft Learn when relevant; and
10. the change did not add speculative projects, interfaces, services, gates, fallback paths, or host infrastructure.

## Forbidden universal assumptions

The profile never assumes or mandates:

- .NET 10 or any other target framework without repository/user authority;
- `.slnx` conversion;
- Clean Architecture or a fixed project count;
- microservices, containers, Aspire, EF Core, CQRS, a mediator, or repository pattern;
- xUnit, NUnit, MSTest, VSTest, or Microsoft.Testing.Platform migration;
- Central Package Management for a single/simple project;
- all analyzers, global warnings-as-errors, or a coverage threshold; or
- Azure hosting merely because the code is .NET.
