# Good Task Example
## TASK-003 — Implement createTask Server Action

> This example demonstrates a well-formed atomic task. Every field is present, specific, and actionable.

---

## Task Metadata

| Field | Value |
|-------|-------|
| **Task ID** | TASK-003 |
| **Title** | Implement createTask Server Action |
| **Type** | backend |
| **Layer** | business-logic |
| **Status** | pending |
| **Estimated Complexity** | M (50–150 LOC, 1 file) |

---

## File Path

```
features/tasks/actions/createTask.ts
```

This task creates EXACTLY ONE file. The Server Action file is separate from DAL, model, and schema files.

---

## Description

Implements the `createTask` Server Action used by the TaskForm Client Component. The action validates input with Zod, persists the new task via the DAL layer, and records an `audit_log` entry. Returns an `ActionResult<Task>` discriminated union indicating success or typed failure.

---

## Context Summary

This Server Action is the mutation entry point for task creation. It must: (1) check authentication via NextAuth `getServerSession`, (2) validate input using `CreateTaskSchema` (defined in this file), (3) call `createTaskRecord` from the DAL — which is produced in TASK-002, and (4) write an `audit_log` entry with event type `'task.created'`. Do not implement the DAL function here — it already exists after TASK-002. Do not implement the frontend form — that is TASK-006.

---

## Function Signatures

Pre-specified contracts the dev agent must implement:

```typescript
'use server'

import { z } from 'zod'
import type { ActionResult } from '@/lib/types'
import type { Task } from '@prisma/client'

export const CreateTaskSchema = z.object({
  title: z.string().min(3).max(255),
  description: z.string().optional(),
  status: z.enum(['todo', 'in_progress', 'done']),
  priority: z.enum(['low', 'medium', 'high']),
  due_date: z.date().optional()
})

export type CreateTaskInput = z.infer<typeof CreateTaskSchema>

export async function createTask(
  input: CreateTaskInput
): Promise<ActionResult<Task>>
```

---

## Dependencies

| Depends On | Dependency Type | Reason |
|-----------|----------------|--------|
| TASK-001 | data | Requires tasks table to exist in PostgreSQL |
| TASK-002 | data | Requires Task Prisma model + DAL createTaskRecord function |

---

## Acceptance Criteria

- [ ] Function validates input using `CreateTaskSchema.safeParse()` and returns field-level errors on invalid input
- [ ] Function returns the created `Task` object on success: `{ data: task }`
- [ ] Function throws or returns `{ error: 'UNAUTHORIZED' }` for unauthenticated calls (no database write occurs)
- [ ] Function writes an `audit_log` entry with event type `'task.created'` and `user_id` before returning success
- [ ] Function returns `{ error: 'VALIDATION_ERROR', fields: ... }` on Zod validation failure
- [ ] File uses `'use server'` directive as the first line

---

## Test Requirements

| Test Type | Required | Tool | Details |
|-----------|----------|------|---------|
| Unit | Yes | Vitest | Test all code paths with mocked Prisma and NextAuth |
| Integration | Yes | Vitest | Test against real PostgreSQL test database |
| E2E | No | — | E2E covered by TASK-008 (TaskForm E2E test) |

**Coverage Target:** 85%

**Mock Requirements:**
- Prisma client — use `vi.mock` for unit tests; real Supabase test DB for integration
- NextAuth `getServerSession` — mock authenticated session and unauthenticated (null) scenarios

**Test File:** `__tests__/features/tasks/actions/createTask.test.ts`

**Test Scenarios:**
1. Valid input + authenticated → returns created task + audit_log written
2. Invalid input (title too short) → returns VALIDATION_ERROR with field details
3. Unauthenticated (session = null) → returns UNAUTHORIZED, no DB write
4. Valid input + DB error → returns INTERNAL_ERROR, no partial data

---

## Security Requirements

| Requirement | Value | Details |
|------------|-------|---------|
| Authentication | true | Check `getServerSession` at function start |
| Authorization | true | Level: `authenticated` — any logged-in user |
| Input validation (Zod) | true | Schema: `CreateTaskSchema` |
| Audit log | true | Event: `task.created` |
| SQL injection risk | false | Uses Prisma ORM only |
| XSS risk | false | No HTML rendering |
| CSRF risk | false | Next.js Server Actions have built-in CSRF protection |
| DevSecOps review | false | Standard mutation pattern |

**Security Notes:** Call `getServerSession` before any other operation. Use `CreateTaskSchema.safeParse()` (not `.parse()`) to handle errors gracefully. Write to `audit_log` table inside the same transaction as the task creation, or immediately before returning success.

---

## Golden Path Constraints

- [ ] File starts with `'use server'` directive
- [ ] Uses Zod (`CreateTaskSchema`) for input validation — no manual validation
- [ ] Uses Prisma 7 (via DAL function from TASK-002) — no raw SQL
- [ ] All environment variables accessed via `lib/env.ts` — never `process.env` directly
- [ ] Writes `audit_log` entry for the mutation (event type: `task.created`)
- [ ] Authentication via NextAuth `getServerSession` — no custom auth

---

## Notes for Developer

This is a pure Server Action — it has no UI concerns. The function signature must match exactly (return type `ActionResult<Task>`) because TASK-006 (TaskForm) will import and call it with these types. Do not change the return type without updating TASK-006 and escalating to the Tech Lead.

The `ActionResult<T>` type is a shared type defined in `lib/types.ts` — import from there, do not redefine it.

---

## Why This Task is Well-Formed

1. **Single responsibility:** Creates one thing — the `createTask` Server Action in one file
2. **Single file focus:** `features/tasks/actions/createTask.ts` — one file only
3. **Bounded complexity:** M — 50-150 LOC, achievable in one dev session
4. **Testable in isolation:** Can be unit-tested with mocked Prisma + NextAuth
5. **Well-defined output:** Function signatures are pre-specified; dev agent knows exactly what to build
6. **Explicit dependencies:** TASK-001 and TASK-002 are declared — no hidden assumptions
7. **Traceable:** PRD acceptance criterion "Users can create new tasks" is covered
8. **Security requirements defined:** auth, validation, audit log all specified before dev starts
9. **Test requirements complete:** unit + integration + coverage target specified
