# Diagrams

A diagram earns its place when it shows the **mechanism**: who talks to whom, in what order, and what state exists at each moment. Decorative boxes don't. Default to ASCII in the terminal. Offer mermaid when the learner wants it outside the terminal, and an HTML lesson page ([html-lesson.md](html-lesson.md)) for big system-design pictures.

Rules:
- Draw from the **learner's** system when one exists: real service names, real queue names.
- Keep it under ~25 lines and ~80 columns. If it's bigger, split it into two diagrams.
- Label arrows with *what* moves (the request, an event, an ack), and with numbers when numbers matter (`~5k msg/s`, `p99 40ms`).
- Follow the diagram with one sentence saying what to look at: "notice the ack comes back *before* the write commits".

## Which diagram for which question

| Question | Diagram |
|---|---|
| What are the parts and who depends on whom? | Box-and-arrow architecture |
| In what order do things happen across components? | Sequence diagram |
| What goes wrong when two things run at once? | **Interleaving timeline** |
| Where does the time go / where does work pile up? | Pipeline with rates and queues |
| What states can this be in? | State machine |
| How is data laid out / partitioned / replicated? | Storage layout |

## Templates

### Architecture
```
            ┌──────────┐   HTTPS    ┌─────────────┐   SQL    ┌──────────┐
 client ───▶│   LB     │──────────▶ │ api (x3)    │────────▶ │ postgres │
            └──────────┘            └──────┬──────┘          └──────────┘
                                           │ publish order.created
                                           ▼
                                    ┌─────────────┐  consume ┌──────────┐
                                    │  queue      │────────▶ │ worker   │
                                    └─────────────┘          └──────────┘
```

### Sequence
```
client          api              db             queue
  │  POST /order │                │                │
  │─────────────▶│  INSERT order  │                │
  │              │───────────────▶│                │
  │              │◀─── ok ────────│                │
  │              │  publish ──────────────────────▶│   ← crash here = order with no event
  │◀── 201 ──────│                │                │     (dual write → outbox pattern)
```

### Interleaving timeline (the concurrency workhorse)
Time flows down. One column per thread or request. Mark the shared state after each step.
```
 time   T1 (request A)            T2 (request B)            balance
  1     read balance → 100                                   100
  2                               read balance → 100         100
  3     write 100 - 30 = 70                                  70
  4                               write 100 - 50 = 50        50   ← lost update: A's -30 vanished
```
Then show the fixed version: the same timeline with the lock, CAS or `UPDATE … SET balance = balance - 30` in place.

### Pipeline with rates (throughput and backpressure)
```
 producer ──▶ [ queue: 800/1000 ] ──▶ consumers (4 × 250/s = 1000/s)
  1200/s          filling at +200/s → full in ~1s → then? block? drop? 429?
```

### State machine
```
  PENDING ──pay──▶ PAID ──ship──▶ SHIPPED
     │               │
   cancel          refund
     ▼               ▼
  CANCELLED      REFUNDED
```

### Storage layout / partitioning
```
 key hash % 4
 ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
 │ shard0 │ │ shard1 │ │ shard2 │ │ shard3 │   ← hot key "celebrity" all lands on shard2
 │ L  F F │ │ L  F F │ │ L  F F │ │ L  F F │     L = leader, F = follower
 └────────┘ └────────┘ └────────┘ └────────┘
```

## Mermaid (offer, don't default)

The same diagrams as `graph TD`, `sequenceDiagram` or `stateDiagram-v2`. Print them in a fenced ```mermaid block so the learner can paste it into a README or an HTML lesson.
