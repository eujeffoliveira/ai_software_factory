# observability-design-skill

## Purpose

Define the complete observability strategy for the system: structured JSON logging schema, APM tool selection, `audit_log` event definitions for human actions, `sync_log` event definitions for automated jobs, healthcheck endpoint requirements, and alerting thresholds. The output (`Observability_Strategy.md`) is a binding specification that developers and Agente05_DevOps consume to implement instrumentation.

## When to Use

- During architecture design phase, before finalizing `Architecture.md`
- When a new service, integration, or cron job is added to the system
- When a security review or DevOps review raises observability gaps
- When an SLA or NFR requires specific logging or alerting behavior

## Inputs

- `Architecture.md` — component list, cron jobs, integrations, data flows
- `context_view_path` — `Agente02_SoftwareArchitect/context_view.md` (§9 Observability, §3 Principles P3 Auditability)
- `templates/Observability_Strategy.md` — base template

## Outputs

- `Observability_Strategy.md` — primary output; defines log schema, APM tool, `audit_log` events, `sync_log` events, healthcheck, and alerting

## Procedure

1. **Enumerate loggable events** — from `Architecture.md`, identify:
   - Every human-initiated action (mutations via Server Actions or API endpoints that change data) → `audit_log`
   - Every automated/background job (cron jobs, sync processes, batch operations) → `sync_log`
   - Infrastructure events (cold starts, DB connection failures, external API errors) → application log

2. **Define the JSON log schema** — every log entry must be structured JSON with these mandatory fields:
   ```json
   {
     "timestamp": "ISO 8601 — required on all entries",
     "level": "info | warn | error | debug",
     "service": "app | cron | worker | api",
     "traceId": "correlation ID — propagated from request",
     "userId": "authenticated user ID — null for public/system events",
     "event": "snake_case event name (e.g., job_application_submitted)",
     "payload": "structured object — no raw PII"
   }
   ```

3. **Define `audit_log` events** — for every human action identified in step 1:
   - Event name: `snake_case` noun-verb (e.g., `job_published`, `application_rejected`)
   - Required fields: `userId`, `resourceType`, `resourceId`, `action`, `diff` (before/after for updates), `ipAddress` (hashed, not raw)
   - PII handling: mask or hash all PII fields in the log payload — never store raw email or name in audit logs
   - Retention: audit logs must have explicit retention period stated (default: 90 days)

4. **Define `sync_log` events** — for every cron job and background process:
   - Event name: `snake_case` job identifier (e.g., `nightly_score_sync`, `application_status_poll`)
   - Required fields: `jobId`, `scheduledAt`, `startedAt`, `completedAt`, `duration_ms`, `records_processed` (use `0` for jobs that do not process records, e.g., health checks, notification jobs), `status` (`"success"` | `"failure"` | `"partial"`), `errors` (`null` on success, full error context on failure)
   - Error logging: on job failure, log full error context including stack trace (not just "job failed")
   - SLA fields: log expected vs. actual duration for jobs with NFR latency requirements

5. **Select APM tool** — choose from approved options (or flag for ADR if none apply):
   - **Sentry** — for error tracking and performance monitoring (Golden Path default for frontend + server)
   - **Vercel Analytics** — for web vitals and page performance (automatic with Vercel deploy)
   - **Custom Prometheus endpoint** — only if advanced metrics required and team has capacity (requires ADR)
   State the chosen tool(s), their scope (which components), and integration method.

6. **Define `/api/health` endpoint** — required for every project:
   - Method: GET
   - Authentication: none (public endpoint)
   - Response: `200 OK` when healthy, `503 Service Unavailable` when degraded
   - Payload: `{ "status": "ok"|"degraded", "timestamp": "ISO 8601", "checks": { "db": "ok"|"error", "externalService": "ok"|"error" } }`
   - Latency target: must respond in < 500ms. Implementation: execute a minimal query (e.g., `SELECT 1`) to verify DB connectivity without running aggregations or full-table scans. The health check confirms connectivity, not data correctness.

7. **Define alerting thresholds** — for each component in Architecture.md:
   - Error rate threshold: % of 5xx responses that triggers alert (default: > 1% over 5 minutes)
   - Response time threshold: P95 latency that triggers alert (from PRD NFRs)
   - Job failure threshold: number of consecutive job failures before alert (default: 1)
   - DB connection threshold: if pool exhausted > 30s, alert

8. **PII masking rules** — define how PII is handled in logs:
   - Email: `masked_email` — show first 2 characters + `***@domain.com`
   - Name: `masked_name` — show initials only
   - Phone: completely redacted — `[REDACTED]`
   - IPs: hash with project salt before logging

9. **Populate `Observability_Strategy.md`** using the template structure.

## Quality Gate

`Observability_Strategy.md` passes this skill's quality check when:
- Log schema defines all 7 mandatory fields
- Every human action has a named `audit_log` event
- Every cron job has a named `sync_log` event
- APM tool is named with scope and integration method
- `/api/health` endpoint is specified with response schema
- Alerting thresholds defined for all components
- PII masking rules documented

## Failure Modes

- **Missing log fields:** Log schema omits `traceId` or `userId` → trace correlation breaks in production
- **Unmasked PII in logs:** Raw email addresses in `audit_log` payload → GDPR/LGPD violation
- **No APM decision:** Observability strategy without naming the APM tool → implementation team cannot proceed
- **`/api/health` not specified:** Healthcheck endpoint not defined → deployment and monitoring tooling will fail

## RAG Policy

Authorized collections at runtime:
- `architecture_reference_full` (context_view.md §9 Observability, §3 P3 Auditability)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill's output must comply with:
- `context_view.md §9` — Observability requirements
- `context_view.md §3 P3` — Auditability principle
- `checklists/observability_design_checklist.md`

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
