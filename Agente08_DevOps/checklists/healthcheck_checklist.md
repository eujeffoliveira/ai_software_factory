# Healthcheck Checklist
## Pre-Deploy Verification + Post-Deploy Monitoring

Use Section 1 during Gate 6 preparation (verify endpoint). Use Section 2 during Gate 7 (monitor post-deploy).

---

## Section 1 — Endpoint Verification (Gate 6 Pre-Deploy)

Run against staging URL before issuing `READY_FOR_HUMAN_APPROVAL`.

- [ ] **Endpoint exists:** `GET /api/healthcheck` route is defined in the codebase
- [ ] **File location:** `app/api/healthcheck/route.ts`
- [ ] **No authentication required:** endpoint has no `auth()` check, no session check
- [ ] **Database connectivity check included:** uses `prisma.$queryRaw\`SELECT 1\`` or equivalent
- [ ] **Response schema correct:**
  ```typescript
  {
    status: "ok" | "error",
    timestamp: string,  // ISO-8601
    version: string     // semver or package.json version
  }
  ```
- [ ] **Success response code:** HTTP 200
- [ ] **Error response code:** HTTP 503 (not 200 with error in body)
- [ ] **Response time acceptable:** `curl -w "\nTime: %{time_total}s\n" [staging_url]/api/healthcheck` < 2.0 seconds
- [ ] **DB check is real:** response returns `{"status": "error"}` when DB is not reachable (test in staging if possible)

**Manual verification command:**
```bash
curl -s [staging_url]/api/healthcheck | jq .
# Expected: {"status": "ok", "timestamp": "2024-...", "version": "..."}
```

**Pre-deploy result:** [ ] **PASS** | [ ] **FAIL** (see failure action in FM-05)

---

## Section 2 — Post-Deploy Monitoring (Gate 7 Execution)

Execute after production deployment completes. Monitor every 30 seconds for 5 minutes.

**Monitoring start time:** [ISO-8601 timestamp]
**Production healthcheck URL:** `[production_url]/api/healthcheck`

| Check # | Target Time | Actual Time | HTTP Status | Response Time | DB Check | Pass? |
|---------|------------|-------------|-------------|---------------|----------|-------|
| 1 | T+0s | | | ms | | [ ] |
| 2 | T+30s | | | ms | | [ ] |
| 3 | T+1m | | | ms | | [ ] |
| 4 | T+1m30s | | | ms | | [ ] |
| 5 | T+2m | | | ms | | [ ] |
| 6 | T+2m30s | | | ms | | [ ] |
| 7 | T+3m | | | ms | | [ ] |
| 8 | T+3m30s | | | ms | | [ ] |
| 9 | T+4m | | | ms | | [ ] |
| 10 | T+5m | | | ms | | [ ] |

**Consecutive failure tracker:**
- After check [N] FAIL: consecutive_failures = 1
- After check [N+1] FAIL: consecutive_failures = 2
- After check [N+2] FAIL: consecutive_failures = **3 → ROLLBACK TRIGGERED**

---

## Section 3 — Rollback Decision

- [ ] **3 consecutive failures?** → ROLLBACK TRIGGER — proceed to `checklists/rollback_checklist.md`
- [ ] **All 10 checks passing?** → Healthcheck monitoring PASS — proceed to Gate 7 APPROVED
- [ ] **Intermittent failures (not 3 consecutive)?** → Consider RETURNED_FOR_MONITORING, monitor for additional 30 minutes

---

## Section 4 — Produce Healthcheck_Report.md

- [ ] Compile all 10 monitoring results into `Healthcheck_Report.md` (from `templates/Healthcheck_Report.md`)
- [ ] Calculate: total checks, passed, failed, max consecutive failures
- [ ] Calculate: average response time, max response time
- [ ] Record rollback trigger (if applicable)
- [ ] Set `overall_status` to appropriate value
- [ ] Include report as part of `Post_Deploy_Report.md`

---

## Runtime Knowledge Policy

This checklist is consulted at runtime from `Agente08_DevOps/checklists/healthcheck_checklist.md`. Healthcheck specification is in `context_view.md` Section 6 and `knowledge/knowledge_cards.md` Card 004. Decision rules applied: DR005 (missing endpoint blocks Gate 6), DR006 (3 failures triggers rollback). Do not access `context/` or `lib/` to complete this checklist.
