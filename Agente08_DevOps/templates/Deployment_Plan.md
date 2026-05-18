# Deployment Plan
## Gate 6 Status: [READY_FOR_HUMAN_APPROVAL | BLOCKED_NO_ROLLBACK_PLAN | BLOCKED_MISSING_ARTIFACT | BLOCKED_CI_FAILURE]

> **Status Rationale:** [One to two sentences explaining the gate status decision with specific evidence]

**Project:** [Project Name]
**Feature/Release:** [Brief description of what is being deployed]
**Target Environment:** Production
**Planned Deploy Date:** [YYYY-MM-DD]
**Target Commit SHA:** [7+ character SHA]
**Prepared by:** Agente08_DevOps v1.0.0
**Prepared at:** [ISO-8601 timestamp]

---

## Prerequisite Gates

| Gate | Status | Artifact |
|------|--------|----------|
| Gate 4 (QA Review) | [APPROVED / NOT_VERIFIED] | QA_Report.md |
| Gate 5 (Security Review) | [APPROVED / NOT_VERIFIED] | Security_Audit.md |

---

## Pre-Deploy Checklist

All items must be PASS before Gate 6 status is `READY_FOR_HUMAN_APPROVAL`.

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | Gate 4 (QA) APPROVED — QA_Report.md attached | [ ] PASS / [ ] FAIL | |
| 2 | Gate 5 (Security) APPROVED — Security_Audit.md attached | [ ] PASS / [ ] FAIL | |
| 3 | CI pipeline passing on target commit (typecheck, lint, tests, build) | [ ] PASS / [ ] FAIL | |
| 4 | Staging environment variables all present and valid | [ ] PASS / [ ] FAIL | |
| 5 | Production environment variables all present and valid | [ ] PASS / [ ] FAIL | |
| 6 | Staging and production use distinct, non-shared secrets | [ ] PASS / [ ] FAIL | |
| 7 | `lib/env.ts` Zod schema matches deployed secret set | [ ] PASS / [ ] FAIL | |
| 8 | Database migrations documented and risk-assessed | [ ] PASS / [ ] FAIL / [ ] N/A | |
| 9 | Destructive migrations have human sign-off | [ ] PASS / [ ] FAIL / [ ] N/A | |
| 10 | `Rollback_Plan.md` complete and procedure verified in staging | [ ] PASS / [ ] FAIL | |
| 11 | Healthcheck endpoint (`GET /api/healthcheck`) functional in staging | [ ] PASS / [ ] FAIL | |
| 12 | Smoke tests (all 4) passing in staging | [ ] PASS / [ ] FAIL | |
| 13 | Observability configured (logs, error tracking, uptime monitoring) | [ ] PASS / [ ] FAIL | |
| 14 | Incident runbooks produced (or updated if MTTR > 1hr since last deploy) | [ ] PASS / [ ] FAIL | |
| 15 | Cron handlers have `guardCron()` as first call (if cron routes exist) | [ ] PASS / [ ] FAIL / [ ] N/A | |

---

## Deployment Steps

**IMPORTANT: Execute only after receiving explicit human approval at Step 8.**

| Step | Action | Command / UI Action | Verification |
|------|--------|---------------------|--------------|
| 1 | Verify staging is green | Run smoke tests against staging URL | All 4 smoke tests PASS |
| 2 | Confirm human approval received | Check documented approval in this plan | Approver name + timestamp present |
| 3 | Execute database migration (if applicable) | `npx prisma migrate deploy` | `prisma migrate status` shows all applied |
| 4 | Verify migration completed | `npx prisma migrate status` | No pending migrations remaining |
| 5 | Trigger Vercel production deployment | `vercel --prod` | Deployment URL returned |
| 6 | Wait for deployment to complete | Monitor Vercel dashboard | Deployment status: Ready |
| 7 | Start healthcheck monitoring | `GET /api/healthcheck` every 30s for 5min | 10/10 checks return 200 |
| 8 | Run production smoke tests | Execute Playwright smoke suite | All 4 tests PASS |
| 9 | Confirm observability receiving events | Check Vercel logs + error tracker | audit_log/sync_log entries visible |
| 10 | Confirm with Tech Lead | Report Gate 7 status | Handoff package delivered |

**⚠ HUMAN APPROVAL REQUIRED before Step 3. Do not execute deployment without explicit authorization.**

---

## Environment Variables

### New Variables in This Release

| Variable Name | Description | Staging Configured | Production Configured |
|---------------|-------------|-------------------|----------------------|
| [VAR_NAME] | [What this variable controls] | [ ] Yes / [ ] No | [ ] Yes / [ ] No |

_List only variables added or changed in this release. If no changes: "No environment variable changes in this release."_

### Validation Status

- Staging: All variables present and valid — [ ] YES / [ ] NO
- Production: All variables present and valid — [ ] YES / [ ] NO
- No secrets shared between environments — [ ] CONFIRMED / [ ] VIOLATION FOUND
- All accessed via `lib/env.ts` (no scattered `process.env`) — [ ] CONFIRMED / [ ] VIOLATION FOUND

See `Environment_Checklist.md` for complete per-variable validation results.

---

## Database Migrations

### Migrations Being Applied

| Order | Migration File | Operations | Destructive | Duration (est.) | Risk | Sign-off |
|-------|---------------|------------|-------------|-----------------|------|----------|
| 1 | [filename] | [ADD COLUMN / CREATE TABLE / etc.] | [ ] Yes / [ ] No | [X] seconds | LOW/MEDIUM/HIGH | [N/A or name+date] |

_If no pending migrations: "No pending migrations in this release."_

### Migration Safety Checklist

- [ ] All migrations are backward-compatible with current codebase
- [ ] No data loss will occur (or data migration planned)
- [ ] Estimated duration is acceptable (< 30s each, or long-running strategy planned)
- [ ] Forward-fix rollback migration prepared for all destructive operations
- [ ] `prisma migrate deploy` (NOT `prisma db push`) confirmed as execution command

See `Migration_Deploy_Plan.md` for complete migration plan.

---

## Rollback Plan

**Rollback_Plan.md:** ATTACHED — see companion document `Rollback_Plan.md`

Status: [ ] COMPLETE — procedure verified in staging | [ ] INCOMPLETE — BLOCKS GATE 6

**Quick reference:**
- Application rollback: Vercel Dashboard → Deployments → Promote previous → ~5 minutes
- Database rollback: [Forward-fix migration prepared / Not applicable]
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
| Structured logs (`audit_log` + `sync_log`) | [CONFIGURED / MISSING / PARTIAL] | |
| Error tracking (Sentry or equivalent) | [CONFIGURED / MISSING / PARTIAL] | |
| Uptime monitoring (`/api/healthcheck`) | [CONFIGURED / MISSING / PARTIAL] | |
| Performance monitoring (Vercel Analytics) | [CONFIGURED / MISSING / PARTIAL] | |

---

## Human Approval

**This section must be completed by the approving human before execution begins.**

Approved by: _________________________________
Approved at: _________________________________
Approval notes: _________________________________

_By signing above, I confirm I have reviewed `Deployment_Plan.md` and `Rollback_Plan.md` and authorize the production deployment described in this document._
