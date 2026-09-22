# Fundamentals

Domain: fundamentals · Status: **stub** — concept list and edges only; lessons build details from general knowledge. Canon: OSTEP, CS:APP, HPBN, Database Internals, Use The Index Luke

## What LLM answers usually gloss over
- The cost model underneath the abstraction: syscalls, page cache, round trips, index scans.
- Why an index speeds reads and slows writes; when the planner ignores it.
- What TCP guarantees (ordered bytes) and what it doesn't (message boundaries, delivery to the app).

## Concepts
- big-o-by-access-pattern — L1 — requires: —
- process-vs-thread — L1 — requires: —
- memory-hierarchy-and-locality — L3 — requires: big-o-by-access-pattern
- virtual-memory-and-page-cache — L4 — requires: process-vs-thread, memory-hierarchy-and-locality
- syscalls-and-context-switches — L4 — requires: process-vs-thread
- tcp-guarantees — L2 — requires: —
- tcp-handshake-slow-start-hol — L4 — requires: tcp-guarantees
- http-versions — L3 — requires: tcp-guarantees
- dns-and-tls-costs — L3 — requires: tcp-guarantees
- sql-basics-and-keys — L1 — requires: —
- indexes-btree — L3 — requires: sql-basics-and-keys, big-o-by-access-pattern
- query-plans — L4 — requires: indexes-btree
- transactions-acid — L3 — requires: sql-basics-and-keys
- isolation-anomalies — L4 — requires: transactions-acid, race-condition
- storage-engines-btree-vs-lsm — L5 — requires: indexes-btree
- connection-pooling — L3 — requires: tcp-guarantees
