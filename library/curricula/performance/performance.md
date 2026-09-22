# Performance and throughput

Domain: performance · Levels covered: L1–L6 · Canon: *Systems Performance* (Gregg), "The Tail at Scale", "How NOT to Measure Latency", *High Performance Browser Networking*, Use The Index Luke

## What LLM answers usually gloss over

- **No measurement.** Generated "optimizations" come without a profile, a baseline or a target.
- Averages hide the problem. Users feel **p99**, and fan-out makes p99 the common case.
- Latency and throughput are different goals, and optimizing one can hurt the other (batching).
- Every pool, queue and cache has a size that should be **derived** (Little's law), not guessed.
- A cache is a consistency decision, not just a speed-up. Invalidation and stampedes are the real cost.
- Servers fall off a cliff near saturation (the utilization knee), not gracefully.

## Concepts

### latency-vs-throughput — L1
requires: —
**Core:** Latency is the time for one operation. Throughput is operations per unit time. A highway: the speed limit (latency) vs the number of lanes (throughput). Batching raises throughput and raises latency.
**Misconceptions:** "faster requests always mean more throughput"; "throughput is just 1/latency" (only with no concurrency).
**MCQ:** A service handles one request at a time at 50 ms each. You make it process 10 concurrently, and per-request latency rises to 60 ms. Throughput? — (a) *correct:* ~167 req/s, up from 20; (b) down, because latency rose (misconception: conflating the two); (c) unchanged at 20 req/s (misconception); (d) exactly 200 req/s (misconception: ignores the latency increase).
**Read:** *Systems Performance*, ch. 2 "Methodologies" (terminology).

### latency-numbers — L2
requires: latency-vs-throughput
**Core:** Orders of magnitude every engineer should carry:
- L1 cache ~1 ns
- main memory ~100 ns
- SSD random read ~100 µs
- same-datacenter round trip ~0.5 ms
- cross-continent round trip ~50–150 ms

A network hop costs as much as ~a million memory reads, so chatty service calls dominate.
**Misconceptions:** "the DB query is the slow part" (often it's the N sequential round trips).
**MCQ:** A page makes 40 sequential calls to a service in the same datacenter (1 ms each, including the round trip). The fastest win? — (a) *correct:* batch them or parallelize them (~40 ms → ~1–5 ms); (b) a faster CPU (misconception); (c) add an index (misconception: not a query problem); (d) HTTP/2 alone (misconception: sequential dependency remains).

### n-plus-one — L1
requires: latency-numbers
**Core:** One query for the list plus one per item: N+1 round trips. Fix it with a join, `IN (…)`, or the ORM's eager loading.
**Misconceptions:** "the ORM handles it".
**Exercise:** find an N+1 with query logging, fix it, and measure.

### measure-first-profiling — L3
requires: latency-vs-throughput
**Core:** Establish a baseline, a target, and a profile *before* changing code. CPU profile and flame graph for compute; wall-clock and off-CPU profiles for waits. Optimize the widest frame on the critical path.
**Misconceptions:** "I know where it's slow" (intuition is usually wrong); "micro-benchmarks predict production".
**MCQ:** An endpoint takes 900 ms. The CPU profile shows 30 ms of CPU. Where's the time? — (a) *correct:* off-CPU: waiting on I/O, locks or downstream calls; use tracing / off-CPU profiling; (b) the profiler is broken (misconception); (c) GC (possible, but it would show up as CPU); (d) the JIT (misconception).
**Read:** Gregg, flame graphs; *Systems Performance*, the CPU and off-CPU analysis chapters.

### caching — L3
requires: latency-numbers · related: consistency-models
**Core:** Trade freshness for speed. Choose:
- a pattern: cache-aside, read-through, write-through or write-behind;
- the TTL and the invalidation rule;
- what happens on a miss storm.

Hit ratio sets the benefit. Invalidation sets the bug count.
**Misconceptions:** "cache everything"; "TTL solves invalidation" (bounded staleness is still staleness); "the cache can't hurt availability" (cold-start stampede).
**MCQ:** A popular key's TTL expires, and 5,000 concurrent requests miss at once and hit the DB. What is this, and what's the fix? — (a) *correct:* a cache stampede; single-flight / request coalescing, or early probabilistic refresh; (b) cache poisoning; add auth (misconception); (c) a hot partition; add shards (misconception); (d) normal; raise the TTL (misconception: delays, doesn't fix).
**Exercise:** implement single-flight around a slow loader.

### batching-and-amortization — L3
requires: latency-vs-throughput
**Core:** Pay the fixed cost once per batch (a round trip, fsync, a syscall). Tune batch size against added latency (size OR time limit, whichever first).
**Misconceptions:** "bigger batches are always better" (latency and memory grow; retries get bigger).

### littles-law — L4
requires: latency-vs-throughput
**Core:** `L = λ × W`: items in the system = arrival rate × time in the system. It sizes pools, workers and queues: 2,000 req/s × 50 ms = 100 concurrent requests in flight, so a pool of 20 DB connections at 50 ms per query caps you at 400 queries/s.
**Misconceptions:** "pool size is a tuning guess"; "more connections = more throughput" (the DB saturates; see the knee).
**MCQ:** 1,500 req/s, and each request holds a DB connection for 20 ms. Minimum pool size to avoid queueing on average? — (a) *correct:* 30; (b) 1,500 (misconception: one per request per second); (c) 75 (misconception: arithmetic with the wrong unit); (d) 20 (misconception: equals the latency number).
**Exercise:** derive the worker count for a queue consumer from the target rate and per-message time; then verify with a load test.
**Read:** *Systems Performance*, ch. 2 (queueing theory section).

### utilization-knee — L4
requires: littles-law
**Core:** Queueing delay grows non-linearly with utilization. For simple queues, wait ∝ ρ/(1−ρ): 50% → 1×, 80% → 4×, 90% → 9×, 95% → 19×. Run hot components at 60–75% with headroom for spikes.
**Misconceptions:** "90% CPU means 10% spare capacity".
**MCQ:** A service at 60% utilization has p99 = 40 ms. Traffic grows so utilization hits 90%. p99 roughly? — (a) *correct:* several times higher, possibly 4–6×+, because queueing explodes near saturation; (b) 60 ms, linear (misconception); (c) unchanged until 100% (misconception); (d) lower, thanks to warmed caches (misconception).

### tail-latency — L4
requires: littles-law · related: fan-out
**Core:** p99 is what the slowest 1% feel, and it's what users hit on any page that makes many calls. With fan-out to N backends, P(at least one slow) = 1 − 0.99^N: 100 backends → 63% of requests hit a p99. Mitigations: hedged or backup requests, timeouts with fallbacks, reducing variance (GC, noisy neighbours), fewer hops.
**Misconceptions:** "average latency is fine, so users are fine"; "p99 is outliers we can ignore".
**MCQ:** Each backend has p99 = 1 s (median 10 ms). A request fans out to 100 backends and waits for all. What fraction of requests take ≥ 1 s? — (a) *correct:* ~63%; (b) 1% (misconception: the tail doesn't compound); (c) 100% (misconception); (d) ~10% (misconception).
**Read:** Dean & Barroso, "The Tail at Scale".

### load-testing-properly — L4
requires: tail-latency
**Core:** Test open-loop (a fixed arrival rate), not just closed-loop, or **coordinated omission** hides stalls. Ramp to find the knee. Test with production-like data and the cache hit ratio. Report the percentiles and the error rate at each step.
**Misconceptions:** "wrk with 100 connections tells me max throughput" (closed-loop: latency hides behind back-off).
**Read:** Gil Tene, "How NOT to Measure Latency".

### use-and-red-methods — L4
requires: measure-first-profiling
**Core:**
- **USE** for resources: Utilization, Saturation, Errors, per CPU, disk, network and pool.
- **RED** for services: Rate, Errors, Duration.

They make a complete, fast checklist when something is slow.
**Read:** Gregg, "The USE Method".

### capacity-planning — L5
requires: utilization-knee, littles-law
**Core:** From the forecast load and per-request cost, derive instances, headroom, and the component that saturates first. Plan for peak × safety factor, a failover of N−1, and cost per request.
**Misconceptions:** "autoscaling replaces capacity planning" (cold starts, quotas, downstream limits).

### performance-budgets-across-services — L6
requires: capacity-planning, tail-latency
**Core:** Allocate latency and error budgets along a call chain. Enforce them with timeouts and SLOs, so one team's regression can't silently consume another's budget.
