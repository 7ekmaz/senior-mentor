---
name: explain-the-diff
description: Explain code the agent just wrote or changed — why this design, what was rejected, what fails in production, the fundamental underneath — then one prediction question. Use when the user says "I don't understand what you just did", "explain this change/code", "why did you do it that way", "walk me through this diff", or runs /mentor explain or /mentor shadow on|off.
---

# Explain the diff: never let generated code go un-understood

Method: [../../library/pedagogy.md](../../library/pedagogy.md) · production lens: [../../library/production-lens.md](../../library/production-lens.md) · state: [../../library/formats.md](../../library/formats.md)

The anti-dependency skill. Agent-written code the user can't explain is a liability they now own.

## What to explain

The last substantial change: `git diff`, or the edits made in this session. The user can instead point at specific files or lines. Read the topic's progress file for the user's level and depth. If there isn't one, pitch at L3 and D2, and offer placement at the end.

## Shape (normal)

1. **What changed, in 3 sentences.** The behaviour, not a file list.
2. **The map.** A small diagram when the change spans components or has an order of operations ([diagrams.md](../../library/diagrams.md)).
3. **The load-bearing lines.** Walk the 2–5 lines that matter most. For each one:
   - what it does;
   - why it's this way;
   - the obvious alternative, and why it lost.
4. **Decisions made silently.** Every choice the agent made without asking: a library, a data shape, sync vs async, an error strategy, a default value. For each one: what it trades away, and whether it's a one-way door. **This is the core of the skill.** Buried decisions are what LLM output hides.
5. **Production lens, at their level.** What breaks under concurrency, load or failure, with a severity (ship-blocker / fix soon / worth knowing). Be honest about your own code's weaknesses.
6. **The fundamental** it rests on, in one line.
7. **One prediction question** via AskUserQuestion, e.g. "if two requests hit this at once, what happens?". A wrong answer → name the misconception in two sentences and mark it `shaky`. It's a teaching moment, not a gate.
8. Log the concepts touched into the graph (`src: shadow (<context>)`).

## Shadow mode (`/mentor shadow on|off`)

When shadow is on for a topic (the progress file's `shadow_cadence` is not `quiet`), during normal work:

- Before applying a **substantial** change, explain what you're about to do and why at their level, then ask one prediction question. Trivial edits (renames, imports, formatting) pass silently.
- Checks land only at natural checkpoints: before a commit, after a feature works, at a design decision. Never mid-flow.
- "Quiz me less" / "more" adjusts `shadow_cadence` permanently.

## Sprint

2–3 sentences on what changed and why, the one trap, and no question. Add `explain <change>` to `## Learn later`.

## Level lens

- **L1–L2:** trace execution line by line for the load-bearing part, and define every term.
- **L3–L4:** focus on step 4 (silent decisions) and step 5 (production lens).
- **L5+:** the system impact: coupling introduced, ownership, what this makes harder later.
