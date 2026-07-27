# Authority and conflict handling

## Source registry

For every relevant human-authored or controlled source, record:

| Path | Content role | Mutation rule | Scope | Status/evidence |
| --- | --- | --- | --- | --- |

Content roles: approved product/operation authority, active controlled/external requirement, draft/discovery input, evidence/reference, or history. Mutation rules: agent-editable, human-edit-only, preserve-in-place, generated-from named source, or archived/removal-authorized.

Never infer either field from a filename such as `operator-notes`, `PRD`, `spec`, or `archive`. An explicit repository/user declaration controls. Unclassified notes remain preserved discovery input until classified.

## Default authority order

1. current explicit user direction;
2. declared active product/operator authority and controlled external requirements;
3. accepted ADRs and design authority within their scope;
4. current architecture/operations documents;
5. code, configuration, tests, CI, IaC, and live reads as evidence of current behavior;
6. draft/discovery sources;
7. historical/superseded material.

Higher authority does not erase observed divergence. Record intended and current state separately.

## Conflict protocol

Create `DOC-CON-NNN` when two sources with the same relevant role materially disagree. State both claims, paths, observable effect, recommended default, and one decision question. Incorporate the answer and rescan affected claims. Do not resolve by newest timestamp, longest file, folder name, or implementation convenience.

Protected sources may remain binding without being edited. Map approved facts into canonical agent-maintained owners only when the repository's mutation rules permit it; otherwise link to the protected owner.
