# UI/UX planning

Activate when the change affects visible behavior, interaction, content, accessibility, layout, responsiveness, tokens, visual assets, components, or patterns.

## Read authority first

Read `docs/product/index.md`, applicable product area, root `design/README.md`, governing brand/foundation/token/asset/component/pattern files, source/runtime maps, and current UI code. Separate approved design authority from references or proposals.

## UI contract

For each affected surface record:

- user goal and entry/exit;
- available actions and purpose-revealing labels;
- normal, empty, loading, disabled, validation, error, partial, success, recovery, permission, offline/timeout states as applicable;
- data/rule source and side effects;
- keyboard/focus/semantic/accessibility behavior;
- viewport/responsive behavior;
- content/terminology and internal-Azure wording boundary;
- canonical design/token/asset source and runtime mapping;
- functional, accessibility, and visual evidence.

Do not narrate obvious controls with explanatory sentences or expose internal Azure functions/services in user-facing areas. Do not synthesize logos, fonts, icons, imagery, screenshots, data, or product copy.

## Incremental versus major direction

An incremental change follows current authority and may extend an exercised component/pattern. A major direction changes brand, navigation model, core interaction, visual language, or token foundation and requires explicit human choice before detailed implementation planning.

Future possibilities may shape a small currently exercised seam. Do not add component frameworks, Storybook, token pipelines, abstraction layers, or placeholder variants without current need.
