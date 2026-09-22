# System-design case studies

Reference for the system-design skill: where learners typically go wrong, and what a strong answer contains at each level. **Don't recite these.** The learner drives; use this file to know what to probe.

## 1. URL shortener

**Key requirements:** create a short code → long URL; redirect fast; the read:write ratio is ~100:1; links live for years; custom aliases are optional.

**Estimates that decide:** 100M new links/month ≈ 40 writes/s; reads ≈ 4k/s average, ~15k/s peak. Storage ≈ 100M × 12 months × 5 yrs × ~500 B ≈ 3 TB. **Decision:** reads dominate → cache hot codes; the writes fit one DB leader.

**Key decisions:**
- Code generation: hash + collision check, vs a counter + base62 (a counter needs coordination: ranges per instance), vs random + a unique constraint.
- 301 vs 302 redirects: 301 is cached by browsers, so you lose analytics.
- The store: key-value lookup by code. Any KV store or a relational table with a PK works; say why.

**Common mistakes:**
- L2–L3: no collision handling; offset-based IDs that leak volume; no cache.
- L4: ignoring analytics write amplification on the redirect path (make it async); no abuse and rate limiting.

**Deep dives:** a hot link (celebrity) in the cache; the ID-generation coordination; the analytics pipeline via a queue.

## 2. Chat / messaging

**Key requirements:** 1:1 and group messages, in order within a conversation; delivery and read receipts; offline delivery; history.

**Estimates:** 50M DAU × 40 msgs/day ≈ 23k msgs/s average. Persistent connections: millions of concurrent WebSockets. **Decision:** a connection-gateway tier, separate from the message service; partition storage by conversation.

**Key decisions:**
- Push over WebSocket, with fallback.
- Per-conversation ordering (sequence numbers per conversation, not global time).
- Storage keyed `(conversation_id, seq)`.
- Fan-out on write for small groups; fan-out on read for huge channels.

**Common mistakes:**
- Global ordering by timestamp (clock skew).
- The DB write and the push being non-atomic (outbox).
- Assuming exactly-once (use client message ids for dedup).
- One connection server as a SPOF.

**Deep dives:** presence at scale; reconnection and missed-message sync (a cursor per device); large-group fan-out.

## 3. Rate limiter (a shared service or middleware)

**Key requirements:** limit per user/key/IP; low added latency (<1–2 ms); accurate enough; works across N app instances.

**Key decisions:**
- The algorithm: token bucket (allows bursts) vs sliding-window log (exact, memory-heavy) vs sliding-window counter (approximate, cheap).
- Where the state lives: local per instance (fast, inaccurate by up to N×) vs a central Redis (accurate, adds a network hop and a dependency).
- Fail-open vs fail-closed when the limiter store is down.

**Concurrency trap:** `GET count` → `SET count+1` from many instances is a lost update. Use an atomic `INCR` with expiry, or a Lua script for the token bucket.

**Common mistakes:** non-atomic check-and-increment; no decision on fail-open/closed; returning 500 instead of 429 with Retry-After.

**Deep dives:** hot keys in Redis; multi-region limits; the local + global hybrid.

## 4. Notification system (a realistic "real" design)

**Key requirements:** multiple channels (push, email, SMS); user preferences; retries; dedup; priority (OTP vs marketing); provider outages.

**Key decisions:**
- A queue per channel and priority (bulkheads: the marketing backlog never delays OTPs).
- Idempotency key per notification.
- Provider failover behind an adapter.
- Templating outside the send path.

**Common mistakes:**
- One queue for everything (priority inversion).
- Retrying non-idempotent provider calls (duplicate SMS).
- No per-user rate cap (spam).
- No DLQ.

**Deep dives:** exactly-once illusions with third-party providers; scheduling at scale; a preference-check race when a user unsubscribes mid-send.

## 5. News feed (L4+)

**Key decisions:**
- Fan-out on write (fast reads; expensive for celebrities) vs fan-out on read (cheap writes; slow reads).
- The hybrid: push for normal users, pull for celebrities.
- Ranking offline vs online.
- Feed storage as a capped list per user.

**Common mistakes:** pure fan-out-on-write, ignoring celebrities (1M followers × 1 post = 1M writes); fetching the whole feed instead of cursor pagination.
