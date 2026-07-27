# Repository documentation

## Start here

- [Product requirements](product/index.md)
- [Capabilities](product/capabilities.md)
- [Roadmap](roadmap.md)
- [Architecture](architecture.md)
- [Operations](operations.md)
- [Agent mistake log](agent-mistakes.md)
- [Decisions](decisions/)
- [Change records](changes/)
- Visual design: absent; this repository packages a workflow and has no visual application UI.

## Authority order

1. Current explicit user direction.
2. [Product requirements](product/index.md) and active external/controlled requirements declared below.
3. Accepted [ADRs](decisions/) within scope.
4. Current [architecture](architecture.md) and [operations](operations.md).
5. Plugin source, tests, GitHub configuration, and observed tool output as evidence of current behavior.
6. Historical Git revisions of the retired planning and reference-input corpus.

Code proves current behavior, not automatic intended behavior. A discrepancy remains visible until the owning authority and implementation agree.

## Source roles and mutation rules

| Path/source | Content role | Mutation rule | Scope |
| --- | --- | --- | --- |
| `docs/product/` | approved product authority | agent-editable through reviewed changes | purpose, requirements, capabilities, supported boundaries |
| `docs/decisions/` | accepted decision authority | append/supersede through reviewed ADRs | hard-to-reverse architecture/workflow choices |
| `docs/architecture.md` | current architecture authority | same-PR maintenance | package/component/ownership model |
| `docs/operations.md` | current operating authority | same-PR maintenance | build, validate, install, release, recover |
| `docs/changes/` | one change's durable plan/evidence/history | owning workflow only; historical after completion | bounded change decisions and proof |
| `docs/agent-mistakes.md` | improvement evidence | append incidents/corrections only; never rewrite history | qualifying agent mistakes |
| Git history before the alpha implementation | provenance/history | read-only | retired planning pack and earlier reference inputs |
| OpenAI and Microsoft primary documentation | external current evidence | read-only; query when material, do not vendor | Codex/plugin/skill and Azure/.NET facts |

There is no protected human-authored source inside the current working tree. A future declared source is added here with both its content role and mutation rule; a filename alone grants no authority.

## Document ownership

Product documents own intended behavior. Capabilities own stable IDs/allocation. Roadmap owns outcome horizons. GitHub owns actionable work and live state. Architecture owns current boundaries/callers. Operations owns procedures. ADRs own decisions. A change record owns one change's plan and evidence, then becomes history.

## Drift prevention

Every material change declares affected canonical owners and updates them in the same PR. The canonical check validates machine-testable structure, links, schemas, append history, and routing. It does not certify semantic truth; independent exact-head review compares documents with current package/scripts/configuration/callers.
