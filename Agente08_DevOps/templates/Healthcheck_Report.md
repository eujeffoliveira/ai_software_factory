# Healthcheck Report
## Post-Deploy Monitoring Window

**Monitored endpoint:** `GET [production_url]/api/healthcheck`
**Monitoring started:** [ISO-8601 timestamp — immediately after deploy completed]
**Interval:** 30 seconds
**Duration:** 5 minutes (10 total checks)

---

## Time-Series Results

| Check # | Time | HTTP Status | Response Time | DB Check | Response Status | Notes |
|---------|------|-------------|---------------|----------|-----------------|-------|
| 1 | T+0s | [200] | [Xms] | [PASS] | [ok] | |
| 2 | T+30s | [200] | [Xms] | [PASS] | [ok] | |
| 3 | T+1m | [200] | [Xms] | [PASS] | [ok] | |
| 4 | T+1m30s | [200] | [Xms] | [PASS] | [ok] | |
| 5 | T+2m | [200] | [Xms] | [PASS] | [ok] | |
| 6 | T+2m30s | [200] | [Xms] | [PASS] | [ok] | |
| 7 | T+3m | [200] | [Xms] | [PASS] | [ok] | |
| 8 | T+3m30s | [200] | [Xms] | [PASS] | [ok] | |
| 9 | T+4m | [200] | [Xms] | [PASS] | [ok] | |
| 10 | T+5m | [200] | [Xms] | [PASS] | [ok] | |

---

## Summary

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Total checks | 10 | 10 | — |
| Checks passed | [10] | 10 | [PASS] |
| Checks failed | [0] | < 3 consecutive | [PASS] |
| Max consecutive failures | [0] | < 3 | [PASS] |
| Average response time | [Xms] | < 2000ms | [PASS] |
| Max response time | [Xms] | < 2000ms | [PASS] |

---

## Rollback Status

**Rollback triggered:** [ ] YES / [X] NO

_If YES:_
- Trigger condition: [3rd consecutive failure at check #N]
- Rollback initiated at: [timestamp]
- See `Rollback_Plan.md` for execution procedure

---

## Overall Result

**Healthcheck monitoring status:** [ ] **PASS** — all checks passed, service healthy

[ ] **FAIL — ROLLBACK TRIGGERED** — 3 consecutive failures, rollback initiated

[ ] **FAIL — INTERMITTENT** — failures occurred but did not reach rollback threshold (recommend RETURNED_FOR_MONITORING)
