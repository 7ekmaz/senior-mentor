---
max_turns: 12
allowed_tools: [Read, Glob, Grep, Skill]
---

Our order service is a Python FastAPI app on Postgres (the code isn't in this folder — just work with me on the approach). I want to add webhook delivery: when an order is paid, notify every subscribed partner URL, and retry when a partner is down. Please build it.
