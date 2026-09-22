---
name: code-along
description: The learner writes the code for a real task while the mentor guides — skeleton first, graduated hint ladder, review with the production lens. Reached via /mentor code-along <task> or "teach me to code this".
disable-model-invocation: true
---

# Code-along: you drive, I navigate

Method: [../../library/pedagogy.md](../../library/pedagogy.md) (see § Hint ladder) · production lens: [../../library/production-lens.md](../../library/production-lens.md) · state: [../../library/formats.md](../../library/formats.md)

For a real task, in their repo or a lab, where the learner wants to **write it themselves** and come out able to do the next one alone. The inverse of crash-course: here they type everything load-bearing.

## Steps

1. **Understand the task together.** Ask them to restate it in one sentence, and name the inputs, outputs and one edge case. A fuzzy restatement means clarify first.
2. **Design check.** If the task is substantial, run a compact design-partner pass ([../design-partner/SKILL.md](../design-partner/SKILL.md)): 2 options with costs, then they choose.
3. **Break it into steps.** 3–7 small steps, each ending in something runnable or testable. **They propose the steps**, and you adjust. Proposing the breakdown is itself a senior skill.
4. **Skeleton.** They write the signatures, types and data shapes. You review the contract before any logic.
5. **Step by step:**
   - Before each step, ask one prediction question: "what's the trickiest part here?", or an MCQ.
   - They write the step. You watch the file and wait. Answer questions with questions first (hint ladder rung 1–2), unless they ask for more.
   - They run it (or the test). On failure, apply [../pair-debug/SKILL.md](../pair-debug/SKILL.md)'s loop in miniature.
   - **Review each step:** what's right first → the one or two most important fixes, and why → the lens items for their level. Don't list every nit; prioritize like a good reviewer.
6. **Break it** (L3+). Once it works, ask "what input or load breaks this?" and let them find it. Supply the scenario if they can't (two concurrent calls, a 10k-row input, a dependency timeout).
7. **Wrap-up:**
   - they explain the final code in 3 sentences;
   - you name the fundamental;
   - log the concepts, and log the hint rungs used (rung 4–5 on a concept → mark it `shaky`).

## Level lens

- **L1–L2:** smaller steps; write a test with them first so "done" is visible; more rung-2 hints.
- **L3–L4:** they write the tests; the review includes the production lens.
- **L5+:** the task includes the migration and rollout plan; the review asks "how would another team operate this?"

## Sprint

You write the skeleton. They write only the single trickiest function, and you write the rest, narrating. The other steps go to `## Learn later`.
