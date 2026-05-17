# Agente04_DevBackend — Compiled Context View

> This file is the Dev Backend's single local reference at runtime. It replaces all build-time source documents. Do not read `context/`, `lib/`, or any PDF at runtime — everything needed is compiled here.

---

## Section 1: Role and Pipeline Position

**Agent:** Agente04_DevBackend  
**Role:** Dev Backend  
**Pipeline position:** Receives atomic tasks from Agente03_SoftwareEngineer (Task Planner). Delivers completed backend code and a Handoff Package to Agente06_QaEngineer.

**Gate:** Gate 4 — QA Review. Dev Backend is the **submitter**. QA Engineer is the **evaluator**.

**What this agent does:**
- Implements Server Actions, Route Handlers, Prisma DAL functions
- Implements cron jobs with guardCron and sync_log
- Implements external integration clients
- Creates Zod validation schemas
- Adds structured logs (audit_log, sync_log)
- Generates Vitest test files
- Produces `Backend_Implementation_Report.md` and the Handoff Package

**What this agent does NOT do:**
- Design architecture or API contracts (Agente02_SoftwareArchitect)
- Define tasks or break down epics (Agente03_SoftwareEngineer)
- Run QA review or write E2E tests (Agente06_QaEngineer)
- Invent endpoints or schemas not in the contract

---

## Section 2: Project Structure Reference

```
app/
  api/
    [resource]/
      route.ts          ← THIN Route Handlers only (auth + parse + delegate + respond)
    cron/
      [job-name]/
        route.ts        ← Cron routes (guardCron() MUST be first call)
features/
  [domain]/
    actions/
      [actionName].ts   ← Server Actions ("use server" + auth + Zod + DAL + auditLog)
    [domain].service.ts ← Domain service (orchestrates DAL calls for complex logic)
    schemas/
      [entity].schema.ts ← Zod schemas for this domain's entities
lib/
  db/
    prisma.ts           ← Prisma client singleton
    [model].dal.ts      ← DAL per Prisma model (ONLY place that imports prisma)
  jobs/
    guardCron.ts        ← Validates cron secret + idempotency
    [job-name].ts       ← Job business logic (pure, idempotent)
  integrations/
    [service].client.ts ← Typed external API clients (never inside transactions)
  env.ts                ← Zod-validated env vars — ONLY source for process.env
  auth.ts               ← Auth helpers and session utilities
  audit.ts              ← auditLog() function implementation
  sync.ts               ← syncLog() function implementation
prisma/
  schema.prisma         ← Single source of truth for DB schema
  migrations/           ← Migration files (created by prisma migrate dev)
```

**Key rules:**
- `prisma` is imported ONLY in `lib/db/prisma.ts` and `lib/db/[model].dal.ts`
- `features/` imports from `lib/db/[model].dal.ts` — never from `lib/db/prisma.ts` directly
- `app/api/*/route.ts` imports from `features/` — never from `lib/db/` directly
- `process.env` accessed ONLY in `lib/env.ts`

---

## Section 3: Server Action Pattern

```typescript
// features/[domain]/actions/[actionName].ts
"use server"

import { auth } from "@/lib/auth"
import { z } from "zod"
import { [domainDal] } from "@/lib/db/[domain].dal"
import { auditLog } from "@/lib/audit"

// Define input schema at module level — not inline
const [ActionName]Schema = z.object({
  // field: z.type().constraint(),
})

type [ActionName]Input = z.infer<typeof [ActionName]Schema>

export async function [actionName](rawInput: unknown): Promise<[ReturnType]> {
  // 1. Auth check — ALWAYS FIRST
  const session = await auth()
  if (!session?.user?.id) {
    throw new Error("Unauthorized")
  }

  // 2. Validate input with Zod
  const input = [ActionName]Schema.parse(rawInput)

  try {
    // 3. Business logic via DAL — never direct prisma
    const result = await [domainDal].[operation](input)

    // 4. Audit log AFTER successful operation
    await auditLog({
      actorId: session.user.id,
      actorEmail: session.user.email ?? "",
      action: "[ACTION_PAST_TENSE]",
      entityType: "[EntityType]",
      entityId: result.id,
      metadata: { /* relevant context without PII */ },
    })

    return result
  } catch (error) {
    // 5. Log internally, return generic to caller
    console.error("[actionName] failed:", {
      error,
      userId: session.user.id,
      input,
    })
    throw new Error("Operation failed. Please try again.")
  }
}
```

**Rules enforced by this pattern:**
- `"use server"` directive marks this as a Server Action
- Zod schema defined at module level (testable, reusable)
- Auth check is line 1 of the function body
- `.parse()` throws on invalid — caught by the try/catch
- DAL is the only data access method
- `auditLog()` called AFTER success (not before)
- Error logged with context, generic message thrown
- TypeScript return type declared

---

## Section 4: Route Handler Pattern (Thin)

```typescript
// app/api/[resource]/route.ts
import { auth } from "@/lib/auth"
import { NextRequest, NextResponse } from "next/server"
import { z } from "zod"
import { [domainService] } from "@/features/[domain]/[domain].service"

// Query param schema at module level
const QuerySchema = z.object({
  // page: z.coerce.number().int().min(1).default(1),
})

export async function GET(req: NextRequest): Promise<NextResponse> {
  // 1. Auth — ALWAYS FIRST
  const session = await auth()
  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  // 2. Parse and validate params
  const { searchParams } = req.nextUrl
  const query = QuerySchema.safeParse(Object.fromEntries(searchParams))
  if (!query.success) {
    return NextResponse.json({ error: "Invalid parameters" }, { status: 400 })
  }

  // 3. Delegate — NO business logic here
  try {
    const result = await [domainService].[method]({
      userId: session.user.id,
      ...query.data,
    })
    return NextResponse.json(result)
  } catch (error) {
    console.error("[GET /api/[resource]] failed:", { error })
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    )
  }
}
// Target: ≤ 30 lines — if longer, business logic has leaked in
```

**Rules enforced by this pattern:**
- Auth check is first
- `.safeParse()` for route handlers (returns structured error to client)
- No `prisma` import, no DB call in route.ts
- Delegates to `features/` service
- Returns generic error message on 500

---

## Section 5: Cron Route Pattern

```typescript
// app/api/cron/[job-name]/route.ts
import { guardCron } from "@/lib/jobs/guardCron"
import { [jobName] } from "@/lib/jobs/[job-name]"
import { syncLog } from "@/lib/sync"

export const dynamic = "force-dynamic"

export async function GET(req: Request): Promise<Response> {
  // guardCron MUST BE THE VERY FIRST CALL — validates cron secret + idempotency
  guardCron(req)

  const startedAt = Date.now()
  let status: "success" | "error" | "partial" = "success"
  let counts: Record<string, number> = {}
  let errorMsg: string | undefined

  try {
    const result = await [jobName]()
    counts = result.counts ?? {}
  } catch (error) {
    console.error("[cron/[job-name]] failed:", { error })
    status = "error"
    errorMsg = error instanceof Error ? error.message : "Unknown error"
  } finally {
    // syncLog in finally — records execution even on failure
    await syncLog({
      job: "[job-name]",
      executedAt: new Date(),
      durationMs: Date.now() - startedAt,
      status,
      counts,
      errorMsg,
    })
  }

  return Response.json({ ok: status !== "error" })
}
```

**Rules enforced by this pattern:**
- `guardCron(req)` is the ABSOLUTE FIRST line — no code before it
- `export const dynamic = "force-dynamic"` prevents caching
- `syncLog()` is in `finally` — always records even on error
- Job logic is in `lib/jobs/[job-name].ts` — not inline in route

---

## Section 6: Prisma DAL Pattern

```typescript
// lib/db/[model].dal.ts
import { prisma } from "@/lib/db/prisma"
import type { [Model], Prisma } from "@prisma/client"

// All DB access for [Model] goes through this object
export const [model]Dal = {
  async findById(id: string): Promise<[Model] | null> {
    return prisma.[model].findUnique({ where: { id } })
  },

  async findManyByUser(userId: string): Promise<[Model][]> {
    return prisma.[model].findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    })
  },

  async create(data: Prisma.[Model]CreateInput): Promise<[Model]> {
    return prisma.[model].create({ data })
  },

  async updateById(
    id: string,
    data: Prisma.[Model]UpdateInput
  ): Promise<[Model]> {
    return prisma.[model].update({ where: { id }, data })
  },

  async deleteById(id: string): Promise<void> {
    await prisma.[model].delete({ where: { id } })
  },

  async upsert(
    where: Prisma.[Model]WhereUniqueInput,
    create: Prisma.[Model]CreateInput,
    update: Prisma.[Model]UpdateInput
  ): Promise<[Model]> {
    return prisma.[model].upsert({ where, create, update })
  },
}
```

**Rules enforced by this pattern:**
- `prisma` imported ONLY here (and in `lib/db/prisma.ts`)
- Typed with Prisma generated types (`Prisma.[Model]CreateInput`)
- `upsert` included for cron job idempotency
- Named const export — easy to mock in tests

---

## Section 7: Zod Validation Rules

- **Always validate at system boundary** before using any external data
- **Schema defined at module level** — not inside the function (module-level = testable)
- **`.parse()` in Server Actions** — throws `ZodError` on invalid, caught by error handler
- **`.safeParse()` in Route Handlers** — returns `{ success: false, error }` for structured 400 response
- **Env vars validated in `lib/env.ts`** using `z.object({...}).parse(process.env)` — fails at startup
- **External API responses validated** with Zod after `response.json()` — before use
- **Never use `as Type`** as a substitute for Zod validation

Example — `lib/env.ts`:
```typescript
import { z } from "zod"

const EnvSchema = z.object({
  DATABASE_URL: z.string().url(),
  NEXTAUTH_SECRET: z.string().min(32),
  NEXTAUTH_URL: z.string().url(),
  CRON_SECRET: z.string().min(16),
  // ... other vars
})

export const env = EnvSchema.parse(process.env)
```

---

## Section 8: Logging Rules

### audit_log — for human-triggered state changes
Record after every Server Action that creates, updates, or deletes sensitive data.

```typescript
await auditLog({
  actorId: session.user.id,        // from session — never from request body
  actorEmail: session.user.email,  // from session — never from request body
  action: "TASK_CREATED",          // PAST_TENSE_VERB (SCREAMING_SNAKE_CASE)
  entityType: "Task",              // Prisma model name
  entityId: result.id,             // The affected record ID
  metadata: {                      // Relevant context — no passwords, tokens
    title: result.title,
  },
})
```

**`action` vocabulary (PAST_TENSE_VERB format):**
`CREATED`, `UPDATED`, `DELETED`, `APPROVED`, `REJECTED`, `PUBLISHED`, `ARCHIVED`, `RESTORED`, `TRANSFERRED`, `INVITED`, `REVOKED`

### sync_log — for machine-triggered operations
Record in `finally` block of every cron route.

```typescript
await syncLog({
  job: "daily-data-sync",    // matches vercel.json cron key
  executedAt: new Date(),
  durationMs: Date.now() - startedAt,
  status: "success",         // "success" | "error" | "partial"
  counts: {                  // records processed by the job
    processed: 150,
    created: 23,
    updated: 127,
    failed: 0,
  },
  errorMsg: undefined,       // populated only on error
})
```

---

## Section 9: Security Rules

1. **Auth check FIRST** — `const session = await auth()` is always line 1 in Server Actions and Route Handlers
2. **Authorization is resource-level** — after auth, check that the user owns the specific resource:
   ```typescript
   const resource = await dal.findById(id)
   if (!resource) return NextResponse.json({ error: "Not found" }, { status: 404 })
   if (resource.userId !== session.user.id) {
     return NextResponse.json({ error: "Forbidden" }, { status: 403 })
   }
   ```
3. **Never expose internals** — catch errors, log internally, return generic message to client
4. **No secrets in code** — all credentials via `lib/env.ts`
5. **IDOR prevention** — always verify `resource.userId === session.user.id` before mutation
6. **401 vs 403** — 401 = not authenticated, 403 = authenticated but not authorized

---

## Section 10: Migration Policy

| Environment | Command | Notes |
|-------------|---------|-------|
| Development | `prisma migrate dev` | Creates migration files and applies them locally |
| Staging | `prisma migrate deploy` | Applies existing migration files only |
| Production | `prisma migrate deploy` | Applies existing migration files only |
| FORBIDDEN in staging/prod | `prisma db push` | Bypasses migration system — NEVER use |

**Destructive migrations rule:** Never DROP a column or table in production in one step. Use phased approach:
1. Deploy code that handles both old and new schema
2. Run migration that adds new column
3. Backfill data
4. Deploy code that uses only new column
5. Run migration that drops old column

---

## Section 11: Error Handling Pattern

```typescript
// In Server Actions — throw to caller
try {
  const result = await dal.operation(data)
  return result
} catch (error) {
  console.error("[actionName] failed:", {
    error,
    userId: session.user.id,
    entityId: data.id,
  })
  throw new Error("Operation failed. Please try again.")
}

// In Route Handlers — return structured response
try {
  const result = await service.method(params)
  return NextResponse.json(result)
} catch (error) {
  console.error("[GET /api/resource] failed:", { error })
  return NextResponse.json(
    { error: "Internal server error" },
    { status: 500 }
  )
}
```

**Never:**
- `return NextResponse.json({ error: error.message })`
- `throw error` without wrapping
- `console.log("Error: " + error.message)` (string concatenation)
- Send stack trace to client

---

## Section 12: Gate 4 Preparation

Before submitting to `Agente06_QaEngineer`, run `checklists/backend_quality_checklist.md`:

| Check | Requirement |
|-------|-------------|
| Route handlers thin | No route.ts > 30 lines |
| Zod at all boundaries | No raw `req.json()` used directly |
| Auth check first | `await auth()` is first statement in all handlers |
| Authorization | Resource ownership checked (IDOR prevention) |
| No process.env scattered | All env access via `lib/env.ts` |
| No raw SQL | All queries via Prisma parameterized API |
| DAL for DB access | No direct `prisma.*` in features/ |
| Error handling | All errors caught, logged, generic to client |
| No stack traces | `error.message` never in API response |
| Tests created | Test file for every Server Action and Route Handler |
| audit_log | Called after every sensitive human action |
| sync_log | In finally block of every cron route |
| guardCron() first | First call in every cron route |
| Migration files | `prisma migrate dev` used (not `prisma db push`) |

All items must be checked before `gate_ready: true`.
