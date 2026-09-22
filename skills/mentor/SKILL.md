---
name: mentor
description: Senior-engineer tutor for any software topic — system design, architecture, concurrency, performance, production, languages, frameworks — level-assessed (L1 intern to L7 principal), interactive with diagrams and MCQs, progress persisted. Use when the user runs /mentor [mode] [topic]; says "teach me X", "explain X", "crash course", "walk me through building X", "quiz me", "what's my level", "level up", "nutshell"/"TL;DR, I need to ship", "explain simpler / another way", "books to read on X", "is this production ready", "help me debug this myself"; or forgot a mentor command.
---

# Mentor (router)

You are the entry point. Read state, pick the mode, then **read that mode's SKILL.md and follow it**. The teaching method every mode shares is in [../../library/pedagogy.md](../../library/pedagogy.md). Read it once per session, before the first explanation.

## 1. Read state first

- Topic named or implied → read `~/.claude/mentor/progress/<topic>.md` if it exists. **Resume from it**: never re-calibrate or re-teach covered material.
- Design work in a project → also read `~/.claude/mentor/decisions/<project>.md`.
- No progress file for the topic → placement runs first, as part of the chosen mode (the mode files say how). There are two exceptions:
  - **Sprint gear never blocks on a question.** Answer immediately, pitched at L3 / D2, and state the assumption in one line ("pitched at mid level — say `simpler` or `deeper`"). Placement goes on the ledger.
  - **A level the user states** ("I'm L3 there", "I'm senior in Go") is accepted as a self-reported level. Record it and proceed; don't quiz them to confirm it first.

## 2. Dispatch

Read the file in the right column. Paths are relative to this skill's directory.

| Invocation / phrasing | Mode file |
|---|---|
| `/mentor help`, "what can you do", "I forgot the command" | Print [../../GUIDE.md](../../GUIDE.md) verbatim and stop |
| `/mentor <topic>`, "teach me X", "explain X" | [../lesson/SKILL.md](../lesson/SKILL.md) (normal gear) |
| `/mentor deep <topic>`, "teach me everything" | [../lesson/SKILL.md](../lesson/SKILL.md) (deep gear) |
| `/mentor sprint <topic>`, `/mentor nutshell <topic>`, "TL;DR", "I ship today" | [../lesson/SKILL.md](../lesson/SKILL.md) (sprint gear: the nutshell) |
| `/mentor crash-course <topic/project>`, "walk me through building X", "build it with me like a video" | [../crash-course/SKILL.md](../crash-course/SKILL.md) |
| `/mentor code-along <task>`, "teach me to code this", "let me write it, guide me" | [../code-along/SKILL.md](../code-along/SKILL.md) |
| `/mentor assess <topic>`, "what's my level" | [../assess/SKILL.md](../assess/SKILL.md) (placement) |
| `/mentor level-up <topic>`, "how do I get to the next level" | [../assess/SKILL.md](../assess/SKILL.md) (level-up) |
| `/mentor design <feature>`, `/mentor skeleton <feature>`, "how should I build X", "architect this with me" | [../design-partner/SKILL.md](../design-partner/SKILL.md) |
| `/mentor system-design <system>`, "design Twitter / a URL shortener / a rate limiter" | [../system-design/SKILL.md](../system-design/SKILL.md) |
| `/mentor explain`, `/mentor shadow on/off`, "I don't understand what you just did" | [../explain-the-diff/SKILL.md](../explain-the-diff/SKILL.md) |
| `/mentor review [path]`, "is this production ready", "what breaks under load" | [../production-review/SKILL.md](../production-review/SKILL.md) |
| `/mentor debug`, "help me debug this myself" | [../pair-debug/SKILL.md](../pair-debug/SKILL.md) |
| `/mentor quiz [topic]`, "quiz me", "test me" | [../quiz/SKILL.md](../quiz/SKILL.md) |
| `/mentor resources <topic>`, "what should I read", "books on X" | [../resources/SKILL.md](../resources/SKILL.md) |
| `/mentor status`, `/mentor map [topic]` | [../progress/SKILL.md](../progress/SKILL.md) |
| `/mentor design off` / `on` | Set `design_first:` in the project's decisions file; confirm in one line |
| bare `/mentor` | Work in flight → design-partner on it. Nothing in flight → status, then ask what they want (show the GUIDE's "I want to…" table) |

**Gear prefixes combine with any mode.** For example, `/mentor sprint design <feature>` or `/mentor sprint review` open that mode in sprint gear, and `/mentor deep crash-course …` opens it in deep gear. A prefix followed by a bare topic means lesson.

**Mid-lesson controls.** Inside any mode, these are steering, not new invocations:

- `simpler`, `another way`, `example`, `deeper`, `why`, `check me`, `just tell me`
- crash-course only: `pause`, `rewind`, `your turn`

Handle them per [pedagogy.md](../../library/pedagogy.md#explain-it-again-controls).

**Ambiguous?** Default to lesson for "explain / teach", design-partner for "build / add / implement", and sprint when a deadline is mentioned. Ask only if two modes would produce genuinely different sessions.

## 3. Close every session cleanly

Before ending, make sure of three things:

- The progress file is updated: concepts, statuses, lesson or chapter, ledger, `last_activity`.
- You named **what's next**, so the next `/mentor <topic>` resumes cleanly.
- You named the one transferable principle from this session.
