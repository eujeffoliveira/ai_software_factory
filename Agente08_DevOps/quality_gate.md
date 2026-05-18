# Agente08_DevOps — Quality Gate Reference

This document defines the entry criteria, exit criteria, mandatory artifacts, authorized status codes, and decision rules for Gates 6 and 7.

---

## Gate 6 — Deployment Review

### Role in Gate 6
- **Agente08_DevOps**: Prepares all artifacts and validates all pre-conditions
- **Human (via Tech Lead)**: Approves the actual production deployment
- **No automated override**: Gate 6 `READY_FOR_HUMAN_APPROVAL` means the artifacts are ready — it does NOT mean deployment can proceed without human authorization

### Gate 6 Entry Criteria
The following must all be true before DevOps begins Gate 6 preparation:

| # | Criterion | Source |
|---|-----------|--------|
| 1 | `Security_Audit.md` present with `gate_decision: APPROVED` | Agente07_DevSecOps handoff |
| 2 | `QA_Report.md` present with `gate_decision: APPROVED` | Agente06_QaEngineer handoff |
| 3 | Implementation files at the reviewed commit accessible | Handoff package |
| 4 | `Architecture.md` available | Handoff package |
| 5 | `package.json` available | Handoff package |
| 6 | `prisma/schema.prisma` and migration files accessible | Handoff package |
| 7 | CI/CD workflow configuration accessible | Repository |
| 8 | Vercel project exists and staging environment is configured | Pre-existing infrastructure |

### Gate 6 Mandatory Artifacts
Both artifacts are **required** before Gate 6 status can be `READY_FOR_HUMAN_APPROVAL`. Missing either = immediate block.

1. **`Deployment_Plan.md`** — complete deployment plan with all checklist items verified
2. **`Rollback_Plan.md`** — complete rollback plan with tested procedure and trigger conditions

### Gate 6 Pre-Deploy Checks (all must pass for READY_FOR_HUMAN_APPROVAL)

| Check | Skill | Required |
|-------|-------|---------|
| CI/CD pipeline passing (typecheck + lint + tests + build) | `ci-cd-pipeline-skill` | Mandatory |
| Staging environment variables all present | `environment-validation-skill` | Mandatory |
| Production environment variables all present | `environment-validation-skill` | Mandatory |
| No secrets shared between staging and production | `environment-validation-skill` | Mandatory (CRITICAL if violated) |
| `lib/env.ts` Zod schema matches deployed secret set | `environment-validation-skill` | Mandatory |
| Pending migrations documented and risk-assessed | `migration-deploy-skill` | Mandatory if migrations exist |
| Destructive migrations have human sign-off | `migration-deploy-skill` | Mandatory if destructive |
| `Rollback_Plan.md` complete | `rollback-planning-skill` | Mandatory |
| Healthcheck endpoint functional in staging | `healthcheck-validation-skill` | Mandatory |
| Smoke tests passing in staging | `post-deploy-smoke-test-skill` | Mandatory |
| Observability configured (logs, error tracking, uptime) | `observability-setup-skill` | Mandatory |
| Incident runbooks produced | `incident-runbook-skill` | Mandatory for first go-live |
| `vercel.json` cron config correct, `guardCron()` in handlers | `vercel-deployment-skill` | Mandatory if crons exist |

### Gate 6 Status Codes

#### `READY_FOR_HUMAN_APPROVAL`
**Meaning:** All pre-deploy checks passed. Deployment_Plan.md and Rollback_Plan.md are complete. Awaiting explicit human authorization to execute production deployment.

**Required evidence:**
- All 13 pre-deploy checks above are PASS
- Deployment_Plan.md complete with all sections filled
- Rollback_Plan.md complete with trigger conditions and tested procedure
- No BLOCKED items outstanding

**Next action:** Human reviews and approves → Agente08_DevOps executes deployment (Phase 2)

---

#### `BLOCKED_NO_ROLLBACK_PLAN`
**Meaning:** `Rollback_Plan.md` is missing, incomplete, or lacks critical sections (trigger conditions, rollback steps, database strategy, estimated time, owner).

**Required evidence:** Specific missing section(s) identified

**Blocking condition:** DR001 — this block cannot be cleared without a complete Rollback_Plan.md

**Resolution:** DevOps produces Rollback_Plan.md using `rollback-planning-skill` → reissue Gate 6 status

---

#### `BLOCKED_MISSING_ARTIFACT`
**Meaning:** A required input artifact is missing or does not have the expected approved status. Common causes: Security_Audit.md missing or not APPROVED, QA_Report.md missing or not APPROVED, implementation files not accessible at reviewed commit.

**Required evidence:** Which artifact is missing and what is expected

**Resolution:** Return to the agent responsible for the missing artifact → resubmit to DevOps when complete

---

#### `BLOCKED_CI_FAILURE`
**Meaning:** The GitHub Actions CI/CD pipeline has failing checks on the target commit. Deployment of failing code is prohibited.

**Required evidence:** Which CI steps are failing, commit SHA, workflow run URL

**Resolution:** Return to the responsible Dev agent to fix the failing checks → CI must be green before Gate 6 can proceed

---

### Gate 6 — What Blocks It (Non-Negotiable)
These conditions block Gate 6 regardless of schedule pressure, Tech Lead instructions, or any other factor:

1. `Rollback_Plan.md` missing or incomplete
2. Required input artifact missing or not APPROVED
3. CI/CD pipeline failing on target commit
4. `prisma db push` usage detected in staging or production
5. Secrets shared between staging and production
6. Destructive migration without human sign-off
7. Healthcheck endpoint missing in staging
8. Smoke tests failing in staging

---

## Gate 7 — Post-Deploy Validation

### Role in Gate 7
Agente08_DevOps owns Gate 7 entirely. After human approval at Gate 6 and deployment execution, DevOps monitors, validates, and issues the final Gate 7 status. No additional human approval is required for Gate 7 unless a BLOCKED_SLO_VIOLATION occurs (which triggers escalation).

### Gate 7 Entry Criteria

| # | Criterion |
|---|-----------|
| 1 | Gate 6 `READY_FOR_HUMAN_APPROVAL` issued |
| 2 | Explicit human approval received (documented in Deployment_Plan.md) |
| 3 | `vercel --prod` deployment executed |
| 4 | `prisma migrate deploy` executed (if applicable) and confirmed successful |

### Gate 7 Mandatory Artifacts

1. **`Post_Deploy_Report.md`** — deployment outcome with healthcheck table, smoke test results, error rate, migration status, and gate decision

### Gate 7 Post-Deploy Checks (all must pass for APPROVED)

| Check | Threshold | Skill |
|-------|-----------|-------|
| Healthcheck passes continuously for 5 minutes | 0 consecutive failures in 5 min | `healthcheck-validation-skill` |
| All 4 smoke tests pass | 4/4 PASS | `post-deploy-smoke-test-skill` |
| Error rate within threshold (first 10 min) | < 5% | Direct monitoring |
| Migration confirmed successful | 0 errors | `migration-deploy-skill` |
| Structured logs flowing | audit_log + sync_log active | `observability-setup-skill` |

### Gate 7 Status Codes

#### `APPROVED`
**Meaning:** Production deployment is stable. All post-deploy checks passed. Service is healthy and observable.

**Required evidence:**
- Healthcheck: all checks passing for full 5-minute window (T+0m through T+5m)
- Smoke tests: all 4 passing
- Error rate: < 5% in first 10 minutes
- Migration: applied successfully
- Logs: structured logs confirmed flowing

**Next action:** Handoff to Agente00_TechLead for project closure

---

#### `RETURNED_FOR_MONITORING`
**Meaning:** Deployment succeeded but requires an extended monitoring period before final APPROVED can be issued. Typically: non-critical anomalies detected (slightly elevated error rate below rollback threshold, isolated performance degradation, minor smoke test flakiness that passed on retry).

**Required evidence:** Specific anomalies identified with current measurements vs. thresholds

**Extended monitoring period:** Define explicitly (e.g., "Monitor for 30 additional minutes; issue APPROVED if error rate drops below 2%")

**Resolution:** DevOps monitors the defined period and issues final status

---

#### `BLOCKED_SLO_VIOLATION`
**Meaning:** Post-deploy checks confirmed a service level violation. Rollback has been triggered (or is being prepared). Service health is compromised.

**Triggers (any one is sufficient):**
- Healthcheck fails 3 consecutive checks within the 5-minute window
- Error rate > 5% sustained for 10 minutes
- Smoke test failure on primary user flow (not flaky — reproducible failure)
- Response time P95 > 3x baseline

**Required evidence:** Specific violation(s) with measurements, rollback status

**Required action:** Initiate rollback procedure → escalate to Tech Lead → produce incident runbook entry → postmortem if MTTR > 1 hour

---

## Gate Decision Matrix

| Condition | Gate 6 Status | Gate 7 Status |
|-----------|---------------|---------------|
| All pre-deploy checks pass + artifacts complete | `READY_FOR_HUMAN_APPROVAL` | — |
| Rollback_Plan.md missing | `BLOCKED_NO_ROLLBACK_PLAN` | — |
| Security_Audit.md not APPROVED | `BLOCKED_MISSING_ARTIFACT` | — |
| CI/CD pipeline failing | `BLOCKED_CI_FAILURE` | — |
| All post-deploy checks pass | — | `APPROVED` |
| Minor anomalies, not at rollback threshold | — | `RETURNED_FOR_MONITORING` |
| Healthcheck failure / error rate breach / smoke failure | — | `BLOCKED_SLO_VIOLATION` |

---

## Gate 6 → Gate 7 Transition

Gate 7 begins only after:
1. Gate 6 status is `READY_FOR_HUMAN_APPROVAL`
2. Human explicitly approves (documented)
3. DevOps executes: `prisma migrate deploy` (if applicable) → `vercel --prod`

The transition from Gate 6 to Gate 7 is gated by human approval. DevOps does not self-authorize the transition.
