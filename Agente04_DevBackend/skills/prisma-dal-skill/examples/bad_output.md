# Bad Output Example — prisma-dal-skill

```typescript
// lib/db/task.dal.ts — 3 violations
import { prisma } from "@/lib/db/prisma"

// VIOLATION 1: Default export instead of named const object
export default {
  findTask: async (id: any) => {  // VIOLATION 2: typed as any, no return type
    return prisma.task.findUnique({ where: { id } })
  },

  // VIOLATION 3: Raw SQL with string concatenation — SQL INJECTION
  findByUser: async (userId: string) => {
    return prisma.$queryRawUnsafe(
      "SELECT * FROM tasks WHERE user_id = '" + userId + "'"
    )
  },
  // Missing: upsert (cron jobs can't be idempotent without it)
  // Missing: typed parameters throughout
}
```

| Violation | Impact | Fix |
|-----------|--------|-----|
| Default export | Hard to mock in tests | `export const taskDal = { ... }` |
| `any` typed params | No compile-time safety | Use `Prisma.TaskCreateInput` etc. |
| Raw SQL concatenation | SQL injection — CRITICAL | Use `prisma.task.findMany({ where: { userId } })` |
| Missing upsert | Cron jobs will create duplicates | Add `upsertByExternalId` method |

**Gate 4 result:** BLOCKED_SECURITY_VIOLATION (SQL injection)
