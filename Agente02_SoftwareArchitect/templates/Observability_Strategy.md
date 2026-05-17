# Observability Strategy — [Project Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Architect:** Agente02_SoftwareArchitect

---

## 1. Structured Logging

**Format:** JSON (all production logs)  
**Never log:** tokens, cookies, secrets, full email, full name, sensitive PII without masking.

### 1.1. Required Log Fields

```json
{
  "timestamp": "ISO 8601",
  "level": "debug | info | warn | error",
  "message": "string",
  "requestId": "string (optional)",
  "userId": "string (optional — masked or ID only, never email in error logs)",
  "route": "string (optional)",
  "job": "string (optional — for cron/job logs)",
  "durationMs": "number (optional)",
  "status": "string (optional)",
  "errorCode": "string (optional)"
}
```

### 1.2. Log Level Guidelines

| Level | When to use |
|-------|-------------|
| `debug` | Development only, never in production unless emergency |
| `info` | Successful operations, job completions, key business events |
| `warn` | Unexpected but recoverable conditions, deprecation notices |
| `error` | Errors that require attention; include errorCode, never include stack trace |

---

## 2. sync_log — Automated Jobs

Every cron job and automated job must log to `sync_log` on completion.

| Field | Type | Description |
|-------|------|-------------|
| `job` | string | Job identifier |
| `executed_at` | DateTime | Execution timestamp |
| `duration_ms` | int | Total execution time |
| `status` | string | `success` \| `error` \| `partial` |
| `counts` | Json | `{ processed, created, updated, failed }` |
| `error_msg` | string? | Error message if status is error |

**Jobs covered:**
- [Job name] — [frequency] — [purpose]

---

## 3. audit_log — Human/Admin Actions

Every sensitive human action must log to `audit_log`.

| Field | Type | Description |
|-------|------|-------------|
| `actor_user_id` | string | ID of the acting user |
| `actor_email` | string | Email of the acting user (operational PII) |
| `action` | string | Action identifier (e.g., `approve_user`, `export_data`) |
| `entity_type` | string | Type of entity affected |
| `entity_id` | string? | ID of entity affected |
| `metadata` | Json? | Additional context (non-PII) |
| `created_at` | DateTime | Timestamp |

**Events covered:**
- `approve_user` — When admin approves a user
- `reject_user` — When admin rejects a user
- `change_role` — When admin changes a user role
- `export_data` — When data is exported
- [Domain-specific events]

---

## 4. APM — Application Performance Monitoring

**Selected tool:** [Sentry | Datadog | OpenTelemetry | Vercel Analytics | TBD — see ADR-NNN]

**Configuration:**
- Error tracking: enabled
- Performance monitoring: [enabled | disabled]
- Session replay: [disabled — PII risk]

**Critical routes to monitor:**
- `/api/health` — baseline availability
- `POST /api/cron/*` — job completion rates
- Server Actions — p95 response time

---

## 5. Healthcheck

**Endpoint:** `GET /api/health`  
**Auth required:** No  
**Response format:**

```json
{
  "status": "ok | error",
  "db": "ok | unreachable",
  "ts": "ISO 8601 timestamp",
  "version": "commit hash (optional)"
}
```

**Checks:**
- [ ] Application responds (HTTP 200)
- [ ] Database responds (`SELECT 1`)
- [ ] [Additional critical dependency responds — if any]

---

## 6. Post-Deploy Validation

After every production deploy, validate:

1. `GET /api/health` returns `{ "status": "ok", "db": "ok" }`
2. Login flow completes successfully
3. [Primary critical user flow] works end-to-end
4. APM shows no error spike in the 15 minutes after deploy
5. Last cron execution completed successfully (check sync_log)
