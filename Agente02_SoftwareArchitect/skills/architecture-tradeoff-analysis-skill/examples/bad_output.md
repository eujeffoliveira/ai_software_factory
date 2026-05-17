# Bad Output — architecture-tradeoff-analysis-skill

## Scenario

Same decision: WebSockets vs. SWR polling for application status updates.

## Produced analysis (problematic)

```
Decision: We should use WebSockets for real-time notifications.

WebSockets are the correct choice because:
- They are real-time
- Modern browsers support them
- Users expect instant updates

SWR polling is outdated and inefficient. We should not use it.
```

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | Decision framed as a conclusion, not a question | Decision question format required: "Should we use X or Y for [context]?" |
| 2 | Only 1 option analyzed in detail — SWR dismissed as "outdated" without criteria | Minimum 2 alternatives with formal evaluation |
| 3 | "WebSockets are the correct choice" — binary right/wrong language | No option is correct in absolute terms; rephrase as "preferred given [criteria]" |
| 4 | No evaluation criteria defined or scored | Criteria table with HIGH/MEDIUM/LOW required |
| 5 | No sacrifices listed for WebSockets — only benefits stated | Sacrifices list is mandatory; for WebSockets: Vercel incompatibility, external service cost, complexity |
| 6 | Primary tension not named | Must state the core tension explicitly (e.g., "Responsiveness vs. infrastructure complexity") |
| 7 | No revisit trigger | Must state the condition that would make this decision wrong in hindsight |
| 8 | Vercel compatibility not considered — Vercel does not support persistent WebSocket connections natively | This is a critical omission; WebSockets would require an external service (Pusher, Ably) which is a Golden Path deviation and requires ADR |
| 9 | FR-09 (60s NFR) not checked against polling alternative — SWR at 30s satisfies FR-09 | Analysis must verify whether simpler options satisfy the requirement before advocating for complexity |

## Gate result

Analysis fails quality gate. The WebSocket recommendation without checking Vercel compatibility would trigger a `BLOCKED_PENDING_ADR` at Gate 2. The skill must rerun with the decision framed as a question, all alternatives formally evaluated, and Vercel infrastructure constraints applied.
