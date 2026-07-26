# UI and UX planning, implementation, and review

## Decision

UI/UX is a conditional route inside planning and delivery, not a separate public skill in the first plugin release.

Reasons:

- “Plan this screen” and “implement this screen” share the same durable change record and repository endpoint as other changes.
- A competing UI skill would overlap the planning/delivery triggers and risk two plans or two owners.
- UI-specific inputs and checks are substantial enough for dedicated references, but they remain part of the parent goal.
- If standalone design handoffs become a repeated independent user goal, promote them in a later plugin version using the public-skill test in [skill boundaries](../standards/skill-boundaries.md).

## Trigger classifier

Load the UI/UX route when the request or proposed diff affects any of:

- route/page/screen/navigation structure;
- user-visible workflow or interaction;
- forms, validation, empty/loading/error/permission states;
- component layout or styling;
- responsive or input-device behavior;
- user-facing copy, labels, status names, or notifications;
- accessibility semantics, focus, keyboard, contrast, or motion; or
- visual assets/design-system tokens.

```text
UI impact?
   | no
   `--------------------> normal plan/delivery
   |
   yes
   v
existing local pattern and bounded change?
   | yes
   +--------------------> incremental UI route
   |
   no / major shell, journey, or design direction
   v
major UI route + explicit direction approval
```

## Authority order

Before planning UI:

1. Current user instruction.
2. Applicable declared product/external requirements and relevant discovery/evidence sources, using their recorded roles.
3. Canonical product behavior and terminology.
4. Root `design/` visual authority when `docs/product/index.md` declares `Visual UI: present`.
5. Approved UI/design ADR or product-area contract.
6. Existing runtime tokens, components, routes, and real screenshots mapped by `design/`.
7. Current implementation as evidence, not automatic intent.
8. Unapproved concepts as reference only.

Do not derive product policy from a mockup. Do not let an attractive existing component override a settled operator workflow.

## Planning inputs

Inspect:

- user/role and permission;
- real entry point and preceding/following workflow;
- commands/queries and owning backend use cases;
- data values, provenance, validation, and conflict behavior;
- supported device/viewport and input modes;
- current components/tokens/assets/fonts/icons;
- `design/README.md`, brand/foundation rules, token-source declaration, asset inventories, component/pattern indexes, and approved/superseded reference status;
- current screenshots or a locally running application when available;
- existing automated/manual UI proof; and
- user-facing language constraints.

Repository-provided emails, documents, images, and data may be used. Do not fabricate synthetic domain emails, images, documents, or instructions for UI test data.

## Required UI contract in the change record

Every material UI plan contains:

| Section | Required content |
| --- | --- |
| User and job | Named user/role, goal, entry, successful exit |
| Journey | Ordered interaction steps and navigation consequences |
| Information hierarchy | What must be visible, grouped, progressive, or hidden |
| Action mapping | Each user action -> real command/query/policy owner -> success/failure result |
| State matrix | Loading, empty, success, validation, permission denied, conflict, dependency failure, retry/recovery |
| Content/copy | Exact labels/status terminology where material; no internal Azure wording or narrated obvious functions |
| Accessibility | Semantics, label/name, keyboard order, focus, error association, contrast/non-colour cue, reduced motion as applicable |
| Viewport/input | Supported narrow/standard/wide or explicit desktop-only boundary; pointer/keyboard/touch requirements derived from product authority |
| Reuse | Existing components/tokens/assets used and any justified new component |
| Design authority | Exact `design/` files and source/runtime mappings changed, or why the current design system remains authoritative without edits |
| Acceptance evidence | Functional caller proof, manual interaction checks, visual evidence, and targeted automation |

### State matrix template

```markdown
| State | Trigger | User sees | Available action | Backend effect | Recovery/proof |
| --- | --- | --- | --- | --- | --- |
| Loading | Query pending | Existing layout with bounded progress indication | Cancel/back if supported | No mutation | Slow-path/manual check |
| Empty | Valid query has no rows | Clear empty result and next valid action | ... | ... | ... |
| Validation | Submitted value invalid | Field-associated error and retained input | Correct/resubmit | No accepted mutation | ... |
| Dependency failure | Owning service fails | Purposeful error without internal service names | Retry or safe exit | No duplicate action | ... |
```

Only applicable states are required, but “not applicable” needs a reason for a material user journey.

## Incremental UI route

Use when the repository already has an approved shell/design system and the change is bounded.

1. Capture baseline route, screenshot/state, component owner, and current behavior.
2. Map the requested change onto existing components and tokens.
3. Write the UI contract sections relevant to the change.
4. Ask the user only about a material product/visual decision that authority cannot resolve.
5. Plan the smallest end-to-end slice, including backend action mapping and failure state.
6. Continue to implementation or stop at the requested plan endpoint.

Do not generate three concepts for a routine field, button, validation correction, or existing-pattern screen.

## Major UI route

Use when creating or replacing a shell, navigation model, core journey, information architecture, or visual direction.

```text
requirements + real workflow inventory
              |
              v
direction-neutral UI contract
              |
              v
2-3 materially different low-fidelity directions
              |
              v
fresh requirements/UX review
              |
              v
explicit user selection
              |
              v
implementation-ready contract
```

Rules:

- Directions differ in workflow/information architecture, not merely color or decoration.
- Low-fidelity HTML/CSS, text wireframes, or diagrams are preferred because they are inspectable and easy to revise.
- Visual-image generation is optional, never a mandatory dependency, and only follows an approved direction.
- An image is a concept, not product authority, implementation, or acceptance evidence.
- Record the selected direction and rejected trade-offs in the change record or an ADR only when the choice is durable and hard to reverse.

## User-facing wording rules

- Buttons and labels state the action or destination directly.
- Do not include “dev copy,” internal/weird wording, or prose that narrates obvious controls.
- Do not expose Azure Function names, resource names, queue/topic names, storage accounts, internal workflows, or deployment language.
- Errors explain the user-relevant problem and safe next action without leaking implementation details.
- Status names match product authority; do not invent synonyms for visual variety.
- Destructive/irreversible actions name their effect and require the product-authorized confirmation pattern.

## Implementation route

1. Re-run the application and capture the relevant baseline when possible.
2. Implement through the real route and existing policy owner; do not create UI-only business rules.
3. Reuse approved components/tokens before adding a new abstraction.
4. When the approved visual rule, canonical source asset, token set, component route, or interaction pattern changes, update its `design/` owner and source-to-runtime mapping in the same change. Never hand-edit a declared generated output.
5. Implement the complete applicable state matrix, not only the happy state.
6. Use purpose-revealing component, handler, CSS token, and test names.
7. Keep product copy out of internal Azure/configuration identifiers.
8. Add only tests that catch a plausible regression at the cheapest valuable layer.
9. Exercise the real route manually or through the repository's browser/UI harness.
10. Capture post-change visual evidence for the reviewed states and supported viewport/input boundary.
11. Update product documentation for intended interaction and architecture/operations only when their boundaries changed.

Do not introduce a screenshot-diff service, component library, design-token framework, responsive system, or end-to-end test suite merely because one UI change exists. Reuse the repository's system or add the smallest exercised element.

## Proportional UI proof

| Change | Minimum proof |
| --- | --- |
| Copy/label only | Rendered location, terminology check, relevant accessibility name, docs-path checks |
| Existing component behavior | Focused component/handler check plus manual real-route success and failure state |
| New form/workflow | Validation/permission/failure paths, keyboard/focus, real command mapping, supported viewports, fresh review |
| Major shell/navigation | All primary journeys, role/permission boundaries, responsive contract, accessibility review, visual evidence, explicit selected direction |
| High-risk/destructive UI | Server-side policy proof, stale/double-submit/idempotency behavior, confirmation/recovery, security review |

Automated accessibility or browser tests are used when already available or when the regression value justifies them. Manual checks are recorded honestly; they are not described as automated proof.

## Independent review additions

The fresh reviewer checks:

- every visible action maps to the correct real owner/caller;
- no required state is omitted or contradictory;
- permission and failure behavior fail safely;
- the UI does not narrate itself or reveal internal Azure terms;
- labels/statuses match product authority;
- keyboard, focus, semantics, errors, contrast/non-colour cues, and supported viewport boundaries are addressed;
- new abstraction/design-system work is justified by current use; and
- the declared token source remains unique and every changed logo/icon/font/design source maps to its actual runtime consumer/export; and
- screenshots/concepts are evidence only and use no prohibited fabricated domain material.

## Completion gates

Plan-only UI work is complete when:

- the direction-neutral contract is decision-complete;
- any material major-direction choice is approved;
- real action/caller mapping and all applicable states are specified;
- acceptance evidence is planned; and
- standard/high-risk fresh plan review has no required finding.

Delivered UI work is complete when:

- the real route behaves as specified;
- applicable states and permissions are proven;
- supported viewport/input and accessibility checks are recorded;
- fresh review is clear;
- canonical documentation is current; and
- applicable `design/` authority, asset inventories, and source/runtime mappings are current; and
- the normal delivery/CI gates pass.

## Packaged reference split

```text
plan-azure-repository-change/references/
`-- ui-ux-planning.md

deliver-azure-repository-change/references/
`-- ui-ux-delivery.md
```

The planning reference contains the classifier, inputs, design-authority inspection, UI contract, incremental/major route, and decision gate. The delivery reference contains design/source synchronization, implementation, proportional proof, wording, and review additions. Each is directly linked from its owning `SKILL.md` and includes the applicable rules from [the repository UI/design-system standard](../standards/ui-design-system.md) without requiring a separate public skill.
