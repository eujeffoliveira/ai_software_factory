# Tollgate Checklist

Run this checklist before issuing any gate decision.

---

## Pre-Gate Checklist (All Gates)

- [ ] Artifact validation was completed using `artifact_validation_checklist.md`
- [ ] Handoff Package is present and valid
- [ ] State Ledger reflects the current phase
- [ ] No pending human approvals are blocking this gate
- [ ] No active CRITICAL blockers from previous phases

---

## Gate 1 — PRD Approval

- [ ] PRD.md exists
- [ ] User stories have INVEST format
- [ ] Acceptance criteria are in BDD/Gherkin format
- [ ] Functional requirements are listed
- [ ] Non-functional requirements are listed
- [ ] Out-of-scope is defined
- [ ] No technology choices in PRD
- [ ] Handoff Package complete

**Issue Gate 1 decision →**

---

## Gate 2 — Architecture Approval

- [ ] Architecture.md exists
- [ ] API_Contract.json exists
- [ ] DB Schema exists
- [ ] Golden Model compliance verified (Next.js 16, proxy.ts, Prisma 7, Vercel, NextAuth v5)
- [ ] All deviations have ADR
- [ ] Security strategy defined
- [ ] Observability strategy defined
- [ ] Deployment strategy defined
- [ ] Risks identified
- [ ] Consider Council activation for complex or high-risk architecture
- [ ] Handoff Package complete

**Issue Gate 2 decision →**

---

## Gate 3 — Execution Plan Approval

- [ ] Execution_Plan.json exists
- [ ] All tasks have unique IDs
- [ ] All tasks are atomic
- [ ] Dependencies mapped correctly
- [ ] Files specified per task
- [ ] Acceptance criteria per task
- [ ] Security requirements per relevant task
- [ ] Test requirements per task
- [ ] No oversized tasks
- [ ] Handoff Package complete

**Issue Gate 3 decision →**

---

## Gate 4 — QA Review

- [ ] QA_Report.md exists
- [ ] Status is explicitly stated
- [ ] All acceptance criteria evaluated
- [ ] Typecheck reported
- [ ] Lint reported
- [ ] Tests reported
- [ ] Failures classified with severity
- [ ] Handoff Package complete

**Issue Gate 4 decision →**

---

## Gate 5 — Security Review

- [ ] Security_Audit.md exists
- [ ] Status is explicitly stated
- [ ] OWASP Top 10 reviewed
- [ ] Data protection compliance reviewed
- [ ] Secrets verified
- [ ] Authorization verified
- [ ] Logs privacy verified
- [ ] Findings listed with severity and remediation
- [ ] Handoff Package complete
- [ ] If BLOCKED: human escalation prepared

**Issue Gate 5 decision →**

---

## Gate 6 — Deployment Approval

- [ ] Deployment_Plan.md exists
- [ ] Rollback_Plan.md exists (mandatory)
- [ ] Environment variables validated
- [ ] Migration plan defined
- [ ] Healthcheck endpoint confirmed
- [ ] Smoke tests defined
- [ ] Human approval obtained for production
- [ ] Secrets not reused between environments

**Issue Gate 6 decision →**

---

## Gate 7 — Post-Deploy Validation

- [ ] Post_Deploy_Report.md exists
- [ ] /api/health is healthy
- [ ] Critical flows validated
- [ ] Logs checked
- [ ] APM checked when available
- [ ] Migration success confirmed

**Issue Gate 7 decision →**

---

## Post-Gate Checklist (All Gates)

- [ ] Gate decision documented in `Gate_Decision.md`
- [ ] State Ledger updated (phase, agent, artifacts, gate_history)
- [ ] Risks from this gate registered in State Ledger
- [ ] Next agent briefed or human escalation sent
