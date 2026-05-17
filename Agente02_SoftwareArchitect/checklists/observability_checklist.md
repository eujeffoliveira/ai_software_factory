# Observability Checklist

_Run before finalizing Observability_Strategy.md._

---

## Structured Logging

- [ ] Log format is JSON for all production environments
- [ ] Required fields are defined: timestamp, level, message, requestId (optional), userId (optional)
- [ ] Forbidden fields are defined: tokens, secrets, cookies, full PII
- [ ] Log levels are defined with guidelines (debug/info/warn/error)
- [ ] Server Components log format is specified
- [ ] Route Handlers log format is specified
- [ ] Server Actions log format is specified

## sync_log

- [ ] All cron jobs are listed in sync_log configuration
- [ ] sync_log fields are defined: job, executed_at, duration_ms, status, counts, error_msg
- [ ] Every cron job writes to sync_log on completion (success or error)

## audit_log

- [ ] All sensitive human actions are listed as audit_log events
- [ ] Mandatory events covered: user approval/rejection, role change, data export, configuration change
- [ ] audit_log fields are defined: actor_user_id, actor_email, action, entity_type, entity_id, metadata, created_at
- [ ] Domain-specific sensitive events are identified

## APM

- [ ] APM tool is selected (Sentry / Datadog / OpenTelemetry / Vercel Analytics) or flagged for ADR
- [ ] Error tracking is configured
- [ ] Critical routes to monitor are listed
- [ ] Session replay is disabled (PII risk) or approved with data handling policy

## Healthcheck

- [ ] /api/health endpoint is defined
- [ ] Health response schema is specified (status, db, ts)
- [ ] Database connectivity check (`SELECT 1`) is in the healthcheck
- [ ] Additional critical dependencies are listed for health checks if applicable
- [ ] Post-deploy smoke test includes /api/health verification

## No Anti-Patterns

- [ ] No PII appears in any log field definition
- [ ] No full email address in error logs
- [ ] No stack trace exposed to client
- [ ] No full request/response body logging for endpoints handling sensitive data
