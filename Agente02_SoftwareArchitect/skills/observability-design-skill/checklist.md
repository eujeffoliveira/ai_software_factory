# observability-design-skill Checklist

## Pre-execution
- [ ] `Architecture.md` available with component list, cron jobs, and integrations enumerated
- [ ] PRD NFRs checked for SLA and latency requirements (to set alerting thresholds)
- [ ] APM tool preference confirmed or default applied (Sentry + Vercel Analytics)
- [ ] PII field list available from `database-modeling-skill` output (or from PRD data requirements)

## During execution

### Log schema
- [ ] Base log schema defines all 7 mandatory fields: `timestamp`, `level`, `service`, `traceId`, `userId`, `event`, `payload`
- [ ] `traceId` is a correlation ID propagated from the incoming request
- [ ] `userId` is set to `null` for public/system events (not omitted)

### audit_log events
- [ ] Every human-initiated mutation in Architecture.md has a named `audit_log` event
- [ ] Event names are `snake_case` (e.g., `job_published`, `application_rejected`)
- [ ] Every `audit_log` event includes: `userId`, `resourceType`, `resourceId`, `action`
- [ ] Update events include `diff` (before/after)
- [ ] IP address: hashed with project salt, not raw
- [ ] No raw PII in `audit_log` payload — masking applied

### sync_log events
- [ ] Every cron job in Architecture.md has a named `sync_log` event
- [ ] Every `sync_log` event includes: `jobId`, `scheduledAt`, `startedAt`, `completedAt`, `duration_ms`, `records_processed`, `errors`
- [ ] Job failure logs full error context (not just "job failed")

### APM and healthcheck
- [ ] APM tool selected with scope and integration method stated
- [ ] `/api/health` endpoint defined: GET, public (no auth), responds < 500ms
- [ ] `/api/health` payload schema: `{ "status": "ok"|"degraded", "timestamp", "checks": { "db": "ok"|"error" } }`
- [ ] Dependencies checked in `/api/health` identified (DB at minimum)

### Alerting
- [ ] Error rate threshold defined per component (default: > 1% 5xx over 5 minutes)
- [ ] P95 response time threshold defined per component (from PRD NFRs)
- [ ] Job failure alert threshold defined (default: 1 consecutive failure)

### PII masking
- [ ] Masking rule defined for each PII type: email, name, phone, IP address
- [ ] Retention period stated for audit logs (default: 90 days)

## Post-execution
- [ ] `Observability_Strategy.md` written to project artifacts folder
- [ ] `log_schema_complete: true`
- [ ] `health_endpoint_defined: true`
- [ ] `pii_masking_defined: true`
- [ ] `compliance_gaps` list is empty

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/`, `Agente02_SoftwareArchitect/context_view.md`, and project artifacts as input only
