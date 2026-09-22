# Contributing

The most valuable contributions are **curricula** and **evals**.

## Add or fill a curriculum

1. Pick a stub in `library/curricula/`, or add a new `library/curricula/<domain>/<topic>.md`.
2. Follow the format in [library/curricula/README.md](library/curricula/README.md). Every concept needs:
   - a level tag ([library/levels.md](library/levels.md));
   - `requires` edges that point down, with no cycles;
   - real misconceptions;
   - one prediction MCQ whose distractors are named misconceptions ([library/mcq.md](library/mcq.md)).
3. Fill in "What LLM answers usually gloss over". It's the point of the file.
4. Cite canon only by chapter or section, and only what you've verified.

## Change a skill

- Shared behaviour belongs in `library/`. A skill file holds only what is unique to its mode. Don't copy rules between skills; point at them.
- Keep auto-triggering skills to the minimum. A new mode should be `disable-model-invocation: true` and dispatched from `skills/mentor/SKILL.md`.
- Update [GUIDE.md](GUIDE.md) and the router's dispatch table together, and add an eval case.

## Evals

Each case lives in `evals/<case>/` as `prompt.md` + `graders/*.md`. Add a trigger case and an anti-trigger case for any behaviour change. Run:

```
claude plugin validate .
claude plugin eval . --runs 1
```
