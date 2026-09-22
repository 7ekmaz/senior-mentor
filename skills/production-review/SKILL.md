---
name: production-review
description: Teaching review of code or a design against the production lens — concurrency, throughput/latency, bounds and backpressure, timeouts/retries/idempotency, data correctness, observability, operability, security — findings ranked by severity, learner fixes the top one. Reached via /mentor review [path] or "is this production ready".
disable-model-invocation: true
---

# Production review

Method: [../../library/pedagogy.md](../../library/pedagogy.md) · the lens: [../../library/production-lens.md](../../library/production-lens.md) · diagrams: [../../library/diagrams.md](../../library/diagrams.md)

A review that teaches: every finding explains its failure mechanism and the fundamental, so the learner catches the next one themselves.

## Steps

1. **Scope.** The target is a path, the current diff, or a design (a decision record or a description). Ask them for its context in one AskUserQuestion, unless the repo answers it: expected load, criticality, who calls it.
2. **Learner first.** Ask: "Before I review — what do you think is the riskiest part?" Credit what they catch.
3. **Walk the lens** section by section, pitched to their level (● / ◐ / ○ in the lens). Read the actual code paths: callers, config, the retry and timeout settings. Never review from the diff alone when behaviour depends on context.
4. **Findings.** Rank them **ship-blocker → fix soon → worth knowing**. For each one:
   - the condition that triggers it (the concrete scenario: "two workers pick the same job when…");
   - what the user or operator would see;
   - the fix, and what the fix costs;
   - the fundamental, in one line.

   Draw the timeline or pipeline diagram for concurrency and throughput findings.
5. **They fix the top ship-blocker.** Normal and deep gear: they write the fix, and you review it (hint ladder if stuck). You may take the mechanical fixes.
6. **Log.** Add each finding's concept to the graph. Items they didn't recognize → `shaky`. Name the one habit that would have prevented the top finding.

## Level lens

- **L1–L2:** ● items only; teach each one; cap at 5 findings.
- **L3–L4:** ● and ◐. Include the Little's-law check on any pool, queue or worker count.
- **L5+:** everything, at fleet scale: blast radius, failure domains, cost, operability by other teams.

## Sprint

Only the top 3 ship-blockers, each with its fix, in one screen. Everything else goes to `## Learn later` as `review: <finding>`, so none of it is lost.
