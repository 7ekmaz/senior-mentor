# Mentor: quick guide

Not sure what to type? Just type **`/mentor`** and it will ask what you need.
Forgot a command? Type **`/mentor help`** to see this page.

## I want to…

| I want to… | Type | Example |
|---|---|---|
| learn something new | `/mentor <topic>` | `/mentor kafka` |
| learn it all, in depth | `/mentor deep <topic>` | `/mentor deep postgres` |
| get just the essentials, I'm in a hurry | `/mentor sprint <topic>` | `/mentor sprint redis` |
| watch it being built, step by step | `/mentor crash-course <project>` | `/mentor crash-course job queue in Go` |
| code it myself, with help | `/mentor code-along <task>` | `/mentor code-along add pagination` |
| find out my level | `/mentor assess <topic>` | `/mentor assess concurrency` |
| reach the next level | `/mentor level-up <topic>` | `/mentor level-up system-design` |
| design a feature before coding it | `/mentor design <feature>` | `/mentor design notifications` |
| practise system design | `/mentor system-design <system>` | `/mentor system-design url shortener` |
| understand code the AI just wrote | `/mentor explain` | |
| check it's production-ready | `/mentor review [file]` | `/mentor review worker.py` |
| debug it myself, with hints | `/mentor debug` | |
| test myself | `/mentor quiz [topic]` | `/mentor quiz` |
| get books and docs to read | `/mentor resources <topic>` | `/mentor resources caching` |
| see my progress | `/mentor status` | |
| see what I know as a map | `/mentor map <topic>` | `/mentor map concurrency` |

You can also just ask in plain words: "teach me Docker", "quiz me", "why did you do it that way?"

## While learning, you can say

| Say | What happens |
|---|---|
| `simpler` | Explained again, easier, from the basics |
| `another way` | Same idea, explained differently (picture, story, numbers, code trace…) |
| `example` | A new, different example |
| `deeper` | More detail on how it really works |
| `why` | Why it exists, and what it costs |
| `check me` | One quick question to test yourself |
| `next` | Move on |
| `just tell me` | Skip the questions and give me the answer |

In a crash course, you can also say:

| Say | What happens |
|---|---|
| `pause` | Stop and explain that line |
| `rewind` | Explain the last step again, a different way |
| `your turn` | I'll write the next part myself |
| `faster` | Speedrun mode |

## Levels

Your level is set **per topic**, and it only decides how things are explained to you. It is not a grade.

| Level | Title |
|---|---|
| L1 | intern |
| L2 | junior |
| L3 | mid |
| L4 | senior |
| L5 | staff |
| L6 | senior staff |
| L7 | principal |

## In a hurry?

Add `sprint` to almost anything: `/mentor sprint design …`, `/mentor sprint review`. You get the one-screen version. Whatever was skipped is saved to a **learn later** list, which `/mentor status` shows when you have time.

## Where your progress lives

`~/.claude/mentor/` holds your progress, decisions and reading lists. Plain markdown, safe to read or edit.
