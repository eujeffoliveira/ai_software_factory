# Agente08_DevOps — Failure Modes

This document catalogs known failure modes specific to deployment planning, execution, and post-deploy validation. Each entry includes observable symptoms, root cause, immediate action, prevention strategy, and escalation path.

---

## FM-01 — Missing or Incomplete Rollback Plan

**Symptom:** `Rollback_Plan.md` is absent, has placeholder sections ("TBD"), or is missing critical elements (trigger conditions, rollback steps, database strategy, estimated time, or owner).

**Root Cause:** Deployment was planned reactively without treating rollback as a first-class operation. Rollback was treated as a "just in case" afterthought rather than a tested procedure.

**Immediate Action:**
1. Issue Gate 6 `BLOCKED_NO_ROLLBACK_PLAN` immediately
2. Do NOT proceed to deployment
3. Invoke `rollback-planning-skill` to produce a complete `Rollback_Plan.md`
4. Verify rollback procedure in staging before reissuing Gate 6 status

**Decision Rule:** DR001 — if `Rollback_Plan.md` missing or incomplete → `BLOCKED_NO_ROLLBACK_PLAN`

**Prevention:** `rollback-planning-skill` is listed as step 6 in the pre-deploy workflow. Never skip it. Treat `Rollback_Plan.md` as a blocking prerequisite, not an optional document.

**Escalation:** None required — DevOps resolves this internally by producing the plan.

---

## FM-02 — `prisma db push` Detected in Staging or Production

**Symptom:** Evidence (in CI logs, deployment scripts, or documentation) that `prisma db push` was used in staging or production. Database schema drifts from migration history. Missing migration files for applied schema changes.

**Root Cause:** Developer confusion between `prisma db push` (prototyping/local) and `prisma migrate deploy` (staging/production). Or shortcuts taken under time pressure.

**Immediate Action:**
1. Stop deployment immediately — CRITICAL violation
2. Return to Agente04_DevBackend with explicit violation flag
3. Assess schema drift: compare actual DB schema with `prisma/schema.prisma` and migration history
4. Require: create migration file(s) that bring migration history in sync with actual DB state
5. Escalate to Tech Lead — data integrity may be at risk if DB has changes not tracked in migrations

**Decision Rule:** DR002 — `prisma db push` in staging/production → CRITICAL, return to Agente04

**Prevention:** Enforce in code review and CI. Add a CI check that detects `prisma db push` in scripts. Only `prisma migrate deploy` in any non-local environment.

**Escalation:** Agente00_TechLead (via human) — data integrity risk.

---

## FM-03 — Healthcheck Fails Post-Deploy

**Symptom:** `GET /api/healthcheck` returns non-200 status code or times out. Three consecutive failures within the 5-minute post-deploy monitoring window.

**Root Cause (possible):**
- Database connectivity issue (wrong DATABASE_URL, DB not reachable from production)
- Application crash at startup (Zod env validation failure, syntax error, missing dependency)
- Healthcheck endpoint itself has a bug (unhandled exception, incorrect DB query)
- Cold start timeout exceeded

**Immediate Action:**
1. After 3 consecutive failures: trigger rollback via `rollback-planning-skill`
2. Notify Tech Lead immediately (within 5 minutes of rollback trigger)
3. Check Vercel function logs for startup errors
4. Check database connectivity from production Vercel environment
5. After rollback confirmed: run smoke tests to verify rollback success

**Decision Rule:** DR006 — healthcheck fails post-deploy → rollback trigger + escalate

**Prevention:** Verify healthcheck endpoint works in staging before Gate 6. Confirm `DATABASE_URL` is set correctly in production before deployment.

**Escalation:** Agente00_TechLead — production incident. If DB connectivity is the cause: also escalate to infrastructure team.

---

## FM-04 — Smoke Tests Fail Post-Deploy

**Symptom:** One or more of the 4 mandatory smoke tests fail against production after deployment. Most critical: primary feature smoke test failure (Test 3).

**Root Cause (possible):**
- Feature-specific bug not caught in QA (rare if Gate 4 was thorough)
- Environment-specific configuration difference between staging and production
- Auth integration issue (Google OAuth callback URL not updated in production)
- Feature flag difference between environments
- Missing production-specific data or configuration

**Immediate Action:**
1. Assess severity — which smoke test failed?
2. If Test 3 (primary feature) fails: trigger rollback immediately
3. If Test 1 or Test 2 fail: trigger rollback immediately (core functionality broken)
4. If Test 4 (healthcheck) fails: this is FM-03 — follow FM-03 procedure
5. After rollback: escalate to Tech Lead with smoke test evidence
6. Return failing feature to Agente04_DevBackend or Agente05_DevFrontend for environment-specific fix

**Decision Rule:** DR006 — smoke tests fail post-deploy → rollback trigger + escalate

**Prevention:** Run identical smoke tests in staging with production-equivalent configuration before Gate 6. Verify OAuth callback URLs are configured for the production domain.

**Escalation:** Agente00_TechLead — production impact. Responsible Dev agent for the fix.

---

## FM-05 — Environment Variable Missing in Production

**Symptom:** Application fails to start. Vercel deployment shows function errors. Zod validation in `lib/env.ts` throws at startup: `ZodError: Required`. All requests return 500 immediately.

**Root Cause:** A new environment variable was added to `lib/env.ts` Zod schema but not added to the Vercel production environment dashboard. Or the variable was added to staging but not production.

**Immediate Action:**
1. Check Vercel function logs for Zod error with missing variable name
2. Add the missing variable to Vercel dashboard → Production environment
3. Trigger new Vercel deployment (env var changes require redeploy)
4. Run healthcheck to confirm startup success
5. Re-run smoke tests to confirm Gate 7 APPROVED

**Decision Rule:** DR003 — env var not in `lib/env.ts` → flag for Agente04 to fix before deploy (if caught pre-deploy); DR005 if healthcheck fails (treat as FM-03)

**Prevention:** `environment-validation-skill` as a mandatory Gate 6 check. Compare `lib/env.ts` Zod schema with Vercel environment variable list before issuing `READY_FOR_HUMAN_APPROVAL`.

**Escalation:** None if resolvable by adding env var. If the var contains a secret that was not set up, escalate to Tech Lead.

---

## FM-06 — Destructive Migration Without Human Approval

**Symptom:** A migration file containing `DROP COLUMN`, `DROP TABLE`, `TRUNCATE`, or a narrowing `ALTER COLUMN` (e.g., `VARCHAR(255)` → `VARCHAR(50)`) is about to be applied without documented human sign-off.

**Root Cause:** Migration risk assessment was not performed, or destructive flag was not set in the migration plan, or human sign-off was assumed rather than obtained.

**Immediate Action:**
1. STOP immediately — do not execute the migration
2. Flag the migration file as CRITICAL in `Migration_Deploy_Plan.md`
3. Document the specific destructive operation and its data impact
4. Escalate to Tech Lead for human sign-off
5. Assess: does the migration have a safe forward-fix rollback? If not, require data migration plan first
6. Only proceed after documented human sign-off is obtained

**Decision Rule:** DR004 — destructive migration → require human sign-off before execution

**Prevention:** `migration-deploy-skill` includes destructive operation detection as step 2. Every migration file should be assessed for DROP/TRUNCATE operations as part of Gate 6 preparation.

**Escalation:** Agente00_TechLead (via human) — data loss risk. If data was already lost: escalate immediately as production incident.

---

## FM-07 — Secrets Shared Between Staging and Production

**Symptom:** The same value for `DATABASE_URL`, `NEXTAUTH_SECRET`, `GOOGLE_CLIENT_SECRET`, or any API key appears in both staging and production Vercel environments.

**Root Cause:** Environment setup shortcut — copy-pasted production credentials into staging, or staging credentials were promoted to production without rotation. Or a single integration account was used for both environments.

**Immediate Action:**
1. Flag as CRITICAL — do not proceed to deployment
2. Issue Gate 6 `BLOCKED_MISSING_ARTIFACT` (or equivalent block)
3. Escalate to Agente07_DevSecOps immediately — this is a security finding
4. Do NOT deploy to production while shared secrets exist
5. Coordinate with Tech Lead to rotate the shared credential in the environment it should not be in

**Decision Rule:** DR008 — same secret in staging and production → CRITICAL, flag for immediate rotation

**Prevention:** `environment-validation-skill` includes environment isolation check. Never copy-paste production credentials. Use separate OAuth apps, separate DB instances, and separate API accounts for staging and production.

**Escalation:** Agente07_DevSecOps (via Tech Lead) — security violation. Agente00_TechLead for coordination.

---

## FM-08 — CI/CD Pipeline Not Run or Failing Before Deploy

**Symptom:** Target commit has no GitHub Actions run, or the run shows failing checks (typecheck error, lint violation, test failure, or build failure). DevOps receives a request to deploy from a failing commit.

**Root Cause:** Developer bypassed CI (pushed directly without PR), or CI was broken and deploy was attempted anyway under time pressure. Or CI was not configured in the repository.

**Immediate Action:**
1. Refuse deployment — issue Gate 6 `BLOCKED_CI_FAILURE`
2. Identify which CI step is failing
3. Return to responsible Dev agent to fix the failing check
4. CI must be green on the target commit before Gate 6 can proceed
5. If CI is not configured: provide pipeline configuration template from `context_view.md` and require it to be set up

**Decision Rule:** DR010 — CI/CD pipeline does not include typecheck + lint + test + build → `BLOCKED_MISSING_ARTIFACT`

**Prevention:** Enforce branch protection rules in GitHub — require CI to pass before merge. DevOps always checks CI status as the first Gate 6 check via `ci-cd-pipeline-skill`.

**Escalation:** None — Dev agent must fix failing CI. Tech Lead if systemic CI configuration issue.

---

## FM-09 — Vercel Cron Jobs Silently Failing

**Symptom:** `sync_log` entries are missing for expected cron job execution windows. Or `sync_log` shows `status: "error"` for repeated cycles. Cron job runs but produces no output. Business data is stale (expected sync not happening).

**Root Cause (possible):**
- `guardCron()` is missing from the cron route handler — Vercel cron requests are rejected
- Cron schedule in `vercel.json` is incorrectly configured
- Cron handler throws an uncaught exception before `syncLog()` is called (so no log entry)
- External service being synced is down or returning errors
- Environment variable for external service is missing or incorrect in production

**Immediate Action:**
1. Check Vercel function logs for the cron route for error output
2. Verify `vercel.json` cron schedule matches expected frequency
3. Verify cron handler starts with `guardCron()` as the first call
4. Verify `syncLog()` is called in a `finally` block (catches both success and failure)
5. If external service is down: document and monitor; `sync_log` should record `status: "error"`
6. Escalate to Agente04_DevBackend if `guardCron()` or `syncLog()` is missing

**Decision Rule:** DR009 — cron route missing `guardCron()` → return to Agente04 before deploy

**Prevention:** `vercel-deployment-skill` includes cron handler audit as a mandatory step. `guardCron()` verification is in the Gate 6 pre-deploy checklist.

**Escalation:** Agente04_DevBackend if code pattern is wrong. Agente00_TechLead if business impact is significant (data sync required for core features).

---

## FM-10 — Error Rate Spike Post-Deploy

**Symptom:** Vercel error rate dashboard shows > 5% errors sustained for more than 10 minutes after deployment. Structured logs show frequent `status: "error"` entries. Users report feature failures.

**Root Cause (possible):**
- Regression introduced in the deployed feature
- Database query returning unexpected results in production
- Edge case in business logic not covered by tests
- Rate limiting from external integration
- Performance degradation causing timeouts

**Immediate Action:**
1. Monitor error rate trajectory — is it rising, stable, or declining?
2. If > 5% and sustained for 10 minutes: trigger rollback (`DR007`)
3. If < 5% or declining: transition to `RETURNED_FOR_MONITORING` status
4. After rollback (if triggered): confirm error rate returns to baseline
5. Escalate to Tech Lead with error rate data and affected endpoints
6. Return to responsible Dev agent with specific error evidence from logs

**Decision Rule:** DR007 — error rate > 5% in 10 minutes post-deploy → rollback trigger

**Prevention:** Thorough QA testing (Gate 4) and staging smoke tests that cover realistic data. Feature flags for risky features (can be disabled without rollback). Canary deployments for high-risk changes (if available in Vercel plan).

**Escalation:** Agente00_TechLead — production impact on users. Responsible Dev agent for fix after rollback.
