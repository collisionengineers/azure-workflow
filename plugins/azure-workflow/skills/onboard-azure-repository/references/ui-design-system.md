# UI design-system onboarding

Activate only when `Visual UI: present` or an existing design corpus must be preserved. The repository root owns a `design/` directory for durable visual authority; runtime source/assets remain in their normal application paths.

## Inventory and map

For each product surface, inventory brand/style, logos, imagery, colour, typography/fonts, spacing/layout, motion, accessibility, tokens/themes, icons, components, patterns, screenshots/mockups/reference designs, canonical source files, generated outputs, and runtime consumers.

Record one source-to-runtime map. Preserve existing approved systems; do not replace them for stylistic preference. Establish one canonical token source only when shared tokens are currently exercised. Never create synthetic logos, fonts, icons, screenshots, imagery, copy, token values, or placeholder brand claims.

## Required design spine

Use the conditional templates under `assets/repository/design/`:

```text
design/README.md
design/brand/{style.md,imagery.md,logos/README.md}
design/foundations/{colour,typography,spacing-and-layout,motion,accessibility}.md
design/tokens/README.md
design/assets/{icons,fonts}/README.md
design/components/index.md
design/patterns/index.md
design/references/README.md
```

Every document names its governed surfaces and canonical source/runtime paths. The design directory stores descriptive authority and approved source assets, not duplicated build outputs.

## User-facing rules

Functionality should be apparent from controls and labels. Do not scatter explanatory narration through the app, expose internal Azure resource/function/service names, or label user concepts with infrastructure wording. Plan actions, states, errors, recovery, accessibility, responsiveness, and content before visual polish.

## Parity

Removal or relocation requires asset identity/checksum or approved mapping, token/source/runtime consistency, link resolution, and fresh semantic/visual review. Structural existence alone is not proof.
