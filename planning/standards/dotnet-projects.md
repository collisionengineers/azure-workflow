# .NET repository routing profile

## Purpose and ownership

This is a conditional routing profile for repositories containing .NET projects. It is deliberately not a static .NET handbook. It tells the owning workflow:

1. when .NET-specific inspection is needed;
2. which repository facts to establish locally;
3. when current Microsoft evidence is material; and
4. how to avoid applying guidance for the wrong framework, host, or project type.

Packaged owner: `plugins/azure-workflow/references/dotnet-projects.md`.

Direct consumers:

- `$onboard-azure-repository` when a .NET project or solution is detected;
- `$plan-azure-repository-change` and `$deliver-azure-repository-change` when the outcome affects .NET source, project/build/package configuration, tests, persistence, hosting, publishing, or deployment;
- `$explain-repository` when .NET mechanics materially affect the requested explanation; and
- `$review-repository-pull-request` when a pull request contains or behaviorally affects that scope.

`$operate-azure-repository` does not load this profile merely because an Azure resource runs .NET. Live Azure state remains owned by the operate workflow.

## Authority split

```text
desired product behavior ------------> user + operator/product authority
current repository behavior ---------> source + config + tests + tool output
current Microsoft product fact ------> Microsoft Learn MCP
workflow/quality requirements -------> owning Azure Workflow references
```

Microsoft Learn does not know the repository's intended behavior or prove its live call paths. Repository code does not establish current Microsoft support. If the sources disagree, surface the conflict; do not silently modernize the repository or ignore current platform risk.

## Activation

Activate when inspection finds one or more of:

```text
*.csproj  *.fsproj  *.vbproj  *.sln  *.slnx  *.slnf
global.json  Directory.Build.*  Directory.Packages.props
```

Do not activate solely because prose mentions .NET or an Azure resource happens to use a .NET runtime.

## Inspect the repository first

Establish only facts relevant to the active goal:

- exact solution/project entry points, project references, languages, SDK style, target frameworks, runtime identifiers, workloads, hosts, executable/test/publish projects, and deployment targets;
- `global.json`, build props/targets, package-version owners, NuGet configuration/locks, tool manifests, analyzers, formatting and warnings policy, and generated-source boundaries;
- the affected entry point, composition root, dependency registrations/lifetimes, configuration declarations/binding/validation, rule owner, persistence or external effects, and real callers;
- test-suite roles, external prerequisites, migrations/schema authority, and exact restore/build/test/format/pack/publish/migration commands; and
- CI's selected SDK/toolchain, commands, paths, platform, and relationship to the supported local Windows workflow.

Do not infer these facts from folder names, a solution file alone, or generic Microsoft examples. Use the repository's declared files and actual tool output.

## Classify the relevant variant

| Variant | Local questions to settle before seeking generic guidance |
| --- | --- |
| ASP.NET Core | Which host/composition root, endpoint or middleware path, configuration route, and request caller are affected? |
| Worker or console | Which host lifecycle, invocation path, scope, shutdown/cancellation, retry, and external-effect behavior exists? |
| Library or package | Which target frameworks, public/serialized contract, package metadata, and representative consumer are authoritative? |
| Desktop or cross-platform UI | Which UI framework, platform/workload, UI-thread/state owner, packaging path, and repository design authority apply? |
| Entity Framework or other persistence | Which model/schema owner, context/provider, migration/startup project, apply authority, and recovery path apply? |
| Azure Functions | Which runtime, worker model, trigger/binding, package set, local tooling, host configuration, and deployment path apply? |
| .NET Framework or non-SDK project | Which exact framework, Visual Studio/MSBuild/NuGet/Windows prerequisites and compatibility obligations apply? |
| Test project | Which test platform/runner, suite role, discovery configuration, and external dependency boundary apply? |

A repository can contain several variants. Load and research only those material to the request.

## Use Microsoft Learn for current facts

Apply the central [Microsoft Learn call policy](../interfaces/mcp.md#availability-is-not-invocation). Registration is not invocation.

- **Onboard:** make one scoped currency pass for each detected target-framework/SDK family and specialised Microsoft host whose support status is material.
- **Plan:** query when the design selects or changes a Microsoft-controlled version, SDK/tool behavior, host/worker model, API, package/test platform, deployment/publish mechanism, migration path, or official pattern.
- **Deliver:** reuse the plan's scoped evidence unless a version/support/error/deprecation drift signal, contradictory observed behavior, or a new Microsoft-dependent decision appears.
- **Explain:** query when a current Microsoft fact is necessary to understand the mechanism; do not query merely because the code is C#, F#, or Visual Basic.
- **Review:** independently refresh a current Microsoft claim only when it can determine a finding or verdict.

Ask a narrow query containing the actual product, version/TFM, host/model, and decision. Use search to find candidates, then fetch and inspect the applicable official page before relying on it. Search results can mix current, legacy, migration, and framework-specific material; reject a result whose audience or version does not match the repository.

Record every used result in the existing change record or review output with its official URL, UTC retrieval time, exact product/version/host scope, claim status (`requirement`, `recommendation`, or `example`), and decision effect. Do not copy documentation pages into the repository.

If Microsoft Learn is unavailable, follow the MCP contract's official-source fallback and block only the decision that requires current evidence.

## Apply the owning workflow

After the technology facts are established, use the normal generic contracts for authority, maintainable ownership, repository mode, UI/UX, documentation, testing, delivery, and independent review. This profile does not duplicate them.

For a .NET-affecting change, retain enough evidence to identify:

- exact projects, target frameworks, affected caller-to-owner path, and dependency-direction effect;
- configuration, public contract, package, persistence/schema, host, publish, and deployment consequences;
- focused proof selected for plausible regression value and the exact commands actually run; and
- any current Microsoft fact that materially affected the decision.

Framework, solution-format, package-management, host-model, test-platform, or architecture modernization is a separately named change unless it is the user's requested outcome.

## Universal prohibitions

Never choose for every .NET repository:

- a target framework or upgrade;
- `.sln`, `.slnx`, or another solution format;
- a fixed project count or architecture pattern;
- microservices, containers, Aspire, Clean Architecture, CQRS, a mediator, repositories, or extra interfaces;
- Entity Framework or another persistence technology;
- Central Package Management or another package layout;
- a test framework/runner, coverage threshold, analyzer expansion, or global warnings-as-errors policy; or
- Azure or any other deployment host.

Do not store current support tables, end-of-support dates, CLI defaults, migration deadlines, package/API recipes, or code samples in this packaged profile. Retrieve those when a material decision requires them.
