# Security Requirements Checklist
## Agente03 Software Engineer / Task Planner
## Version: 1.0.0

Run this checklist on every task before including it in Execution_Plan.json.
Security is baked in, not bolted on. Rule: P6. Apply decision rules DR007–DR012.

---

## Task-Level Checks

### 1. Every Task Has security_requirements Defined
- [ ] The task object contains a `security_requirements` field
- [ ] `security_requirements` has at minimum: `auth_required`, `authorization_check`, `input_validation_required`, `audit_log_required`
- [ ] Fields are explicitly set (true or false) — not omitted

_Failure: Add security_requirements to every task. Gate 3 blocks on missing security requirements for sensitive tasks._

### 2. All API Route Tasks Have auth_required Assessed
- [ ] Every `backend` task that is an API Route Handler: `auth_required` is set
- [ ] Every `backend` task that is a Server Action: `auth_required` is set
- [ ] If `auth_required: false`: task is documented as intentionally public in `security_notes`

_Rule: No endpoint is public by default. Absence of `auth_required: false` + justification is a security gap._

### 3. All Mutation Tasks Have audit_log_required Assessed
- [ ] Every task that creates, updates, or deletes data: `audit_log_required` is assessed
- [ ] Every task that modifies user permissions or roles: `audit_log_required: true`
- [ ] Every task that performs financial or security-sensitive operations: `audit_log_required: true`
- [ ] When `audit_log_required: true`: `audit_event_type` is specified (e.g., `"task.created"`)

_Rule: DR008 — all sensitive data mutations must be audited._

### 4. All User Input Tasks Have input_validation_required: true
- [ ] Every task that accepts user-submitted data: `input_validation_required: true`
- [ ] This includes: form submissions, API request bodies, query parameters used in business logic
- [ ] When `input_validation_required: true`: `zod_schema_name` is specified

_Rule: DR007 — Zod validation at every system boundary, no exceptions._

### 5. All Public Endpoints Documented as Intentionally Public
- [ ] Every task with `auth_required: false` has an explanation in `security_notes` stating why it is public
- [ ] Public endpoints are limited to: health checks, webhooks with their own auth, public landing pages
- [ ] No data endpoint is public without explicit justification

### 6. Zod Schema Specified for Input Validation Tasks
- [ ] For every task with `input_validation_required: true`: `zod_schema_name` is filled in
- [ ] The Zod schema name follows PascalCase convention (e.g., `CreateTaskSchema`)
- [ ] The Zod schema is either: already defined in a prior task, or a new schema task is created

### 7. devsecops_review_required Set for High-Risk Tasks
- [ ] Tasks involving authentication setup: `devsecops_review_required: true`
- [ ] Tasks with identified SQL injection risk: `devsecops_review_required: true`
- [ ] Tasks involving encryption or cryptographic operations: `devsecops_review_required: true`
- [ ] Tasks touching payment or PII data: `devsecops_review_required: true`

### 8. Cron Handler Tasks Include guardCron()
- [ ] Every task implementing a Vercel Cron handler: `cron_guard_required: true`
- [ ] `security_notes` specifies that `guardCron()` must be the first call in the handler body
- [ ] Cron handler task has `auth_required: false` (Vercel internal) but `cron_guard_required: true`

_Rule: DR012 — `guardCron()` must be the first call in every cron handler. No exceptions._

### 9. XSS and CSRF Risks Assessed for Frontend Tasks
- [ ] Every `frontend` task that renders user-supplied content: `xss_risk` is assessed
- [ ] Every frontend form task: `csrf_risk` is assessed (Next.js Server Actions have built-in CSRF, note it)
- [ ] If `xss_risk: true`: `security_notes` explains sanitization approach

### 10. SQL Injection Risk Assessed for Database Tasks
- [ ] Tasks that use Prisma raw queries: `sql_injection_risk` is assessed
- [ ] All Prisma raw query tasks: `sql_injection_risk: true` with parameterization noted in `security_notes`
- [ ] Standard Prisma ORM queries (no raw): `sql_injection_risk: false`

---

## Plan-Level Checks

### 11. Authorization Level Consistent Across Plan
- [ ] Tasks in the same feature area have consistent `authorization_level`
- [ ] No task has a more permissive authorization_level than its parent route

### 12. All Security Tasks in the Plan
- [ ] If NextAuth configuration is required, a `security` type task exists for it
- [ ] If role-based access control is required, tasks for RBAC setup exist

---

## Runtime Knowledge Policy

This checklist is executed using only local artifacts:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P6)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` (DR007–DR012)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card009, Card010)
- `Agente03_SoftwareEngineer/context_view.md` (Golden Path security requirements)

Never reads: `context/`, `lib/`, `*.pdf`

---

## Result

- **PASS:** All items checked → Security requirements are complete for all tasks
- **FAIL (BLOCKING):** Sensitive task without `input_validation_required: true` or `audit_log_required: true` → Fix before Gate 3
- **FAIL (ADVISORY):** Missing `devsecops_review_required` on high-risk tasks → Review and set before handoff
