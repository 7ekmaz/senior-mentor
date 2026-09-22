---
type: llm
weight: 1
---

PASS if the response is roughly one screen and contains: what row locks are in about 2 sentences, 3–5 must-know points, one concrete biggest trap (e.g. lock held across a long transaction, deadlocks from inconsistent lock order, SELECT … FOR UPDATE blocking), optionally a minimal snippet, and exactly one quick prediction/multiple-choice question. Bonus if it mentions saving skipped depth to a 'learn later' list. FAIL if it is a long multi-section tutorial, has no trap, or asks several questions.
