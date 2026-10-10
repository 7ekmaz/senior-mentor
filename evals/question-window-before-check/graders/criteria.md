---
type: llm
weight: 1
---

PASS if, after the explanation, the agent explicitly invites the learner's questions in plain text (e.g. 'Questions on any part of this before I check you? Say ready when you want the question') and does NOT ask a graded checkpoint MCQ in the same turn as the explanation. A single prediction question asked BEFORE the explanation and framed as a guess is fine. FAIL if the explanation is immediately followed by a checkpoint/quiz question with no question window, or if it runs a placement quiz.
