---
name: system-design
description: Guided, level-aware system design walkthrough — requirements, back-of-envelope estimates, API, data model, architecture, deep dives on bottlenecks/concurrency/consistency, failure modes, operations — the learner drives, the mentor probes. Reached via /mentor system-design <system>.
disable-model-invocation: true
---

# System design

Method: [../../library/pedagogy.md](../../library/pedagogy.md) · levels: [../../library/levels.md](../../library/levels.md) · diagrams: [../../library/diagrams.md](../../library/diagrams.md) · lens: [../../library/production-lens.md](../../library/production-lens.md) · canon: [../../library/curricula/system-design/](../../library/curricula/system-design/)

Two uses:
- **Practice:** "design a URL shortener", "design a chat system". An interview-style exercise, but taught.
- **Real:** "design the notification system for our product". Everything below, plus a decision record in `~/.claude/mentor/decisions/<project>.md`, and grounding in their repo and constraints.

**The learner drives.** At each step, ask them first, then probe, correct and teach. Only draw the answer yourself after they've tried, or when they say `just tell me`.

## Steps

1. **Requirements.** They list functional requirements, then non-functional ones: scale, latency, availability, consistency, durability. Probe for the ones they missed. **L1–L3 usually miss the non-functionals; that miss is the lesson.** Agree on the 3–4 that shape the design.
2. **Back-of-envelope estimates.** They estimate:
   - QPS, read vs write;
   - storage per year;
   - bandwidth;
   - peak vs average.

   Show the arithmetic with them, e.g. "100M DAU × 10 reads/day ÷ 86,400 ≈ 11.6k QPS avg, ~3× at peak". Name what the numbers *decide*: "35k QPS of reads → one Postgres can't serve this without a cache". **Numbers that decide nothing are theatre.**
3. **API.** They write 3–5 endpoints or messages, with request and response shapes. Check idempotency on writes, pagination, and error cases.
4. **Data model.** Access patterns first, then the schema. "Storage shape follows query shape." Choose the store by the access pattern and consistency need, and name what the choice trades away.
5. **High-level architecture.** They sketch it; you render the ASCII diagram. Walk one read and one write through it, as a sequence.
6. **Deep dives.** Pick 2–3 by level, where the design is most likely to break:
   - **Bottleneck:** which component falls over first at 10×? Use Little's law, and the utilization knee.
   - **Concurrency:** what races exist (double-submit, a counter, inventory)? Draw the interleaving timeline and pick the fix: a constraint, CAS, a lock, a single writer.
   - **Consistency:** what can be stale, for how long, and who notices? Read-your-writes, the dual-write outbox.
   - **Hot spots:** a hot key or a celebrity user, partitioning and resharding.
   - **Caching:** what to cache, the invalidation strategy, the stampede.
7. **Failure modes.** For each dependency: what happens when it's slow, down, or returns garbage? Timeouts, retries, circuit breakers, degraded mode, blast radius.
8. **Operations.** How we'd know it's broken (SLIs/SLOs), deploy and rollback, migration from the current system (real case), and the cost order of magnitude.
9. **Wrap-up.**
   - The **final diagram**.
   - The top 3 risks.
   - What they'd do differently at 100× scale.
   - The fundamentals named; add them to the graph.
   - Real use: write the decision record.
   - Offer the HTML lesson page ([html-lesson.md](../../library/html-lesson.md)).

After each step: one MCQ or "what if" question from the concepts it touched.

## Level lens

| Level | Emphasis |
|---|---|
| L1–L2 | Steps 1, 3, 5, taught slowly: what each box does, and why a cache or LB exists. Skip the deep dives, or do one lightly. |
| L3 | All steps; one deep dive (the bottleneck). The estimates are the stretch. |
| L4 | All steps; 2–3 deep dives; failure modes in full. |
| L5+ | Add build vs buy, multi-region, the migration path, team ownership boundaries, cost. They also critique their own design's one-way doors. |

## Case studies

`../../library/curricula/system-design/case-studies.md` has worked references: requirements, estimates, key decisions and common mistakes. Use them to know where learners typically go wrong. Don't recite them.

## Sprint: the cheat sheet

One page: the key requirements, estimates → what they decide, the high-level diagram, the data store and why, the top 3 risks with mitigations. One MCQ. Skipped deep dives go to `## Learn later`.
