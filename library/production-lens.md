# The production lens

The questions a senior engineer asks of any code or design before it meets real traffic. Used by production-review, by code reviews in code-along, by "break it on purpose" in crash-course, and by the deep dives in system-design.

**Pitch it to the level** ([levels.md](levels.md)):
- L1–L2: items marked ●.
- L3–L4: ● and ◐.
- L5+: everything, at fleet scale.

For each finding, say what fails, under what condition, how you'd see it in production, and the fix. Then name the fundamental ([pedagogy.md](pedagogy.md#unbury-the-fundamental)).

## 1. Concurrency and shared state
- ● Is any mutable state touched by more than one thread, task, request or process? Who else writes it?
- ● Check-then-act (`if not exists: create`) without atomicity → a race. Use a unique constraint, a compare-and-swap or a lock.
- ◐ Lock scope and ordering: held across I/O? Two locks taken in different orders → deadlock.
- ◐ Async code calling blocking I/O → the event loop stalls for everyone.
- ○ Memory visibility / happens-before across threads. Lock-free code correctness.

## 2. Throughput, latency and resource bounds
- ● N+1 queries; work inside loops that belongs outside; loading everything into memory.
- ◐ Every queue, buffer, cache and pool is **bounded**, with a stated policy when full (block, drop, shed, 429).
- ◐ **Backpressure**: when the consumer is slower than the producer, where does the excess go?
- ◐ Little's law check: `in-flight = arrival rate × latency`. Do the pool and worker sizes fit it?
- ○ Tail latency: fan-out multiplies p99. Coordinated omission in benchmarks. The utilization knee (~70–80%).

## 3. Failure handling
- ● Every network or disk call can fail. Is the error handled, surfaced, and not swallowed?
- ◐ **Timeouts** on every outbound call, shorter than the caller's own timeout.
- ◐ **Retries** with exponential backoff and jitter, a max attempt count, and **only for idempotent operations**. Retry storms amplify outages.
- ◐ **Idempotency**: is a replay safe? Use idempotency keys, upserts, dedup by message id.
- ○ Circuit breakers, bulkheads, graceful degradation, load shedding, failure domains, blast radius.

## 4. Data correctness
- ● Input validation at the boundary; parameterized queries.
- ◐ Transactions span exactly the invariant. The isolation level is chosen, not defaulted (lost updates, write skew).
- ◐ Dual writes (DB + queue, DB + cache) → use the outbox pattern or accept inconsistency explicitly.
- ○ Schema migrations that are backward compatible (expand → migrate → contract); ordering and exactly-once myths in messaging.

## 5. Observability
- ● Errors are logged with context (ids, not just "failed").
- ◐ Structured logs, the RED metrics (rate, errors, duration) per endpoint, a health check that checks dependencies, and trace ids across hops.
- ○ SLOs and alerting on symptoms, not causes. Dashboards someone else can read at 3 a.m.

## 6. Operability and change
- ● Config and secrets come from the environment, never hard-coded.
- ◐ Can it be deployed and **rolled back** safely? Is there a feature flag for the risky part?
- ◐ Graceful shutdown: in-flight work drained, consumers acked or nacked.
- ○ Capacity headroom, cost, who is on call for it, and runbooks.

## 7. Security
- ● Injection (SQL, shell, template); secrets in logs; authn/authz on every endpoint.
- ◐ Least privilege; rate limiting; SSRF and path traversal on user-supplied URLs and paths.
- ○ Threat model, tenant isolation, supply chain.

## Severity words (use consistently)

- **Ship-blocker:** will cause data loss, an outage, or a security hole under realistic conditions.
- **Fix soon:** degrades under load or during incidents.
- **Worth knowing:** fine at today's scale; name the tripwire that makes it matter.
