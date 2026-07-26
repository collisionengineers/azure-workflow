# Azure evidence

## Scope resolution

Use observed authentication/account data to report tenant ID/name, subscription ID/name, environment/resource group, resource IDs, and time. Confirm the target's repository relationship from IaC/config/operations or explicit user scope. Never infer scope from a repository/resource name.

## Read-only evidence

Prefer Azure MCP for discoverable live reads; use `az`/`azd` where repository procedures or missing MCP coverage require it. Safe reads include list/show/get, deployment state, logs/metrics, resource properties, and role-assignment metadata without secrets. A plan/what-if is read-only only when the specific tool guarantees no mutation.

Capture tool/command, relevant inputs, UTC time, result, and limitation. An auth/permission/tool error is not an empty result.

## Sensitive output

Never print credentials, tokens, keys, connection strings, secret values, message/document bodies, or full environment/config dumps. Prefer names/IDs and redact secret-bearing values while retaining evidence that a setting exists.
