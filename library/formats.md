# Mentor file formats

All state lives under `~/.claude/mentor/`. Create directories as needed. Use kebab-case file names (`rabbitmq.md`, `system-design.md`) and absolute dates everywhere.

| File | Written by | Holds |
|---|---|---|
| `progress/<topic>.md` | every teaching skill | level, depth, gear, calibration, curriculum, concept graph, ledger |
| `decisions/<project>.md` | design-partner, system-design | architecture decisions and their assumptions |
| `resources/<topic>.md` | resources | a verified, level-mapped reading list |

## Progress file

```markdown
---
topic: rabbitmq
level: L3                      # career level for THIS topic: L1..L7, or `unassessed`
level_history: [L2@2026-07-20, L3@2026-08-10]
depth: D2                      # last depth that landed: D1 | D2 | D3
gear: normal                   # sprint | normal | deep: default pace, overridable per invocation
projects: [Zenith, Viro]       # repos used for grounding; may be empty
shadow_cadence: normal         # quiet | normal | frequent (explain-the-diff checks)
last_activity: 2026-08-03
---

## Calibration
Knows well: Python, asyncio, gRPC, ML pipelines. Learning RabbitMQ to debug the
Zenith→Viro run pipeline. Best bridges: asyncio queues, gRPC streaming.
Modalities: worked numbers + sequence diagrams land; analogies don't.
Dropped to D1 twice on delivery semantics — go concrete there.

## Curriculum
- [x] R1. Connections, channels, why channels aren't threads — [repo: Zenith/queue/*]
- [x] R2. Exchanges & routing keys in run dispatch — [repo]
- [ ] R3. Acknowledgements & redelivery — [repo]
- [ ] R4. Dead-letter exchanges — [beyond this repo] (gap: Viro consumers have no DLX)
- [ ] R5. Delivery guarantees & idempotent consumers — [beyond this repo] — read: resources#ddia-ch11

## Concept graph
<!-- <id> [status] Lx — requires: … | builds_upon: … | related: … — src: … — quiz: … -->
- channel-vs-connection [solid] L2 — requires: tcp-basics — src: R1 — quiz: correct@2026-08-01
- manual-ack [weak] L3 — requires: channel-vs-connection | builds_upon: message-lifecycle — src: R3 — quiz: wrong@2026-08-03
- prefetch-count [untested] L4 — requires: manual-ack | related: backpressure — src: shadow (Viro consumer PR)

## Level-up
<!-- written by assess: the gap to the next level and the promotion-challenge record -->
Target: L4 — gap: prefetch-count, backpressure, consumer-scaling, poison-messages
- 2026-08-20 challenge L4: 4/6 MCQ, open question partial → not yet; misses → poison-messages, backpressure

## Crash course
<!-- only when a crash course is running -->
Project: "rate-limited job queue in Go" — repo: ~/mentor-labs/job-queue — chapter 3/7 done (commit c3f…)

## Learn later
- 2026-08-02 — DLX routing (skipped: sprint on the outage fix) — concept: dead-letter-exchange

## Debug log
<!-- root causes found in pair-debugging; the misconception is prime quiz material -->
- 2026-08-03 — consumer redelivery storm — root cause: ack sent before DB commit — misconception: "ack means processed" → concept: manual-ack

## Notes
Prefers exercises in a scratch file, not the repo. Said "quiz me less" on 2026-08-02 → cadence quiet.
```

### Conventions

- **Level** is the career level for this topic ([levels.md](levels.md)). Only `assess` changes it, and every change is appended to `level_history`.
- **Depth** is the last depth level that landed ([pedagogy.md](pedagogy.md#career-level-l1l7-vs-depth-d1d3)).
- **Lesson ids** use a topic letter plus a number (`R3`, `B2`, `S5`). They never use a bare `L<n>`, which reads as a career level. Old files keep their ids untouched.
- **Concept status:**
  - `untested`
  - → `shaky` (needed a depth drop, or one wrong answer)
  - → `weak` (repeated misses)
  - → `solid` (two consecutive correct)

  Promote or demote on every quiz, checkpoint or challenge.
- **Concept level tag** (`L3`) is the career level at which the concept is expected knowledge. It drives level-up gaps and quiz difficulty. Take it from the curriculum file when one exists.
- **Edges** (all optional, comma-separated ids):
  - `requires:` a hard prerequisite: you cannot understand this without that. It drives root-cause tracing and teaching order.
  - `builds_upon:` softer: understanding deepens with it but isn't blocked.
  - `related:` a sibling concept, useful for contrast.
- Edges point **down to prerequisites**. Never create a cycle; if one appears, demote the weaker edge to `related`.
- Concepts may live in other topics' files (`js-closures` required from `react.md`). When a trace hits an id absent here, look in the other progress files before treating it as new.
- `src:` is the lesson id, or one of `shadow (<context>)`, `debug (<date>)`, `crash-course ch<n>`, `design (<date>)`.
- Update `last_activity` on every write.

### Root-cause tracing

When a concept is missed:

1. Collect its `requires` (then theirs, transitively) into a candidate list.
2. Probe each candidate with **one** quick question, deepest first. Stop at the first one they clearly hold.
3. The deepest failing node is the real gap. Teach that, then re-ask the original question.
4. If every prerequisite holds, the gap is the concept itself. Re-teach it one depth level lower, in a new modality.
5. Record surprising traces in Notes ("Context failures traced to closures, not Context").

Say it out loud: "this one's actually upstream. Let's fix closures and this stops being confusing." Two or three probes at most, then teach. Interrogation is not tutoring.

## Decision file

One file per project: `~/.claude/mentor/decisions/<project>.md`, newest entry first. design-partner and system-design write it, and read it at the start of every design conversation.

```markdown
---
project: Viro
design_first: on               # on | off; only write this line when turned off
last_activity: 2026-08-03
---

## 2026-08-03 — Where chat history lives for Forge
**Constraints gathered:** ~50 runs/day, chats read far more than written, history
must survive restarts, single tenant for now, ship in a week.
**Decided:** per-message rows in Postgres keyed by run_id.
**Rejected:** one JSON blob per run — trades queryability for write simplicity.
Redis-only — trades durability for latency; history dies on eviction.
**Trade-off axis:** query flexibility vs. write simplicity.
**Cost accepted:** an extra table and migration; more writes on long chats.
**Rests on:** chats stay well under ~10k messages per run.
**Invalidated if:** runs become long-lived, or chats get shared across tenants.
**Door:** one-way — data model plus a migration.
**Riskiest assumption / how it was checked:** write volume — benchmarked at 3k
msgs/run, p99 insert 4ms. Fine.
**Pattern:** Repository — chat storage sits behind `ChatStore`.
**Contract agreed:** `ChatStore.append(run_id, msg) -> MsgId`,
`ChatStore.history(run_id, limit, before) -> list[Msg]`, raises `RunNotFound`.
**Principle:** storage shape follows query shape → concept `query-shaped-storage`.
**Note:** user chose Postgres over my Redis+Postgres hybrid recommendation.
```

Conventions:
- Every entry names a **cost** and an **invalidation condition**. An entry missing either is incomplete: a decision whose downside you can't state hasn't been made, only assumed.
- `Pattern:` is omitted when no standard pattern honestly applies.
- `Contract agreed:` holds the signatures from the skeleton step. Implementation and review are checked against it.
- A reversed decision is never deleted. Add a new entry and mark the old one `**Superseded by:** <date entry>`.
- When implementation drifts, update the entry in place with a `**Drifted:**` line.
- `Principle:` links to a concept id in a topic progress file.

## Resources file

`~/.claude/mentor/resources/<topic>.md`, written by the resources skill.

```markdown
---
topic: concurrency
checked: 2026-09-22            # date every link below was last verified
---

## Must-read now
- [ddia-ch7] *Designing Data-Intensive Applications*, Kleppmann — ch. 7 "Transactions",
  §Weak Isolation Levels (~40 min) — L3 — concepts: read-skew, lost-update, write-skew
  — why: the canonical map of what each isolation level actually prevents.

## Going deeper
- [herlihy-ch2] *The Art of Multiprocessor Programming* — ch. 2 "Mutual Exclusion" — L5
  — concepts: mutual-exclusion, peterson-lock — why: proves why locks are hard.

## Official docs / specs
- [pg-mvcc] PostgreSQL docs, "Concurrency Control" §13.2 — https://www.postgresql.org/docs/current/transaction-iso.html
  — L3 — concepts: mvcc, serializable-snapshot
```

Conventions:
- The `[id]` is what lessons and chapters cite (`read: resources#ddia-ch7`).
- Every entry has: an exact section, an estimated time, a level, the concepts it covers, and a one-line why.
- Every URL was fetched and resolved on the `checked` date. Books without a URL cite edition and chapter.

## Quiz, curriculum and map formats

- MCQ format and rules: [mcq.md](mcq.md).
- Curriculum template: 5–10 micro-lessons of ~10–15 minutes each. Order them as:
  1. repo lessons needed for the current task
  2. remaining repo lessons
  3. `[beyond this repo]` canon

  Within that, follow dependency order. Tag lessons `[repo: <path>]` or `[beyond this repo]`, and mark gaps inline: `(gap: <what the project is missing>)`.
- Map rendering: see [../skills/progress/SKILL.md](../skills/progress/SKILL.md).
