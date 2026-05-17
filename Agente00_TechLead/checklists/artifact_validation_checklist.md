# Artifact Validation Checklist

Use before every gate decision. Check each item for the relevant artifact.

---

## PRD.md (Gate 1)

- [ ] File `PRD.md` exists and is non-empty
- [ ] Problem statement is defined
- [ ] User stories follow INVEST format (Independent, Negotiable, Valuable, Estimable, Small, Testable)
- [ ] Each user story has BDD/Gherkin acceptance criteria (Given/When/Then)
- [ ] Functional requirements are explicitly listed
- [ ] Non-functional requirements are explicitly listed (performance, security, scalability, accessibility)
- [ ] Out-of-scope items are explicitly stated
- [ ] Open questions are registered (or confirmed as none)
- [ ] No technology choices embedded (no databases, frameworks, libraries)
- [ ] No implementation assumptions embedded
- [ ] Handoff Package is present and complete

**Gate 1 can proceed:** All items checked ✅

---

## Architecture.md + API_Contract.json + DB_Schema (Gate 2)

### Architecture.md
- [ ] Architecture document exists and is non-empty
- [ ] System components are defined with clear responsibilities
- [ ] Follows Golden Model: Next.js 16 + App Router + proxy.ts
- [ ] Uses React 19, TypeScript 5 strict
- [ ] Database: PostgreSQL via Supabase + Prisma 7
- [ ] Deploy: Vercel + Vercel Cron
- [ ] Auth: NextAuth v5 + Google OAuth
- [ ] Any Golden Path deviation has a corresponding ADR
- [ ] Security strategy is defined (auth layers, authorization model, LGPD classification)
- [ ] Observability strategy is defined (logs, audit_log, sync_log)
- [ ] Testing strategy is defined (Vitest, Playwright scoping)
- [ ] Deployment strategy is defined (CI/CD, migrations, environments)
- [ ] Technical risks are identified

### API_Contract.json
- [ ] API contract file exists
- [ ] All endpoints are listed with HTTP methods
- [ ] Request schemas are defined
- [ ] Response schemas are defined (including error responses)
- [ ] Authentication requirements are specified per endpoint
- [ ] Authorization requirements are specified per endpoint

### DB_Schema
- [ ] Schema file exists (`.sql` or `.prisma`)
- [ ] Prisma model names use camelCase
- [ ] DB column names use snake_case via `@map()`
- [ ] Table names use snake_case via `@@map()`
- [ ] Primary keys and foreign keys are defined
- [ ] Indexes for common queries are proposed

### Handoff Package
- [ ] Present and complete

**Gate 2 can proceed:** All items checked ✅

---

## Execution_Plan.json (Gate 3)

- [ ] File `Execution_Plan.json` exists and is non-empty
- [ ] Every task has a unique ID
- [ ] Every task is atomic (single responsibility, single file or function scope)
- [ ] Task descriptions are clear and unambiguous
- [ ] Dependencies between tasks are explicitly mapped
- [ ] Execution order is defined and respects dependencies
- [ ] Files to create or edit are specified per task
- [ ] Acceptance criteria are associated with each task
- [ ] Security requirements are associated with security-relevant tasks
- [ ] Test requirements are associated with each task
- [ ] No task spans multiple domains (backend + frontend in one task without explicit reasoning)
- [ ] Handoff Package is present and complete

**Gate 3 can proceed:** All items checked ✅

---

## QA_Report.md (Gate 4)

- [ ] File `QA_Report.md` exists and is non-empty
- [ ] Status is explicitly declared: PASS / FAIL_FIX_REQUIRED / FAIL_BLOCKING
- [ ] All acceptance criteria from PRD were evaluated
- [ ] Typecheck result is reported
- [ ] Lint result is reported
- [ ] Test execution results are reported (passed, failed, skipped)
- [ ] Each failure is classified with severity
- [ ] Specific code locations are cited for failures
- [ ] Handoff Package is present and complete

**Gate 4 can proceed:** Status = PASS ✅

---

## Security_Audit.md (Gate 5)

- [ ] File `Security_Audit.md` exists and is non-empty
- [ ] Status is explicitly declared
- [ ] OWASP Top 10 review was performed and documented
- [ ] Data protection compliance (LGPD/GDPR) assessment was performed
- [ ] Secrets and credentials verified (no hardcoding detected)
- [ ] Server-side authorization verified
- [ ] Sensitive data in logs verified (no PII in plain text)
- [ ] Critical dependencies assessed for CVEs when applicable
- [ ] Specific findings listed with severity
- [ ] Remediation guidance provided for each finding
- [ ] Handoff Package is present and complete

**Gate 5 can proceed:** Status = APPROVED or APPROVED_WITH_WARNINGS ✅

---

## Deployment_Plan.md + Rollback_Plan.md (Gate 6)

### Deployment_Plan.md
- [ ] Deployment plan exists and is non-empty
- [ ] Target environment is specified
- [ ] Pre-deploy checklist is defined
- [ ] Migration plan is defined (reversible / compatible / irreversible / destructive)
- [ ] CI/CD pipeline steps are documented
- [ ] Environment variables are listed and validated
- [ ] `/api/health` healthcheck endpoint exists

### Rollback_Plan.md
- [ ] **Rollback plan exists** (mandatory — gate blocks without it)
- [ ] Rollback conditions are defined
- [ ] Rollback steps are documented
- [ ] Responsible person/agent is identified
- [ ] Database impact of rollback is assessed
- [ ] Post-rollback validation steps are defined
- [ ] Communication plan is included

### Approvals
- [ ] Human approval obtained for production deployment

**Gate 6 can proceed:** All items checked + Human approval received ✅

---

## Post_Deploy_Report.md (Gate 7)

- [ ] File `Post_Deploy_Report.md` exists
- [ ] `/api/health` status reported as healthy
- [ ] Critical user flows validated (login, main screen)
- [ ] Error logs checked for first 15 minutes (or relevant window)
- [ ] APM metrics checked when available
- [ ] Migration execution result reported
- [ ] Smoke test results reported
- [ ] Explicit status declared: DEPLOY_HEALTHY / DEPLOY_DEGRADED / ROLLBACK_REQUIRED / INCIDENT_OPENED

**Gate 7 can proceed:** Status = DEPLOY_HEALTHY ✅
