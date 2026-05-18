# Bad Deployment Plan Example

This example demonstrates an incomplete, dangerous Deployment_Plan.md that incorrectly issues `APPROVED` (bypassing human approval) and is missing critical sections. Do NOT produce plans like this.

---

# Deployment Plan
## Gate 6 Status: APPROVED ❌ WRONG — should be READY_FOR_HUMAN_APPROVAL at most

> **Status Rationale:** Everything looks good. Let's deploy!

**Project:** Dashboard App
**Feature/Release:** Dashboard update
**Target Environment:** Production
**Planned Deploy Date:** ASAP
**Prepared by:** Agente08_DevOps v1.0.0

---

## Pre-Deploy Checklist

- [x] Gate 5 Security approved (I think)
- [x] CI passing (should be fine)
- [x] Ready to deploy

---

## Deployment Steps

1. Deploy to Vercel

---

## Environment Variables

No changes.

---

## Database Migrations

We have a migration to run. It should be fine.

---

## Rollback Plan

TBD — we'll figure it out if something goes wrong.

---

## Human Approval

Not needed, it's a small change.

---

**WHAT IS WRONG WITH THIS EXAMPLE (do not make these mistakes):**

1. **Gate 6 status is `APPROVED`** — this is not a valid Gate 6 status code. Gate 6 status must be `READY_FOR_HUMAN_APPROVAL` when all checks pass. `APPROVED` is a Gate 7 status. DevOps never auto-approves deployment.

2. **Missing prerequisite gate verification** — "I think" is not evidence. Security_Audit.md and QA_Report.md must be explicitly confirmed with their gate decisions.

3. **No CI pipeline evidence** — "should be fine" is not verification. The specific GitHub Actions run number and commit SHA must be referenced.

4. **No environment variable validation** — "No changes" does not confirm all existing variables are present and valid in production.

5. **No migration details** — "We have a migration to run. It should be fine." tells us nothing about what the migration does, whether it's destructive, how long it will take, or what the rollback strategy is.

6. **Rollback plan is `TBD`** — this triggers DR001: `BLOCKED_NO_ROLLBACK_PLAN`. A deployment plan with "TBD" rollback is not deployable. Gate 6 must issue `BLOCKED_NO_ROLLBACK_PLAN`.

7. **No smoke test mention** — there is no evidence that staging smoke tests were run or passing.

8. **No healthcheck mention** — there is no monitoring plan defined.

9. **No observability confirmation** — structured logs, error tracking, and uptime monitoring are not mentioned.

10. **"Not needed" for human approval** — human approval at Gate 6 is MANDATORY, non-negotiable, and cannot be waived for any reason, including "it's a small change."

11. **Deployment steps are inadequate** — "Deploy to Vercel" is not a deployment plan. Steps must include: migration execution, specific verification commands, healthcheck monitoring plan, and smoke test execution.

**Correct action:** Do not issue Gate 6 status based on this document. Invoke `rollback-planning-skill` (produces Rollback_Plan.md), `environment-validation-skill` (verifies env vars), `migration-deploy-skill` (documents migration), run all Gate 6 checklist sections, then reissue with complete evidence.
