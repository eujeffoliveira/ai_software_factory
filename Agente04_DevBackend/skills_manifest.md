# Agente04_DevBackend — Skills Manifest

This document indexes all 11 authorized skills for the Dev Backend agent. Each entry documents purpose, trigger conditions, inputs, outputs, key failure modes, Gate 4 quality reference, permitted RAG collections, and architecture compliance notes.

---

## Skill Index

| # | Skill ID | Type | Gate Relevance |
|---|----------|------|----------------|
| 1 | nextjs-server-action-skill | Implementation | Primary — most tasks use this |
| 2 | nextjs-route-handler-skill | Implementation | For REST endpoints |
| 3 | prisma-dal-skill | Data Access | Required when DB is involved |
| 4 | zod-validation-skill | Validation | Required at every input boundary |
| 5 | cron-job-implementation-skill | Scheduled Jobs | For automated/scheduled tasks |
| 6 | structured-logging-skill | Observability | For error boundaries and key operations |
| 7 | audit-log-implementation-skill | Compliance | For every sensitive human action |
| 8 | sync-log-implementation-skill | Observability | For every cron job |
| 9 | backend-test-generation-skill | Quality | Required — tests are part of Definition of Done |
| 10 | external-integration-client-skill | Integration | For third-party API clients |
| 11 | sql-safety-review-skill | Security | Run before every Gate 4 submission |

---

## Skill 1: nextjs-server-action-skill

**Purpose:** Implements a Server Action following the Golden Path pattern — `"use server"`, Zod validation, auth check first, DAL call, audit_log, typed return.

**When to Use:**
- Any mutation triggered from a Server Component or Client Component (create, update, delete, approve, etc.)
- When the operation requires authentication and belongs to a feature domain

**Inputs:**
- Atomic task spec (function_signatures, acceptance_criteria, security_requirements)
- Zod schema field definitions from API contract
- DAL reference for the relevant Prisma model

**Outputs:**
- TypeScript file at `features/[domain]/actions/[actionName].ts`
- Function exported as named async function with typed input and output

**Key Failure Modes:**
- Missing `"use server"` directive (file not treated as Server Action)
- Auth check placed after input parsing (FM-03)
- Direct `prisma.*` call instead of DAL (FM-02 variant)
- `auditLog()` missing for sensitive mutations (FM-07)

**Quality Gate Reference:** Gate 4 — `checklists/backend_quality_checklist.md`, `checklists/authz_checklist.md`, `checklists/audit_log_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `nodejs_patterns`, `clean_code`

**Architecture Compliance:**
- File MUST be in `features/[domain]/actions/`
- MUST have `"use server"` as first line
- MUST call `await auth()` before any other logic
- MUST use DAL — no direct `prisma` import
- MUST call `auditLog()` for CREATE, UPDATE, DELETE operations

---

## Skill 2: nextjs-route-handler-skill

**Purpose:** Implements a thin Route Handler at `app/api/[resource]/route.ts`. Route handlers authenticate, parse, delegate to features/, and return the response. Nothing more.

**When to Use:**
- External webhooks that need HTTP endpoints
- REST APIs consumed by non-Next.js clients
- Cron trigger endpoints (use cron-job-implementation-skill instead for full cron jobs)
- Mobile app or third-party consumer needs a REST endpoint

**Inputs:**
- Route spec from `API_Contract.json` (path, method, auth_required, request/response schemas)
- Reference to the `features/` service function to delegate to

**Outputs:**
- TypeScript file at `app/api/[resource]/route.ts`
- Maximum ~30 lines of code

**Key Failure Modes:**
- Business logic inline in route.ts (FM-01) — symptom: route.ts > 30 lines
- Missing auth check (FM-03)
- Raw `req.json()` without Zod (FM-02)
- Direct `prisma.*` import in route.ts (violation of DAL principle)

**Quality Gate Reference:** Gate 4 — `checklists/backend_quality_checklist.md`, `checklists/authz_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `api_design`

**Architecture Compliance:**
- File MUST be in `app/api/[resource]/route.ts`
- MUST NOT import `prisma` directly
- MUST NOT contain business logic beyond auth+parse+delegate+respond
- Target ≤ 30 lines; if longer, extract to features/

---

## Skill 3: prisma-dal-skill

**Purpose:** Implements the Data Access Layer for a Prisma model. All database operations for a model live in `lib/db/[model].dal.ts` and are exported as a named const object.

**When to Use:**
- Any task that creates or modifies a Prisma model's CRUD operations
- When a new entity is added to the schema
- When adding a new query type (findByExternalId, findManyWithFilter, etc.)

**Inputs:**
- Prisma model name from `prisma/schema.prisma`
- List of required operations (findById, findMany, create, update, delete, upsert, etc.)
- Any custom query requirements from the task spec

**Outputs:**
- TypeScript file at `lib/db/[model].dal.ts`
- Named const export `[model]Dal` with typed methods

**Key Failure Modes:**
- Raw SQL with string concatenation (FM-05) — SQL injection risk
- `prisma.$queryRaw` with template literal interpolation (FM-13)
- Missing `upsert` method (makes job idempotency impossible — FM-12)
- No TypeScript types (runtime errors instead of compile-time errors)

**Quality Gate Reference:** Gate 4 — `checklists/sql_safety_checklist.md`, `checklists/backend_quality_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `data_intensive_applications`

**Architecture Compliance:**
- File MUST be in `lib/db/[model].dal.ts`
- MUST import from `@/lib/db/prisma` only
- MUST NOT use raw SQL string concatenation
- MUST export as named const object (not default export, not individual functions)

---

## Skill 4: zod-validation-skill

**Purpose:** Creates Zod validation schemas for a feature's input boundaries — Create, Update, Query, and ID schemas with TypeScript type inference.

**When to Use:**
- Before implementing any Server Action or Route Handler that receives external data
- When adding a new entity to the system
- When the API contract defines new request schemas

**Inputs:**
- Entity name and field definitions from task spec or `API_Contract.json`
- Constraints: min/max lengths, required fields, optional fields, enums, formats

**Outputs:**
- TypeScript file at `features/[domain]/schemas/[entity].schema.ts`
- Exported schemas and inferred TypeScript types

**Key Failure Modes:**
- Schemas defined inline (inside function body) — not reusable or testable (FM-02)
- Missing type inference (`z.infer<typeof Schema>`) — loses TypeScript benefits
- Constraints too loose (no min/max) — allows invalid data
- Env var schema not in `lib/env.ts` — scattered process.env access (FM-04)

**Quality Gate Reference:** Gate 4 — `checklists/zod_validation_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `nodejs_patterns`

**Architecture Compliance:**
- Schema files MUST be at module level (not inline in functions)
- Types MUST be inferred with `z.infer<typeof Schema>`
- Env var schema MUST be in `lib/env.ts`
- Constraints MUST match `API_Contract.json` specifications

---

## Skill 5: cron-job-implementation-skill

**Purpose:** Implements a complete Vercel Cron job — route handler with `guardCron()`, job function in `lib/jobs/`, `syncLog()` in finally, and idempotency mechanism.

**When to Use:**
- Any scheduled or automated background job
- Data synchronization tasks (importing from external sources)
- Cleanup jobs (deleting expired records)
- Notification dispatch jobs

**Inputs:**
- Job spec: name, schedule (cron expression), operations to perform, idempotency strategy
- Vercel Cron configuration requirements

**Outputs:**
- Route file at `app/api/cron/[job-name]/route.ts`
- Job logic file at `lib/jobs/[job-name].ts`
- `vercel.json` cron entry (or note to add it)

**Key Failure Modes:**
- `guardCron()` not first call (FM-09) — route not protected
- `syncLog()` only on success path, not in finally (FM-08) — missed failure records
- Non-idempotent job — creates duplicates on retry (FM-12)
- External API called inside transaction (FM-11)

**Quality Gate Reference:** Gate 4 — `checklists/cron_idempotency_checklist.md`, `checklists/sync_log_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `data_intensive_applications`

**Architecture Compliance:**
- Route MUST be at `app/api/cron/[job-name]/route.ts`
- `guardCron(req)` MUST be the absolute first statement
- `syncLog()` MUST be in the `finally` block
- Job function MUST be idempotent (upsert or existence check)
- `export const dynamic = "force-dynamic"` required

---

## Skill 6: structured-logging-skill

**Purpose:** Adds structured JSON logging to backend operations — error boundaries, significant state transitions, and performance-sensitive paths.

**When to Use:**
- Adding error handling to any backend function
- Logging significant operations for operational visibility
- Any place where `console.log` or `console.error` is needed

**Inputs:**
- Operation name/location identifier
- Log level (error, warn, info)
- Context fields to include (userId, entityId, operation-specific data)

**Outputs:**
- `console.error("[location] description:", { structured, context, object })` calls
- Never string concatenation — always structured object

**Key Failure Modes:**
- String concatenation in log messages (`"Error: " + error.message`) — not parseable by log aggregators
- Sensitive data logged (passwords, tokens, full error stack in production)
- Missing context fields — log is not debuggable
- Location identifier missing — log is not traceable

**Quality Gate Reference:** Gate 4 — `checklists/backend_quality_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `nodejs_patterns`

**Architecture Compliance:**
- Always use structured object: `console.error("[location]:", { error, ...context })`
- Never: `console.log("Error: " + error.message)`
- Sensitive data (passwords, tokens, PII beyond audited fields) must not be logged
- Location prefix identifies the file and function for tracing

---

## Skill 7: audit-log-implementation-skill

**Purpose:** Adds `auditLog()` calls for sensitive human actions — any Server Action that creates, updates, or deletes data on behalf of a user.

**When to Use:**
- Any Server Action that creates a record
- Any Server Action that updates sensitive data
- Any Server Action that deletes a record
- Any Server Action that approves, rejects, or changes status of a record

**Inputs:**
- Action verb (past tense: CREATED, UPDATED, DELETED, APPROVED, REJECTED)
- Entity type (Prisma model name)
- Trigger location (file path + function name)
- Metadata fields to include

**Outputs:**
- `auditLog({ actorId, actorEmail, action, entityType, entityId, metadata })` call after the successful operation

**Key Failure Modes:**
- Called before the operation (FM-07 variant) — if operation fails, audit is false
- `actorId` from request body instead of session — can be spoofed
- Action not in PAST_TENSE_VERB format — inconsistent audit trail
- Missing for a DELETE operation — unauditable data loss
- PII in metadata that shouldn't be there (passwords, tokens)

**Quality Gate Reference:** Gate 4 — `checklists/audit_log_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `architecture_reference_backend_view`

**Architecture Compliance:**
- MUST be called AFTER the successful DB operation
- actorId and actorEmail MUST come from `session` (not request body)
- action MUST be PAST_TENSE_VERB in SCREAMING_SNAKE_CASE
- Required for ALL CREATE/UPDATE/DELETE operations on user data

---

## Skill 8: sync-log-implementation-skill

**Purpose:** Adds `syncLog()` calls for automated job executions — every cron route must record its execution, status, duration, and counts.

**When to Use:**
- Every cron route handler
- Every background job that processes data in bulk
- Any automated synchronization function

**Inputs:**
- Job name (must match `vercel.json` cron key)
- Counts to track (records processed, created, updated, failed)

**Outputs:**
- `syncLog({ job, executedAt, durationMs, status, counts, errorMsg })` call in `finally` block

**Key Failure Modes:**
- `syncLog()` only in success path — failures not recorded (FM-08)
- `durationMs` computed from after the job (wrong value)
- `status` hardcoded as "success" — never reflects errors
- `counts` empty object — job execution not trackable
- `errorMsg` populated on success (confusing logs)

**Quality Gate Reference:** Gate 4 — `checklists/sync_log_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `architecture_reference_backend_view`

**Architecture Compliance:**
- MUST be in `finally` block (not just success path)
- `startedAt = Date.now()` MUST be captured before job starts
- `status` MUST reflect actual outcome (success/error/partial)
- `errorMsg` MUST be `undefined` when status is "success"

---

## Skill 9: backend-test-generation-skill

**Purpose:** Generates Vitest unit tests for Server Actions, Route Handlers, and DAL functions. Minimum 4 test cases per function.

**When to Use:**
- After implementing any Server Action
- After implementing any Route Handler
- After implementing complex DAL functions
- As part of the Definition of Done for every task

**Inputs:**
- Function under test (name, file path, behavior)
- Mock dependencies (auth, DAL, external clients)
- Test cases required (from acceptance criteria)

**Outputs:**
- Vitest test file at `[same-path]/[file].test.ts` or `__tests__/[file].test.ts`
- Minimum 4 test cases: unauthenticated, invalid input, success path, error path

**Key Failure Modes:**
- Only happy-path test — fails to catch auth and validation bugs
- No mocks — tests hit real DB and external APIs (slow, brittle)
- No auth null test — auth bypass bugs go undetected
- Test descriptions don't explain the scenario
- `console.error` assertions instead of behavior assertions

**Quality Gate Reference:** Gate 4 — `checklists/backend_test_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `nodejs_patterns`

**Architecture Compliance:**
- MUST use Vitest (`describe`, `it`, `expect`, `vi`)
- MUST mock `@/lib/auth` for auth scenarios
- MUST mock DAL modules (unit tests — no real DB)
- MUST cover: null session, invalid input, success, error
- Minimum 4 test cases per Server Action

---

## Skill 10: external-integration-client-skill

**Purpose:** Implements a typed client for a third-party external API — credentials from `lib/env.ts`, response validation with Zod, timeout configured, never called inside transactions.

**When to Use:**
- Any task that integrates with a third-party API (email, SMS, payment, data provider, etc.)
- When a new external service needs to be accessed from backend code

**Inputs:**
- API spec: service name, base URL env var, auth method, endpoints to implement
- Response shape definitions

**Outputs:**
- TypeScript file at `lib/integrations/[service].client.ts`
- Exported named const object with typed methods

**Key Failure Modes:**
- API key hardcoded in source (FM-04 variant) — security violation
- No timeout — requests can hang indefinitely
- Response not validated with Zod — runtime type errors
- Called inside `prisma.$transaction` (FM-11) — blocks transaction
- No error types defined — callers can't handle specific failures

**Quality Gate Reference:** Gate 4 — `checklists/backend_quality_checklist.md`, `checklists/sql_safety_checklist.md` (for data safety)

**RAG Collections Permitted:** `backend_engineering`, `api_design`, `nodejs_patterns`

**Architecture Compliance:**
- File MUST be in `lib/integrations/[service].client.ts`
- Credentials MUST come from `lib/env.ts` — never hardcoded
- Responses MUST be validated with Zod
- Timeout MUST be configured (`AbortSignal.timeout`)
- MUST NOT be called inside `prisma.$transaction`

---

## Skill 11: sql-safety-review-skill

**Purpose:** Reviews backend code files for SQL injection vulnerabilities, unsafe data access patterns, and N+1 query issues before Gate 4 submission.

**When to Use:**
- Before every Gate 4 submission (mandatory)
- When reviewing any DAL file
- When reviewing any code that uses `prisma.$queryRaw`
- When reviewing code that processes user input destined for DB queries

**Inputs:**
- Array of backend source file paths to review
- Scope: full review or targeted (DAL only, route only, etc.)

**Outputs:**
- SQL safety report with risk level (LOW/MEDIUM/HIGH/CRITICAL)
- Findings list: file, issue, line reference, recommended fix
- Boolean `sql_injection_safe`
- Boolean `uses_only_parameterized`

**Key Failure Modes:**
- Template literal string in Prisma query (e.g., `` prisma.$queryRaw(`SELECT * WHERE id = ${userId}`) ``)
- `prisma.$executeRaw` with unescaped user input
- N+1 queries (loop calling DAL inside another query result iteration)
- SELECT * on large tables in performance-critical paths

**Quality Gate Reference:** Gate 4 — `checklists/sql_safety_checklist.md`

**RAG Collections Permitted:** `backend_engineering`, `data_intensive_applications`, `architecture_reference_backend_view`

**Architecture Compliance:**
- Any CRITICAL or HIGH finding blocks Gate 4 submission
- All `$queryRaw` must use `Prisma.sql` template tag (not string interpolation)
- User input must be validated with Zod before reaching any query
- N+1 patterns must be resolved with `include` or batched queries
