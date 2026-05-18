# Bad Post-Deploy Report Example

This example shows an inadequate Post_Deploy_Report.md that wrongly issues Gate 7 `APPROVED` without any evidence. Do NOT produce reports like this.

---

# Post-Deploy Report
## Gate 7 Status: APPROVED ❌ WRONG — no evidence, cannot be APPROVED

**Project:** Dashboard App
**Deploy Date:** 2026-05-18
**Deployment ID:** (not recorded)
**Reported by:** Agente08_DevOps v1.0.0

---

## Deployment Summary

Deploy successful. Everything is working fine.

---

## Healthcheck Results

Healthcheck is fine.

---

## Smoke Test Results

Not tested yet — will monitor later.

---

## Database Migration Status

Migration ran. Seems fine.

---

## Observability

Logs are configured.

---

## Issues Found

None.

---

## Gate 7 Decision

**Status:** APPROVED

**Rationale:** Deployment was successful.

**Next agent:** Agente00_TechLead

---

**WHAT IS WRONG WITH THIS EXAMPLE (do not make these mistakes):**

1. **Gate 7 `APPROVED` without evidence** — The status cannot be APPROVED without specific, measurable evidence. "Everything is working fine" is not evidence. Gate 7 APPROVED requires: 10/10 healthcheck checks, 4/4 smoke tests, and error rate data.

2. **"Healthcheck is fine"** — A healthcheck report requires a time-series table with check number, time offset, HTTP status code, response time in milliseconds, and DB check result for each of the 10 monitoring checks (every 30s for 5 minutes). "Fine" tells us nothing.

3. **"Not tested yet — will monitor later"** — Smoke tests are mandatory before Gate 7 status is issued. They cannot be deferred to "later." If smoke tests have not been run, the Gate 7 status cannot be APPROVED.

4. **"Migration ran. Seems fine."** — Migration section requires: the specific migration filename, applied-at timestamp, duration in seconds, and success/failure status. It also requires post-migration verification (`prisma migrate status` output).

5. **"Logs are configured"** — Observability section must verify that logs are actually flowing — not just that they are configured. Required evidence: specific log entries seen (audit_log count, sync_log count), error tracking receiving events (event ID or count), uptime monitoring confirmed active.

6. **Deployment ID not recorded** — The Vercel deployment ID is essential for rollback (it identifies the specific deployment to revert to) and for audit trails. It must be recorded.

7. **No error rate data** — Post-deploy monitoring must include the error rate percentage in the first 10 minutes. Without this, there is no evidence that the 5% error rate threshold was not breached.

8. **Gate 7 rationale is empty** — "Deployment was successful" is not a rationale. The rationale must reference specific metrics: "All 10 healthcheck checks returned HTTP 200. All 4 smoke tests passed. Error rate was X%."

**Correct action:** Do NOT issue Gate 7 status without evidence. Execute the 5-minute healthcheck monitoring window (`healthcheck-validation-skill`), run smoke tests (`post-deploy-smoke-test-skill`), verify observability (`observability-setup-skill`), and collect error rate data. Only then produce Post_Deploy_Report.md with specific evidence and issue an evidence-based gate decision.
