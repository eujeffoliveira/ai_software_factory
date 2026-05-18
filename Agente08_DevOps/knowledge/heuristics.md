# Agente08_DevOps — Decision Heuristics

Heuristics H1–H15 are fast, reliable decision shortcuts distilled from deployment experience and the DevOps bibliography. Use them for rapid assessment before invoking a full skill.

---

## H1 — "If it's not in source control, it doesn't exist"

When assessing a migration, environment configuration, or deployment script, if it is not committed to source control, treat it as absent. A migration described verbally but not in `prisma/migrations/` has not been applied and cannot be tracked. An environment variable described in a document but not in Vercel dashboard is missing.

**Application:** During Gate 6 checks, verify artifacts exist in their authoritative location, not just in documentation.

---

## H2 — "Staging is production's dress rehearsal — if it fails there, abort"

If smoke tests, migrations, or healthchecks fail in staging, they will fail in production. Never proceed to production deployment after a staging failure with the assumption that "it's just a staging issue." Staging failures are production bugs that have not yet reached users.

**Application:** When `post-deploy-smoke-test-skill` or `healthcheck-validation-skill` report failures in staging, issue Gate 6 BLOCKED and return to the responsible Dev agent.

---

## H3 — "Small, frequent deployments fail less than large, infrequent ones"

A deployment with 3 changed files carries less risk than one with 30. Large deployments make incident attribution harder (which change caused the failure?). When receiving a very large changeset for deployment, flag the deployment frequency metric and note the elevated Change Failure Rate risk.

**Application:** Note batch size in Post_Deploy_Report.md. Encourage more frequent, smaller deployments in improvement recommendations.

---

## H4 — "Rollback time must be known before deploy time"

Never proceed to production deployment without a known, tested rollback path. If rollback would take 2 hours (due to a complex migration), the deployment risk profile is fundamentally different from one where rollback takes 5 minutes. The rollback time estimate is a Gate 6 prerequisite.

**Application:** `rollback-planning-skill` must state explicit estimated rollback time. If rollback time is unknown, the plan is incomplete.

---

## H5 — "A healthcheck that does not check the database is a smoke detector without batteries"

A healthcheck that returns 200 unconditionally tells you the server is running — not that the application is functional. The healthcheck must verify database connectivity to serve as a meaningful post-deploy health signal.

**Application:** During `healthcheck-validation-skill`, verify the implementation includes `prisma.$queryRaw\`SELECT 1\`` or equivalent DB check. Reject healthcheck endpoints that are static responses.

---

## H6 — "The first 5 minutes post-deploy are the highest-risk window"

Most deployment failures surface within the first 5 minutes — startup crashes, missing env vars, broken migrations, auth failures. The post-deploy monitoring window is not bureaucratic — it covers the highest-risk interval.

**Application:** Never declare Gate 7 APPROVED before the 5-minute healthcheck monitoring window completes. Do not abbreviate the window under schedule pressure.

---

## H7 — "If you need to share a secret to test staging, you've already failed"

Staging and production must use independent credentials at all times. Using production DATABASE_URL in staging to "test with real data" is a CRITICAL security violation. Using the same OAuth credentials creates an audit trail mixing staging and production events.

**Application:** `environment-validation-skill` always compares secret values (by hash or known-different check) between staging and production. Any shared secret triggers CRITICAL escalation.

---

## H8 — "Observability is a prerequisite, not a follow-up"

Deploying without structured logs, error tracking, and uptime monitoring is choosing to be ignorant of what the production system is doing. Observability is not something to add "after launch" — it must be in place before any production traffic flows.

**Application:** `observability-setup-skill` is a mandatory Gate 6 check. Missing observability components block `READY_FOR_HUMAN_APPROVAL`.

---

## H9 — "A migration that drops data without a plan is irreversible"

Data, once dropped, cannot be retrieved from a backup in real-time (backups restore to a previous state, losing newer data). Destructive migrations require: (1) human sign-off, (2) a data migration plan if rows will be lost, (3) a backup verification that restoration is possible, and (4) a forward-fix migration plan.

**Application:** `migration-deploy-skill` flags any DROP, TRUNCATE, or narrowing ALTER as destructive. Execution requires documented human sign-off. Non-negotiable.

---

## H10 — "The pipeline exists to prevent surprises in production"

Every failed CI check, every failing smoke test in staging, and every incomplete Gate is preventing a production incident. When there is pressure to "just deploy it" despite failing checks, remember: the pipeline catches what code review, manual testing, and optimism miss. The pipeline is not bureaucracy — it is risk management.

**Application:** Never negotiate with failing CI checks or staging failures. The cost of fixing them is always lower than the cost of a production incident.

---

## H11 — "MTTR is the metric that matters most during an incident"

When a production incident occurs, every minute of downtime is a minute of user impact. The focus shifts entirely from process compliance to fastest safe resolution. Rollback is faster than a fix. Rollback first, investigate second.

**Application:** In a BLOCKED_SLO_VIOLATION scenario, the first action is rollback (if applicable), not root cause analysis. Root cause analysis happens in the postmortem.

---

## H12 — "If the cron job silently disappeared, look for the missing guardCron()"

Vercel Cron jobs that do not call `guardCron()` as their first operation will be rejected by Vercel's cron secret validation. The job appears to "not run" with no obvious error in application logs. The fix is always: add `guardCron(request)` as the first call in the route handler.

**Application:** When investigating missing cron executions, check for `guardCron()` before any other diagnosis. This is the most common cause of silent cron failures on Vercel.

---

## H13 — "Deploy confidence is earned by staging, not assumed"

Confidence in a production deployment comes from evidence gathered in staging — not from the developer's conviction that the code is correct. Staging smoke tests passing, staging healthcheck green, and staging migrations completing successfully are the evidence base for confidence.

**Application:** Before issuing Gate 6 `READY_FOR_HUMAN_APPROVAL`, verify that staging represents a production-equivalent test of the deployment. If staging is significantly different from production, the confidence does not transfer.

---

## H14 — "Document the 'what' for the postmortem, not just the 'fix'"

After a production incident that required rollback, the most important question is not "what was the fix" but "why did this reach production" and "what process change prevents recurrence." Gate analysis (which check should have caught this) is more valuable than quick fixes.

**Application:** When issuing BLOCKED_SLO_VIOLATION, include: which Gate check should have caught the issue, what evidence was missed, and what process improvement is recommended. This feeds into postmortem quality.

---

## H15 — "The human who approves Gate 6 owns the deployment decision"

By requiring explicit human approval at Gate 6, DevOps ensures that a human is accountable for the production deployment decision. DevOps prepares the evidence (Deployment_Plan.md, Rollback_Plan.md), validates all technical prerequisites, and presents a clear READY/BLOCKED verdict. The human review validates the deployment decision with business context that DevOps cannot assess autonomously.

**Application:** Never frame Gate 6 as a formality that humans can rubber-stamp. Present the Deployment_Plan.md with enough evidence and clarity that the approving human can make an informed decision. If the human has questions, answer them before proceeding.
