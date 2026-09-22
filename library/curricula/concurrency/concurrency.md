# Concurrency

Domain: concurrency · Levels covered: L1–L6 · Canon: OSTEP (concurrency part), *Java Concurrency in Practice*, *Seven Concurrency Models*, *The Art of Multiprocessor Programming*, DDIA ch. on transactions

## What LLM answers usually gloss over

- **Who else touches this state?** Generated code adds a lock or `async` without saying what's shared or why.
- Async ≠ parallel. A blocking call inside `async` code stalls every task on that loop.
- A lock fixes correctness and **costs throughput**. Contention is never mentioned.
- Races across **processes and machines** (two workers, two pods) are not fixed by an in-process mutex. The database constraint or an atomic update is the real fix.
- "Thread-safe" collections don't make *compound* operations (check-then-act) atomic.
- Memory visibility: without a happens-before edge, another thread may never see the write.

## Concepts

### concurrency-vs-parallelism — L1
requires: — · related: async-await
**Core:** Concurrency is *structuring* a program as independently progressing tasks. Parallelism is *executing* at the same instant on multiple cores. You can have concurrency on one core (interleaving) and parallelism without much concurrency design (SIMD).
**Misconceptions:** "async makes it run in parallel"; "more threads = faster always".
**Diagram:** a timeline, one core interleaving A/B vs two cores running A and B side by side.
**MCQ:** A Python asyncio program makes 100 HTTP calls on one thread and finishes 20× faster than the sequential version. Why? — (a) *correct:* the waits overlap: while one call waits on the network, others proceed; (b) asyncio uses all cores (misconception: async = parallel); (c) the GIL is released for asyncio (misconception: conflating the GIL with the event loop); (d) HTTP calls are batched into one request (misconception: async changes the protocol).
**Exercise:** time 20 sleeps of 100 ms sequentially vs concurrently; explain the result.
**Read:** OSTEP, "Concurrency: An Introduction".

### race-condition — L1
requires: concurrency-vs-parallelism · related: atomicity
**Core:** The result depends on the timing of interleaved operations on shared state. `count += 1` is read-modify-write: three steps another thread can interleave between.
**Misconceptions:** "one line of code is atomic"; "it passed the tests so it's safe" (races are probabilistic).
**Diagram:** the interleaving timeline, lost update on a counter.
**MCQ:** Two threads each run `count += 1` 1,000,000 times on a shared int with no lock. The most likely final value? — (a) *correct:* somewhere below 2,000,000, varying run to run; (b) exactly 2,000,000 (misconception: `+=` is atomic); (c) exactly 1,000,000 (misconception: the threads fully overwrite each other); (d) the program crashes (misconception: races always fault).
**Exercise:** reproduce the lost update, then fix it two ways (lock, atomic).
**Read:** OSTEP, "Locks".

### atomicity-and-check-then-act — L2
requires: race-condition
**Core:** Compound operations (`if key not in map: map[key] = …`, "select then insert") need the check and the act in one atomic step. Use a lock around both, an atomic primitive (`putIfAbsent`, CAS), or push it to the database (unique constraint, `INSERT … ON CONFLICT`).
**Misconceptions:** "a thread-safe map makes my code thread-safe"; "checking first prevents duplicates".
**Diagram:** a timeline, two requests both pass `SELECT … WHERE email=?` and both INSERT.
**MCQ:** A signup handler does `SELECT` for the email, then `INSERT` if absent, on 3 app servers. The cheapest reliable way to prevent duplicate accounts? — (a) *correct:* a unique index on email, and handle the conflict error; (b) a mutex around the handler (misconception: an in-process lock spans servers); (c) check twice (misconception: re-checking closes the window); (d) SERIALIZABLE isolation on every request (works, but misconception that it's cheapest: heavy and retries needed).
**Exercise:** make a signup endpoint idempotent under concurrent double-submit.
**Read:** DDIA, transactions chapter, §lost updates / write skew.

### mutex-and-critical-section — L2
requires: race-condition
**Core:** A mutex serializes access to a critical section. Keep critical sections short. Never hold a lock across I/O or a callback you don't control.
**Misconceptions:** "locking the object locks all access to it" (only code that takes the lock is protected); "a bigger lock is safer" (it's slower, and deadlock-prone).
**Diagram:** a timeline with a lock, showing waiting threads queueing.
**MCQ:** The lock is held while calling a remote API (p99 800 ms). 50 req/s hit this path. What happens? — (a) *correct:* throughput collapses to ~1–2 req/s through that path, and the queue grows without bound; (b) fine, locks are cheap (misconception: the lock's cost is the acquire, not the hold time); (c) deadlock (misconception: slowness = deadlock); (d) the lock auto-releases on timeout (misconception).
**Read:** *JCIP*, ch. 2–3.

### deadlock — L3
requires: mutex-and-critical-section
**Core:** Four conditions are needed together: mutual exclusion, hold-and-wait, no preemption, circular wait. Break one. In practice: a global lock order, try-lock with timeout, or don't hold one lock while taking another.
**Misconceptions:** "deadlocks only happen with many locks" (two is enough; so is a DB row pair); "a timeout fixes deadlock" (it turns it into retries and livelock risk).
**Diagram:** the interleaving timeline, T1 holds A waits B, T2 holds B waits A.
**MCQ:** Two transfers run at once: A→B locks A then B; B→A locks B then A. The fix with the least throughput cost? — (a) *correct:* always lock accounts in id order; (b) a single global lock (works; misconception that it's cheap); (c) add sleep between locks (misconception); (d) raise the DB timeout (misconception: masks it).
**Exercise:** write the transfer function with ordered locking.
**Read:** OSTEP, "Common Concurrency Problems".

### threads-vs-async-vs-processes — L3
requires: concurrency-vs-parallelism
**Core:**
- **Threads:** preemptive, shared memory, OS-scheduled; good for blocking I/O and CPU on runtimes without a GIL.
- **Async** (event loop): cooperative, one thread, cheap tasks; great for many concurrent I/O waits; any blocking call stalls everything.
- **Processes:** isolation and real CPU parallelism, at the cost of IPC.

Choose by the workload: I/O-bound with many connections → async; CPU-bound → processes (or threads without a GIL); mixed → async plus a thread or process pool for the blocking part.
**Misconceptions:** "async is always faster"; "threads are too heavy" (true only at 10k+); "Python threads give CPU parallelism".
**MCQ:** A FastAPI `async def` endpoint calls `requests.get()` (blocking), and p99 jumps under load. Why? — (a) *correct:* the blocking call stalls the event loop, so every request waits; (b) requests is slow (misconception: blames the library, not the model); (c) too few threads (misconception: async endpoints don't use the thread pool); (d) the GIL (misconception).
**Exercise:** fix it three ways: httpx async, `run_in_executor`, a plain `def` endpoint. Compare them.
**Read:** *Seven Concurrency Models*, the threads/locks chapter.

### async-await — L2
requires: concurrency-vs-parallelism
**Core:** `await` yields to the event loop until the awaited thing is ready. Code between awaits runs without interruption, so races happen *across* awaits, not within them.
**Misconceptions:** "no threads = no races" (interleaving happens at each await).
**MCQ:** Two asyncio tasks run `v = cache[k]; await fetch(); cache[k] = v + 1`. Can updates be lost? — (a) *correct:* yes, both read before either writes, across the await; (b) no, single thread (misconception); (c) only with multiple loops (misconception); (d) only on PyPy (misconception).

### contention-and-throughput — L4
requires: mutex-and-critical-section, littles-law
**Core:** Throughput through a lock is at most `1 / hold_time`. Adding threads past that adds only waiting and context switches. Fixes: shrink the critical section, shard the lock (striping), use lock-free/atomic ops for simple state, or give the state a single owner (message passing).
**Misconceptions:** "scale by adding workers" (not past the serial fraction: Amdahl); "lock-free is always faster" (CAS retry storms under high contention).
**Diagram:** pipeline with rates: 8 workers → 1 lock (hold 2 ms → max 500/s) → the rest queue.
**MCQ:** A service does 400 req/s with 8 threads; each request holds a global lock for 2 ms. You go to 32 threads. Throughput becomes? — (a) *correct:* about the same, capped near 500/s by the lock; (b) ~1600/s (misconception: linear scaling); (c) it drops to 0 (misconception: deadlock); (d) it doubles (misconception).
**Exercise:** benchmark a global lock vs a striped lock vs a per-shard owner goroutine.
**Read:** *JCIP*, ch. 11 "Performance and Scalability".

### backpressure — L4
requires: contention-and-throughput · related: bounded-queue, littles-law
**Core:** When producers outpace consumers, the excess must go somewhere: block the producer, drop, shed with a 429, or grow memory until the process dies. Every queue must be bounded and must state its full-policy. Backpressure propagates slowness upstream, which is what you want.
**Misconceptions:** "unbounded queues absorb spikes" (they convert a spike into an OOM later); "just autoscale" (lag and cost; the bound is still needed).
**Diagram:** pipeline with rates, the queue filling at +200/s.
**MCQ:** A producer at 1200/s feeds consumers that can do 1000/s via an unbounded in-memory queue. After an hour? — (a) *correct:* ~720k items queued, latency ~12 min, memory climbing to OOM; (b) stable (misconception: queues smooth everything); (c) 200/s get dropped (misconception: unbounded queues don't drop); (d) consumers speed up (misconception).
**Exercise:** add a bounded queue with each policy (block / drop-oldest / reject) and observe the behaviour under load.
**Read:** *Release It!*, the stability patterns (Bulkheads, Fail Fast).

### memory-visibility — L4
requires: race-condition
**Core:** Without synchronization, CPUs and compilers may reorder or cache writes, so another thread may see stale or partially constructed data. Locks, volatile/atomic, channels and thread start/join create **happens-before** edges that guarantee visibility.
**Misconceptions:** "if I write it, others see it immediately"; "only increments race, flags are safe".
**MCQ:** Thread A sets `data = x; ready = true` (plain fields). Thread B loops `while !ready {}` then reads data. In Java/C++ without volatile/atomic, what's possible? — (a) *correct:* B may spin forever, or see ready=true with stale data; (b) always works on x86 (misconception: the hardware model hides the compiler reordering); (c) compile error (misconception); (d) B always sees the right data, just slowly (misconception).
**Read:** the Go memory model / the Java Memory Model (JCIP ch. 16).

### lock-free-and-cas — L5
requires: memory-visibility, contention-and-throughput
**Core:** Compare-and-swap loops update shared state without blocking. That brings progress guarantees, the ABA problem, and retry storms under contention. Use it for counters and simple structures; prefer proven library implementations.
**Misconceptions:** "lock-free means wait-free"; "lock-free is always faster".
**Read:** *The Art of Multiprocessor Programming*, the chapters on linearizability and concurrent objects.

### message-passing-and-ownership — L4
requires: threads-vs-async-vs-processes · related: backpressure
**Core:** "Don't communicate by sharing memory; share memory by communicating." One owner goroutine or actor holds the state; others send it messages. That trades lock reasoning for queue reasoning (bounds, ordering, and what happens when the owner is slow).
**Misconceptions:** "channels remove all concurrency bugs" (deadlocks on unbuffered channels, goroutine leaks).
**Exercise:** rewrite a mutex-guarded cache as a single-owner goroutine; compare.

### distributed-races — L4
requires: atomicity-and-check-then-act · related: idempotency
**Core:** Across processes and machines there is no shared mutex. Correctness comes from the datastore:
- atomic updates (`UPDATE … SET n = n - 1 WHERE n > 0`)
- unique constraints
- optimistic concurrency (version columns)
- `SELECT … FOR UPDATE`
- idempotency keys

Distributed locks (Redis, etcd) need fencing tokens to be safe.
**Misconceptions:** "Redis SETNX is a safe distributed lock" (not without fencing: GC pauses and lease expiry).
**MCQ:** Two pods decrement inventory via `SELECT stock` then `UPDATE stock = :new`. Oversells happen. The simplest correct fix? — (a) *correct:* a single atomic `UPDATE … SET stock = stock - 1 WHERE id=? AND stock > 0`, checking rows affected; (b) a mutex in each pod (misconception); (c) a Redis lock without fencing (misconception: it's safe); (d) retry on failure (misconception).
**Read:** DDIA, "the trouble with distributed systems" (fencing tokens); Kleppmann, "How to do distributed locking".

### concurrency-models-at-system-scale — L6
requires: message-passing-and-ownership, distributed-races
**Core:** Choosing shared-nothing (partition by key, single writer per partition), actors, or CSP across a whole system, to eliminate coordination rather than manage it.
**Read:** DDIA, partitioning + stream processing chapters.
