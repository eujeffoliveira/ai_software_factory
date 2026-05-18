# Post-Deploy Report
## Gate 7 Status: [APPROVED | RETURNED_FOR_MONITORING | BLOCKED_SLO_VIOLATION]

> **Status Rationale:** [One to two sentences with specific metrics as evidence]

**Project:** [Project Name]
**Deploy Date:** [ISO-8601 timestamp]
**Deployment ID:** [Vercel deployment ID]
**Deployment URL:** [Production URL]
**Reported by:** Agente08_DevOps v1.0.0
**Human Approver (Gate 6):** [Name/identifier of approving human]

---

## Deployment Summary

[1–2 sentences describing what was deployed and the overall outcome. Example: "Deployed the user dashboard feature (commit abc1234) to production at 14:32 UTC. All post-deploy checks passed with no incidents."]

---

## Healthcheck Results

Monitoring `GET /api/healthcheck` every 30 seconds for 5 minutes.

| Check # | Time | HTTP Status | Response Time | DB Check | Notes |
|---------|------|-------------|---------------|----------|-------|
| 1 | T+0s | [200] | [Xms] | [PASS] | |
| 2 | T+30s | [200] | [Xms] | [PASS] | |
| 3 | T+1m | [200] | [Xms] | [PASS] | |
| 4 | T+1m30s | [200] | [Xms] | [PASS] | |
| 5 | T+2m | [200] | [Xms] | [PASS] | |
| 6 | T+2m30s | [200] | [Xms] | [PASS] | |
| 7 | T+3m | [200] | [Xms] | [PASS] | |
| 8 | T+3m30s | [200] | [Xms] | [PASS] | |
| 9 | T+4m | [200] | [Xms] | [PASS] | |
| 10 | T+5m | [200] | [Xms] | [PASS] | |

**Summary:**
- Total checks: 10
- Passed: [10] / Failed: [0]
- Max consecutive failures: [0]
- Average response time: [Xms]
- Rollback triggered: [NO]

---

## Smoke Test Results

| # | Test | Status | Retry Count | Notes |
|---|------|--------|-------------|-------|
| 1 | App loads (GET / returns 200) | [PASS / FAIL] | 0 | |
| 2 | Unauthenticated redirect to /auth/signin | [PASS / FAIL] | 0 | |
| 3 | Authenticated primary feature accessible | [PASS / FAIL] | 0 | |
| 4 | API healthcheck returns 200 | [PASS / FAIL] | 0 | |

**Overall smoke test result:** [4/4 PASS — no rollback triggered]

---

## Database Migration Status

| Migration File | Applied At | Duration | Status |
|---------------|------------|----------|--------|
| [filename] | [timestamp] | [X]s | [SUCCESS] |

_If no migrations: "No database migrations in this release."_

**Post-migration verification:**
- `prisma migrate status` confirms all migrations applied: [ ] YES
- No migration errors in Vercel logs: [ ] YES

---

## Observability

| Component | Status | Evidence |
|-----------|--------|----------|
| `audit_log` entries flowing | [ ] CONFIRMED | [Number seen in first 30 min] |
| `sync_log` entries flowing | [ ] CONFIRMED / [ ] N/A | [Number seen / no cron in this release] |
| Error tracking (Sentry) receiving events | [ ] CONFIRMED | [Test event ID or first error seen] |
| Uptime monitor active on `/api/healthcheck` | [ ] CONFIRMED | [Monitor name/URL] |

**Error rate (first 10 minutes post-deploy):** [X%] — [within threshold / EXCEEDS 5% threshold]
**P95 response time (first 30 minutes):** [Xms]
**Alerts triggered:** [NO / YES — see Issues section]

---

## Issues Found

_If no issues:_ "No issues found. Deployment healthy."

| # | Issue | Severity | Status |
|---|-------|----------|--------|
| 1 | [Description] | [LOW/MEDIUM/HIGH/CRITICAL] | [MONITORING/ESCALATED/RESOLVED] |

---

## Rollback Record

_Complete this section only if rollback was triggered._

- Rollback triggered: [ ] YES / [X] NO
- Rollback trigger condition: [Healthcheck failure / Error rate / Smoke test / Manual]
- Rollback initiated at: [timestamp]
- Rollback completed at: [timestamp]
- MTTR (deploy → service restored): [X minutes]
- Tech Lead notified at: [timestamp]
- Postmortem required: [ ] YES (MTTR > 1hr) / [ ] NO

---

## DORA Metrics (this cycle)

| Metric | This Deploy | Target |
|--------|-------------|--------|
| Deployment Frequency | [1st deploy of the week / 2nd / etc.] | Weekly |
| Lead Time for Changes | [Commit date → today] | < 1 day |
| Change Failure Rate | [Did this deploy cause an incident? YES/NO] | < 15% |
| MTTR | [N/A — no incident / X minutes] | < 1 hour |

---

## Gate 7 Decision

**Status:** [APPROVED | RETURNED_FOR_MONITORING | BLOCKED_SLO_VIOLATION]

**Rationale:** [Specific evidence supporting the decision — e.g., "All 10 healthcheck checks returned HTTP 200. All 4 smoke tests passed. Error rate was 0.3% in the first 10 minutes, well within the 5% threshold. Gate 7 APPROVED."]

**Next agent:** Agente00_TechLead

_If RETURNED_FOR_MONITORING:_ "Extended monitoring period: [X] minutes. Condition for APPROVED: error rate remains below 2% for the monitoring period."

_If BLOCKED_SLO_VIOLATION:_ "Rollback has been initiated. Tech Lead has been notified. Post_Deploy_Report.md updated with rollback timeline. Postmortem [triggered / not required]."
