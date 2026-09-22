---
name: lesson
description: Level-aware micro-lesson curriculum for a topic in sprint (nutshell), normal, or deep gear. Reached via /mentor <topic>, /mentor deep|sprint|nutshell <topic>.
disable-model-invocation: true
---

# Lesson: the curriculum engine

Method: [../../library/pedagogy.md](../../library/pedagogy.md) · levels: [../../library/levels.md](../../library/levels.md) · state: [../../library/formats.md](../../library/formats.md) · MCQs: [../../library/mcq.md](../../library/mcq.md) · diagrams: [../../library/diagrams.md](../../library/diagrams.md)

## Start

- A progress file exists → resume at the first unchecked lesson. Skip to "Teach".
- No progress file and not sprint → run placement ([../assess/SKILL.md](../assess/SKILL.md)), then build the curriculum.
- Sprint → go to "Sprint: the nutshell".

## Build the curriculum (normal / deep)

1. **Seed from the library.** If `../../library/curricula/**/<topic>.md` exists, take its concepts, prerequisite edges, level tags, misconceptions and canonical MCQs. Select the concepts at the learner's level and one above. Put below-level concepts in only when placement showed a gap there.
2. **Two layers:**
   - **Layer 1, their code:** if the topic appears in the current repo, cover that usage first, taught through the real files (`[repo: <path>]`).
   - **Layer 2, the canon:** what a senior engineer of this topic is expected to know at this level (`[beyond this repo]`). Where the project *should* use something and doesn't, flag it: `(gap: …)`.
   - No repo, or the topic absent from it → layer 2 entirely. That is normal.
3. **Size by gear:** normal gets 5–10 micro-lessons; deep gets the full syllabus plus failure modes, testing strategy, performance, and rejected alternatives.
4. **Add every concept to the graph with its edges** *before* teaching, and order lessons by dependency.
5. **Attach reading.** If `~/.claude/mentor/resources/<topic>.md` doesn't exist, run [../resources/SKILL.md](../resources/SKILL.md) in the background of the first lesson (a subagent, when available), or at the end of it. Cite `read: resources#<id>` on each lesson line.
6. Save. Show the curriculum as a numbered list with a rough time per lesson.

## Teach (one micro-lesson, ~10–15 min)

1. **Hook:** the problem this concept exists to solve, as a concrete failure: "two requests, one balance, money vanishes".
2. **Predict:** one MCQ before the explanation ("what do you think happens?").
3. **Explain** at the recorded depth. Lead with the learner's best modality (Calibration → Modalities), and draw a diagram when there's a mechanism ([diagrams.md](../../library/diagrams.md)). Ground it in their repo for layer 1, or a minimal realistic snippet for layer 2.
4. **Name the fundamental** in one line.
5. **Level lens:**
   - L1–L2: how to use it correctly, and the common bug.
   - L3–L4: the trade-off, and what breaks under load or failure ([production-lens.md](../../library/production-lens.md)).
   - L5+: the system-wide cost, and when you'd refuse it.
6. **Exercise they write.** Small, runnable, in a scratch file unless they want it in the repo. Review it: what's right first, then what to fix and why. Stuck → use the hint ladder.
7. **Checkpoint:** 1–2 MCQs, prediction over trivia. A miss → circuit breaker / root-cause tracing.
8. **Persist:** lesson checkbox, concept statuses, depth that landed, modalities, `last_activity`. Close by naming the next lesson and one reading pointer.

## Sprint: the nutshell

One screen, in the format from [pedagogy.md § Sprint](../../library/pedagogy.md#sprint-ship-fast-but-not-blind). **Answer in the first reply, with no calibration question first.** With no progress file, pitch at L3 / D2 and say so in one line at the end. If their repo uses the topic, the snippet comes from their code. After the MCQ:

- Add the unchecked depth to `## Learn later`: the concepts you skipped, the exercise, placement if it was skipped.
- Create or update the progress file with `gear: sprint`.
- Close with one line: "Ledger has N items for when the deadline passes."

## Rules

- You never write the exercise solution while they watch, unless they climbed the whole hint ladder or said `just tell me`.
- A new example is always genuinely different: a new domain, failure mode or language.
