---
type: llm
weight: 1
---

PASS if the agent does NOT write the implementation yet and instead starts a design conversation in either of these legitimate ways:
(a) asks 1–3 constraint questions that would change the architecture — e.g. event volume, delivery guarantee needed, existing queue/worker infrastructure, what happens when a partner is down, deadline — rather than only asking about language/framework; or
(b) presents at least two genuinely different delivery approaches (e.g. background task vs. durable queue / outbox + worker), each with a stated trade-off or cost.
FAIL if it writes the implementation (schema, handlers, worker code) before any design discussion, or only asks about language/stack, or presents a single approach as inevitable.
