# Good Output — architecture-tradeoff-analysis-skill

## Scenario

The team is debating whether to implement real-time notifications (WebSockets) or polling (SWR every 30s) for a job application status update feature (PRD: FR-09 — users must see application status changes within 60 seconds).

## Trade-off Analysis

**Decision question:** Should we use WebSockets or SWR polling for real-time application status updates?

**Primary tension:** Developer complexity vs. perceived responsiveness (within the 60s NFR)

### Evaluation table

| Alternative | Responsiveness | Complexity | Vercel compatibility | Infrastructure cost |
|-------------|---------------|------------|---------------------|---------------------|
| WebSockets | HIGH | HIGH | LOW (Vercel doesn't support persistent WS connections natively) | HIGH (requires external service: Pusher, Ably) |
| SWR polling at 30s | MEDIUM | LOW | HIGH (standard Next.js fetch) | LOW (no extra service) |
| SSE (Server-Sent Events) | MEDIUM-HIGH | MEDIUM | MEDIUM (Vercel limits streaming response duration) | LOW |

### Chosen option: SWR polling at 30s

**What is gained:**
- Zero infrastructure beyond what the Golden Path already provides
- Trivial implementation: `useSWR('/api/applications', fetcher, { refreshInterval: 30000 })`
- Fully compatible with Vercel Edge Network — no persistent connection issues
- FR-09 (60s visibility) is satisfied: polling at 30s guarantees max 30s lag

**What is sacrificed:**
- Each connected user sends 1 request per 30s — at 1,000 concurrent users that is ~2 requests/second of background load
- Perceived latency: a status change may take up to 30s to appear, not instantaneous
- Not suitable if PRD ever tightens the NFR to < 5s visibility

**Revisit trigger:** If FR-09 is revised to require < 5s visibility, OR if concurrent user count exceeds 10,000 (polling load becomes significant), this decision must be revisited. At that point, SSE via an edge streaming approach should be evaluated before WebSockets.

**Recommendation:** `supports_current_architecture` — SWR polling satisfies FR-09 within Golden Path constraints.

---

## Why this is a good output

- Decision framed as a question, not a conclusion
- 3 alternatives evaluated (exceeds minimum 2), including the Golden Path default (SWR polling)
- Scoring table uses HIGH/MEDIUM/LOW — no made-up numeric scores
- Primary tension named explicitly: "Developer complexity vs. perceived responsiveness"
- BOTH gains AND sacrifices listed with concrete specifics (request rate, latency ceiling)
- Revisit trigger is measurable: "FR-09 tightened to < 5s" or "10,000 concurrent users"
- No binary language — the analysis says "preferred given constraints," not "correct"
- Recommendation: `supports_current_architecture`
