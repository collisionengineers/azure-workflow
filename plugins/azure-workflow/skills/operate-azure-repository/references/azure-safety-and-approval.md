# Azure mutation safety and approval

Treat create, update, delete, deploy, restart, scale, role/configuration/secret/network change, data operation, and any uncertain side effect as mutation.

Before mutation, provide exact tenant/subscription/scope/resources, observed current state, desired operation and changed properties, expected effect, cost/downtime/destructive impact, IaC owner, validation, recovery, and excluded drift. Then ask approval for that exact card and stop.

Approval is invalid when it predates the card, refers generally to implementation/deployment, or the target/command/property/effect has changed. Re-read state immediately before apply; material drift requires a new card.

Execute once after approval, validate through a read, and report partial failure exactly. Never retry, expand scope, delete/recreate, use admin bypass, or “clean up” unrelated resources without a new approved card. Prepare recovery as a new mutation when needed.
