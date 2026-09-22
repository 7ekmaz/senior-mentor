# MCQs

Every multiple-choice question in every skill follows these rules. Ask via AskUserQuestion, **one question per call**.

## Rules

1. **Prediction over trivia.** Ask what happens, what breaks, or what they'd choose. Never ask for a definition or a name.
   - Good: "What does this return if the broker restarts here?"
   - Bad: "What does AMQP stand for?"
2. **Four options. Every distractor is a named misconception** that a real engineer holds. No filler, no joke options.
3. **Answerable in seconds.** The code shown in the question is at most ~10 lines.
4. **Level-tagged.** Write the question at the concept's level ([levels.md](levels.md)). Placement and promotion challenges pick by level; quizzes pick by weakness.
5. Keep the correct option's position varied. Keep option lengths similar, so the longest option isn't a giveaway.
6. **After the answer, one paragraph:** why the right one is right, and what the chosen distractor gets wrong, named as the misconception. If they answered correctly, name the most tempting distractor and why it's wrong.
7. Write `correct@<date>` or `wrong@<date>` onto the concept and update its status ([formats.md](formats.md#conventions)). A miss triggers root-cause tracing ([formats.md](formats.md#root-cause-tracing)) in quiz and assess modes.

## Format

```
Question (L3, manual-ack): A consumer with manual acks crashes after processing a message
but before acking it. What happens to the message?
- Redelivered to another consumer    (correct — unacked messages are requeued on channel close)
- Lost                               (misconception: confusing manual-ack with auto-ack)
- Sent to the dead-letter exchange   (misconception: DLX handles reject/expiry, not consumer death)
- Blocked until that consumer returns (misconception: messages are pinned to a consumer)
```

The parenthetical notes are for you. Show only the option text to the learner.

## Question shapes that work

| Shape | Example stem |
|---|---|
| Predict the output | "Two goroutines run this 1000 times each. What does it print?" |
| Find the failure | "This passes every test. What breaks first in production?" |
| Pick under constraint | "10k writes/s, reads are rare, loss is unacceptable. Which store?" |
| What changes at scale | "Traffic goes 10×. Which component falls over first?" |
| Order the steps | "Which sequence makes this retry safe?" |
| Diagnose | "p50 is fine, p99 jumped 10× after the deploy. Most likely cause?" |

## Open questions (placement and promotion only)

One free-text question at the target level, e.g. "Walk me through what happens, step by step, when this service's database fails over mid-request."

Grade it against the level rubric: did they name the mechanism, the failure mode and the fix at that level's scope? Tell them what a strong answer at that level would add.
