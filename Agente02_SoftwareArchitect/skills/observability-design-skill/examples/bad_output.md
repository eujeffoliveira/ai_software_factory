# Bad Output — observability-design-skill

## Scenario

Same job board SaaS. 5 human actions and 1 cron job to instrument.

## Produced Observability_Strategy.md (problematic excerpt)

```
## Logging

We will use console.log for all logging. Errors will be logged with console.error.

Log format: "[TIMESTAMP] [LEVEL] message"

Example: "2026-05-17 ERROR Job failed"

## Monitoring

We will add Sentry someday if needed.

## Health

We should add a /health endpoint later.
```

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | `console.log` with string interpolation — not structured JSON | Base log schema must be structured JSON; all 7 mandatory fields required |
| 2 | Log format is a plain string — `"[TIMESTAMP] [LEVEL] message"` — not parseable | Structured JSON required for Vercel Log Drains and APM correlation |
| 3 | `traceId`, `userId`, `service` fields missing entirely | All 7 mandatory log fields required: timestamp, level, service, traceId, userId, event, payload |
| 4 | No `audit_log` events defined for any of the 5 human actions | Every human-initiated mutation must have a named `audit_log` event |
| 5 | No `sync_log` event defined for the nightly scoring cron job | Every cron job must have a named `sync_log` event with all required fields |
| 6 | "We will add Sentry someday if needed" — APM deferred indefinitely | APM tool must be selected now with scope and integration method; implementation team cannot proceed without this |
| 7 | `/api/health` marked as "later" — deferred | `/api/health` is required for every project and must be fully specified before Gate 2 |
| 8 | No PII masking rules | PII fields must be explicitly masked; raw emails in logs are a GDPR/LGPD violation |
| 9 | "Job failed" as the full error log | Job failure must log: jobId, startedAt, completedAt, records_processed, records_failed, full error message and stack |
| 10 | No alerting thresholds defined | Alerting thresholds required for all components |

## Gate result

`RETURNED_FOR_REVISION` — Observability_Strategy.md fails quality gate on 10 dimensions. The absence of structured logging and deferred APM/healthcheck decisions block downstream implementation. Skill must rerun with full Architecture.md as input and complete all sections.
