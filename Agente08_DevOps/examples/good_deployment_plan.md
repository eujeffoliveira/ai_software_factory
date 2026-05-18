# Good Deployment Plan Example

This example demonstrates a complete, production-quality Deployment_Plan.md that correctly issues `READY_FOR_HUMAN_APPROVAL`. Use this as a reference when producing `Deployment_Plan.md`.

---

# Deployment Plan
## Gate 6 Status: READY_FOR_HUMAN_APPROVAL

> **Status Rationale:** All 15 pre-deploy checklist items have been verified PASS. Rollback_Plan.md is complete and the rollback procedure was tested in staging on 2026-05-16. CI pipeline is green on commit `a3f7b2c`. Awaiting explicit human authorization before executing production deployment.

**Project:** Project Dashboard App
**Feature/Release:** User Dashboard with Project Management (v1.2.0)
**Target Environment:** Production
**Planned Deploy Date:** 2026-05-18
**Target Commit SHA:** `a3f7b2c9d4e1f3a5b8c2d6e9f0a1b3c5d7e9f012`
**Prepared by:** Agente08_DevOps v1.0.0
**Prepared at:** 2026-05-17T14:30:00Z

---

## Prerequisite Gates

| Gate | Status | Artifact |
|------|--------|----------|
| Gate 4 (QA Review) | APPROVED | QA_Report.md — dated 2026-05-15 |
| Gate 5 (Security Review) | APPROVED | Security_Audit.md — dated 2026-05-16 |

---

## Pre-Deploy Checklist

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Gate 4 (QA) APPROVED — QA_Report.md attached | PASS | QA_Report.md confirmed APPROVED, 2026-05-15 |
| 2 | Gate 5 (Security) APPROVED — Security_Audit.md attached | PASS | Security_Audit.md confirmed APPROVED, 2026-05-16 |
| 3 | CI pipeline passing on target commit (typecheck, lint, tests, build) | PASS | GitHub Actions run #842, all steps green, commit a3f7b2c |
| 4 | Staging environment variables all present and valid | PASS | 6/6 variables in lib/env.ts Zod schema present in Vercel Preview |
| 5 | Production environment variables all present and valid | PASS | 6/6 variables present in Vercel Production |
| 6 | Staging and production use distinct, non-shared secrets | PASS | DATABASE_URL, NEXTAUTH_SECRET, OAuth credentials all distinct |
| 7 | `lib/env.ts` Zod schema matches deployed secret set | PASS | Schema has 6 vars, 6 present in both environments |
| 8 | Database migrations documented and risk-assessed | PASS | 1 migration: `20260515_add_project_status` — LOW risk, ADD COLUMN with default |
| 9 | Destructive migrations have human sign-off | N/A | No destructive migrations in this release |
| 10 | `Rollback_Plan.md` complete and procedure verified in staging | PASS | Rollback_Plan.md complete, Vercel dashboard rollback tested 2026-05-16 |
| 11 | Healthcheck endpoint functional in staging | PASS | `GET /api/healthcheck` → 200, `{"status": "ok"}`, avg 145ms, DB check PASS |
| 12 | Smoke tests (all 4) passing in staging | PASS | All 4 smoke tests passed on staging (2026-05-17T10:00Z) |
| 13 | Observability configured (logs, error tracking, uptime monitoring) | PASS | audit_log verified, Sentry active, UptimeRobot monitoring /api/healthcheck |
| 14 | Incident runbooks produced | PASS | 5 runbooks produced: 500 errors, DB failure, auth failure, cron failure, deploy failure |
| 15 | Cron handlers have `guardCron()` as first call | PASS | `app/api/cron/sync-projects/route.ts` — `guardCron()` verified as first call |

---

## Deployment Steps

| Step | Action | Command / UI Action | Verification |
|------|--------|---------------------|--------------|
| 1 | Verify staging is green | Run smoke tests: `npx playwright test e2e/smoke.spec.ts --project=staging` | All 4 tests PASS |
| 2 | Confirm human approval received | Check Human Approval section of this document | Approver name + timestamp present |
| 3 | Execute database migration | `npx prisma migrate deploy` | `prisma migrate status` shows all applied |
| 4 | Verify migration success | `npx prisma migrate status` | Output: "All migrations have been applied" |
| 5 | Trigger Vercel production deployment | `vercel --prod` | Deployment URL returned |
| 6 | Wait for deployment | Monitor Vercel dashboard → Deployments | Status: Ready (2–3 min) |
| 7 | Start healthcheck monitoring | `curl -s [url]/api/healthcheck` every 30s for 5min | 10/10 checks return 200 |
| 8 | Run production smoke tests | `npx playwright test e2e/smoke.spec.ts --project=production` | All 4 tests PASS |
| 9 | Confirm observability active | Check Vercel logs + Sentry dashboard | audit_log entries visible, Sentry active |
| 10 | Report to Tech Lead | Deliver Post_Deploy_Report.md | Gate 7 status: APPROVED |

**⚠ HUMAN APPROVAL REQUIRED before Step 3. Do not execute deployment without explicit authorization.**

---

## Environment Variables

### New Variables in This Release

| Variable Name | Description | Staging Configured | Production Configured |
|---------------|-------------|-------------------|----------------------|
| `NEXT_PUBLIC_FEATURES_DASHBOARD` | Feature flag for dashboard module | Yes | Yes |

### Validation Status

- Staging: All variables present and valid — YES
- Production: All variables present and valid — YES
- No secrets shared between environments — CONFIRMED (DATABASE_URL has distinct hostnames: `staging-db.supabase.co` vs `production-db.supabase.co`)
- All accessed via `lib/env.ts` — CONFIRMED (grep search found 0 violations)

See `Environment_Checklist.md` for complete per-variable validation results.

---

## Database Migrations

### Migrations Being Applied

| Order | Migration File | Operations | Destructive | Duration (est.) | Risk | Sign-off |
|-------|---------------|------------|-------------|-----------------|------|----------|
| 1 | `20260515120000_add_project_status` | ADD COLUMN `status VARCHAR(50) NOT NULL DEFAULT 'active'` to `projects` table | No | ~2 seconds (42K rows) | LOW | N/A |

### Migration Safety Checklist

- [x] Migration is backward-compatible — `status` has DEFAULT value, existing code works
- [x] No data loss — ADD COLUMN with DEFAULT populates all existing rows
- [x] Estimated duration: ~2 seconds on 42K row table — acceptable
- [x] Forward-fix rollback migration prepared: `20260518_remove_project_status` (`DROP COLUMN status`)
- [x] `prisma migrate deploy` confirmed as execution command

See `Migration_Deploy_Plan.md` for complete migration plan.

---

## Rollback Plan

**Rollback_Plan.md:** ATTACHED — see companion document `Rollback_Plan.md`

Status: COMPLETE — procedure verified in staging on 2026-05-16

**Quick reference:**
- Application rollback: Vercel Dashboard → Deployments → Promote "v1.1.0-preview" → ~3 minutes
- Database rollback: Forward-fix migration `20260518_remove_project_status` prepared — removes `status` column
- Rollback trigger: 3× healthcheck failures in 5min OR error rate > 5% for 10min OR smoke test failure

---

## Monitoring Plan

**Healthcheck endpoint:** `GET /api/healthcheck`
**Interval:** Every 30 seconds
**Duration:** 5 minutes (10 total checks)
**Rollback trigger:** 3 consecutive failures

**Error rate threshold:** > 5% sustained for 10 minutes → rollback trigger

**Smoke test schedule:** Immediately after deploy, then every 5 minutes for first 30 minutes

---

## Observability Status

| Component | Status | Notes |
|-----------|--------|-------|
| Structured logs (`audit_log` + `sync_log`) | CONFIGURED | Verified in staging — entries visible in Vercel logs |
| Error tracking (Sentry) | CONFIGURED | DSN configured, test event confirmed received |
| Uptime monitoring (`/api/healthcheck`) | CONFIGURED | UptimeRobot monitor active, 5-minute interval |
| Performance monitoring (Vercel Analytics) | CONFIGURED | Web Vitals enabled in Vercel project settings |

---

## Human Approval

**This section must be completed by the approving human before execution begins.**

Approved by: _________________________________
Approved at: _________________________________
Approval notes: _________________________________

_By signing above, I confirm I have reviewed Deployment_Plan.md and Rollback_Plan.md and authorize the production deployment described in this document._

---

**WHY THIS IS A GOOD EXAMPLE:**
- All 15 pre-deploy checklist items are explicitly verified with evidence (not just checked boxes)
- Migration is documented with specific table name, row count, and estimated duration
- Rollback plan is referenced with specific previous deployment ID and estimated rollback time
- Environment isolation is confirmed with specific hostname evidence
- CI pipeline status references a specific run number and commit SHA
- Human approval section is present and correctly positioned
- Gate 6 status is `READY_FOR_HUMAN_APPROVAL` (not APPROVED — human must approve)
- Deployment steps explicitly state human approval requirement at Step 2
