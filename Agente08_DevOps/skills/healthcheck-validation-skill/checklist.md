# healthcheck-validation-skill Checklist

## Pre-Execution
- [ ] Healthcheck URL provided
- [ ] Check phase specified (pre_deploy or post_deploy)

## Pre-Deploy Execution
- [ ] Route handler content reviewed: no auth check present
- [ ] Route handler content reviewed: DB connectivity check present (prisma.$queryRaw)
- [ ] Response schema verified: {status, timestamp, version}
- [ ] Manual check: curl returns 200 with {"status":"ok"} in < 2s
- [ ] Error response: returns 503 (not 200) when DB fails

## Post-Deploy Execution (5-minute monitoring window)
- [ ] Check 1 (T+0s) executed and recorded
- [ ] Checks 2–10 executed every 30 seconds
- [ ] Consecutive failure counter tracked
- [ ] Rollback triggered if 3 consecutive failures reached
- [ ] All 10 results recorded in Healthcheck_Report.md

## Post-Execution
- [ ] overall_status set correctly
- [ ] rollback_triggered set correctly
- [ ] Healthcheck_Report.md produced (post_deploy only)

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 6. Cards: 004. Rules: DR005, DR006. Heuristics: H5, H6.
