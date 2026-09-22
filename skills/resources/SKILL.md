---
name: resources
description: Find and verify the books, papers, official docs, and talks worth reading for a topic at the learner's level, mapped to specific chapters/sections and to concepts, saved as a reading list lessons cite. Reached via /mentor resources <topic> or "what should I read on X"; also run by lesson/crash-course when a topic has no reading list.
disable-model-invocation: true
---

# Resources: what to read, exactly which part, and why

Canon seed: [../../library/canon.md](../../library/canon.md) · schema: [../../library/formats.md](../../library/formats.md#resources-file) · levels: [../../library/levels.md](../../library/levels.md)

Goal: a short, verified reading list where every entry points at a **specific chapter or section**, maps to concepts in the learner's graph, and says why it's worth their time at their level.

## Steps

1. **Read state.** The topic's progress file (level, concepts, gaps, ledger) and any existing `~/.claude/mentor/resources/<topic>.md`.
   - If the existing file was `checked` within 90 days and the concepts haven't changed, just present it.
   - If the concepts have changed, add to it.
2. **Start from the canon.** Pull the matching entries from canon.md for the topic's domain, filtered to the learner's level ± 1.
3. **Search** (WebSearch / WebFetch). Look for primary, high-trust sources that fill gaps the canon doesn't cover:
   1. official docs and specs/RFCs for the concrete technology;
   2. seminal papers;
   3. engineering blog posts and postmortems from teams running it in production;
   4. well-known conference talks.

   Prefer the newest authoritative version: current docs, the latest edition.
4. **Verify every entry.**
   - Fetch each URL and confirm it resolves and says what you claim.
   - For books, confirm the chapter and section title from a table of contents when you can fetch one. Otherwise cite the chapter by subject ("the chapter on transactions"), not a guessed number.
   - **Never invent a title, author, chapter, or URL.** Drop anything you couldn't verify, or mark it `(unverified — check)`.
5. **Map each entry:** the exact section, estimated reading time, level, the concepts it covers (use graph ids), and a one-line *why*.
6. **Tier the list:**
   - **Must-read now:** at most 3. The fastest path to the current lesson or gap.
   - **Going deeper:** for the next level.
   - **Official docs / specs:** reference.

   Keep it short. A 30-item list is a list nobody reads.
7. **Write** `~/.claude/mentor/resources/<topic>.md` with `checked: <today>`. Add `read: resources#<id>` pointers to the matching curriculum lines in the progress file.
8. **Present:** the must-reads, with a time estimate for each, and one sentence on what to look for while reading ("notice how each isolation level is defined by which anomaly it prevents"). Offer a 2-question MCQ check after they read.

## Run by other skills

When lesson or crash-course calls this, run it without interrupting the teaching: as a subagent when available, otherwise at a natural break. Present only the must-read for the current lesson.

## Sprint

The single must-read section with its time, e.g. "DDIA, the transactions chapter, §Weak Isolation Levels — 20 min", verified. The rest of the list goes to `## Learn later` as one item: `reading list for <topic>`.
