# Bad Output Example — nextjs-server-action-skill

**Task:** TASK-003 — Implement createTask Server Action  
**Result:** 5 violations — Gate 4 BLOCKED

```typescript
// features/tasks/actions/createTask.ts
// MISSING "use server" — Violation 1

import { prisma } from "@/lib/db/prisma"  // Violation 2: direct prisma import

export async function createTask(input: any) {  // Violation 3: no Zod, typed as any
  // Violation 4: no auth check — any caller can create tasks
  
  const task = await prisma.task.create({  // Violation 2 continued: direct prisma call
    data: {
      title: input.title,
      userId: input.userId,  // Violation 5: userId from input — can be spoofed
    },
  })

  // Missing auditLog — Violation 6

  return task
  // In the caller: catch(error) { return { error: error.message } }  — Violation 7
}
```

**Violations and Fixes:**

| # | Violation | FM | Fix |
|---|-----------|-----|-----|
| 1 | Missing `"use server"` | — | Add `"use server"` as first line |
| 2 | Direct `prisma` import | FM-01 | Replace with `taskDal` from `@/lib/db/task.dal` |
| 3 | No Zod validation, `input: any` | FM-02 | Add `CreateTaskSchema = z.object({...})` at module level, call `.parse()` |
| 4 | No auth check | FM-03 | Add `const session = await auth(); if (!session?.user?.id) throw "Unauthorized"` as first two lines |
| 5 | `userId` from input | FM-03 variant | Use `session.user.id` instead |
| 6 | No `auditLog()` | FM-07 | Add `await auditLog({...})` after successful `taskDal.create()` |
| 7 | `error.message` to caller | FM-10 | Catch internally, throw `new Error("Generic message")` |

**Gate 4 result:** BLOCKED_SECURITY_VIOLATION (missing auth) + RETURNED_FOR_REVISION (missing validation, DAL, audit)
