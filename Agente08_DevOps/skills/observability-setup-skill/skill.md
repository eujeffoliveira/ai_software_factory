# Skill: observability-setup-skill

## Purpose

Verify and confirm that all observability components are configured before go-live: structured JSON logging (audit_log, sync_log), error tracking (Sentry or equivalent), uptime monitoring on `/api/healthcheck`, and Vercel Web Analytics for Core Web Vitals.

## When to Use

- Before first production deployment (go-live)
- When observability configuration changes
- After any incident where an observability gap was identified

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Server Action and cron files | Required | To verify audit_log and sync_log usage |
| Error tracking configuration | Required | Sentry DSN or equivalent config |
| Uptime monitor status | Required | Whether monitor is active on healthcheck URL |

## Outputs

Observability readiness status per component for Deployment_Plan.md observability section:
- `CONFIGURED` — all required fields present and passing verification
- `PARTIAL` — component exists but one non-critical field or configuration item is missing (e.g., uptime monitor exists but alert threshold not set)
- `MISSING` — component absent entirely or a critical field is missing (e.g., no Sentry DSN, no audit_log calls in Server Actions)

All 4 components must reach CONFIGURED before Gate 6 passes; PARTIAL on any component = RETURNED_FOR_REVISION.

## Constraints

- All 4 components (structured logs, error tracking, uptime, performance) must be CONFIGURED before `READY_FOR_HUMAN_APPROVAL`
- Missing error tracking blocks Gate 6 — cannot deploy blind
- `audit_log` must use `actorId` and `actorEmail` from the NextAuth session object (`session.user.id` and `session.user.email`) — never from `req.body`, query parameters, or request headers

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 9 (Observability Stack), `knowledge/knowledge_cards.md` Card 010 (Structured Logging Reference).
