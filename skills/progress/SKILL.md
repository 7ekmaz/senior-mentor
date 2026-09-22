---
name: progress
description: Show learning status across topics (levels, lessons, weak spots, learn-later ledger, level-up readiness, stale decisions) or render a topic's concept graph. Reached via /mentor status or /mentor map [topic].
disable-model-invocation: true
---

# Progress: status and map

State schema: [../../library/formats.md](../../library/formats.md)

## `/mentor status`

Read every file in `~/.claude/mentor/progress/`, plus the current project's `~/.claude/mentor/decisions/<project>.md`. Print one block per topic, most recent first:

```
concurrency — L3 (since 2026-08-10) · normal gear · 4/7 lessons · last 2026-09-20
  weak: lock-ordering, memory-visibility · shaky: backpressure
  learn later (2): row-lock escalation · placement
  ▶ next: C5 backpressure — or `/mentor level-up concurrency` (gap 3/4 solid)
```

Then list:
- **Level-up ready:** topics where every `## Level-up` gap concept is solid → "take the promotion challenge?"
- **Ledger due:** sprint items older than 7 days → offer to pay one down.
- **Decisions at risk:** entries whose `Rests on:` / `Invalidated if:` condition looks false given what you know about the project now.
- **Reading:** unread must-reads from `~/.claude/mentor/resources/`.

End with a single recommended next action.

## `/mentor map [topic]`

Walk the `requires` edges from the roots (concepts with no prerequisites) outward. Render an indented tree:

```
rabbitmq (L3)
├── ✓ tcp-basics
│   └── ✓ channel-vs-connection
│       └── ✗ manual-ack
│           └── · prefetch-count  [L4 gap]
└── ✓ exchange-types
    ├── ✓ routing-keys
    └── ~ message-lifecycle
```

- Markers: `✓` solid · `~` shaky · `✗` weak · `·` untested.
- Tag level-up gap concepts with `[L<n> gap]`.
- Show `builds_upon` as a dashed note under a node when it matters. Omit `related` unless asked.

Offer a mermaid `graph TD` version for use outside the terminal.
