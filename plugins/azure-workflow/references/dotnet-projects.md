# .NET repository routing profile

This is a conditional routing profile, not a static .NET handbook. Use it to establish repository facts, select the relevant project/host variant, and decide when current Microsoft Learn evidence is necessary.

## Activation and authority

Activate for material scope involving `*.csproj`, `*.fsproj`, `*.vbproj`, `*.sln`, `*.slnx`, `*.slnf`, `global.json`, `Directory.Build.*`, or `Directory.Packages.props`. Do not activate for a prose mention of .NET or solely because an Azure resource uses a .NET runtime.

```text
desired product behavior       -> user and declared product/operator authority
current repository behavior    -> source, config, tests, and observed tool output
current Microsoft product fact -> Microsoft Learn MCP
workflow quality gates         -> owning Azure Workflow skill/reference
```

Surface conflicts; never silently modernize the repository or let generic guidance override its supported contract.

## Inspect only relevant local facts

- solution/project entry points, references, languages, SDK style, TFMs, RIDs, workloads, hosts, executable/test/publish projects, and deployment targets;
- `global.json`, props/targets, package-version owner, NuGet config/locks, tool manifests, analyzers, formatting/warnings policy, and generated-source boundaries;
- affected entry point, composition root, DI registrations/lifetimes, configuration declaration/binding/validation, rule owner, persistence/external effects, and real callers;
- test-suite roles, external prerequisites, migrations/schema authority, and exact restore/build/test/format/pack/publish/migration commands;
- CI SDK/toolchain/platform/commands and parity with the supported Windows/PowerShell workflow.

Infer none of these from folder names or a solution file alone.

## Classify the material variant

| Variant | Resolve locally |
| --- | --- |
| ASP.NET Core | host/composition root, endpoint/middleware path, configuration route, request caller |
| Worker/console | lifecycle, invocation, scopes, cancellation, retry, external effects |
| Library/package | TFMs, public/serialized contracts, package metadata, representative consumer |
| Desktop/cross-platform UI | framework/workload/platform, UI-thread/state owner, packaging, repository design authority |
| Persistence/EF | model/schema owner, context/provider, migration/startup project, apply authority, recovery |
| Azure Functions | runtime/worker model, triggers/bindings, packages, local tools, host config, deployment |
| .NET Framework/non-SDK | exact framework and Visual Studio/MSBuild/NuGet/Windows prerequisites and compatibility |
| Test project | platform/runner, suite role, discovery configuration, external dependencies |

A repository may contain several variants; use only those material to the current goal.

## Microsoft Learn call gate

- **Onboard:** one scoped currency check per detected TFM/SDK family and specialized Microsoft host when support status matters.
- **Plan:** query when selecting/changing a Microsoft version, SDK/tool, host/worker model, API, package/test platform, deployment/publish mechanism, migration, or official pattern.
- **Deliver:** reuse scoped plan evidence unless a version/support/error/deprecation drift signal, contradictory behavior, or new Microsoft decision appears.
- **Explain:** query only when a current Microsoft fact is necessary to understand the mechanism.
- **Review:** independently refresh only a current claim that can change a finding/verdict.

Use a narrow query with actual product, version/TFM, host/model, and decision. Fetch the matching official page; search results alone may mix legacy/current variants. Record official URL, UTC retrieval time, scope, claim status (`requirement`, `recommendation`, or `example`), and decision effect. Do not vendor documentation pages or static support tables.

## Apply the owning workflow

Retain enough evidence to identify exact projects/TFMs, caller-to-owner path, dependency direction, configuration/public/package/persistence/host/deployment effects, selected regression proof, commands actually run, and material current Microsoft facts.

Modernization is a separately named change unless explicitly requested. Never impose a target framework, solution format, project count, architecture pattern, microservices, containers, Aspire, Clean Architecture, CQRS, mediator, repositories, persistence technology, package layout, test framework, coverage threshold, analyzer expansion, global warnings policy, or Azure host on every .NET repository.
