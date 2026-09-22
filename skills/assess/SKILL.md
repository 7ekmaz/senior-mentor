---
name: assess
description: Place the learner on the L1–L7 career ladder for a topic, or show the gap to the next level and run a promotion challenge. Reached via /mentor assess or /mentor level-up.
disable-model-invocation: true
---

# Assess: placement and level-up

Method: [../../library/pedagogy.md](../../library/pedagogy.md) · rubric: [../../library/levels.md](../../library/levels.md) · MCQ rules: [../../library/mcq.md](../../library/mcq.md) · state: [../../library/formats.md](../../library/formats.md)

Frame it honestly and lightly: "a few quick questions so I pitch this right, not an exam". The result is a teaching setting, never a grade. Show it that way.

## Placement (`/mentor assess <topic>`, or the first contact from any mode)

1. **Self-report.** One AskUserQuestion with up to 3 questions:
   - "Which is closest to you on <topic>?" — options: the L1–L2 / L3 / L4 / L5+ signature descriptions from levels.md, in plain words.
   - What they already know well (for bridging).
   - Why they need it now.
2. **Adaptive MCQs, binary-searching the ladder.** Start one level *below* the self-report.
   - Correct → go up a level. Wrong → go down.
   - 4–6 questions total. Stop when two answers bracket a level.
   - Use the topic's curriculum file (`../../library/curricula/**/<topic>.md`) for level-tagged concepts and canonical MCQs when one exists. Otherwise write questions from the levels.md domain cells.
3. **One open question** at the bracketed level: "walk me through what happens when …". Grade it against the rubric (mcq.md § Open questions).
4. **Place.** Use the rules in levels.md § Placement bands. Tell them in 3 lines:
   - their level;
   - what they reliably have (quote a specific answer);
   - the one gap that would move them up.

   Offer to start teaching right there.
5. **Write** the progress file:
   - `level:`, and `level_history: [L3@<date>]`
   - `## Calibration`
   - each probed concept, with its status and quiz result
   - `depth: D2` as a default (D1 if the open answer was mechanical-level shaky)

Sprint gear skips steps 2–3. Use the self-report as the level and add `placement (skipped: sprint)` to `## Learn later`.

## Level-up (`/mentor level-up <topic>`)

1. **Gap.** Read the current level from the progress file. If the user stated a level in the request ("I'm L3"), use that as self-reported and **show the gap right away**, with no placement quiz. Offer the promotion challenge as the verification instead. Run placement first only when no level is known at all. Diff the levels.md domain cells at the current and next level. Turn each gap item into a concept tagged with the next level:
   - add it to the graph with `requires` edges to what they already have;
   - write `## Level-up` → `Target: L<n+1> — gap: …`.
2. **Show it** as a short, concrete list: "You can use locks correctly. For L4: reason about contention cost, choose lock vs lock-free vs message passing, design backpressure." Include rough time: "~5 micro-lessons".
3. **Plan.** Offer to teach the gap now, via the lesson flow with only the gap concepts as the curriculum, or via a crash course that exercises them. Attach `resources` must-reads for the gap if a resources file exists.
4. **Promotion challenge.** Offer it when every gap concept is `solid`, or when the learner asks. It has three parts:
   - 5–6 MCQs at the target level, mixed across the gap and prerequisites;
   - one open "what breaks at 10× load / when X fails" question;
   - for a target of L5+, a short design review: present a flawed design and ask them to find the three biggest problems and the one-way doors.

   Outcome:
   - **Pass** (≥ 5/6 and a solid open answer): bump `level:`, append to `level_history`, log the challenge under `## Level-up`, and name the next target.
   - **Not yet:** log it; misses feed root-cause tracing (formats.md) and become the next lessons. No gate on continuing. Say "not yet", never "failed".
5. **Level down.** When lessons keep landing a level below `level:` (see pedagogy.md § Circuit breaker, step 5), lower it by one, append to history with a note, and tell the learner in one line why the pitch is changing.

## Auto-suggest

When the progress skill notices every gap concept is solid, it suggests the challenge. This file owns the challenge itself.
