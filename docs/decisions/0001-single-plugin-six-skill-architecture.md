# ADR 0001: One plugin with six goal-based skills

- Status: accepted
- Date: 2026-07-26

## Context

Earlier workflow attempts split lifecycle stages and concerns across many plugins/skills, copied upstream material, and added task-state machinery. Routing, authority, review, and repair became hard to understand. The replacement must own the full repository lifecycle while staying legible, reusable across Azure projects, and safe for a non-coder.

## Decision

Ship one `azure-workflow` plugin with exactly six public skills: onboard, plan, deliver, explain, review PR, and operate Azure. A skill exists only for a standalone user outcome with a distinct authorization/stopping boundary and success criterion.

UI/UX, documentation, testing/CI, GitHub, versioning, risk, and .NET are conditional procedures/references within those workflows. Package exactly Azure MCP and Microsoft Learn MCP. Use Git/`gh` for GitHub. Add no hook, app, background state, or workflow database.

## Consequences

- Public routing is understandable and each skill has a clear endpoint.
- Shared lifecycle policy has one owner; conditional detail loads only when relevant.
- Actual PR review remains independent/read-only and delivery owns remediation.
- Azure mutation has a separate exact-approval boundary.
- New skills require evidence, not symmetry.
- Some workflows are substantial, so direct references and deterministic helpers are required to keep entry points concise.
