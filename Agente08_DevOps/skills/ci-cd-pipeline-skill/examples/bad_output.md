# Bad Output — ci-cd-pipeline-skill

**Overall Status:** PASS ❌ WRONG — Vitest is failing

| Step | Status |
|------|--------|
| TypeScript typecheck | PASS |
| ESLint | not checked |
| Vitest unit tests | FAIL (3 test failures) |
| Next.js build | PASS |
| Playwright E2E | not checked |

**Gate 6 impact:** Deploy anyway, tests will be fixed later.

**WHAT IS WRONG:**
- ESLint and Playwright not checked — all 5 steps must be verified
- Vitest has 3 failures but `overall_status` is PASS — this is wrong
- "Deploy anyway" is never valid — CI failure = BLOCKED_CI_FAILURE at Gate 6 (DR010)
