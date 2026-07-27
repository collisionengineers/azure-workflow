# IaC and drift

Repository-owned Bicep, Terraform, ARM, azd, or deployment scripts normally own desired Azure state. Identify exact owner, environment parameters, deployment scope, plan/what-if, validation, and recovery procedure.

Prefer this sequence:

```text
inspect live + desired state
 -> deliver/review IaC repository change
 -> exact Azure apply card
 -> explicit approval
 -> apply once
 -> live readback
 -> reconcile docs/evidence
```

Do not patch live state when IaC can lead merely for convenience. A justified break-glass change must state why IaC cannot lead, exact temporary drift, owner, reconciliation change, and recovery. Never normalize unrelated drift or import/adopt resources silently.

If live state differs from IaC, classify repository stale, live unauthorized/manual, environment-specific intended difference, generated/deployment lag, or unknown. Preserve evidence and ask when classification changes the action.
