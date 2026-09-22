# The canon: vetted reading per domain

The seed list the resources skill starts from before searching for newer or niche material. These are books and papers senior engineers actually cite.

**Always point at a chapter or section, never "read the whole book".** When citing, give the edition and chapter. Chapter numbers differ across editions, so confirm them when you can fetch a table of contents, and say "chapter on X" when you can't. Levels mark where each source starts paying off ([levels.md](levels.md)).

## Fundamentals
- *Operating Systems: Three Easy Pieces*, Arpaci-Dusseau & Arpaci-Dusseau. Free online at ostep.org. L1–L4. Virtualization (processes, scheduling, memory), concurrency (threads, locks, condition variables), persistence.
- *Computer Systems: A Programmer's Perspective*, Bryant & O'Hallaron. L2–L4. The memory hierarchy, linking, virtual memory, system-level I/O, network programming.
- *High Performance Browser Networking*, Ilya Grigorik. Free online at hpbn.co. L2–L4. TCP, TLS, HTTP/1.1–2, latency.
- *Database Internals*, Alex Petrov. L3–L5. Storage engines (B-trees, LSM), distributed-database fundamentals.
- *Use The Index, Luke*, Markus Winand. Free online. L2–L4. SQL indexing and query plans.

## Concurrency
- *Java Concurrency in Practice*, Goetz et al. L3–L5. The ideas (visibility, safe publication, thread confinement, liveness) transfer beyond Java.
- *The Art of Multiprocessor Programming*, Herlihy & Shavit. L5+. Mutual exclusion, linearizability, lock-free structures.
- *Seven Concurrency Models in Seven Weeks*, Paul Butcher. L3–L5. Threads/locks, functional, actors, CSP, data parallelism compared.
- *Is Parallel Programming Hard, And, If So, What Can You Do About It?*, Paul McKenney. Free online. L5+. Memory ordering, RCU, scalability.

## Performance
- *Systems Performance* (2nd ed.), Brendan Gregg. L4–L6. The USE method, methodologies, CPU/memory/disk/network analysis.
- Brendan Gregg's site (brendangregg.com). L3+. Flame graphs, USE method summaries.
- "The Tail at Scale", Dean & Barroso, *Communications of the ACM*, 2013. L4+. Why fan-out makes p99 dominate, and hedged requests.
- Gil Tene, "How NOT to Measure Latency" (talk). L4+. Coordinated omission.

## Distributed systems
- *Designing Data-Intensive Applications*, Martin Kleppmann. L3–L6. Replication, partitioning, transactions, consistency and consensus, batch and stream. The single most useful book for this plugin's audience.
- *Understanding Distributed Systems*, Roberto Vitillo. L3–L4. A shorter, practical on-ramp.
- Papers, L5+:
  - Lamport, "Time, Clocks, and the Ordering of Events in a Distributed System" (1978)
  - Ongaro & Ousterhout, "In Search of an Understandable Consensus Algorithm" (Raft, 2014)
  - DeCandia et al., "Dynamo: Amazon's Highly Available Key-value Store" (2007)
  - Corbett et al., "Spanner: Google's Globally-Distributed Database" (2012)
- Jepsen analyses (jepsen.io). L4+. How real databases break their consistency claims.

## System design
- *System Design Interview* vol. 1 & 2, Alex Xu. L3–L4. A case-study format; good for the shape of a design conversation.
- *Designing Data-Intensive Applications* again, for the reasoning behind the boxes.
- *The System Design Primer* (github.com/donnemartin/system-design-primer). L2–L4. Free.
- Engineering blogs from teams running the thing at scale: official posts from Discord, Cloudflare, Uber, Netflix, Stripe, Figma and others. Cite the specific post, and prefer postmortems and architecture write-ups.

## Architecture and code design
- *A Philosophy of Software Design*, John Ousterhout. L2–L5. Deep modules, information hiding, complexity.
- *Fundamentals of Software Architecture*, Richards & Ford. L4–L6. Architecture styles, characteristics, trade-off analysis.
- *Domain-Driven Design*, Eric Evans. L4–L6. Bounded contexts, ubiquitous language. *Implementing Domain-Driven Design* (Vaughn Vernon) is the practical companion.
- *Building Evolutionary Architectures*, Ford, Parsons & Kua. L5+. Fitness functions, incremental change.
- *Refactoring* (2nd ed.), Martin Fowler. L2–L4.
- Michael Nygard, "Documenting Architecture Decisions" (the original ADR post). L3+.
- Alistair Cockburn, "Hexagonal Architecture" (original article). L4+.

## Production engineering
- *Site Reliability Engineering* and *The Site Reliability Workbook*, Google. Free at sre.google. L3–L6. SLOs, error budgets, monitoring, incident response, postmortems.
- *Release It!* (2nd ed.), Michael Nygard. L3–L5. Stability patterns: timeouts, circuit breakers, bulkheads. Anti-patterns: cascading failures.
- *Accelerate*, Forsgren, Humble & Kim. L5+. Delivery performance and what drives it.
- *Observability Engineering*, Majors, Fong-Jones & Miranda. L4+.
- OWASP Top 10 and OWASP Cheat Sheet Series (owasp.org). L2+. Security basics at the boundary.

## Official docs beat blog posts

For any concrete technology (PostgreSQL, Redis, Kafka, Linux, the language runtime), the official documentation's conceptual chapters are the first citation. Examples: the PostgreSQL "Concurrency Control" chapter, Redis's persistence and replication docs, Kafka's design docs, the Go memory model. Use blog posts to add practice on top of the docs, never to stand in for them.
