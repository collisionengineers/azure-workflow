# MCP server contract

## Exact inventory

Version `0.1.0-alpha.1` includes exactly two MCP servers.

| Name | Transport | Purpose | Authentication |
| --- | --- | --- | --- |
| `azure` | Local stdio through `npx` | Inspect and, after explicit approval, operate Azure resources | Local Azure credential chain; the plugin stores no credential |
| `microsoft-learn` | Remote streamable HTTP | Search and fetch current official Microsoft and Azure documentation | No authentication |

There is no GitHub MCP, Azure DevOps MCP, Box MCP, OpenAI MCP, custom workflow server, or plugin-owned database server. GitHub operations use `git`, `gh`, and `gh api` because GitHub Projects setup still needs API/GraphQL coverage and a second GitHub credential/tool path would add ambiguity without replacing those commands.

## Exact `.mcp.json`

Path: `plugins/azure-workflow/.mcp.json`

```json
{
  "mcpServers": {
    "azure": {
      "command": "npx",
      "args": [
        "-y",
        "@azure/mcp@3.0.0-beta.29",
        "server",
        "start"
      ],
      "env": {
        "AZURE_MCP_COLLECT_TELEMETRY": "false"
      }
    },
    "microsoft-learn": {
      "type": "http",
      "url": "https://learn.microsoft.com/api/mcp"
    }
  }
}
```

## Why the Azure package is pinned

- `@azure/mcp` is a prerelease dependency at the selected version.
- The exact registry probe on 2026-07-26 reported `latest: 3.0.0-beta.29`; the package is still pinned rather than following that moving tag.
- Pinning makes installation and tool discovery reproducible.
- Version updates happen through an ordinary reviewed change with startup, tool-list, read-only inventory, and approval-gate tests.
- Do not use `@latest` in committed configuration.

## Tool-use policy

```text
Need current Microsoft guidance?
        |
        +--> microsoft-learn search/fetch --> cite source in decision or record
                 |
                 `--> refresh .NET/Azure version, support, host, and tooling facts

Need actual Azure state?
        |
        +--> resolve tenant/subscription/environment
        +--> azure read/inventory/validation
        +--> mutation needed?
                 |
                 +-- no --> report evidence
                 |
                 +-- yes --> prepare exact apply card
                              |
                              +--> explicit user approval?
                                      | no  -> stop without mutation
                                      | yes -> execute once, then validate
```

The skills, not the MCP manifest, enforce mutation policy. A tool being available never constitutes authorization to use its write behavior.

## Availability is not invocation

Registering `microsoft-learn` only makes its read tools available. Codex does not automatically consult it, and the MCP manifest cannot decide when a query is useful. Every consuming skill therefore applies this explicit guidance gate:

```text
Does the outcome depend on a current Microsoft product fact or recommendation?
             |
        +----+----+
        |         |
       no        yes
        |         |
        |         v
        |   same active change already has scoped official evidence
        |   and no version/support/error/drift signal invalidates it?
        |              |
        |         +----+----+
        |         |         |
        |        yes        no
        |         |         |
        |         v         v
        |       reuse    query Microsoft Learn MCP
        |                    |
        +--------------------+
                     |
                     v
       record source, retrieval time, scope, claim, and decision effect
```

### Mandatory Microsoft Learn calls

Call Microsoft Learn when at least one is true:

- the user explicitly asks what Microsoft recommends, asks to check Microsoft Learn, or asks for current/supported/best-practice guidance;
- onboarding a .NET repository must establish current support status for its target framework/SDK and specialised Microsoft host such as Azure Functions;
- a plan selects or changes a Microsoft-controlled version, target framework, SDK/tool, package model, test platform, host model, API, Azure service capability, limit, retirement/deprecation, migration path, deployment/publish behavior, or security/reliability mechanism;
- delivery encounters behavior that contradicts the cited plan evidence, introduces a new Microsoft-dependent decision, or implements without applicable current evidence;
- an explanation materially depends on a current Microsoft-controlled version, support state, API, host, service, limit, migration, security, reliability, deployment, or tooling fact;
- independent review must decide a material finding whose correctness depends on a current Microsoft claim; or
- an Azure operation relies on current service/API/CLI/IaC behavior, limits, retirement state, or prescribed migration/recovery guidance rather than only on an already-proven repository command and observed resource state.

### Calls that are normally unnecessary

Do not call Microsoft Learn merely because:

- a file is C#, F#, Visual Basic, Bicep, or another Microsoft-associated format;
- a change is pure repository-owned business logic with unchanged platform contracts;
- the question is answered by actual repository code/configuration or stable already-recorded evidence for the same active change;
- the task is ordinary formatting, naming, typo repair, or Markdown maintenance; or
- the agent wants generic “best practices” to fill space or justify a preferred architecture.

The MCP supplies external platform evidence. It does not override the user, canonical product decisions, active external/controlled requirements routed by `docs/index.md`, or observed repository behavior. A conflict is surfaced as a decision or noncompliance finding.

## Evidence reuse and refresh

Planning records Microsoft evidence so delivery does not repeat identical searches mechanically. Explanation may reuse scoped evidence for the same active question. Reuse requires all of:

- an official Microsoft URL and retrieval timestamp;
- the exact product/version/host/decision scope;
- the claim or recommendation actually relied on; and
- no drift signal, such as a support date passing, framework/service/tool version changing, a new deprecation notice, implementation behavior contradicting the source, or the plan’s relevant baseline changing.

Independent review refreshes a decisive current claim itself rather than treating the implementation owner’s citation as proof. It need not repeat non-decisive background research.

Do not impose an arbitrary “query every N days” rule. Refresh is driven by the decision and drift signals. Deduplicate identical queries inside one active workflow, and fetch only the pages needed to resolve the question.

Record compact evidence in the change record or review result:

```markdown
- Question: <decision requiring current Microsoft evidence>
- Source: <official Microsoft URL>
- Retrieved: <UTC timestamp>
- Applies to: <product/version/host/scope>
- Status: requirement | recommendation | example
- Effect: <what the evidence changed, confirmed, or ruled out>
```

Do not vendor or reproduce whole Microsoft documentation pages.

## Startup and failure behavior

- Check `node`, `npm`, and `npx` availability before diagnosing an Azure MCP startup failure.
- Run Azure authentication preflight before resource calls. State the exact tenant and subscription returned; never infer them from a repository name.
- Treat an Azure CLI or credential-chain error as an external blocker. Do not downgrade it to an empty-resource result.
- If Microsoft Learn is unavailable or throttled, use another official Microsoft primary source and record the fallback. Do not silently substitute an unverified secondary source for an unstable Azure fact.
- The shared .NET profile uses Microsoft Learn before a material current version/framework/Functions-worker/test-platform/publish/hosting decision unless scoped evidence for the same active change remains valid under the reuse rules. It does not create a third MCP registration and does not let current docs silently override repository support authority.
- If neither MCP nor an official Microsoft fallback is available, block only the decision that requires current evidence. Continue independent repository-grounded work and report the precise evidence gap; do not describe the whole repository or change as blocked when it is not.
- Never echo tokens, connection strings, secret values, message bodies, or full environment dumps.

## Acceptance probes

1. Azure MCP process starts and exposes tools.
2. A read-only subscription or resource-group inventory succeeds against an explicitly reported scope.
3. Microsoft Learn returns a current official documentation result.
4. Call-policy fixtures prove mandatory call, same-change reuse, drift-triggered refresh, independent-review refresh, non-Microsoft/no-current-fact non-use, compact evidence recording, and scoped failure behavior.
5. A simulated Azure write request stops at the approval card and performs no mutation.
6. After a deliberately approved safe test operation, the route records observed post-change state; this test may be deferred until an agreed disposable Azure scope exists.

The current workstation has a known `az account show` failure caused by an unreadable Azure CLI extension metadata path. Live Azure acceptance remains incomplete until that local prerequisite is repaired and the read-only probe passes.
