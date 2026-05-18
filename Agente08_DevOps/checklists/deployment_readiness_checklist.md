# Deployment Readiness Checklist
## Gate 6 — Pre-Deploy Validation

Run this checklist before issuing any Gate 6 status code. All items must be PASS for `READY_FOR_HUMAN_APPROVAL`.

---

## Section 1 — Prerequisite Gates

- [ ] **Security_Audit.md received** — file is present in the handoff package
- [ ] **Gate 5 status is APPROVED** — Security_Audit.md shows `gate_decision: APPROVED`
- [ ] **QA_Report.md received** — file is present
- [ ] **Gate 4 status is APPROVED** — QA_Report.md shows `gate_decision: APPROVED`
- [ ] **Implementation files accessible** — at the reviewed commit SHA

**Failure:** Any missing or non-APPROVED prerequisite gate → issue `BLOCKED_MISSING_ARTIFACT`

---

## Section 2 — CI/CD Pipeline

- [ ] **CI pipeline run exists** for the target commit SHA on GitHub Actions
- [ ] **TypeScript typecheck** (`tsc --noEmit`) — status: PASS
- [ ] **ESLint** — status: PASS (zero errors)
- [ ] **Vitest unit tests** — status: PASS (all tests green)
- [ ] **Next.js production build** (`next build`) — status: PASS
- [ ] **Playwright E2E tests** — status: PASS (or not yet configured — note in plan)

**Failure:** Any failing CI step → issue `BLOCKED_CI_FAILURE` with specific failing steps listed

---

## Section 3 — Environment Variables

- [ ] **`lib/env.ts` reviewed** — Zod schema identified, all required variables listed
- [ ] **Staging (Preview):** all variables in Zod schema are present in Vercel dashboard
- [ ] **Staging (Preview):** all variables pass type validation (URL, min-length, etc.)
- [ ] **Production:** all variables in Zod schema are present in Vercel dashboard
- [ ] **Production:** all variables pass type validation
- [ ] **Environment isolation:** no secret has the same value in staging AND production
- [ ] **No scattered `process.env`:** no direct `process.env` calls outside `lib/env.ts`

**Failure:** Missing variable in production → likely `BLOCKED_MISSING_ARTIFACT` (deploy will fail at boot)
**Failure:** Shared secrets → CRITICAL — escalate to Agente07_DevSecOps before proceeding

---

## Section 4 — Database Migrations

- [ ] **Pending migrations assessed:** `prisma migrate status` reviewed for target environment
- [ ] **No `prisma db push` evidence:** confirm this command was not used in staging/production
- [ ] **Each migration file reviewed:** operations summarized, is_destructive assessed
- [ ] **Backward compatibility confirmed:** current codebase works with both old and new schema
- [ ] **Duration estimated:** for tables with > 100K rows, duration estimate is based on row count
- [ ] **Destructive operations signed off:** human sign-off obtained for all DROP/TRUNCATE/narrowing ALTER
- [ ] **Long-running migrations planned:** if any migration > 30s, online strategy or maintenance window planned
- [ ] **Forward-fix migrations prepared:** for each destructive operation, a forward-fix migration is ready
- [ ] **Migration_Deploy_Plan.md produced:** complete document ready

_If no pending migrations: mark all migration checks N/A and note "No pending migrations in this release."_

**Failure:** Destructive migration without sign-off → BLOCKED until human approves
**Failure:** `prisma db push` detected → CRITICAL — return to Agente04_DevBackend

---

## Section 5 — Rollback Plan

- [ ] **`Rollback_Plan.md` exists** — file is present
- [ ] **Trigger conditions defined:** at least 4 conditions (healthcheck, error rate, smoke test, manual)
- [ ] **Application rollback steps complete:** specific Vercel dashboard steps listed
- [ ] **Target deployment ID identified:** last known-good Vercel deployment ID recorded
- [ ] **Database rollback strategy documented:** forward-fix described or N/A noted
- [ ] **Estimated rollback time stated:** application rollback time and DB rollback time (if applicable)
- [ ] **Rollback owner identified:** role responsible for execution
- [ ] **Rollback procedure tested in staging:** verified on [date]

**Failure:** `Rollback_Plan.md` missing or incomplete → issue `BLOCKED_NO_ROLLBACK_PLAN`

---

## Section 6 — Healthcheck Endpoint

- [ ] **`GET /api/healthcheck` endpoint exists** in the codebase
- [ ] **No authentication required** — endpoint is public
- [ ] **DB connectivity check included** — `prisma.$queryRaw\`SELECT 1\`` or equivalent
- [ ] **Response schema correct:** `{"status": "ok", "timestamp": "...", "version": "..."}`
- [ ] **Response time acceptable:** responds in < 2 seconds in staging
- [ ] **Healthcheck returns 200 in staging** — verified with curl or Playwright test

**Failure:** Missing or non-functional healthcheck → return to Agente04_DevBackend to implement

---

## Section 7 — Smoke Tests

- [ ] **Smoke test suite exists** (`e2e/smoke.spec.ts` or equivalent)
- [ ] **Test 1 implemented:** App loads (GET / returns 200)
- [ ] **Test 2 implemented:** Unauthenticated redirect to /auth/signin
- [ ] **Test 3 implemented:** Authenticated primary feature accessible
- [ ] **Test 4 implemented:** API healthcheck returns 200
- [ ] **All 4 smoke tests passing in staging** — verified on staging URL

**Failure:** Missing smoke tests → produce them with `post-deploy-smoke-test-skill` guidance
**Failure:** Smoke tests failing in staging → return to responsible Dev agent (H2: staging failures are production bugs)

---

## Section 8 — Observability

- [ ] **Structured logs configured:** `audit_log` (human actions) and `sync_log` (cron) using `console.log(JSON.stringify({...}))`
- [ ] **audit_log verified flowing:** test log entries appear in Vercel function logs
- [ ] **Error tracking configured:** Sentry (or equivalent) is set up and receiving test events
- [ ] **Uptime monitoring active:** external monitor checking `GET /api/healthcheck` every [X] minutes
- [ ] **Vercel Web Analytics enabled:** Core Web Vitals being collected

**Failure:** Missing observability → `observability-setup-skill` must configure before `READY_FOR_HUMAN_APPROVAL`

---

## Section 9 — Cron Jobs (if applicable)

- [ ] **`vercel.json` reviewed:** cron schedule entries are correct
- [ ] **All cron route handlers verified:** each starts with `guardCron(request)` as the FIRST call
- [ ] **`syncLog()` in `finally` block:** all cron handlers log in finally (even on error)
- [ ] **Cron idempotency confirmed:** running the job twice produces the same result as running it once

_If no cron jobs in this release: mark all cron checks N/A._

**Failure:** Missing `guardCron()` → return to Agente04_DevBackend (DR009)

---

## Section 10 — Incident Runbooks

- [ ] **Runbooks exist for all 5 critical scenarios:**
  - [ ] Application 500 errors spike
  - [ ] Database connectivity failure
  - [ ] Authentication failure (NextAuth/Google OAuth)
  - [ ] Cron job failure
  - [ ] Deployment failure / rollback execution
- [ ] **Runbooks updated** (if MTTR > 1 hour in previous incident)

**Failure on first go-live:** Issue `BLOCKED_MISSING_ARTIFACT` if runbooks are not prepared

---

## Section 11 — Deployment Plan Document

- [ ] **`Deployment_Plan.md` produced** using `templates/Deployment_Plan.md`
- [ ] **All sections complete** — no placeholder text ("TBD", "to be determined")
- [ ] **Gate status code present** in header
- [ ] **Human approval section present** — ready for approver signature

---

## Final Gate 6 Decision

| Section | Result |
|---------|--------|
| 1 — Prerequisite Gates | [ ] PASS / [ ] FAIL |
| 2 — CI/CD Pipeline | [ ] PASS / [ ] FAIL |
| 3 — Environment Variables | [ ] PASS / [ ] FAIL |
| 4 — Database Migrations | [ ] PASS / [ ] FAIL / [ ] N/A |
| 5 — Rollback Plan | [ ] PASS / [ ] FAIL |
| 6 — Healthcheck Endpoint | [ ] PASS / [ ] FAIL |
| 7 — Smoke Tests | [ ] PASS / [ ] FAIL |
| 8 — Observability | [ ] PASS / [ ] FAIL |
| 9 — Cron Jobs | [ ] PASS / [ ] FAIL / [ ] N/A |
| 10 — Incident Runbooks | [ ] PASS / [ ] FAIL |
| 11 — Deployment Plan | [ ] PASS / [ ] FAIL |

**All PASS → Gate 6 status: `READY_FOR_HUMAN_APPROVAL`**
**Any FAIL → Gate 6 status: appropriate BLOCKED code (see above)**

---

## Runtime Knowledge Policy

This checklist is consulted at runtime from `Agente08_DevOps/checklists/deployment_readiness_checklist.md`. Decision rules applied: DR001 (rollback plan), DR002 (prisma db push), DR005 (healthcheck), DR006 (smoke tests), DR008 (shared secrets), DR009 (guardCron), DR010 (CI pipeline). Do not access `context/` or `lib/` to complete this checklist — all required knowledge is in `context_view.md` and `knowledge/`.
