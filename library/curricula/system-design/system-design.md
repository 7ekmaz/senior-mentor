# System design

Domain: system design · Levels covered: L1–L7 · Canon: DDIA, *System Design Interview* vol. 1–2, *The System Design Primer*, *Understanding Distributed Systems*, SRE book

## What LLM answers usually gloss over

- **Requirements first.** Generated designs jump to boxes (Kafka! Redis! microservices!) before scale, consistency and failure requirements are known.
- **Numbers that decide.** Estimates are either skipped or computed and then ignored.
- **The data model follows the access pattern.** Generated designs pick the store first.
- **Every added box is an on-call surface**, a failure mode and a consistency boundary. Simplicity is a requirement.
- Dual writes (DB + queue, DB + cache) silently break consistency. This is where the outbox pattern and CDC come in.
- What happens when each dependency is **slow**, not just down.

## Concepts

### client-server-and-http — L1
requires: —
**Core:** A client sends requests; servers are stateless workers behind an address; state lives in datastores. Statelessness is what makes horizontal scaling possible.
**MCQ:** Why do we try to keep app servers stateless? — (a) *correct:* any instance can serve any request, so you can add or remove instances and survive a crash; (b) stateless is faster per request (misconception); (c) HTTP requires it (misconception); (d) to save memory (misconception).

### load-balancing — L2
requires: client-server-and-http
**Core:** Spread requests across instances: round-robin, least-connections, consistent hashing for affinity. Health checks remove dead instances. L4 vs L7 balancing.
**Misconceptions:** "sticky sessions are free" (uneven load; a lost session on failure).

### back-of-envelope-estimation — L3
requires: latency-numbers
**Core:** QPS = DAU × actions/day ÷ 86,400 (peak ≈ 2–5× average). Storage = items/day × size × retention. Then state what each number **decides**: one DB or sharded? Is a cache needed? Can one machine hold it in memory?
**Misconceptions:** "precision matters" (the order of magnitude is the point); "estimates are an interview ritual" (they choose the architecture).
**MCQ:** 50M DAU, each posting 2 items/day at 1 KB, kept 5 years. Storage roughly? — (a) *correct:* ~180 TB (100M items/day × 1 KB ≈ 100 GB/day × 1,825 days); (b) ~180 GB (misconception: a unit slip); (c) ~1.8 PB (misconception: an extra ×10); (d) ~36 TB (misconception: one year).
**Exercise:** estimate QPS and storage for a URL shortener, and name two decisions the numbers force.

### api-design-for-systems — L3
requires: client-server-and-http · related: idempotency
**Core:** Resource-oriented endpoints; idempotency keys on unsafe writes; cursor pagination over offset; explicit error contracts; versioning.
**Misconceptions:** "offset pagination is fine at scale" (deep offsets scan, and inserts shift pages).

### query-shaped-storage — L3
requires: back-of-envelope-estimation
**Core:** List the access patterns (which queries, how often, what latency, what consistency), then choose the schema and store. Relational for flexible queries and transactions; key-value for known-key lookups at scale; wide-column / LSM for write-heavy time series; search indexes for text.
**Misconceptions:** "NoSQL scales, SQL doesn't"; "pick the database first".
**MCQ:** Chat app: messages written constantly, read as "the last 50 in this conversation". The best-fitting primary key? — (a) *correct:* (conversation_id, message_time/id), partitioned by conversation; (b) message_id alone (misconception: ignores the access pattern); (c) user_id (misconception); (d) a full-text index (misconception).

### caching-in-architecture — L3
requires: caching, query-shaped-storage
**Core:** Where caches go (client, CDN, app, in front of the DB), what's cacheable, invalidation on write, and stampede protection. A cache reduces load, but the DB must survive a cold cache.

### replication — L4
requires: query-shaped-storage
**Core:** Leader-follower scales reads and gives failover. Async replication → replica lag → read-your-writes problems. Sync replication → higher write latency. Multi-leader and leaderless bring conflicts to resolve.
**Misconceptions:** "replicas are always up to date"; "failover is instant and lossless" (with async replication, you lose acknowledged writes).
**MCQ:** A user updates their profile, refreshes, and sees the old value; reads go to async replicas. The minimal fix? — (a) *correct:* read-your-writes: route that user's reads to the leader for a short window after writing (or use a version token); (b) make all replication sync (misconception: most expensive); (c) add a cache (misconception: another stale layer); (d) retry the read (misconception).
**Read:** DDIA, the replication chapter.

### partitioning — L4
requires: replication
**Core:** Split data by key (hash for spread, range for scans). Hot keys defeat hashing. Resharding needs consistent hashing or virtual nodes. Cross-partition queries and transactions get expensive.
**Misconceptions:** "hash partitioning prevents hot spots" (not for one hot key).
**Read:** DDIA, the partitioning chapter.

### async-processing-and-queues — L4
requires: backpressure · related: idempotency
**Core:** Move slow or unreliable work off the request path. Queues give buffering, retries and decoupling, at the cost of eventual consistency, ordering questions, poison messages (DLQ), and delivery that is at-least-once, so consumers must be idempotent.
**Misconceptions:** "the queue guarantees exactly-once"; "async fixes slowness" (it moves it, and adds lag).

### idempotency — L3
requires: api-design-for-systems
**Core:** Doing it twice has the same effect as doing it once. Retries, redelivery and double clicks make it mandatory for writes. Implement with an idempotency key stored with the result, upserts, or dedup by message id.
**MCQ:** A payment API call times out at the client. The client retries. What prevents a double charge? — (a) *correct:* the client sends an idempotency key; the server stores key→result and returns the stored result on a replay; (b) a shorter timeout (misconception); (c) don't retry (misconception: loses payments); (d) exactly-once HTTP (misconception).

### outbox-and-dual-writes — L4
requires: async-processing-and-queues, idempotency
**Core:** Writing to the DB and publishing to a queue are two systems. A crash between them makes them diverge. The outbox: write the event row in the same DB transaction, and a relay publishes it (or CDC does). Consumers stay idempotent.
**Diagram:** the sequence template in diagrams.md (the crash after INSERT, before publish).

### consistency-models — L4
requires: replication
**Core:** Linearizable, sequential, causal, read-your-writes, eventual. Pick per use case: money and inventory need strong guarantees; like counts and feeds tolerate eventual. CAP: under a partition, choose C or A. PACELC: otherwise, choose latency or consistency.
**Misconceptions:** "CAP means pick 2 of 3 always"; "eventual means inconsistent forever".
**Read:** DDIA, "Consistency and Consensus".

### failure-modes-and-resilience — L4
requires: async-processing-and-queues
**Core:** Timeouts, retries with backoff and jitter, circuit breakers, bulkheads, load shedding, graceful degradation. Design for *slow* dependencies. Slow is worse than down, because it ties up your resources.
**Read:** *Release It!*, stability patterns.

### consensus-and-coordination — L5
requires: consistency-models
**Core:** Leader election, locks and config agreement need consensus (Raft/Paxos, via etcd/ZooKeeper). It's expensive and latency-bound, so keep it off the hot path.
**Read:** the Raft paper.

### multi-region — L5
requires: consistency-models, failure-modes-and-resilience
**Core:** Active-passive vs active-active; data residency; the cross-region latency (~70–150 ms) on every synchronous write; conflict resolution; region evacuation.

### migration-and-evolution — L5
requires: query-shaped-storage
**Core:** Get from the current system to the target without downtime: dual-run, shadow traffic, backfill, expand/contract schemas, the strangler fig pattern, a rollback at every step.

### build-vs-buy-and-org-shape — L6
requires: migration-and-evolution
**Core:** Managed service vs self-run: operability, cost, lock-in. Conway's law: system boundaries follow team boundaries. Design ownership so each team can deploy and operate its part alone.

### platform-direction — L7
requires: build-vs-buy-and-org-shape, multi-region
**Core:** Multi-year architecture bets; which decisions are one-way doors for the whole company; standards that other orgs adopt willingly; deprecating systems.
