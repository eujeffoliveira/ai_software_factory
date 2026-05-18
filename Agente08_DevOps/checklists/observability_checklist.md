# Observability Checklist
## Pre-Deploy — observability-setup-skill

Run this checklist before first go-live and after any incident where observability gap was identified. All components must be CONFIGURED before Gate 6 `READY_FOR_HUMAN_APPROVAL`.

---

## Section 1 — Structured Logging (`audit_log`)

`audit_log` must capture every human-initiated create, update, or delete action.

- [ ] **`audit_log` calls exist** in all relevant Server Actions that modify data
- [ ] **`audit_log` format is correct** (structured JSON with all required fields):
  ```json
  {
    "type": "audit_log",
    "actorId": "<from session>",
    "actorEmail": "<from session — never from request body>",
    "action": "<PAST_TENSE_VERB>",
    "entityType": "<table_name>",
    "entityId": "<entity_id>",
    "metadata": {},
    "timestamp": "<ISO-8601>"
  }
  ```
- [ ] **No PII in metadata:** raw passwords, tokens, or personal data not stored
- [ ] **Test verification:** trigger a test action in staging, confirm `audit_log` entry appears in Vercel function logs
- [ ] **actorId/actorEmail sourced from session** — never from request body

**Result:** [ ] CONFIGURED / [ ] MISSING / [ ] PARTIAL (describe gaps)

---

## Section 2 — Structured Logging (`sync_log`)

`sync_log` must be called in every cron job's `finally` block.

- [ ] **`sync_log` calls exist** in all cron route handlers
- [ ] **Called in `finally` block** — executes even when job fails
- [ ] **`sync_log` format is correct:**
  ```json
  {
    "type": "sync_log",
    "job": "<job-name>",
    "executedAt": "<ISO-8601>",
    "durationMs": <number>,
    "status": "success" | "error",
    "counts": {},
    "errorMsg": null
  }
  ```
- [ ] **Test verification:** trigger a cron run in staging, confirm `sync_log` entry appears

_If no cron jobs in this release: mark CONFIGURED with note "No cron jobs in this release."_

**Result:** [ ] CONFIGURED / [ ] MISSING / [ ] N/A (no cron jobs)

---

## Section 3 — Error Tracking

- [ ] **Error tracking tool selected:** Sentry / [equivalent]
- [ ] **Sentry (or equivalent) installed** in `package.json` dependencies
- [ ] **Sentry initialized** in the application (e.g., `sentry.server.config.ts`, `sentry.client.config.ts`)
- [ ] **SENTRY_DSN (or equivalent)** is set in Vercel environment variables for both staging and production
- [ ] **Test verification:** trigger a deliberate test error in staging → confirm it appears in Sentry dashboard
- [ ] **Error grouping configured** (if needed for high-volume error reduction)
- [ ] **Ignored errors configured** (if needed — e.g., expected 4xx errors that are not bugs)

**Result:** [ ] CONFIGURED / [ ] MISSING / [ ] PARTIAL (describe gaps)

---

## Section 4 — Uptime Monitoring

- [ ] **Uptime monitoring tool selected:** Better Uptime / UptimeRobot / [equivalent]
- [ ] **Monitor configured** on `GET [production_url]/api/healthcheck`
- [ ] **Check interval:** every [5] minutes (or more frequent if available)
- [ ] **Alert channel configured:** [email / Slack / etc.] for downtime notifications
- [ ] **Alert threshold:** alert after [2] consecutive failures (to avoid false positives)
- [ ] **Test verification:** temporarily disable healthcheck in staging → confirm monitor sends alert

**Result:** [ ] CONFIGURED / [ ] MISSING / [ ] PARTIAL

---

## Section 5 — Performance Monitoring

- [ ] **Vercel Web Analytics enabled** in Vercel project settings
- [ ] **Core Web Vitals collection active:** LCP, CLS, FID/INP being reported
- [ ] **Performance budget defined** (if applicable): [threshold for regression alerts]

**Result:** [ ] CONFIGURED / [ ] MISSING / [ ] OPTIONAL (note if deliberately skipped)

---

## Section 6 — Log Retention and Access

- [ ] **Vercel log access verified:** team members can view function logs in Vercel dashboard
- [ ] **Log retention period noted:** Vercel default is [X] days — acceptable for compliance?
- [ ] **If longer retention needed:** log forwarding to external service configured (e.g., Datadog, Axiom)

---

## Summary

| Component | Status | Evidence |
|-----------|--------|----------|
| `audit_log` structured logging | [ ] CONFIGURED / [ ] MISSING | |
| `sync_log` cron logging | [ ] CONFIGURED / [ ] MISSING / [ ] N/A | |
| Error tracking (Sentry or equiv) | [ ] CONFIGURED / [ ] MISSING | |
| Uptime monitoring (`/api/healthcheck`) | [ ] CONFIGURED / [ ] MISSING | |
| Performance monitoring (Vercel Analytics) | [ ] CONFIGURED / [ ] OPTIONAL | |

**Overall result:** [ ] **ALL CONFIGURED** — ready for go-live / [ ] **GAPS** — [describe missing items]

**Gate 6 impact:** All mandatory items (logs, error tracking, uptime) must be CONFIGURED. Performance monitoring can be OPTIONAL with documented reason.

---

## Runtime Knowledge Policy

This checklist is consulted at runtime from `Agente08_DevOps/checklists/observability_checklist.md`. Observability requirements are in `context_view.md` Section 9 and `knowledge/knowledge_cards.md` Card 010 (structured logging reference). Do not access `context/` or `lib/` to complete this checklist.
