# Agente08_DevOps — Skills Manifest

This manifest indexes all 9 skills available to Agente08_DevOps at runtime. Each entry describes what the skill does, when to trigger it, and what it produces. Skills are invoked in sequential order during the deployment workflow.

---

## Skill Index

| # | Skill ID | Phase | Trigger | Output |
|---|----------|-------|---------|--------|
| 1 | `vercel-deployment-skill` | Pre-deploy (Gate 6) | Every production deployment | Deployment_Plan.md section: Vercel config, deploy steps |
| 2 | `ci-cd-pipeline-skill` | Pre-deploy (Gate 6) | Before issuing Gate 6 status | CI pipeline validation report |
| 3 | `environment-validation-skill` | Pre-deploy (Gate 6) | Before issuing Gate 6 status | Environment_Checklist.md |
| 4 | `migration-deploy-skill` | Pre-deploy + execution | When pending migrations exist | Migration_Deploy_Plan.md |
| 5 | `rollback-planning-skill` | Pre-deploy (Gate 6) | Every deployment — mandatory | Rollback_Plan.md |
| 6 | `post-deploy-smoke-test-skill` | Post-deploy (Gate 7) | After every production deploy | Smoke test results section of Post_Deploy_Report.md |
| 7 | `observability-setup-skill` | Pre-deploy (Gate 6) | Before first production deploy or when observability config changes | Observability status section of Deployment_Plan.md |
| 8 | `incident-runbook-skill` | Pre-deploy (first deploy) | Before first go-live; update when MTTR > 1 hour | Runbook documents per failure scenario |
| 9 | `healthcheck-validation-skill` | Post-deploy (Gate 7) | After every production deploy | Healthcheck_Report.md section of Post_Deploy_Report.md |

---

## Skill 1 — vercel-deployment-skill

**Location:** `skills/vercel-deployment-skill/`

**Purpose:** Plan and document the Vercel production deployment — validate Vercel project configuration, verify `vercel.json` cron setup, confirm `guardCron()` in cron handlers, document the exact deployment steps, and produce the Vercel-specific section of Deployment_Plan.md.

**When to trigger:**
- Every time a production deployment is being prepared (Gate 6 phase)
- Any time `vercel.json` changes or new cron routes are added

**Inputs:** `vercel.json`, cron route handler files, current staging deployment URL, target commit SHA

**Outputs:** Deployment steps section, Vercel configuration validation, cron job inventory

**Constraints:**
- Production deploys require human approval — this skill prepares, does not execute
- Cron routes must have `guardCron()` as their first call or the skill flags a blocking issue
- Docker/K8s/AWS deployment requests → skill returns `ADR_REQUIRED` status

---

## Skill 2 — ci-cd-pipeline-skill

**Location:** `skills/ci-cd-pipeline-skill/`

**Purpose:** Validate that the GitHub Actions CI/CD pipeline is passing on the target commit. Verify the pipeline includes all required steps: TypeScript typecheck, ESLint, Vitest, Next.js build, and Playwright E2E (on main). Block Gate 6 if any step is failing or missing.

**When to trigger:**
- Before issuing any Gate 6 status code
- When CI/CD pipeline configuration changes (`.github/workflows/`)

**Inputs:** Target commit SHA, GitHub Actions workflow status, `.github/workflows/ci.yml`

**Outputs:** Pipeline validation status (PASS/FAIL per step), overall CI status

**Constraints:**
- All 5 pipeline steps (typecheck, lint, test, build, e2e) must be present and passing
- A single failing step issues `BLOCKED_CI_FAILURE` at Gate 6
- Missing pipeline entirely issues `BLOCKED_CI_FAILURE` with setup guidance

---

## Skill 3 — environment-validation-skill

**Location:** `skills/environment-validation-skill/`

**Purpose:** Validate that all environment variables required by `lib/env.ts` are present in the target Vercel environment (staging and production). Verify Zod schema matches the deployed secret set. Confirm staging and production use distinct, non-shared values.

**When to trigger:**
- Before issuing Gate 6 `READY_FOR_HUMAN_APPROVAL`
- When `lib/env.ts` is modified (new env var added)
- When environment variable configuration changes

**Inputs:** `lib/env.ts` Zod schema, Vercel environment variable list (staging + production), `.env.example` if present

**Outputs:** `Environment_Checklist.md` with PASS/FAIL per variable and environment

**Constraints:**
- Missing env var in production = CRITICAL → Gate 6 blocked (deploy will fail at boot via Zod)
- Shared secret between staging and production = CRITICAL → escalate to Agente07_DevSecOps
- `process.env` usage outside `lib/env.ts` = flag for Agente04_DevBackend to fix

---

## Skill 4 — migration-deploy-skill

**Location:** `skills/migration-deploy-skill/`

**Purpose:** Document, validate, and execute Prisma migration deployments. Identify all pending migration files, assess each for backward compatibility and data risk, estimate execution time, flag destructive operations for human sign-off, and produce a `Migration_Deploy_Plan.md`.

**When to trigger:**
- Always as part of Gate 6 preparation when pending migrations exist
- When `prisma/migrations/` contains new migration files not yet applied to the target environment

**Inputs:** `prisma/migrations/` directory, current migration state in target DB, `prisma/schema.prisma`

**Outputs:** `Migration_Deploy_Plan.md` with migration inventory, risk assessment, estimated duration, rollback strategy

**Constraints:**
- `prisma migrate deploy` is the ONLY allowed command — `prisma db push` is forbidden
- Destructive operations (DROP COLUMN, DROP TABLE, truncating ALTER) require human sign-off before execution
- Migration taking > 30 seconds in staging must flag a potential production impact
- Rollback strategy = forward-fix migration (no backward migration)

---

## Skill 5 — rollback-planning-skill

**Location:** `skills/rollback-planning-skill/`

**Purpose:** Produce a complete, tested `Rollback_Plan.md` that defines rollback trigger conditions, application rollback steps via Vercel dashboard, database forward-fix rollback strategy, estimated rollback time, and rollback owner. Gate 6 cannot issue `READY_FOR_HUMAN_APPROVAL` without a complete Rollback_Plan.md.

**When to trigger:**
- Every deployment — mandatory, no exceptions
- Before issuing Gate 6 `READY_FOR_HUMAN_APPROVAL`

**Inputs:** Current deployment, migration files being applied, previous production deployment ID, healthcheck endpoint URL

**Outputs:** `Rollback_Plan.md` with trigger conditions, procedure steps, database strategy, time estimate, owner

**Constraints:**
- Missing `Rollback_Plan.md` → Gate 6 `BLOCKED_NO_ROLLBACK_PLAN` — no exceptions
- Rollback procedure must be tested in staging before production deployment proceeds
- Database rollback = forward-fix only — no backward migration
- Estimated rollback time must be stated explicitly (application: ~5 min; database: context-dependent)

---

## Skill 6 — post-deploy-smoke-test-skill

**Location:** `skills/post-deploy-smoke-test-skill/`

**Purpose:** Execute and document the 4 mandatory smoke tests against production after deployment. Report results in structured table format. Trigger rollback if any smoke test fails on the primary user flow.

**When to trigger:**
- Immediately after every successful production deployment (Gate 7)
- After every rollback (to confirm rollback success)

**Inputs:** Production URL, smoke test suite (`e2e/smoke.spec.ts`), authentication test credentials (from env)

**Outputs:** Smoke test results table (Test name, Status, Notes) for Post_Deploy_Report.md

**Minimum required tests:**
1. App loads — `GET /` returns 200
2. Unauthenticated redirect — `/dashboard` redirects to `/auth/signin`
3. Authenticated primary feature — user can access and use primary feature
4. API healthcheck — `GET /api/healthcheck` returns 200 with `{"status": "ok"}`

**Constraints:**
- All 4 tests must pass for Gate 7 `APPROVED`
- Smoke test failure on primary user flow = rollback trigger + escalate to Tech Lead
- Smoke tests must run against production URL, not staging

---

## Skill 7 — observability-setup-skill

**Location:** `skills/observability-setup-skill/`

**Purpose:** Verify and configure all observability components before go-live: structured JSON logging (audit_log, sync_log), error tracking (Sentry or equivalent), uptime monitoring on `/api/healthcheck`, and Vercel Web Analytics for Core Web Vitals. Produce observability status section for Deployment_Plan.md.

**When to trigger:**
- Before first production deployment (go-live)
- When observability configuration changes
- After any production incident where observability gap was identified

**Inputs:** Codebase (audit_log/sync_log usage), error tracking configuration, uptime monitor configuration, Vercel Analytics status

**Outputs:** Observability readiness status per component (CONFIGURED / MISSING / PARTIAL)

**Constraints:**
- All 4 components must be CONFIGURED before Gate 6 `READY_FOR_HUMAN_APPROVAL`
- Missing structured logs = flag structured logging requirement to Agente04_DevBackend
- Missing error tracking = BLOCKED until configured (flying blind post-deploy)
- Missing uptime monitoring = downtime goes undetected — must be configured

---

## Skill 8 — incident-runbook-skill

**Location:** `skills/incident-runbook-skill/`

**Purpose:** Produce incident runbooks for critical failure scenarios. Each runbook contains: symptoms, initial triage steps, resolution steps, escalation path, and postmortem trigger. Required before first go-live; must be updated when MTTR > 1 hour for any incident.

**When to trigger:**
- Before first go-live (produces the initial runbook set)
- After any incident where MTTR > 1 hour (update the relevant runbook)
- When new critical failure modes are identified

**Required runbooks:**
1. Application 500 errors spike
2. Database connectivity failure
3. Authentication failure (NextAuth/Google OAuth)
4. Cron job failure (missing sync_log, stuck jobs)
5. Deployment failure / rollback execution

**Outputs:** One runbook document per scenario following `templates/Runbook_Template.md`

**Constraints:**
- Runbooks must be practical — symptoms must be observable, steps must be actionable
- Escalation path must name specific agents (Agente00_TechLead, Agente07_DevSecOps) for appropriate scenarios
- Postmortem trigger conditions must be stated explicitly

---

## Skill 9 — healthcheck-validation-skill

**Location:** `skills/healthcheck-validation-skill/`

**Purpose:** Define, verify, and monitor the `GET /api/healthcheck` endpoint. Confirm the endpoint implementation matches spec (no auth, checks DB, returns correct schema, responds within 2s). Execute post-deploy monitoring (every 30s for 5 minutes). Trigger rollback on 3 consecutive failures. Produce Healthcheck_Report.md.

**When to trigger:**
- Before Gate 6 `READY_FOR_HUMAN_APPROVAL` (verify endpoint exists and is correct in staging)
- After every production deployment (5-minute post-deploy monitoring window)
- After rollback (confirm rollback success)

**Inputs:** Healthcheck endpoint URL, healthcheck route handler source code

**Outputs:** `Healthcheck_Report.md` with time-series results (T+0m through T+5m) and PASS/FAIL status

**Constraints:**
- Missing healthcheck endpoint → create and deploy before proceeding (or block Gate 6)
- 3 consecutive failures → rollback trigger + immediate escalation to Tech Lead
- Endpoint must not require authentication
- Endpoint must verify database connectivity (not just return static 200)
- Response must conform to schema: `{"status": "ok", "timestamp": "...", "version": "..."}`
