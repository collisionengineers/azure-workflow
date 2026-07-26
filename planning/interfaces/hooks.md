# Hook contract

## Decision

Version `0.1.0-alpha.1` has no hooks.

The following file must not exist:

```text
plugins/azure-workflow/hooks.json
```

The plugin manifest must not contain a `hooks` property.

## Why

- Durable repository context already has a reliable entry point through root and nested `AGENTS.md` files plus `docs/index.md`.
- A session-start hook would duplicate that routing and could load stale or irrelevant context.
- A tool-preflight hook cannot reliably identify all Azure writes because changes can occur through MCP, Azure CLI, `azd`, Terraform, Bicep deployment commands, or repository scripts.
- Hook command paths and trust records are machine-specific and would weaken portability.
- Current OpenAI plugin documentation supports bundled lifecycle hooks. The installed creator validator still rejects a manifest `hooks` field, so installed behavior and creator validation are not treated as interchangeable evidence.
- No demonstrated workflow failure requires a hook in this plugin. Instructions, deterministic validation, CI, exact-head review, and the explicit Azure mutation gate already own the relevant controls.
- The previous root `hooks.json` is source-project-specific and points to a repository-local script that is absent here; it must be removed during implementation.

## Replacement controls

| Concern a hook might address | Version `0.1.0-alpha.1` control |
| --- | --- |
| Load repository context | `AGENTS.md` routes to `docs/index.md` and nearest local instructions |
| Prevent dirty-tree changes | Every mutating skill begins with `git status --short` and stops if non-empty |
| Prevent unauthorized Azure writes | `operate-azure-repository` requires a single-use explicit apply approval |
| Keep documentation current | Delivery acceptance blocks while canonical docs or the change record are stale |
| Enforce review | Owning workflows invoke the public read-only review skill against the actual PR and cannot complete without an exact-head result |
| Enforce tests | Path-aware local canonical check and required GitHub `verify` status; Markdown-only changes skip code suites |

## Reconsideration criteria

Hooks may be proposed in a future ADR only if all of these are true:

1. A repeated real failure shows the existing instruction/validation/review controls are insufficient.
2. The hook solves a demonstrated failure that repository instructions and deterministic checks cannot solve.
3. The current installed Codex surface and creator/validator agree on the selected hook declaration path.
4. Its paths work from an installed plugin without copying machine-specific scripts into every repository.
5. It has explicit Windows and clean-failure tests and is not the sole safety barrier for destructive or external actions.
