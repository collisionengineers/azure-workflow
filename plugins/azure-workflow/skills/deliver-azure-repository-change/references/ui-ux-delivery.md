# UI/UX delivery

Read the planned UI contract and governing `design/` documents before editing. Trace each affected surface to its component/state/rule/data owner and canonical design/token/asset source.

Implement the required normal, empty, loading, disabled, validation, error, partial, success, recovery, permission, offline/timeout states as applicable. Preserve keyboard/focus/semantic/accessibility and viewport/responsive behavior. Keep business rules outside presentation-only code.

Use logical user concepts and concise controls/labels. Do not narrate obvious actions with explanatory sentences or mention internal Azure resources/functions/services to users. Do not fabricate logos, fonts, icons, imagery, screenshots, data, or product copy.

Update design authority, token/source declarations, asset inventories, components/patterns, and runtime mappings in the same PR. Edit generated assets through their source/generator. Do not introduce a second token owner.

Verify through representative user paths with repository-provided examples: behavior/state transitions, keyboard/accessibility, relevant viewports, and visual comparison against approved references. A screenshot alone cannot prove behavior; unit tests alone cannot prove layout/appearance.
