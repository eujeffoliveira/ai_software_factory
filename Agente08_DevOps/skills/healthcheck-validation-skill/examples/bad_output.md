# Bad Output — healthcheck-validation-skill (post_deploy)

**Overall Status:** PASS ❌ WRONG — only 2 checks performed, check 2 and 3 failed

**Checks:** 3 performed (stopped early) | Consecutive failures: 2

| Check | Status | Notes |
|-------|--------|-------|
| 1 | 200 | |
| 2 | 503 | DB error |
| 3 | 503 | DB error |

**Overall: PASS** ❌ WRONG — 2 consecutive failures, continued to T+1m would give 3rd → rollback

**WHAT IS WRONG:**
- Only 3 checks performed in a 5-minute (10-check) window — abbreviated without reason (violates H6)
- 2 consecutive failures in the first 1m30s should trigger heightened alerting
- If check 4 also fails → rollback trigger (DR006) — stopping at 3 checks misses this
- overall_status PASS with 503s in the results is incorrect
- Monitoring window must run for full 5 minutes (10 checks) unless rollback is triggered first
