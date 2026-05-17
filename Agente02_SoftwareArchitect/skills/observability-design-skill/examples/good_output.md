# Good Output — observability-design-skill

## Scenario

Job board SaaS. Architecture.md components: User auth flow, Job CRUD, Job Application submission, Nightly scoring cron job, /api/health endpoint. PRD NFR-02: P95 API response time < 800ms.

## Produced Observability_Strategy.md (excerpt)

---

## Base Log Schema

All log entries are structured JSON written to stdout (consumed by Vercel Log Drains):

```json
{
  "timestamp": "2026-05-17T10:30:00.000Z",
  "level": "info",
  "service": "app",
  "traceId": "clx123abc456",
  "userId": "clx789user",
  "event": "job_application_submitted",
  "payload": {
    "jobId": "clx456job",
    "applicantId": "clx789user",
    "masked_email": "jo***@example.com"
  }
}
```

## audit_log Events

| Event name | Trigger | Required fields |
|------------|---------|-----------------|
| `user_signed_in` | User completes Google OAuth | userId, ipAddress (hashed), userAgent |
| `job_published` | Recruiter publishes a draft job | userId, resourceType: "Job", resourceId, diff.status |
| `job_application_submitted` | Candidate submits application | userId, resourceType: "JobApplication", resourceId, jobId |
| `application_status_changed` | Recruiter changes application status | userId, resourceId, diff.status.before, diff.status.after |
| `job_deleted` | Recruiter deletes a job | userId, resourceId, diff: { title, status } |

**PII masking in audit_log:**
- `email` → `masked_email`: first 2 chars + `***@domain.com`
- `name` → `masked_name`: initials only
- `ipAddress` → `hashed_ip`: SHA-256 with `AUDIT_LOG_SALT` env var
- Retention: 90 days

## sync_log Events

| Event name | Job type | Required fields |
|------------|----------|-----------------|
| `nightly_score_sync` | cron | jobId, scheduledAt, startedAt, completedAt, duration_ms, records_processed, records_failed, errors[] |

**Job failure log (on error):**
```json
{
  "event": "nightly_score_sync",
  "level": "error",
  "jobId": "nightly_score_sync_20260517",
  "error": { "message": "Scoring service timeout after 30s", "stack": "..." },
  "records_processed": 47,
  "records_failed": 3
}
```

## APM Configuration

| Tool | Scope | Integration |
|------|-------|-------------|
| Sentry | Server errors, performance traces (all API routes) | `@sentry/nextjs` SDK, dsn from `lib/env.ts` |
| Vercel Analytics | Web vitals, Core Web Vitals, page load times | Automatic via Vercel deploy |

## /api/health Endpoint

```
GET /api/health
Auth: None (explicitly public)
Target: responds < 500ms

Response 200:
{
  "status": "ok",
  "timestamp": "2026-05-17T10:30:00.000Z",
  "checks": {
    "db": "ok"
  }
}

Response 503:
{
  "status": "degraded",
  "timestamp": "2026-05-17T10:30:00.000Z",
  "checks": {
    "db": "error"
  }
}
```

## Alerting Thresholds

| Component | Error rate threshold | P95 latency threshold | Notes |
|-----------|---------------------|----------------------|-------|
| API routes | > 1% 5xx over 5 min | > 800ms (NFR-02) | Alert via Sentry |
| Nightly score sync | 1 consecutive failure | > 120s | Alert via Sentry cron monitor |
| /api/health | Any 503 | > 500ms | Alert via Vercel uptime monitor |

---

## Why this is a good output

- Base log schema defines all 7 mandatory fields: timestamp, level, service, traceId, userId, event, payload
- All 5 human actions have named `audit_log` events
- Nightly cron job has a named `sync_log` event with all required fields
- Job failure log includes full error context (not just "error: true")
- Both APM tools named with scope and integration method
- `/api/health` defined: public, < 500ms, response schema with db check
- PII masking rules explicit for email, name, IP
- Alerting thresholds cover all components, P95 threshold tied to NFR-02
- `compliance_gaps: []` — passes quality gate
