# post-deploy-smoke-test-skill Checklist

## Pre-Execution
- [ ] Target URL confirmed and reachable
- [ ] Test environment specified (staging vs production)
- [ ] Auth credentials available for Test 3

## Execution
- [ ] Test 1 executed: GET / returns 200
- [ ] Test 2 executed: /dashboard redirects to /auth/signin
- [ ] Test 3 executed: authenticated primary feature accessible
- [ ] Test 4 executed: /api/healthcheck returns 200 + {"status":"ok"}
- [ ] Each failing test retried once before marking FAIL

## Post-Execution
- [ ] All 4 results documented with PASS/FAIL + retry count
- [ ] `overall_status` set: ALL_PASS or FAIL_ROLLBACK_TRIGGER
- [ ] Rollback trigger initiated if any test failed on retry

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 7. Cards: 006. Rules: DR006.
