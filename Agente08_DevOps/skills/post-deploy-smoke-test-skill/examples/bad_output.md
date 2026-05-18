# Bad Output — post-deploy-smoke-test-skill

**Overall Status:** ALL_PASS ❌ WRONG — Test 3 failed

| Test | Status | Notes |
|------|--------|-------|
| App loads | PASS | |
| Auth redirect | PASS | |
| Primary feature | FAIL | Error 500 when accessing /dashboard | ← ignored!
| Healthcheck | PASS | |

**Overall: ALL_PASS** ❌ WRONG — one FAIL means FAIL_ROLLBACK_TRIGGER

**WHAT IS WRONG:**
- Test 3 FAIL must trigger rollback (DR006) — not be ignored
- Primary feature smoke test failure = service is broken for users
- overall_status must be FAIL_ROLLBACK_TRIGGER when any test fails
- No retry documented — did we retry once before marking FAIL?
