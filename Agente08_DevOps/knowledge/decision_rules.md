# Agente08_DevOps — Decision Rules

Decision rules DR001–DR015 are if-then operational rules. When a condition is met, the action is mandatory — not advisory. Rules are listed in priority order (earlier rules take precedence in conflict).

---

## DR001 — Missing Rollback Plan Blocks Gate 6

**Condition:** `Rollback_Plan.md` is absent OR contains placeholder text ("TBD", "to be determined") OR is missing any of these sections: rollback trigger conditions, application rollback steps, database rollback strategy, estimated rollback time, rollback owner.

**Action:** Issue Gate 6 `BLOCKED_NO_ROLLBACK_PLAN`. Do not proceed to deployment. Invoke `rollback-planning-skill` to produce a complete `Rollback_Plan.md`. Reissue Gate 6 status only after all required sections are complete and procedure is verified in staging.

**Rationale:** P8 — Rollback is a first-class operation. A deployment without a tested rollback plan is not a planned deployment.

---

## DR002 — `prisma db push` in Staging or Production Is a Critical Violation

**Condition:** Evidence exists (in CI logs, deployment scripts, documentation, or database schema drift) that `prisma db push` was executed in a staging or production environment.

**Action:** Stop all deployment activities immediately. Return to Agente04_DevBackend with CRITICAL flag. Escalate to Agente00_TechLead (data integrity risk). Do not deploy to production until migration history is reconciled with actual database state.

**Rationale:** `prisma db push` bypasses migration history, creates untracked schema drift, and cannot be reliably replicated. It violates P11 (Configuration Management) and P12 (Change Control).

---

## DR003 — Env Vars Not Centralized in `lib/env.ts` Must Be Fixed Before Deploy

**Condition:** `process.env.VARIABLE_NAME` references are found in application code outside of `lib/env.ts`. Environment variables are accessed directly in Server Actions, Route Handlers, features, or components.

**Action:** Flag as a pre-deploy blocker. Return to Agente04_DevBackend with specific file paths and line references. Do not deploy until all env var access is centralized via `lib/env.ts` Zod schema.

**Rationale:** Scattered `process.env` calls bypass the Zod validation layer, make it impossible to audit env var usage, and allow type-unsafe access to potentially missing variables.

---

## DR004 — Destructive Migration Requires Human Sign-Off Before Execution

**Condition:** A pending migration file contains any of: `DROP COLUMN`, `DROP TABLE`, `TRUNCATE TABLE`, `ALTER COLUMN` narrowing the data type (e.g., reducing VARCHAR size), or any operation with potential data loss.

**Action:** Flag as destructive in `Migration_Deploy_Plan.md`. Halt migration execution until documented human sign-off is obtained. Document: the specific destructive operation, estimated data impact (rows affected), forward-fix rollback migration, and explicit approver identity and timestamp.

**Rationale:** Destructive migrations are irreversible in real-time. Once data is dropped, it can only be recovered from backups (at the cost of losing newer data). Human accountability is required.

---

## DR005 — Missing Healthcheck Endpoint Blocks Go-Live

**Condition:** `GET /api/healthcheck` does not exist, returns a non-200 status, requires authentication, does not check database connectivity, or does not conform to the expected response schema `{"status": "ok", "timestamp": "...", "version": "..."}`.

**Action:** Flag as a blocking issue. Provide the healthcheck implementation spec from `context_view.md` Section 6. Return to Agente04_DevBackend to implement the endpoint. Do not issue Gate 6 `READY_FOR_HUMAN_APPROVAL` until healthcheck passes in staging.

**Rationale:** Post-deploy monitoring depends on a reliable healthcheck. A missing or non-functional healthcheck means post-deploy validation cannot be performed — flying blind after deployment.

---

## DR006 — Smoke Test or Healthcheck Failure Post-Deploy Triggers Rollback

**Condition:** After production deployment, any of these conditions occur: (a) healthcheck fails 3 consecutive times within 5 minutes, OR (b) any smoke test on Test 1 (app loads), Test 2 (auth redirect), or Test 3 (primary feature) fails and does not pass on a single retry.

**Action:** Initiate rollback immediately via Vercel dashboard (Promote previous deployment). Notify Tech Lead within 5 minutes of rollback trigger. Issue Gate 7 `BLOCKED_SLO_VIOLATION`. After rollback: run smoke tests to confirm rollback success. Produce Post_Deploy_Report.md with full incident timeline.

**Rationale:** Three consecutive healthcheck failures indicate a non-transient system issue. Smoke test failure on primary user flow means users cannot use the application. Rollback is faster than a production hotfix.

---

## DR007 — Sustained Error Rate Above Threshold Triggers Rollback

**Condition:** Post-deploy error rate (HTTP 5xx responses) exceeds 5% sustained for 10 consecutive minutes.

**Action:** Initiate rollback. Notify Tech Lead. Issue Gate 7 `BLOCKED_SLO_VIOLATION`. After rollback: confirm error rate returns to pre-deploy baseline. Begin incident investigation using structured logs (`sync_log`, `audit_log`). Prepare postmortem trigger.

**Rationale:** A 5% error rate means 1 in 20 user requests is failing. If sustained for 10 minutes, this is not a transient spike — it is a systemic issue introduced by the deployment. P4: SLOs define acceptable behavior; this deployment has breached the SLO.

---

## DR008 — Shared Secret Between Staging and Production Is a Critical Security Violation

**Condition:** `environment-validation-skill` detects the same value for any secret variable (`DATABASE_URL`, `NEXTAUTH_SECRET`, OAuth client secret, API key, or any credential) in both staging and production Vercel environments.

**Action:** Do not deploy. Issue Gate 6 block. Escalate to Agente07_DevSecOps immediately as a CRITICAL security finding. Escalate to Agente00_TechLead for coordination. Do not proceed until the shared secret is rotated in the environment where it does not belong.

**Rationale:** Shared secrets between environments violate the principle of environment isolation (P9). A staging compromise could expose production credentials. A staging/production audit log mixing makes incident investigation unreliable.

---

## DR009 — Cron Route Missing `guardCron()` Blocks Deployment

**Condition:** A Vercel Cron route handler (`app/api/cron/*/route.ts`) does not have `guardCron(request)` as its first line of code.

**Action:** Do not deploy. Return to Agente04_DevBackend with specific file path and required fix. Cron routes without `guardCron()` will silently fail in production (Vercel rejects unguarded cron requests). Reissue Gate 6 status only after all cron handlers are verified.

**Rationale:** `guardCron()` validates the Vercel-provided cron secret header. Without it, any HTTP request (including from attackers) can trigger the cron handler. With it, only authenticated Vercel cron invocations proceed.

---

## DR010 — Missing CI/CD Pipeline Steps Block Gate 6

**Condition:** The GitHub Actions workflow file (`.github/workflows/ci.yml` or equivalent) is missing any of these required steps: TypeScript typecheck (`tsc --noEmit`), ESLint, Vitest unit tests, Next.js production build. OR any of these steps are currently failing on the target commit.

**Action:** Issue Gate 6 `BLOCKED_CI_FAILURE`. Identify the missing or failing step specifically. Return to responsible Dev agent (TypeScript/ESLint/Vitest issues → Agente04/05; build issues → Agente04). If pipeline configuration is missing: provide the required pipeline template from `context_view.md` Section 3.

**Rationale:** The CI pipeline is the automated quality gate. Deploying from a commit that has not passed CI bypasses the only automated validation layer. This is how regressions reach production.

---

## DR011 — Long-Running Migration Requires Database Team Review

**Condition:** A migration is estimated to take > 30 seconds on the staging database (based on table row count × operation complexity). For tables with > 1 million rows, any `ALTER TABLE` that rewrites rows or adds an index is in this category.

**Action:** Flag in `Migration_Deploy_Plan.md` as requiring database team review. Assess options: (1) online migration strategy (add column with default → backfill in batches → add NOT NULL constraint), (2) scheduled maintenance window, (3) lock-free index creation (`CREATE INDEX CONCURRENTLY` in Postgres). Obtain human review before proceeding.

**Rationale:** Long-running migrations lock the table, causing application timeouts and 500 errors during deployment. In production, a 30-second migration on a 10-million-row table can cause visible downtime.

---

## DR012 — All Pre-Deploy Checks Pass + Human Approved = Execute Deployment

**Condition:** All 13 Gate 6 pre-deploy checks are PASS, `Deployment_Plan.md` and `Rollback_Plan.md` are complete, Gate 6 status is `READY_FOR_HUMAN_APPROVAL`, and explicit documented human approval is received.

**Action:** Execute the deployment sequence: (1) `prisma migrate deploy` if pending migrations exist → verify success, (2) `vercel --prod` → wait for deployment completion, (3) begin 5-minute healthcheck monitoring window, (4) execute smoke tests, (5) produce `Post_Deploy_Report.md`.

**Rationale:** This is the "green path" — all gates passed, all artifacts ready, human approved. Execute with full monitoring as planned. Do not add ad-hoc steps or skip monitoring.

---

## DR013 — Healthcheck Passing for 5 Minutes + Smoke Tests Passing = Gate 7 APPROVED

**Condition:** All 10 healthcheck checks in the 5-minute window (every 30 seconds) return HTTP 200 with `{"status": "ok", ...}`, all 4 smoke tests pass, and error rate is < 5% in the first 10 minutes.

**Action:** Issue Gate 7 `APPROVED`. Produce `Post_Deploy_Report.md` with all evidence tables complete. Hand off to Agente00_TechLead.

**Rationale:** These three signals together (healthcheck, smoke tests, error rate) confirm that the application is running correctly, users can access it, and the primary feature is functional. This is sufficient evidence for APPROVED.

---

## DR014 — Docker/Kubernetes/AWS Deployment Without ADR Is Rejected

**Condition:** A deployment request arrives specifying Docker containers, Kubernetes orchestration, AWS ECS/EKS, or any non-Vercel hosting platform, without an accompanying ADR (Architecture Decision Record) that has been approved by Agente00_TechLead.

**Action:** Reject the deployment request. Return to Agente00_TechLead with explanation: Vercel is the Golden Path deploy target; alternative platforms require an ADR with documented rationale, approved by Tech Lead, before DevOps can proceed.

**Rationale:** The Golden Path (Vercel) is the default for operational reasons: zero-config serverless, built-in preview deployments, Vercel Cron integration, and predictable scaling. Deviating introduces operational complexity that must be justified and approved.

---

## DR015 — MTTR > 1 Hour Triggers Runbook Update Before Next Deploy

**Condition:** A production incident occurred where Mean Time to Recovery (from incident detection to service restoration) exceeded 1 hour.

**Action:** Before the next production deployment, update the relevant incident runbook using `incident-runbook-skill`. Document: what the incident was, why MTTR exceeded the threshold, what resolution steps were taken, and what process change prevents recurrence. Conduct a blameless postmortem. Include postmortem findings in the next `Deployment_Plan.md`.

**Rationale:** MTTR > 1 hour indicates that the existing runbook was insufficient (missing steps, wrong escalation path, or unknown failure mode). Deploying again without updating the runbook is repeating the risk.
