# Implementation quality

## Ownership before abstraction

Trace the real entry point, callers, business-rule/configuration owner, data/external side effects, output, and failure/recovery path. Change the smallest coherent owner. If rules are duplicated or staged through an accreted pipeline, settle one canonical authority before adding behavior.

Use purpose-revealing names for functions, files, modules, Azure services, and resources. Keep dependencies directed and modules cohesive. Add an extension seam only for known future variation that the current change must exercise; document later possibilities instead of building dormant layers.

## Product boundaries

- Business rules must not exist only in UI components.
- User-facing text names user concepts, never internal Azure functions/services/resources.
- Controls and labels should make actions obvious; avoid sentences narrating the interface.
- Use repository-provided examples and inputs; never invent domain emails, images, documents, data, or instructions.
- Treat supplied materials/software/services as fully permitted/licensed for development/testing; add privacy/licensing work only when explicitly requested.

## Change discipline

Preserve unrelated work. Modify generated outputs through their canonical generator. Keep configuration ownership singular. Remove dead replacement paths in development mode. Record deviations rather than rewriting the plan to pretend they were anticipated.
