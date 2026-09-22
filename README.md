# senior-mentor

**A senior engineer in your coding agent, one that teaches instead of just typing.**

> Forgot a command? → **[GUIDE.md](GUIDE.md)**, or type `/mentor help`.

## Why

Coding agents write working code faster than most of us can read it. The cost is quiet: engineers accept designs they couldn't defend, and the fundamentals end up buried under generated code. The fundamentals in question: why this is a queue, what happens under concurrent requests, where the throughput ceiling is, what breaks when a dependency is slow.

`senior-mentor` turns the agent into the mentor you'd want next to you:

- **It finds your level first**, per topic, on an L1 (intern) → L7 (principal) ladder, then pitches every explanation to it.
- **It teaches interactively.** You predict before it reveals. MCQs are built from real misconceptions, and ASCII diagrams show the real mechanism (interleaving timelines, pipelines with rates, sequences).
- **You write the code.** Code-alongs and crash courses end with "your turn". Watching isn't learning.
- **It designs before it builds.** For substantial features you get 2–3 costed options, one-way vs two-way doors, a named pattern and an agreed skeleton, and the decision is written down.
- **It unburies the fundamentals.** Every explanation names the principle underneath: backpressure, Little's law, idempotency, contention, query-shaped storage.
- **It keeps production at the centre:** concurrency, throughput, tail latency, timeouts and retries, observability, rollback.
- **It respects deadlines.** Sprint gear gives you the one-screen nutshell, and the skipped depth is logged to a learn-later ledger instead of lost.
- **It remembers.** Progress, a concept graph with prerequisites, spaced-repetition quizzes, decision records and reading lists persist across sessions in `~/.claude/mentor/`.

## Install

```
/plugin marketplace add <github-user>/senior-mentor
/plugin install senior-mentor@senior-mentor
```

From a local clone: `/plugin marketplace add /path/to/senior-mentor`.

## What's inside

| Skill | Fires | What it does |
|---|---|---|
| `mentor` | auto + `/mentor` | Router: reads your progress, picks the mode, prints the guide |
| `design-partner` | auto on substantial features | Design-first: constraints → costed options → door → pattern → skeleton → decision record |
| `explain-the-diff` | auto on "what did you just do?" | Explains agent-written code: silent decisions, production risks, the fundamental |
| `assess` | `/mentor assess`, `/mentor level-up` | Placement MCQs, gap to the next level, promotion challenge |
| `lesson` | `/mentor <topic>` | Level-aware micro-lessons; sprint, normal and deep gears |
| `crash-course` | `/mentor crash-course` | A build-along like a video course: narrate → predict → build → run → break → fix → your turn |
| `code-along` | `/mentor code-along` | You write a real task; skeleton-first, hint ladder, review |
| `system-design` | `/mentor system-design` | Requirements → estimates → API → data → architecture → deep dives → failure → ops |
| `production-review` | `/mentor review` | A teaching review against the production lens, ranked by severity |
| `pair-debug` | `/mentor debug` | Socratic debugging with escape valves for real incidents |
| `quiz` | `/mentor quiz` | Spaced repetition over your concept graph, with root-cause tracing |
| `resources` | `/mentor resources` | Verified books, papers and docs, mapped to exact chapters and your concepts |
| `progress` | `/mentor status`, `/mentor map` | Levels, weak spots, the ledger, level-up readiness, stale decisions |

Only three skills trigger on their own (`mentor`, `design-partner`, `explain-the-diff`). The rest are loaded by the router on demand, which keeps the always-on context cost small.

The shared teaching method lives in [`library/`](library/):

- [pedagogy](library/pedagogy.md): depth ladder, explain-again controls, modalities, circuit breaker, gears, ledger, hint ladder
- [levels](library/levels.md): the L1–L7 rubric per domain
- [production lens](library/production-lens.md)
- [diagrams](library/diagrams.md)
- [MCQ rules](library/mcq.md)
- [formats](library/formats.md): state schemas
- [canon](library/canon.md): vetted reading list
- [curricula](library/curricula/): level-tagged syllabi. Concurrency, performance and system design are full; the other domains are stubs.

## Evals

```
claude plugin eval . --runs 1
```

Scenarios live in [`evals/`](evals/). They check that the right skill fires, and that it doesn't fire on trivial work.

## Inspired by

- [obra/superpowers](https://github.com/obra/superpowers): skills as disciplined process
- [mattpocock/skills](https://github.com/mattpocock/skills): small, sharp engineering skills
- [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd): shaping how an agent communicates

## License

MIT
