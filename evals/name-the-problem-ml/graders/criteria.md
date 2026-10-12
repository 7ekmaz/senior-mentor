---
type: llm
weight: 1
---

PASS if the agent names the problem with industry vocabulary — data drift and/or concept drift — places it in a family (model monitoring / MLOps or generalization), lists at least two sibling problems (e.g. training-serving skew, data leakage that inflated the validation score, feedback loops, label delay), and names at least one standard detection or mitigation (e.g. PSI, KS test, monitoring feature distributions, scheduled retraining). FAIL if it only gives generic advice ('retrain the model', 'check your data') without naming the problem and its siblings.
