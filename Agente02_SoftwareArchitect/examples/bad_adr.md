# Example: Bad ADR — What to Avoid

---

# ADR-001 — Use Redis [BAD EXAMPLE — DO NOT REPLICATE]

## Status

Approved ← ❌ Should be PROPOSED — Agente02 cannot self-approve

## Date

2026-05-17

## Context

❌ "We need caching." ← Too vague. What is being cached? Why? What performance problem does this solve? What PRD requirement drives this?

## Decision

❌ "Use Redis for caching." ← Too vague. Redis for what? Session storage? Rate limiting? Data caching? Read-through cache? Each is a different decision.

## Deviation from Golden Path

❌ Missing section entirely. This ADR deviates from the Golden Path (Vercel's built-in Next.js caching + PostgreSQL is the Golden Path) but does not acknowledge the deviation.

## Alternatives Considered

❌ Only one alternative listed — "don't use Redis." Real alternatives missing:
- Next.js unstable_cache / revalidation
- Vercel Edge Config for feature flags
- Supabase materialized views for heavy reads

## Consequences

❌ "Performance will improve." ← Not specific. How much? What metric? What's the latency improvement?

❌ Missing operational consequences: Redis is a new production dependency — requires monitoring, connection pooling, failover strategy, and memory limits.

❌ Missing cost: Redis Cloud costs $X/month. Not mentioned.

## Review Criteria

❌ "Never" ← Not a valid review criteria. Every decision should be time-boxed or condition-based.

---

## Why This ADR Would Be Rejected at Gate 2

| Issue | Impact |
|-------|--------|
| Context too vague — no PRD requirement cited | Cannot evaluate whether Redis is justified |
| Decision too vague — no scope defined | Downstream agents cannot implement from this |
| Self-approved (status: Approved) | ADR from Agente02 must start as PROPOSED |
| Only one alternative | Alternatives analysis insufficient |
| Missing operational and cost consequences | Risk Register incomplete |
| No review criteria | Decision cannot be re-evaluated |

**Gate 2 result:** `RETURNED_FOR_REVISION` — ADR must be rewritten before Gate 2 passes.
