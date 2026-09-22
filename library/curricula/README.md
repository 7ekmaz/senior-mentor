# Curricula

Level-tagged syllabi the lesson, assess, crash-course and quiz skills seed from. One file per topic, grouped by domain. A topic with no file here is still teachable: the skills build its curriculum from general knowledge and the [levels.md](../levels.md) domain cells.

## File format

```markdown
# <Topic>

Domain: <domain> · Levels covered: L1–L6 · Canon: <ids from canon.md>

## What LLM answers usually gloss over
- The things a generated answer skips that a senior would insist on.

## Concepts
### <concept-id> — L3
requires: <ids> · related: <ids>
**Core:** 2–4 sentences: the mechanism, not the definition.
**Misconceptions:** the wrong beliefs that make good distractors.
**Diagram:** which template from diagrams.md, and what it should show.
**MCQ:** one canonical prediction question with 4 options (mcq.md format).
**Exercise:** a small thing the learner writes.
**Read:** a canon pointer.
```

## Rules

- Concept ids are kebab-case and stable. Progress files reference them.
- The level tag is where the concept becomes *expected*, per levels.md.
- `requires` edges point down to prerequisites. No cycles.
- Keep each concept to about 15 lines. This is a seed for teaching, not a textbook.

Status: `concurrency/`, `performance/` and `system-design/` are full. The other domains are stubs listing concepts only; contributions welcome (see CONTRIBUTING.md).
