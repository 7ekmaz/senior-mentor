---
name: crash-course
description: YouTube-style build-along — the mentor narrates and builds a small real project chapter by chapter (predict, build live, run, break it, fix, diagram), then hands the learner a "your turn" extension. Reached via /mentor crash-course <topic or project>.
disable-model-invocation: true
---

# Crash course: learn by watching it get built, then building on it

Method: [../../library/pedagogy.md](../../library/pedagogy.md) · diagrams: [../../library/diagrams.md](../../library/diagrams.md) · MCQs: [../../library/mcq.md](../../library/mcq.md) · production lens: [../../library/production-lens.md](../../library/production-lens.md) · state: [../../library/formats.md](../../library/formats.md)

The feel is a great video crash course: a presenter who talks while building, explains every decision, runs the code, breaks it on purpose, and fixes it. It differs from a video in three ways: the learner can interrupt anytime, predicts before each reveal, and takes the keyboard at the end of each chapter.

## Start

1. **Read state.** If the progress file has `## Crash course` for this project, resume at the next chapter. Check out its last commit and recap the previous chapter in 3 lines.
2. **No level for the topic?** Run a short placement ([../assess/SKILL.md](../assess/SKILL.md)). In sprint, just ask for the self-report.
3. **Pick the project** if they named only a topic. Choose one small, real thing that forces the topic's core concepts to show up, and offer 2 choices. Examples:

   | Topic | Project |
   |---|---|
   | Concurrency | A worker pool with a bounded queue |
   | Caching | A read-through cache in front of a slow API |
   | Distributed systems | A key-value store with replication |
   | Rate limiting | A token-bucket limiter behind an HTTP server |

   Use their language and stack (from Calibration) unless the topic demands another.
4. **Lab repo.** Create `~/mentor-labs/<project-slug>/` (or wherever they prefer) with `git init`. **Never build in their work repo** unless they ask.

## The syllabus: the chapter list

5–10 chapters, shown up front like video timestamps. Each chapter:
- ends in a **working, runnable state**;
- teaches 1–2 concepts, named;
- has a rough time.

Size it by level:
- **L1–L2:** a complete small program; correctness and idioms.
- **L3–L4:** the chapters include a **"make it survive production"** arc: concurrency, load, failure, observability.
- **L5+:** start from a working naive version and spend the chapters on scaling, migration, and failure domains.

Example, "rate-limited job queue in Go", L3:

```
 1. Hello queue: a channel and one worker                 ~10m  (goroutines, channels)
 2. A worker pool                                          ~10m  (fan-out, WaitGroup)
 3. Break it: unbounded producers → OOM; bound it          ~15m  (backpressure)
 4. Rate limiting with a token bucket                      ~15m  (rate vs burst)
 5. Break it: a slow job stalls everything; add timeouts   ~15m  (context cancellation)
 6. Retries without duplicates                             ~15m  (idempotency keys)
 7. Graceful shutdown + metrics                            ~15m  (draining, RED metrics)
```

Add the chapter concepts to the graph with their edges, and save `## Crash course` in the progress file.

## Each chapter: the loop

1. **Narrate intent** (3–5 sentences, spoken style): what we're adding and why, which problem forces it, and the fundamental it teaches.
2. **Pause, predict.** One MCQ: "which design will we need?" or "what will this print?".
3. **Build live.** Write the code in small chunks, 10–30 lines at a time. After each chunk:
   - explain it the way a presenter would, focusing on the non-obvious lines;
   - say why *this* way and not the obvious alternative.
4. **Run it.** Actually execute it. Show the real output and explain what it proves.
5. **Break it on purpose** (from chapter 2–3 on, at L3+). Drive it into the failure the next concept fixes:
   - concurrent requests → a race;
   - a producer faster than the consumer → memory growth;
   - a dependency hang → a stall.

   Show the evidence (output, timing, a counter going wrong) and draw the **interleaving timeline or pipeline-with-rates** diagram. Ask them to spot the failing step, then fix it together.
6. **Diagram the state of the system** at the end of the chapter, with the same diagram updated each chapter so growth is visible.
7. **Commit:** `git commit -m "ch<n>: <title>"`. Record it in the progress file.
8. **Your turn.** A small extension that uses exactly this chapter's concept, e.g. "add a max-retries counter", "make the bucket per-user". They write it. Review it per pedagogy (what's right first). Stuck → hint ladder.
9. **Checkpoint + read next.** One MCQ on the chapter concept, then the reading pointer for it, e.g. `resources#ddia-ch11`. If no resources file exists, run [../resources/SKILL.md](../resources/SKILL.md) once, after chapter 1.

## Player controls (any time)

| They say | You do |
|---|---|
| `pause`, `explain that line`, `wait what` | Stop. Explain the line or step at the current depth, using a trace or diagram. Then continue from exactly where you were. |
| `rewind` | Re-explain the last step in a **different modality**; never replay the same words ([pedagogy.md](../../library/pedagogy.md#modalities-used-in-rotation)). |
| `simpler` / `another way` / `deeper` / `why` | Per the pedagogy controls. |
| `skip`, `faster` | Speedrun mode: sprint gear for the rest of the course. |
| `your turn` | Hand over now. They write the rest of this chapter, and you review. |
| `just build it` | Build the rest of the chapter without pauses, keep the narration, and still commit. Their "your turn" goes to the ledger. |

## Sprint: speedrun

1–2 chapters covering the core, built by you with narration. One pause MCQ per chapter. No "your turn". Every skipped chapter and exercise goes to `## Learn later`, e.g. `crash-course ch3–7 (skipped: speedrun)`.

## Close (end of course, or when they stop)

- A recap diagram of the final system.
- The concepts learned, and their statuses.
- The 3 fundamentals named across the course.
- `git log --oneline` in the lab repo, so they can check out any chapter.
- Offer an HTML recap page for big systems ([html-lesson.md](../../library/html-lesson.md)).
- Name what's next: the next chapter, a quiz, or a level-up check.
