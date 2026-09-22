# Production engineering

Domain: production · Status: **stub** — concept list and edges only; lessons build details from general knowledge. Canon: SRE book + workbook, Release It!, Accelerate, Observability Engineering, OWASP

## What LLM answers usually gloss over
- How you'd know it's broken before users tell you.
- How to roll it back in minutes, and what isn't reversible (migrations, sent emails).
- The security boundary: every input is hostile until validated.

## Concepts
- reading-stack-traces-and-logs — L1 — requires: —
- structured-logging — L3 — requires: reading-stack-traces-and-logs
- metrics-red-use — L3 — requires: structured-logging (see performance.md)
- health-checks — L3 — requires: —
- distributed-tracing — L4 — requires: metrics-red-use
- slos-and-error-budgets — L4 — requires: metrics-red-use
- alerting-on-symptoms — L4 — requires: slos-and-error-budgets
- config-and-secrets — L2 — requires: —
- deploys-and-rollbacks — L4 — requires: health-checks
- feature-flags — L4 — requires: deploys-and-rollbacks
- backward-compatible-migrations — L4 — requires: deploys-and-rollbacks
- graceful-shutdown — L4 — requires: health-checks
- incident-response-and-postmortems — L4 — requires: alerting-on-symptoms
- injection-and-input-validation — L2 — requires: —
- authn-authz — L3 — requires: injection-and-input-validation
- blast-radius-design — L6 — requires: failure-domains
