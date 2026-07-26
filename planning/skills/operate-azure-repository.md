# Skill specification: `operate-azure-repository`

## Public purpose

Inspect, diagnose, validate, deploy, configure, troubleshoot, and verify actual Azure state for a repository while keeping repository-owned IaC and documentation authoritative and requiring explicit approval for every mutation.

## Exact folder

```text
skills/operate-azure-repository/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
`-- references/
    |-- azure-evidence.md
    |-- azure-safety-and-approval.md
    `-- iac-and-drift.md
```

No `scripts/` or `assets/` subfolder exists. Azure execution uses the plugin MCP servers and repository-native CLI/IaC commands.

## `SKILL.md` frontmatter

```yaml
---
name: operate-azure-repository
description: Inspect, diagnose, validate, deploy, configure, troubleshoot, and verify actual Azure resources for a repository using Azure MCP and current Microsoft Learn guidance. Use when the requested outcome depends on current/live Azure state, including identity, networking, cost, reliability, diagnostics, deployment, migration, drift, or resource operation; require explicit user approval immediately before every Azure mutation. Use planning or delivery when the endpoint is a repository plan or implementation, and explain-repository when the user wants only a conceptual explanation that does not depend on live Azure state.
---
```

## `agents/openai.yaml`

```yaml
interface:
  display_name: "Operate Azure Repository"
  short_description: "Plan and apply controlled Azure operations"
  default_prompt: "Use $operate-azure-repository to inspect this repository's Azure scope and carry out only explicitly approved changes."

dependencies:
  tools:
    - type: "mcp"
      value: "azure"
      description: "Azure resource inspection, validation, and approved operations"
      transport: "stdio"
    - type: "mcp"
      value: "microsoft-learn"
      description: "Current official Microsoft and Azure documentation"
      transport: "streamable_http"
      url: "https://learn.microsoft.com/api/mcp"

policy:
  allow_implicit_invocation: true
```

## Required `SKILL.md` body structure

```markdown
# Operate Azure Repository
## Preconditions and scope
## Classify the operation
## Gather current evidence
## Prefer repository-owned desired state
## Prepare the apply card
## Apply once after approval
## Verify and reconcile
## Failure behavior
## Resources
```

## Operation classes

| Class | Examples | Approval |
| --- | --- | --- |
| Read | List subscriptions/resources, inspect configuration, query health/logs/cost | Automatic |
| Research | Microsoft Learn search/fetch, API/version/limit lookup | Automatic |
| Validate | Lint, build, policy check, Azure what-if, deployment validation | Automatic when non-mutating |
| Mutate | Deploy, update configuration, assign RBAC, restart, scale, rotate, delete | Explicit single-use approval |

When a command has mixed or unclear behavior, classify it as mutating.

## Core instructions

1. Confirm that current/live Azure evidence or operation is part of the endpoint. Route a repository-only plan to `$plan-azure-repository-change` and repository/IaC implementation to `$deliver-azure-repository-change`.
2. Read repository authority, architecture, operations, active ADRs, IaC, and active change record.
3. Work in Windows through PowerShell 7. Use `az`, `azd`, workflow skills, and Azure MCP only after the relevant preflight succeeds.
4. Read relevant `operator-notes/` and preserve their authority.
5. Run toolchain and authentication preflight. Resolve and report tenant, subscription, environment, and resource scope.
6. Determine whether the request is read, research, validation, or mutation.
7. Apply the central Microsoft Learn call gate. Query it when the user requests Microsoft guidance or the operation depends on current Azure/.NET service, API, CLI, IaC, version, limit, retirement, migration, security, reliability, deployment, or recovery guidance. Reuse only scoped current evidence without a drift signal; record official links, retrieval time, scope, status, and decision effect. Do not call it for a routine repository-proven command whose correctness is established by observed state alone.
8. Inspect actual Azure state with read-only tools. Distinguish unavailable evidence from an empty result.
9. Prefer modifying repository-owned Bicep, Terraform, `azd`, or deployment scripts through `$deliver-azure-repository-change` before applying live state.
10. Require logical purpose-revealing Azure service/resource names within provider constraints; keep internal Azure names out of user-facing UI/copy.
11. Run format, validate, plan, and what-if operations. Treat drift as a decision, not as permission to overwrite either side.
12. For a mutation, present the exact apply card and wait for an explicit response. Approval is valid only for the shown command/tool call and scope.
13. If any command, resource, subscription, permission, or recovery detail changes after approval, invalidate approval and present a new card.
14. Execute the approved operation once. Do not widen scope or retry a materially different operation without approval.
15. Verify resource state and the real application caller. Record observed results, monitoring, cost/security consequences, and recovery status.
16. Reconcile IaC and canonical documentation. Deliver repository changes through the normal delivery route.

## Exact apply card

```markdown
## Azure apply approval

- Tenant: `<tenant-id-and-name>`
- Subscription: `<subscription-id-and-name>`
- Environment: `<declared-environment>`
- Resources: `<exact resource IDs or deployment scope>`
- Action: `<exact MCP tool or command with secret values redacted>`
- Expected effect: `<observable result>`
- Permissions: `<required role/action>`
- Cost/security/reliability impact: `<summary>`
- Recovery: `<rollback or forward-recovery procedure>`
- Validation: `<post-apply checks>`

Approve this exact Azure operation?
```

## References

### `references/azure-safety-and-approval.md`

Defines operation classification, single-use approval, scope identity, destructive-action handling, credential custody, secret redaction, production caution, and retry rules.

### `references/azure-evidence.md`

Defines source classes, Microsoft Learn citation expectations, actual-state evidence, timestamps, caller-backed validation, logs, monitoring, cost, reliability, and evidence limitations.

### `references/iac-and-drift.md`

Defines IaC precedence, what-if, drift classification, emergency direct changes, backport requirements, state-file safety, migration and recovery evidence, and repository-delivery handoff.

## Failure behavior

- Authentication or Azure CLI failure: stop with exact failing probe and do not report zero resources.
- Ambiguous tenant/subscription/environment: ask for selection before resource calls.
- Missing permissions: report the required action and scope; do not seek broader roles automatically.
- No recovery path for a high-impact mutation: refuse apply until one exists.
- Approval denied or absent: preserve the plan and validation evidence without mutating Azure.
- Partial failure: stop retries, collect observed state, protect data, and present bounded recovery choices.
