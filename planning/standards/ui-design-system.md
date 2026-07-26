# Repository UI and design-system standard

## Purpose

Every onboarded repository with a visual user interface has one obvious, durable place for its visual language, approved source assets, component contracts, and cross-component interaction patterns. That place is the root `design/` directory.

`design/` is not a second product specification and is not a copy of runtime UI code. Product behavior and terminology remain under `docs/product/`; application code remains in the framework's normal source tree. The design directory owns the visual contract and maps each source asset or design rule to its runtime implementation.

## Applicability

Onboarding records exactly one line in `docs/product/index.md`:

```markdown
Visual UI: present | absent
```

- `present`: the required `design/` files below must exist and `docs/index.md` and `AGENTS.md` must route to them.
- `absent`: `design/` is not created merely to satisfy a template. If a real visual-identity authority already exists, it may remain and must follow this standard.
- A later change from `absent` to `present` creates the design spine as part of that change.

The decision is based on real user-facing web, desktop, mobile, kiosk, or comparable visual surfaces. A CLI, API, background worker, or infrastructure repository alone does not make the visual UI present.

## Exact target structure

```text
design/
|-- README.md
|-- brand/
|   |-- style.md
|   |-- imagery.md
|   `-- logos/
|       |-- README.md
|       |-- source/                  # conditional: approved editable/master files exist
|       `-- exports/                 # conditional: generated or delivery variants are tracked
|-- foundations/
|   |-- colour.md
|   |-- typography.md
|   |-- spacing-and-layout.md
|   |-- motion.md
|   `-- accessibility.md
|-- tokens/
|   |-- README.md
|   `-- tokens.json                  # conditional: this is the declared canonical token source
|-- assets/
|   |-- icons/
|   |   |-- README.md
|   |   |-- source/                  # conditional
|   |   `-- exports/                 # conditional
|   `-- fonts/
|       |-- README.md
|       `-- source/                  # conditional: repository-owned font files live here
|-- components/
|   `-- index.md
|-- patterns/
|   `-- index.md
`-- references/
    `-- README.md
```

Every shown Markdown file is required when `Visual UI: present`. Conditional directories are created only when they contain real files; Git-hostile empty directories and placeholder binaries are forbidden. A required inventory file records `none` plus the actual rule when an asset class is deliberately absent, for example `No custom logo; product name is rendered as text` or `System font stack; no repository font files`.

## Authority map

| Question | Canonical owner |
| --- | --- |
| What job, workflow, terminology, permission, or state should the user experience? | `docs/product/` plus any active external/controlled requirement routed by `docs/index.md` |
| What is the approved visual character and imagery treatment? | `design/brand/` |
| Which colour, typography, spacing, layout, motion, and accessibility rules apply? | `design/foundations/` |
| Where is the one machine-readable token source? | Path declared in `design/tokens/README.md` |
| Which logo, icon, and font sources are approved and where do their runtime forms go? | Inventories below `design/brand/logos/` and `design/assets/` |
| Which reusable visual components exist and where is their code? | `design/components/index.md` linking to runtime source |
| Which interaction patterns span components or journeys? | `design/patterns/index.md`, linked back to product behavior |
| What does the application currently execute? | Runtime source plus `docs/architecture.md` |
| How will one design change be delivered and proved? | Its `docs/changes/` record and pull request |

A mockup, screenshot, generated concept, or design reference cannot override product authority, the declared token source, or implemented accessibility behavior.

### Surface applicability

`design/README.md` contains a surface map. Every visual rule, token route, source asset, component family, and approved reference states which named user-facing surface it governs—for example internal application, public website, email, or generated document—and which surfaces it explicitly does not govern.

```markdown
| Surface | Product authority | Brand/foundations | Token/runtime source | Asset source | Proof owner |
| --- | --- | --- | --- | --- | --- |
```

A corporate website or document brand kit cannot silently govern an internal application that it excludes. When existing surfaces intentionally differ, onboarding records the boundary and preserves each current runtime owner; it does not merge palettes, fonts, assets, or interaction rules merely to make the folder look uniform. The repository still declares one canonical token-source route under the current contract, and any non-tokenized surface is explicit rather than a competing unlabelled token owner.

## Required file contracts

### `design/README.md`

```markdown
# Design system

## Authority and scope
## Visual UI surfaces
## Repository map
## Canonical token source
## Source-to-runtime mapping
## Change and review rules
```

It names real UI roots and relative links. It does not repeat the product feature catalog or component API.

### Brand

`brand/style.md` owns visual principles, personality, shape, density, and explicitly rejected treatments. `brand/imagery.md` owns photographic/illustrative treatment, cropping, background, and repository-provided example rules. Neither invents marketing prose or product behavior.

`brand/logos/README.md` uses this inventory:

```markdown
| Asset ID | Purpose | Canonical source | Runtime/export path | Format/variants | Generation or copy command | Validation |
| --- | --- | --- | --- | --- | --- | --- |
```

When a master logo is repository-owned, the approved editable/vector source normally lives in `source/`; generated sizes or formats may live in `exports/`. If the application consumes the master directly or an existing runtime path is already canonical, the inventory links to that path instead of creating a duplicate.

### Foundations

- `colour.md`: semantic roles, light/dark/high-contrast behavior where supported, contrast/non-colour rules, and token links. Hex/RGB values are not manually duplicated when tokens own them.
- `typography.md`: families, scale, weights, line heights, fallback stacks, content constraints, and font-inventory links.
- `spacing-and-layout.md`: spacing scale, grids, density, containers, breakpoints or explicit fixed-viewport boundary.
- `motion.md`: purposeful transitions, durations/easing through tokens where used, interruption, and reduced-motion behavior.
- `accessibility.md`: repository-wide visual/interaction requirements and the applicable [WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/) target; feature-specific state and semantic acceptance remains in each change record.

These files describe approved rules and reference token names. They do not copy every CSS declaration.

### Tokens

There is exactly one canonical token source:

```text
existing token system found?
        | yes
        +--> keep it canonical; design/tokens/README.md links to it
        |
        no
        v
new shared token system currently needed?
        | no
        +--> README records no machine-readable token source yet
        |
        yes
        v
design/tokens/tokens.json becomes canonical
```

For a new JSON token source, use the stable [Design Tokens Community Group 2025.10 format](https://www.designtokens.org/tr/2025.10/format/) unless the target framework has an established incompatible owner. DTCG is an interoperability default, not permission to replace a working repository token system.

`design/tokens/README.md` records:

- the one canonical relative path or `none`;
- format/version;
- generated runtime destinations;
- exact generation command when generation exists;
- exact validation command; and
- the rule that generated outputs are not manually edited.

Do not add a token transformer, theme engine, or generated output merely because this directory exists.

### Icons and fonts

Each inventory maps a logical asset ID to one canonical source and every tracked runtime/export destination. The font inventory also records family, weight/style coverage, loading method, fallback stack, and validation. The icon inventory records size/view-box, colour behavior, accessible-name policy, and code/component mapping where applicable.

No synthetic logo, icon, font, screenshot, or imagery is created during onboarding. Only repository-provided or explicitly user-approved assets are admitted.

### Components and patterns

`components/index.md` is a route, not duplicated implementation documentation:

```markdown
| Component | Purpose | States/variants | Design authority | Runtime source | Proof/example |
| --- | --- | --- | --- | --- | --- |
```

`patterns/index.md` owns cross-component interaction patterns such as validation, confirmation, empty/loading/error presentation, navigation, selection, and notifications. Each row links to the canonical product journey and implementation owner. A one-off layout does not become a pattern prematurely.

### References

`references/README.md` inventories only real approved screenshots, supplied mockups, explorations, or external references. Every item is labelled `approved`, `reference-only`, or `superseded`, with its owner and successor where applicable. Reference material is evidence, never an implicit design decision.

## Source asset and generated-output rules

1. One canonical source exists for each asset; inventories link rather than duplicate.
2. Source-to-runtime transformations are reproducible or explicitly manual and named.
3. Generated exports are labelled and never hand-edited.
4. All documentation and manifests use repository-relative paths; local absolute paths are forbidden.
5. Renames/removals update the inventory, runtime callers, design references, and proof in one change.
6. Git LFS is introduced only for materially large binaries after repository evidence justifies it; it is not a default design-folder dependency. See the [official Git LFS project](https://git-lfs.com/).

## Planning, delivery, and review behavior

For every UI-impacting change:

```text
product job and states
        |
        v
design authority + existing runtime pattern
        |
        v
change-record UI contract
        |
        v
code + any canonical design update + generated outputs
        |
        v
functional/accessibility/visual proof
        |
        v
fresh complete PR review
```

- Planning reads `design/` before proposing visual choices and states exactly which design files will change or why none should.
- Delivery changes a design rule, source asset, token, component route, runtime implementation, and relevant proof together.
- Review checks source-to-runtime mapping, token uniqueness, supported states/viewports/inputs, accessibility, user-facing wording, and absence of unsupported visual drift.
- A visual change that intentionally departs from the current system records the durable reason in the change record; an ADR is added only when the choice is architectural or hard to reverse.

## Onboarding conversion

The onboarding workflow inventories existing style guides, design files, logos, icons, fonts, tokens/themes, CSS variables, component libraries, story/example systems, screenshots, mockups, runtime asset roots, and the surface each source actually governs. It then:

1. identifies each current authority and duplicate;
2. creates a surface-applicability map and preserves the working runtime/token system by default;
3. creates the required design spine from templates;
4. moves or links approved source assets only after caller and history checks;
5. records one source-to-runtime mapping per asset/token system;
6. updates `docs/index.md`, `AGENTS.md`, and product UI status; and
7. identifies asset duplicates by content without assuming that same filename means same authority; and
8. removes superseded design copies only after surface applicability, links, runtime callers, visual proof, and recovery are established.

Onboarding does not create Storybook, a component library, a new CSS architecture, tokens, themes, or brand assets unless the repository already needs and authorizes that current capability.

## Deterministic validation

When `Visual UI: present`, repository validation checks:

- every required design Markdown file and heading exists;
- `docs/index.md` and `AGENTS.md` route to `design/README.md`;
- `design/README.md` names every discovered visual surface and no rule/asset authority has ambiguous or contradictory applicability;
- the token README declares exactly one canonical source or `none` and its relative link resolves;
- source/runtime/export links in asset inventories resolve or are explicitly generated destinations;
- duplicate canonical token files and hand-edited generated-output claims fail;
- forbidden absolute local paths fail;
- conditional asset directories contain real files; and
- no placeholder or synthetic asset ships from the onboarding templates.

Validation checks structure and declared mappings. Functional, visual, and accessibility correctness remain proportional delivery/review evidence.

## Rejected alternatives

- `docs/ui/`: poor fit for master SVGs, font files, generated asset variants, and machine-readable tokens.
- runtime source alone: makes brand/foundation authority and source-asset provenance difficult to find and encourages code to become accidental product intent.
- copying all runtime assets into `design/`: creates two owners and guaranteed drift.
- requiring design machinery in backend-only repositories: adds empty structure with no current owner or consumer.
- a separate UI skill: planning and delivery already own the authorization and repository endpoint; UI remains a conditional reference route.
