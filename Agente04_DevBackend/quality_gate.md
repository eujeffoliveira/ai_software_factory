# Agente04_DevBackend — Quality Gate 4 (QA Review)

## Gate Overview

| Field | Value |
|-------|-------|
| Gate number | 4 |
| Gate name | QA Review |
| Dev Backend role | **Submitter** |
| Evaluator | Agente06_QaEngineer |
| Prerequisite | Gate 3 approved (Execution Plan) |
| Output to next | Handoff Package for Agente06_QaEngineer |

---

## Entry Criteria (for submission)

Before submitting to Gate 4, ALL of the following must be true:

1. Gate 3 approved — Execution Plan with atomic tasks delivered by Agente03_SoftwareEngineer
2. Atomic task completed — all acceptance criteria addressed
3. `Backend_Implementation_Report.md` produced and complete
4. Self-review checklist run and all items checked
5. Test files created (minimum 4 tests per Server Action / Route Handler)
6. No open blocking issues in the Handoff Package (`blocking: true` questions must be escalated before submission)
7. `gate_ready: true` in the Handoff Package

---

## What Dev Backend Must Prepare Before Gate 4 Submission

### 1. Source Code Files
All files listed in the task block must be created or modified:
- Server Actions at `features/[domain]/actions/[name].ts`
- Route Handlers at `app/api/[resource]/route.ts`
- DAL functions at `lib/db/[model].dal.ts`
- Zod schemas at `features/[domain]/schemas/[entity].schema.ts`
- Cron routes at `app/api/cron/[job-name]/route.ts`
- Job logic at `lib/jobs/[job-name].ts`
- Integration clients at `lib/integrations/[service].client.ts`

### 2. Test Files
For every Server Action and Route Handler:
- Test file at `[source-path]/[file].test.ts` or `__tests__/[file].test.ts`
- Minimum 4 test cases per function

### 3. Backend_Implementation_Report.md
Complete report using `templates/Backend_Implementation_Report.md`:
- Task summary
- Files created (with paths and line counts)
- Files modified (with change summary)
- Zod schemas table
- Auth checks table
- Audit log entries table
- Sync log entries table (for cron tasks)
- Test coverage summary
- Self-review checklist (all items checked)
- Open issues (none blocking)
- Gate readiness confirmation

### 4. Handoff Package JSON
Conforms to `handoff_schema.json`:
- `required_next_agent: "Agente06_QaEngineer"`
- `gate_ready: true`
- `validation_checklist` fully populated

---

## Self-Review Checklist (Run Before Submitting)

Run `checklists/backend_quality_checklist.md` in full. Key items:

### Code Structure
- [ ] No business logic in any `route.ts` file
- [ ] All route handlers are ≤ 30 lines
- [ ] Business logic is in `features/[domain]/` — Server Actions or services
- [ ] All DAL functions are in `lib/db/[model].dal.ts`
- [ ] No direct `prisma.*` calls in `features/` or `app/api/`

### Validation
- [ ] Zod schema present at every input boundary
- [ ] Schemas defined at module level (not inline)
- [ ] `.parse()` used in Server Actions
- [ ] `.safeParse()` used in Route Handlers
- [ ] Env vars accessed only via `lib/env.ts`

### Authentication and Authorization
- [ ] `await auth()` is the first call in every Server Action
- [ ] `await auth()` is the first call in every Route Handler
- [ ] 401 returned immediately when session is null
- [ ] Resource ownership verified (IDOR prevention)
- [ ] 403 returned when user is authenticated but not authorized

### Security
- [ ] No `process.env.*` outside `lib/env.ts`
- [ ] No raw SQL string concatenation
- [ ] No `prisma.$queryRaw` with template literal interpolation
- [ ] No `error.message` or stack trace in API responses
- [ ] Generic error messages returned to client

### Logging
- [ ] `auditLog()` called after every sensitive human action (CREATE/UPDATE/DELETE)
- [ ] `actorId` and `actorEmail` sourced from session (not request body)
- [ ] Action verbs in PAST_TENSE_VERB format
- [ ] `syncLog()` in `finally` block of every cron route
- [ ] `guardCron(req)` is the first call in every cron route

### Tests
- [ ] Test file created for every Server Action
- [ ] Test file created for every Route Handler
- [ ] Null session test present
- [ ] Invalid input test present
- [ ] Success path test present
- [ ] Error path test present

### Migrations
- [ ] `prisma migrate dev` used for new schema changes (not `prisma db push`)
- [ ] Migration files committed

---

## Status Codes for Returns from Gate 4

| Code | Meaning | Dev Backend Action |
|------|---------|---------------------|
| `APPROVED` | All checks passed | Pipeline advances to Agente06_QaEngineer |
| `RETURNED_FOR_REVISION` | Code quality issues found | Fix the code issues cited, re-run self-review, resubmit |
| `BLOCKED_MISSING_TESTS` | Test files absent or insufficient | Create/complete test files, resubmit |
| `BLOCKED_SECURITY_VIOLATION` | Security issue found (auth, injection, leak) | Resolve the specific violation, escalate if unclear |

**Important:** `BLOCKED_SECURITY_VIOLATION` returns require Tech Lead notification before resubmitting. The QA Engineer's security findings cannot be overridden by the Dev Backend.

---

## When to Escalate BEFORE Submitting to Gate 4

Do not submit to Gate 4 if any of the following are unresolved:

| Situation | Action |
|-----------|--------|
| API contract is missing or inconsistent | Escalate to Agente00_TechLead |
| DB schema insufficient for the task | Escalate to Agente00_TechLead |
| Authorization requirements ambiguous | Escalate to Agente00_TechLead |
| New npm package needed | Escalate to Agente00_TechLead |
| Task requires architectural change | Escalate to Agente00_TechLead |
| Risk of data loss from migration | Escalate to Agente00_TechLead |
| External integration needs new secret/key | Escalate to Agente00_TechLead |
| Business rules incomplete or contradictory | Escalate to Agente00_TechLead |

Submitting with unresolved blockers results in `RETURNED_FOR_REVISION` and wastes the QA Engineer's review cycle.

---

## Gate 4 Evaluation Scope (What QA Reviews)

The QA Engineer will check:
1. All acceptance criteria from the task block are addressed
2. Code follows Golden Path patterns (thin handlers, DAL, auth)
3. Zod validation present at all inputs
4. Tests cover the required scenarios
5. No security violations (SQL injection, missing auth, exposed internals)
6. Structured logs present where required
7. `Backend_Implementation_Report.md` is complete and accurate

The Dev Backend does not evaluate Gate 4 — only submits to it.
