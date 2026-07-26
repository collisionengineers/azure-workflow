# Azure-operations workflow

## Purpose

Use current official guidance and actual Azure evidence while keeping every live mutation scoped, reversible where possible, explicitly approved, and reconciled with repository-owned desired state.

Use `$explain-repository` for a conceptual Azure/.NET explanation that does not depend on actual resource state. Once the answer requires what a tenant, subscription, deployment, or resource is doing now, this operate workflow owns the read-only evidence even if the final response is educational.

## End-to-end flow

```text
AZURE REQUEST
     |
     v
Read repo authority + IaC + active change record
     |
     v
Tool/auth preflight
     |
     +-- failure --> exact blocker; no empty-state claim; STOP
     |
     v
Resolve tenant + subscription + environment + resource scope
     |
     v
Classify operation
     |
     +-- read/research ------> execute -> record evidence -> END
     |
     +-- validate/what-if ---> execute -> findings?
     |                                      | no -> record -> END
     |                                      | yes -> delivery plan/remediation
     |
     `-- mutate
           |
           v
     update repository IaC first when possible
           |
           v
     validate + plan/what-if + recovery
           |
           v
     present exact apply card
           |
           +-- not approved --> preserve plan; STOP
           |
           `-- approved
                  |
                  v
             execute once
                  |
                  v
             verify actual state + real caller
                  |
                  v
             reconcile IaC/docs/change record -> delivery PR
```

## Preflight

Minimum probes:

- Azure MCP server starts and exposes tools.
- Azure CLI or supported credential chain can identify the current account.
- Tenant ID and name, subscription ID and name, and principal are observable.
- Repository declares or the user selects the intended environment.
- Required resource providers and deployment tools are available for the requested path.

Do not print tokens or run a broad environment dump.

## Scope identity

Every operation record includes:

```text
tenant ID + name
subscription ID + name
environment label
resource group or deployment scope
exact resource IDs when operating on existing resources
credential principal identity where safely available
timestamp in UTC
```

Names without IDs are insufficient for mutations.

## Evidence order

1. Repository-owned product, ADR, architecture, operations, and IaC.
2. Current official Microsoft Learn guidance for unstable service behavior or syntax.
3. Read-only actual Azure state.
4. Repository validation and Azure plan/what-if output.
5. Post-apply actual state and application caller behavior.

State explicitly when sources disagree. Live state proves what exists, not what should exist.

### Microsoft Learn guidance gate

Registration does not mean Learn was consulted. Call it when the user explicitly requests Microsoft guidance or the operation depends on current service/API/CLI/IaC/version/limit/retirement/migration/security/reliability/deployment/recovery behavior. A routine repository-proven command plus observed current resource state does not need a ceremonial documentation query.

Record each material result as an official URL, UTC retrieval time, exact product/version/scope, requirement/recommendation/example status, and decision effect. Reuse scoped evidence only when no drift signal exists. If current guidance is required but neither MCP nor an official fallback is available, block that decision or mutation rather than the unrelated read-only work.

## Desired-state policy

- Prefer Bicep, Terraform, `azd`, or repository deployment scripts already owned by the repository.
- Do not introduce a second IaC framework for convenience.
- Never edit Terraform state directly.
- Treat generated deployment output as evidence/artifact, not committed authority unless repository policy says otherwise.
- A direct emergency change must be documented immediately and followed by a repository change that reconciles desired state.

## Approval validity

Approval is single-use and bound to:

- Exact tenant and subscription IDs.
- Exact resource/deployment scope.
- Exact command or MCP tool with material parameters.
- Expected effect and recovery plan.

Approval expires when any bound value changes, the operation fails partially, the session loses reliable state, or a retry would use different parameters.

## Mutation execution

1. Re-probe authentication and scope immediately before apply.
2. Execute only the approved action.
3. Capture safe output, operation/deployment ID, time, and status.
4. Do not automatically broaden permissions or retry with a destructive alternative.
5. On partial failure, inspect actual state before proposing recovery.

## Post-apply verification

Verify both platform and product behavior:

| Layer | Examples |
| --- | --- |
| Deployment | Provisioning state, deployment operations, drift |
| Identity | Effective principal and least-privilege access |
| Networking | Endpoint reachability, DNS, ingress/egress constraints |
| Configuration | Expected setting present without exposing its secret value |
| Reliability | Health, replicas/zones, probes, recovery path |
| Observability | Logs/metrics/alerts reach expected destinations |
| Product caller | Actual application entry point produces expected outcome |
| Cost | Expected SKU/count and material cost change recorded |

## Special cases

### Destructive action

Deletion, data purge, irreversible migration, key rotation, role removal, and production cutover require explicit destructive wording in the apply card and a recovery/data-protection statement. If recovery is impossible, say so before requesting approval.

### Production

Production is never inferred from naming. Require an explicit environment declaration. Validate rollback/forward recovery, monitoring, blast radius, and maintenance implications before approval.

### Diagnostics

Read-only diagnostics may run automatically. Any restart, scale, configuration update, slot swap, failover, or remediation is a mutation and requires approval.

### Azure CLI permission failure

Report the exact failed path/extension and distinguish local CLI health from Azure authorization. Do not delete or reinstall extensions without separate user authority.
