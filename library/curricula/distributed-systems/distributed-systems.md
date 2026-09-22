# Distributed systems

Domain: distributed-systems · Status: **stub** — concept list and edges only; lessons build details from general knowledge. Canon: DDIA, Understanding Distributed Systems, Lamport 1978, Raft, Dynamo, Spanner, Jepsen

## What LLM answers usually gloss over
- The network is unreliable and a timeout tells you nothing about whether the remote side acted.
- Exactly-once delivery doesn't exist end to end; effectively-once = at-least-once + idempotency.
- Clocks drift; ordering by wall-clock timestamp across machines is a bug.

## Concepts
- network-failure-modes — L2 — requires: tcp-guarantees
- timeouts-and-retries — L3 — requires: network-failure-modes
- idempotency — L3 — requires: timeouts-and-retries (see system-design.md)
- delivery-semantics — L3 — requires: timeouts-and-retries
- eventual-consistency — L3 — requires: delivery-semantics
- replication — L4 — (see system-design.md)
- partitioning — L4 — (see system-design.md)
- cap-and-pacelc — L4 — requires: replication
- clocks-and-ordering — L4 — requires: network-failure-modes
- logical-clocks — L5 — requires: clocks-and-ordering
- outbox-and-dual-writes — L4 — (see system-design.md)
- sagas — L5 — requires: outbox-and-dual-writes
- consensus-raft — L5 — requires: replication, clocks-and-ordering
- distributed-locks-and-fencing — L5 — requires: distributed-races, consensus-raft
- failure-domains — L6 — requires: replication
