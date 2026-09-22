# Levels: L1 intern → L7 principal

The rubric behind placement, level-up gaps, promotion challenges, and how every lesson is pitched. A level is assessed **per topic**. An L5 backend engineer can be L2 in frontend. Level is a teaching setting, never a grade.

## The ladder

| Level | Title | Scope they own | Handles ambiguity | Signature question they can answer |
|---|---|---|---|---|
| **L1** | Intern | A task inside someone else's design | Needs the task broken down | "What does this code do, line by line?" |
| **L2** | Junior | A well-specified feature | Asks when the spec is unclear | "Why does this work, and what input breaks it?" |
| **L3** | Mid | A component end to end | Resolves small ambiguity alone | "What are the trade-offs of this approach vs that one?" |
| **L4** | Senior | A service or subsystem, incl. production | Turns vague asks into designs | "What happens at 10× load, when a dependency is down, or on a retry?" |
| **L5** | Staff | Several services / a team's architecture | Frames the problem for others | "Which of these systems should own this, and what does that cost the org?" |
| **L6** | Senior staff | An org's technical direction in an area | Sets direction under uncertainty | "What should we *not* build, and how do we migrate 40 services safely?" |
| **L7** | Principal | Company-wide architecture & standards | Creates clarity for many orgs | "What's the 3-year shape of this platform, and which bets are one-way doors?" |

## What changes in teaching, by level

| Level | Teach | Exercise shape | Production lens depth |
|---|---|---|---|
| L1–L2 | Mechanics and correctness: what the machine does, the API, the idiom, the common bug. | Heavy code-along; small, complete programs; predict the output. | Errors, input validation, "what if it's empty/null/huge". |
| L3–L4 | Trade-offs, choosing between approaches, designing one component, production readiness. | Design the component, write the load-bearing piece, break it under load. | The full lens: timeouts, retries, idempotency, backpressure, observability, capacity. |
| L5–L7 | Cross-system boundaries, ownership, migrations, org-level cost, deciding under ambiguity, reviewing others. | Design reviews, writing the decision record, a migration plan, "what would you refuse to build". | The lens at fleet scale: blast radius, failure domains, cost, operability by other teams. |

## Per-domain expectations

Each cell is what the level must **reliably do** in that domain. The next cell up is the level-up gap. Curriculum files tag each concept with the level where it becomes expected.

### Fundamentals (OS, memory, networking, data structures, databases)

| L1–L2 | L3 | L4 | L5+ |
|---|---|---|---|
| Big-O of common structures; process vs thread; what TCP/HTTP give you; SQL CRUD, a primary key. | Choose structures by access pattern; the memory hierarchy and locality; connection pooling; indexes and when they hurt. | Syscall and context-switch costs; page cache; TCP slow start/head-of-line; query plans; transaction isolation anomalies. | Kernel/runtime behaviour under pressure; reasoning about hardware limits (NIC, disk IOPS, NUMA); choosing storage engines. |

### Concurrency

| L1–L2 | L3 | L4 | L5+ |
|---|---|---|---|
| What a race is; using a lock correctly; async/await basics. | Deadlock and its four conditions; threads vs async vs processes and when each wins; thread-safe design of one component. | Contention and its throughput cost; lock granularity; lock-free vs message passing; backpressure; memory visibility / happens-before. | Concurrency models across a system (actors, CSP, shared-nothing); designing for no shared mutable state; formal reasoning when it matters. |

### Performance and throughput

| L1–L2 | L3 | L4 | L5+ |
|---|---|---|---|
| Latency vs throughput; measure before optimizing; N+1 queries. | Profiling a hot path; caching and its invalidation cost; batching. | Little's law; tail latency (p99) and why averages lie; queueing and utilization knees; load testing properly. | Capacity planning; cost/performance trade-offs at fleet scale; performance budgets across services. |

### Distributed systems

| L1–L2 | L3 | L4 | L5+ |
|---|---|---|---|
| Networks fail; retries exist; what a message queue is. | Idempotency; at-least-once delivery; timeouts; eventual consistency as a concept. | Replication modes; partitioning; CAP/PACELC in practice; the outbox and saga patterns; exactly-once as a myth. | Consensus and its costs; multi-region design; consistency models chosen per use case; failure-domain design. |

### System design

| L1–L2 | L3 | L4 | L5+ |
|---|---|---|---|
| Client/server, what a load balancer and a cache do. | Design one service: API, data model, the obvious bottleneck. | End-to-end design: estimates, data model driven by query shape, scaling reads vs writes, failure modes. | Multi-system designs, build vs buy, migration from the current system, org and cost constraints. |

### Architecture and code design

| L1–L2 | L3 | L4 | L5+ |
|---|---|---|---|
| Functions and modules with one job; naming. | Layering; dependency direction; deep vs shallow modules; testable seams. | Hexagonal / ports-and-adapters; bounded contexts; coupling and cohesion as costs; writing ADRs. | Architecture across teams (Conway's law); evolutionary architecture; standards others adopt. |

### Production engineering

| L1–L2 | L3 | L4 | L5+ |
|---|---|---|---|
| Logs; reading a stack trace; running the service locally like prod. | Structured logging, metrics, health checks; safe config; basic security (injection, secrets). | SLOs and error budgets; deploys and rollbacks; feature flags; incident response; capacity alarms. | Reliability strategy; blast-radius design; on-call health; security architecture. |

## Placement bands

Placement is done by the `assess` skill, probing with MCQs. Map the result to a level like this:

- Correct on the **signature question** of level N, and on the domain cells of level N → at least level N.
- Placement is the highest level where they're reliably correct, **minus one** when the open "explain what happens when…" answer is shaky at that level.
- Never place above L4 from MCQs alone. L5+ needs the open design question answered at that scope.
