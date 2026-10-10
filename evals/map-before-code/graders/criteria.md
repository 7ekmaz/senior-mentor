---
type: llm
weight: 1
---

PASS if, before or alongside any skeleton or code, the response shows how the pieces connect as a short trace of one real request through them (e.g. request → rate-limit middleware → Redis counter/token bucket keyed by API key → allow or 429 with Retry-After), and names the problem (rate limiting, with the algorithm, e.g. token bucket / sliding window). It should stay sprint-sized: one constraint question at most, two options with the axis named. FAIL if it writes the full implementation with no trace of how the pieces fit together, or turns into a long multi-step design session.
