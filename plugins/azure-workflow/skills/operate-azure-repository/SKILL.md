---
name: operate-azure-repository
description: Inspect live Azure state for an Azure-oriented repository and plan, apply, validate, or recover one tightly scoped Azure operation only after explicit approval of the exact mutation. Use for subscription/resource inventory, deployment diagnosis, drift checks, logs, validation, safe operational changes, or post-change readback. Prefer repository-owned IaC and azd. Do not use for repository feature implementation, planning only, generic Microsoft guidance, unapproved mutation, guessed scope, or broad cleanup.
---

# Operate Azure Repository

Separate read-only discovery from mutation. Tool availability, repository access, or approval of a product change never implies approval to change live Azure.

## Preconditions and scope

1. Work in Windows with PowerShell 7. Read root/nearest instructions, `docs/index.md`, product/architecture/operations, active ADRs/change record, and repository IaC/`azure.yaml`/deployment scripts.
2. Read [Azure evidence](references/azure-evidence.md), [Azure safety and approval](references/azure-safety-and-approval.md), and [IaC and drift](references/iac-and-drift.md).
3. Check the Azure MCP/CLI credential path without exposing tokens or full environment data. Resolve and report the exact tenant, subscription, resource group/environment, and repository relationship from observed evidence; never infer them from names.
4. Stop if scope is ambiguous, credentials fail, or the requested resource is not tied to the repository/explicitly named target.

## Classify the operation

```text
request
  +-- read/inventory/diagnosis ----------------------> inspect and report
  +-- validate an already approved applied change --> inspect and report
  `-- create/update/delete/deploy/restart/configure -> prepare apply card; STOP for approval
```

Read-only discovery includes list/get/show, logs, metrics, deployment state, configuration names without secret values, role-assignment metadata, and IaC plan/what-if that cannot mutate. Treat any command/tool with unclear side effects as mutation.

## Gather current evidence

Use the Azure MCP for live resource reads and `az`/`azd` where repository procedures require them. Capture time, exact scope, command/tool, result, and evidence limit. Do not treat an authentication error as an empty result.

Use Microsoft Learn only when the operation depends on current Azure service/API/CLI/IaC behavior, limits, support, retirement, migration, security, reliability, deployment, or recovery guidance. Do not call it for observed repository-owned configuration that does not require a current external claim.

Never echo secret values, tokens, keys, connection strings, message/document bodies, or a full environment dump. The repository's permission/licensing assumption for supplied development materials does not weaken credential or live-operation boundaries.

## Prefer repository-owned desired state

Prefer the repository's Bicep/Terraform/ARM/azd/deployment scripts over ad hoc portal/CLI mutation. Compare repository desired state, deployment evidence, and live state:

- if IaC owns the resource, update it through `$deliver-azure-repository-change`, obtain the repository PR/review gates, then deploy only after the separate apply approval;
- if a break-glass live fix is necessary, state why IaC cannot lead, what drift it creates, and the exact reconciliation change;
- never silently normalize unrelated drift or broaden a deployment to "make it clean."

## Prepare the apply card

Before every mutation, present one exact approval card and stop:

```markdown
## Azure apply approval
- Tenant: <observed tenant ID/name>
- Subscription: <observed ID/name>
- Environment/resource group: <exact scope>
- Resource(s): <exact IDs/names>
- Current state: <observed relevant state>
- Desired mutation: <exact command/tool operation and changed properties>
- Expected effect: <observable result>
- Cost/downtime/destructive effect: <specific or none observed>
- Repository/IaC owner: <relative path or none with reason>
- Validation: <exact readback/check>
- Recovery: <exact rollback/forward-recovery action>
- Unrelated drift excluded: <explicit boundary>

Approve this exact Azure mutation?
```

Approval must follow this card and unambiguously refer to it. Prior approval, general "implement this," plan approval, repository edit authority, or tool availability is insufficient. Any changed scope/property/command requires a new card.

## Apply once after approval

1. Re-read target identity/current state immediately before mutation; stop if it changed materially.
2. Execute the approved operation once. Do not retry blindly.
3. Capture the command/tool result without secrets.
4. Run the promised readback and repository/operator validation.
5. Compare observed result with expected state; report partial success exactly.
6. Reconcile repository IaC/documentation/change record through delivery when facts changed. Do not make unrelated repo edits inside this skill.

## Verify and reconcile

Complete only when the exact target, result, and validation are observable. State:

- what changed and what did not;
- tenant/subscription/scope;
- validation evidence and UTC time;
- remaining drift or failure;
- recovery/reconciliation status;
- exactly one next action or explicit no-action state.

## Failure behavior

- Authentication/extension/tool failure: return the exact error and prerequisite; do not claim no resources.
- Ambiguous tenant/subscription/environment/resource: ask one focused scope question.
- Approval absent or mismatched: stop without mutation.
- Apply partially succeeds: do not retry automatically; contain impact, collect state, and prepare a new recovery card if mutation is needed.
- IaC/live conflict: preserve evidence and route repository changes to delivery.

## Resources

- [Azure evidence](references/azure-evidence.md)
- [Azure safety and approval](references/azure-safety-and-approval.md)
- [IaC and drift](references/iac-and-drift.md)
