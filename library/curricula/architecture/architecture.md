# Architecture and code design

Domain: architecture · Status: **stub** — concept list and edges only; lessons build details from general knowledge. Canon: A Philosophy of Software Design, Fundamentals of Software Architecture, DDD (Evans/Vernon), Building Evolutionary Architectures, Refactoring, Nygard ADRs, Cockburn hexagonal

## What LLM answers usually gloss over
- Why the code is split the way it is: the dependency direction and what each boundary protects.
- Shallow modules that add interface without hiding complexity.
- Patterns applied as decoration rather than to a recurring problem.

## Concepts
- single-responsibility-functions — L1 — requires: —
- naming-and-abstraction — L2 — requires: single-responsibility-functions
- deep-vs-shallow-modules — L3 — requires: naming-and-abstraction
- information-hiding — L3 — requires: deep-vs-shallow-modules
- layering-and-dependency-direction — L3 — requires: information-hiding
- testable-seams — L3 — requires: layering-and-dependency-direction
- coupling-and-cohesion — L4 — requires: information-hiding
- hexagonal-ports-and-adapters — L4 — requires: layering-and-dependency-direction, testable-seams
- design-patterns-as-solutions — L4 — requires: coupling-and-cohesion
- bounded-contexts — L4 — requires: coupling-and-cohesion
- adrs-and-decision-records — L4 — requires: —
- monolith-vs-services — L5 — requires: bounded-contexts
- conways-law — L5 — requires: monolith-vs-services
- evolutionary-architecture-fitness-functions — L6 — requires: conways-law
