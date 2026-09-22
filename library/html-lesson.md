# Opt-in HTML lesson page

The terminal is the default. Offer a rendered page **only** when a picture is too big for ASCII, and ask first:

- a full system-design walkthrough
- a crash-course recap
- a design review with several diagrams

Offer it in one line, e.g. "Want this as a lesson page with rendered diagrams and a clickable quiz?"

## How

- If the host has an Artifact tool, publish the page through it. Load its design skill first if the host says so.
- Otherwise, write a single self-contained file to `~/.claude/mentor/lessons/<topic>-<yyyy-mm-dd>.html` and give the path.
- One file, with no build step. Mermaid comes from `https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js`. Everything else is inline.
- Light and dark themes via `prefers-color-scheme`. It must be readable at phone width.

## Page skeleton

1. **Title + one-line goal:** "Design a URL shortener — L4 walkthrough".
2. **The fundamental** in a callout box ([pedagogy.md](pedagogy.md#unbury-the-fundamental)).
3. **Sections, one per step** (e.g. requirements → estimates → API → data model → architecture → deep dives → failure modes). Each has:
   - a mermaid diagram, where it helps
   - 3–6 sentences
   - a "why not the alternative" note
4. **Quiz:** the lesson's MCQs as clickable cards. Clicking an option reveals its explanation (the misconception note from [mcq.md](mcq.md)). No scoring backend.
5. **Read next:** entries from `~/.claude/mentor/resources/<topic>.md`, with ids and sections.
6. **Learn later:** the ledger items for this topic, if any.

The page is a recap and reference. The interactive teaching still happens in the conversation. Never move an MCQ checkpoint *into* the page as a replacement for asking it.
