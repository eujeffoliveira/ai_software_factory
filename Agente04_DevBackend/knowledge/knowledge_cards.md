# Agente04_DevBackend — Knowledge Cards

> Reusable concept cards distilled from build-time bibliography and reference architecture. These are reference implementations and pattern summaries for runtime use.

---

## Card 001 — Server Action Pattern

**What:** The standard Golden Path implementation for mutations in Next.js App Router.

**File location:** `features/[domain]/actions/[actionName].ts`

**Required elements:**
1. `"use server"` directive (first line)
2. Zod input schema at module level
3. `await auth()` check as first statement in function body
4. `Schema.parse(rawInput)` for input validation
5. DAL call for DB operations — never direct `prisma`
6. `auditLog()` after successful operation (for mutations)
7. `try/catch` with internal log and generic rethrow

**NEVER:**
- `prisma` imported directly
- `process.env` accessed directly
- Business logic skipped to `route.ts`
- `"use server"` missing
- Auth check after other operations

---

## Card 002 — Route Handler (Thin) Pattern

**What:** REST endpoint for external consumers. Must stay thin.

**File location:** `app/api/[resource]/route.ts`

**Budget:** ≤ 30 lines per HTTP method handler

**Structure:**
1. Auth check → 401 if null
2. Validate params with `.safeParse()` → 400 if invalid
3. Delegate to `features/` service → single await call
4. Return `NextResponse.json(result)`
5. Catch → log internally → return 500 with generic message

**NEVER:**
- Business logic (DB calls, conditional decisions) in route.ts
- `prisma` import
- DAL import
- More than 2 `await` calls in the happy path (auth + delegation)
- `error.message` in 500 response

---

## Card 003 — Cron Job Pattern

**What:** Vercel Cron implementation with mandatory guard and logging.

**Files:**
- `app/api/cron/[job-name]/route.ts` — thin route calling guardCron + job function
- `lib/jobs/[job-name].ts` — job business logic (pure, idempotent)

**Mandatory elements:**
- `guardCron(req)` as ABSOLUTE FIRST call in route handler
- `export const dynamic = "force-dynamic"` in route file
- `syncLog()` in `finally` block — always records, even on failure
- Idempotency: upsert or existence check before creating records

**Job function return shape:**
```typescript
return { counts: { processed: N, created: N, updated: N, failed: N } }
```

**Registered in:** `vercel.json` crons array

---

## Card 004 — Prisma DAL Pattern

**What:** Data Access Layer for a single Prisma model.

**File location:** `lib/db/[model].dal.ts`

**Export pattern:** `export const [model]Dal = { findById, findMany, create, update, delete, upsert }`

**Rules:**
- Only file (besides `lib/db/prisma.ts`) that imports `prisma`
- All operations use Prisma parameterized API — NEVER raw SQL
- Types inferred from Prisma generated types
- `upsert` included for cron job idempotency
- Named const export (not default export, not individual functions)

**Imported by:** Server Actions and service functions — NEVER by Route Handlers directly

---

## Card 005 — audit_log vs sync_log

**audit_log — for human-triggered state changes**

Fields:
- `actorId` — from `session.user.id` (NEVER from request body)
- `actorEmail` — from `session.user.email`
- `action` — PAST_TENSE_VERB: CREATED / UPDATED / DELETED / APPROVED / REJECTED / PUBLISHED / ARCHIVED
- `entityType` — Prisma model name (e.g., "Task")
- `entityId` — ID of the affected record
- `metadata` — relevant context, no passwords/tokens
- `createdAt` — automatic

Used for: compliance, support investigations, debugging of user actions.

**sync_log — for machine-triggered operations**

Fields:
- `job` — job name key (matches `vercel.json` cron path)
- `executedAt` — timestamp
- `durationMs` — total job duration
- `status` — "success" | "error" | "partial"
- `counts` — { processed, created, updated, failed, skipped }
- `errorMsg` — only populated on error

Used for: operational monitoring, job health dashboard, SLA compliance, alerting.

---

## Card 006 — Zod Boundary Validation

**What:** Zod is the trust boundary enforcer for all external data.

**Validate these boundaries:**
1. User inputs — Server Action `rawInput: unknown`, Route Handler body/params
2. Environment variables — `lib/env.ts` with `z.object({...}).parse(process.env)`
3. External API responses — after `response.json()`, before use
4. Webhook payloads — after receiving raw body

**Schema definition rule:** Always at module level — never inline inside a function body.

**Usage by context:**
- Server Actions: `.parse()` — throws `ZodError` on invalid (caught by error handler)
- Route Handlers: `.safeParse()` — returns structured error for 400 response

**Type inference:** Always `type Input = z.infer<typeof InputSchema>` — never manually written interfaces.

---

## Card 007 — Error Handling Contract

**Two audiences for backend errors:**

**Operators** (debugging): Full context via `console.error`
```typescript
console.error("[actionName] failed:", {
  error,         // full error object
  userId: session.user.id,
  entityId: input.id,
  // operation-specific context
})
```

**Users** (API response): Generic message that reveals nothing
```typescript
// Server Actions
throw new Error("Operation failed. Please try again.")

// Route Handlers
return NextResponse.json({ error: "Internal server error" }, { status: 500 })
```

**What never reaches the client:**
- `error.message` (reveals Prisma/system internals)
- `error.stack` (reveals file structure and function names)
- Database constraint names
- Internal function names or file paths

---

## Card 008 — guardCron() Contract

**What:** `guardCron(req)` must be the FIRST call in every cron route handler.

**It validates:**
1. `Authorization` header contains `Bearer ${CRON_SECRET}`
2. Request originates from Vercel infrastructure
3. (Optional) Execution deduplication to prevent concurrent runs

**If validation fails:** Throws immediately — no job logic executes.

**Rule:** No code before `guardCron(req)`. Not variable declarations, not console.log, not imports. The function call must be literally the first statement in the handler.

**Source:** Reference Architecture §19 — Cron Security

---

## Card 009 — Idempotency Strategies

**What:** Making cron jobs and background operations safe to retry.

**Strategy 1 — Upsert** (most common):
```typescript
await dal.upsert({ where: { externalId }, create: createData, update: updateData })
```
Creates if not exists, updates if exists. Use when syncing records from external source.

**Strategy 2 — Existence check**:
```typescript
const existing = await dal.findByExternalId(externalId)
if (!existing) await dal.create(createData)
```
Use when update logic is different from create logic.

**Strategy 3 — Version flag**:
```typescript
const record = await dal.findById(id)
if (record.syncedAt?.toDateString() === new Date().toDateString()) return // already processed today
```
Use when job should run at most once per time period.

**Strategy 4 — External deduplication**:
Pass `Idempotency-Key: job-name-YYYY-MM-DD` header to external API.
Use when the external service supports idempotency keys.

**Test:** Run the job twice on the same data. Second run should produce: zero creates, zero errors, records count unchanged.

---

## Card 010 — Clean Code Applied to Backend

**Source:** Clean Code (Robert C. Martin)

**Function design:**
- Functions do ONE thing (SRP at function level)
- 3-20 lines per function is the sweet spot — longer = doing too much
- Names reveal intent: `createTaskForUser` not `processData`
- No magic numbers: `TIMEOUT_MS = 10_000` not `10000` inline
- Boolean arguments often indicate a function should be split

**Error handling:**
- Errors are not flow control — don't use try/catch for business logic branches
- Each catch block has a purpose: log + rethrow with generic message
- Don't catch what you can't handle

**Commenting:**
- Comments explain WHY, not WHAT
- Code should be self-documenting (good names)
- Out-of-date comments are worse than no comments

**Applied to backend:**
- `createTask` = one function → validate → create → audit → return
- `findManyByUserWithFilters` is readable — `getData` is not
- `const CRON_SECRET_HEADER = "authorization"` not `"authorization"` inline
