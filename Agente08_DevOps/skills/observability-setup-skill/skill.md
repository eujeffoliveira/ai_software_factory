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

Observability readiness status per component (CONFIGURED / MISSING / PARTIAL) for Deployment_Plan.md observability section.

## Constraints

- All 4 components (structured logs, error tracking, uptime, performance) must be CONFIGURED before `READY_FOR_HUMAN_APPROVAL`
- Missing error tracking blocks Gate 6 — cannot deploy blind
- `audit_log` must use session data for actorId/actorEmail (never request body)

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 9 (Observability Stack), `knowledge/knowledge_cards.md` Card 010 (Structured Logging Reference).
