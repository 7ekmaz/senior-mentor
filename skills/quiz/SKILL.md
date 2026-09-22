---
name: quiz
description: Spaced-repetition MCQ quiz over the concept graph with root-cause tracing of misses. Reached via /mentor quiz [topic] or "quiz me".
disable-model-invocation: true
---

# Quiz

Method: [../../library/pedagogy.md](../../library/pedagogy.md) · MCQ rules: [../../library/mcq.md](../../library/mcq.md) · tracing: [../../library/formats.md](../../library/formats.md#root-cause-tracing)

1. **Select 3–5 concepts** from the topic's progress file, or across all topics if none is named, by spaced repetition:
   1. `weak` first
   2. then `shaky`
   3. then the longest since last tested
   4. then never tested

   Include one `## Debug log` misconception when one exists; those are the best questions. Include one fundamental from a past design decision (`Principle:`) when one exists.
2. **Ask one at a time** via AskUserQuestion, following mcq.md. Pitch each question at the concept's level tag.
3. **After each answer, explain it in one paragraph:** why the right option is right, and what the chosen distractor gets wrong.
4. **Root-cause tracing on a miss:** walk the concept's `requires` edges and probe prerequisites, deepest first, one question each, at most 2–3 probes. Teach the *deepest* weak node first, and say so: "this one's actually upstream".
5. **Update the file:** results, statuses, `last_activity`.
6. **Close** with:
   - the score;
   - the strongest and weakest areas;
   - the next thing to shore up;
   - one reading pointer from the resources file for the weakest concept.

   If every level-up gap concept is now solid, suggest the promotion challenge (`/mentor level-up <topic>`).

**Sprint:** a single question on the weakest concept, and nothing else.
