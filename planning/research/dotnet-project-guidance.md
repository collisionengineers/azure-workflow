# Microsoft .NET project guidance research

Research date: 2026-07-26

Scope: current Microsoft guidance that can sensibly apply to **any repository containing .NET projects**, including modern SDK-style .NET, .NET Framework, ASP.NET Core, workers/console apps, libraries, tests, Entity Framework Core, and Azure Functions. This is a technology profile inside the existing workflow, not an Azure-only architecture prescription.

## Status and use

This file is dated research and decision evidence. It is not copied into the plugin and is not operational authority for a future repository run. Version numbers, support dates, defaults, APIs, tooling behavior, host models, and Microsoft recommendations recorded here can drift; a workflow that materially depends on one must refresh it through Microsoft Learn under the central MCP policy.

Only the stable routing decision is carried into the packaged profile: inspect the actual repository, identify its exact .NET variant, ask Microsoft Learn a narrow current question when needed, and apply the normal repository workflow without automatic modernization.

## Conclusion

Microsoft does not prescribe one universal folder tree, a fixed number of projects, Clean Architecture for every application, microservices, Aspire, exhaustive testing, or a mandatory analyzer configuration. Its guidance is more proportional:

- a small single-project application can be appropriate;
- non-trivial applications benefit from clear separation of concerns and dependency direction;
- microservices add real operational and communication complexity and should solve a demonstrated need;
- SDK, target framework, package, analyzer, configuration, and test choices should be explicit and reproducible; and
- integration tests should be focused on important infrastructure behavior, not written for every permutation.

That aligns with this plugin’s stated goal: clean, understandable, extendable code without speculative architecture. The plugin should add **one small shared conditional .NET routing reference**, not another public skill, MCP server, hook, rigid repository template, or static substitute for Microsoft Learn.

## Static-guidance audit

The first draft of the packaged `.NET` standard grew to 220 lines. That was too much. It mixed four different kinds of content:

| Content | Correct owner |
| --- | --- |
| Point-in-time Microsoft release, support, host, API, and tool facts | Microsoft Learn at the point of a material decision; this dated research may retain the historical evidence |
| Repository-specific SDK, project, host, configuration, dependency, test, and command facts | Inspection of the target repository and its actual tool output |
| General ownership, maintainability, documentation, mode, testing, and review rules | Existing generic workflow references and repository authority |
| `.NET` activation, variant detection, evidence questions, and Learn query routing | The concise shared packaged `.NET` profile |

The packaged reference must therefore **not** summarize the Microsoft documentation catalogue or repeat the generic implementation/review handbook. It retains only information that helps an agent choose the right evidence source and avoid applying the wrong `.NET` variant.

The live Microsoft Learn service search performed for this audit through Microsoft's official CLI, which exposes the same search/fetch content capabilities as the MCP server, confirmed both the value and the limit of the service. It returned relevant current .NET dependency-injection and architecture pages, but the same broad query also returned older ASP.NET Web API, SignalR, .NET Framework migration, MAUI, and Functions in-process material. This is expected search behavior, not a defect. It proves why the plugin must supply a small applicability guard:

```text
actual repository variant + requested decision
                    |
                    v
          narrow Microsoft Learn query
                    |
                    v
       fetch and verify the selected page
                    |
                    v
       apply only if product/version/host match
```

Microsoft Learn should be called for current or narrowly defined Microsoft-controlled facts. It should not be called merely because a file is written in C#, and its first search result must not be treated as a universal architecture instruction.

### Keep in the packaged profile

- activation evidence and exact variant classification;
- local repository/toolchain inventory questions that Microsoft Learn cannot answer;
- lifecycle-specific call/reuse/refresh rules;
- a requirement to scope and fetch the applicable official page before relying on it;
- compact evidence recording and failure behavior; and
- prohibitions against automatic framework, architecture, solution, package, test, analyzer, or hosting choices.

### Keep out of the packaged profile

- current supported-version tables and end-of-support dates;
- current CLI defaults, migration deadlines, package/API details, and host-specific recipes;
- copied Microsoft tutorials, code samples, or architecture catalogues;
- duplicated generic rules for source ownership, documentation, modes, testing, UI, and PR review; and
- collision-project-specific architecture lessons.

This keeps the MCP useful rather than ceremonial while preventing it from becoming an unscoped “best practices” oracle.

## What current Microsoft guidance establishes

| Area | Official guidance | Workflow interpretation |
| --- | --- | --- |
| Supported releases | As of this research date, .NET 10 LTS is supported to November 2028; .NET 9 STS and .NET 8 LTS are supported to November 2026. Microsoft advises actively maintained services to use a current supported release and current servicing update. | Discover the repository’s declared SDK/TFMs and support obligations. Never silently upgrade during onboarding or an unrelated feature. Flag unsupported or near-end-of-support targets and plan migration as its own change. Refresh this fact through Microsoft Learn before version work. |
| Architecture size | Microsoft’s architecture guidance says a single deployable monolith is often simpler, a single project can suit small apps, and larger non-trivial apps benefit from logical separation. It also warns that splitting into services adds communication and operational complexity. | Default to the smallest structure that gives a real ownership/dependency boundary. Do not impose microservices, Clean Architecture project counts, or a generic `Domain/Application/Infrastructure` scaffold on every repository. |
| Dependency direction | For non-trivial applications, business/application logic should not depend on UI or infrastructure details; dependencies are wired at the composition root through DI. | Keep controllers, endpoints, Functions triggers, hosted workers, and UI adapters thin. Give each business rule one current owner and keep infrastructure behind explicit dependencies where this reduces real coupling. |
| SDK/project files | SDK-style project files use implicit imports and file inclusion to remain small. `Directory.Build.props` can hold properties shared across projects. | Preserve SDK-style simplicity. Use repository-wide build properties only for genuinely shared policy; do not create a large hidden MSBuild control plane. Legacy/non-SDK conversion is separate modernization work. |
| Solutions | .NET 10 creates `.slnx` by default, while the CLI continues to support `.sln`; migration is an explicit command. | Accept `.sln`, `.slnx`, `.slnf`, or an explicit project entry point. Do not churn an existing solution format merely because a newer default exists. Canonical commands name the exact solution/project when more than one is present. |
| SDK selection | `global.json` is optional when the latest installed SDK is intended; Microsoft notes CI usually benefits from an acceptable SDK range using `rollForward`. | For a reproducible repository/CI contract, declare the accepted SDK feature band and roll-forward policy, unless the repository intentionally floats and documents that behavior. Do not pin to a machine-only absolute SDK path. |
| Packages | NuGet Central Package Management uses `Directory.Packages.props` to share versions. `PackageReference` is the modern/default model for SDK-style .NET. | Introduce central package management only when repeated versions across multiple projects create a real consistency problem. Keep a single project simple. Preserve an intentional legacy package model until a separately scoped migration. |
| Configuration | The options pattern provides strongly typed, scenario-grouped configuration and validation; `ValidateOnStart` can fail invalid configuration at startup. | Avoid scattering environment/configuration string reads through business logic. Define one named owner per behaviorally important setting, bind at the host boundary, validate required values, and document reload/lifetime semantics when relevant. |
| Dependency injection | .NET DI has explicit transient/scoped/singleton lifetimes; scoped services must be resolved within a scope and must not be accidentally captured by a singleton. | Inventory composition roots and lifetimes. Reject service-location and hidden static dependencies when they obscure ownership. Add interfaces only at genuine substitution/boundary points, not around every class. |
| Code analysis/format | Modern .NET includes analyzers, with configurable analysis levels/modes; `dotnet format --verify-no-changes` can enforce an existing `.editorconfig`. | Preserve the repository’s established style/analyzer authority. Ratchet legacy warning debt deliberately rather than turning every warning into an unrelated migration. Format/analyzer checks run for affected code, not Markdown-only changes. |
| Unit tests | Microsoft recommends fast, isolated, repeatable, self-checking, timely unit tests and warns that high coverage alone does not prove quality. | Test valuable rules and plausible regressions. Do not add getter/wiring tests, blanket coverage targets, or one test per line. Difficult-to-test coupling is an architecture signal, not a reason to mock everything. |
| Integration tests | ASP.NET Core guidance recommends focused integration tests for important infrastructure/request paths, commonly through `WebApplicationFactory`; it says not to test every data permutation through infrastructure. | Separate or clearly classify unit and integration suites when their dependencies/runtime differ. Run integration tests only when relevant paths change and keep a small, meaningful end-to-end set. |
| EF Core | EF migrations are source-controlled incremental schema changes; Microsoft says generated migrations should be inspected and tested, and recommends reviewable deployment approaches such as scripts for production. | Name the model/schema source of truth, migration owner, startup project/context, generation command, review proof, apply authority, and rollback/recovery. A feature plan that changes persistence must include the migration path. |
| Health checks | ASP.NET Core health checks should be designed for the actual monitoring/orchestration system; basic liveness is enough for many apps, while readiness has a distinct meaning. | Add probes only when a deployed host/consumer uses them. Do not create decorative endpoints. A check must state what dependency/state it proves and how the platform consumes it. |
| Azure Functions | Microsoft supports modern .NET versions through the isolated worker model; support for the in-process model ends 2026-11-10. | Detect Functions host/runtime/worker model and flag in-process support risk. New Functions work uses the repository’s supported isolated-worker route; migration of an existing app is a separate planned change with deployment proof. |

## Official sources

- [Microsoft Learn MCP server and CLI](https://github.com/MicrosoftDocs/mcp)
- [.NET releases, patches, and support](https://learn.microsoft.com/en-us/dotnet/core/releases-and-support)
- [.NET project SDK overview](https://learn.microsoft.com/en-us/dotnet/core/project-sdk/overview)
- [`global.json` overview](https://learn.microsoft.com/en-us/dotnet/core/tools/global-json)
- [`dotnet sln` and `.slnx`](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-sln)
- [Central Package Management](https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management)
- [Common web application architectures](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)
- [Options pattern](https://learn.microsoft.com/en-us/dotnet/core/extensions/options)
- [Dependency injection service lifetimes](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection/service-lifetimes)
- [Code analysis in .NET](https://learn.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview)
- [`dotnet format`](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-format)
- [.NET unit-testing best practices](https://learn.microsoft.com/en-us/dotnet/core/testing/unit-testing-best-practices)
- [ASP.NET Core integration tests](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-10.0)
- [EF Core migrations](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/)
- [Applying EF Core migrations](https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/applying)
- [ASP.NET Core health checks](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/health-checks?view=aspnetcore-10.0)
- [.NET isolated-worker Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/dotnet-isolated-process-guide)

## Plugin shape

```text
repository contains .csproj/.fsproj/.vbproj or .NET solution
                         |
                         v
             identify project/runtime family
                         |
          +--------------+----------------+
          |              |                |
          v              v                v
    modern SDK       legacy/.NET      specialised host
    style             Framework        ASP.NET/Worker/
          |              |             Library/EF/Functions
          +--------------+----------------+
                         |
                         v
      load shared references/dotnet-projects.md
                         |
                         v
        apply only relevant profile sections
                         |
                         v
       use normal onboard / plan / deliver / explain / review
```

### No separate .NET skill

“.NET work” is not a user goal. Onboarding a .NET repository, planning or implementing a .NET feature, explaining its mechanics, and reviewing its PR still have the same goal-specific authorization boundaries as other technologies. A `.NET` public skill would either duplicate those workflows or become another vague monolith.

### No .NET MCP

The existing Microsoft Learn MCP is sufficient for current framework/tooling documentation. Repository truth still comes from local source and tool output. The Azure MCP is used only when the change has Azure state or deployment implications.

Having the server in `.mcp.json` is not enough: registration exposes tools but does not make an agent consult them. The lifecycle skills must explicitly apply the call policy in [the MCP contract](../interfaces/mcp.md#availability-is-not-invocation).

The correct balance is neither “never call it because the profile already contains guidance” nor “search Microsoft Learn for every C# edit”:

```text
stable reusable principle -----------------> shared .NET profile
current support/version/host/tool fact ----> Microsoft Learn MCP
actual repository behavior ----------------> source/config/tests/tool output
desired product behavior ------------------> user/operator/product authority
```

Onboarding performs a scoped support/host currency pass. Planning calls Learn for a material Microsoft-dependent decision. Delivery reuses that evidence unless implementation reveals drift or a new decision. Explanation calls Learn when a current Microsoft fact is material to understanding. Independent review refreshes a current claim when it can change the verdict. Ordinary pure-domain changes and explanations do not call it.

### No hook

The `.NET` profile needs deterministic commands and path-aware CI, not an always-running local hook. A hook would recreate the exact problem the workflow is designed to avoid: broad checks for unrelated edits.

## Required .NET discovery

Onboarding records at least:

- every `.sln`, `.slnx`, `.slnf`, `.csproj`, `.fsproj`, `.vbproj`, `global.json`, `NuGet.Config`, `Directory.Build.*`, `Directory.Packages.props`, package lock file, tool manifest, and workload declaration;
- SDK style or legacy style, target frameworks, runtime identifiers, nullable/implicit-using/language settings, analyzers, warnings policy, package model, and generated-code boundaries;
- the solution/project-reference graph and exact executable/test/publish entry points;
- host types and composition roots: ASP.NET Core, Worker/console, desktop, library/package, test, Azure Functions, or other;
- configuration declaration, bind/validation location, direct environment/config reads, feature gates, and secret provider boundaries;
- business-rule owners, callers, adapters, persistence/schema ownership, generated/materialized copies, reference/test-only exports, and compatibility paths;
- unit/integration/end-to-end suite boundaries and required external dependencies;
- canonical restore/build/test/format/publish/migration commands and the platforms on which they are expected to agree; and
- support status for SDK, target frameworks, Functions worker/runtime, and deployment host.

## Anti-spaghetti synthesis

The following is the workflow’s synthesis of Microsoft’s proportional architecture guidance and the corrected CollisionSpike audit. It is stricter than a generic template because it addresses the failure mode the plugin must prevent:

1. One behavioral rule has one canonical code owner. Adapters may translate; they do not independently re-decide it.
2. One behaviorally important configuration value has one typed declaration, binding/validation route, and documented consumer set.
3. Each host has an obvious composition root. Dependency registration is not a substitute for tracing the real caller.
4. Controllers, endpoints, Functions triggers, message handlers, and UI actions stay thin enough that current behavior can be followed without reconstructing project history.
5. Generated/materialized code names its canonical source, deterministic generation command, destinations, and parity check. Review normally inspects the source plus generated diff/proof, not three supposed authorities.
6. `reference`, `test-only`, `compatibility`, and `replay` code is not presented or exported as the live domain owner. Released bridges have removal metadata; development mode rejects them.
7. New project/layer/interface/service boundaries require a current dependency, ownership, testability, deployment, or replacement reason. “Future extensibility” alone is insufficient.
8. Plans identify size/branch/fan-out/churn hotspots and avoid adding another decision stage to a hotspot without first settling ownership.

## What the profile must not do

- Force every repository onto .NET 10, `.slnx`, Central Package Management, Clean Architecture, Aspire, containers, microservices, EF Core, xUnit, MSTest, Microsoft.Testing.Platform, or a particular cloud host.
- Convert .NET Framework/non-SDK projects as an onboarding side effect.
- Enable all analyzers or warnings-as-errors across an existing warning backlog without an explicit remediation plan.
- add interfaces, projects, repositories, mediators, CQRS, events, feature flags, or fallback paths merely for hypothetical future work;
- create tests to satisfy coverage percentages rather than protect behavior; or
- treat a green `dotnet build` as proof that the real caller, deployment, migration, or UI path works.
