# Good Output Example — sql-safety-review-skill

**Input:** `files_to_review: ["lib/db/task.dal.ts", "features/tasks/actions/createTask.ts"]`

**SQL Safety Report:**
```json
{
  "risk_level": "LOW",
  "findings": [],
  "sql_injection_safe": true,
  "uses_only_parameterized": true
}
```

**Reviewed code (safe patterns):**
```typescript
// lib/db/task.dal.ts — SAFE
export const taskDal = {
  async findByUser(userId: string) {
    return prisma.task.findMany({ where: { userId } })  // parameterized via where object
  },
  async updateStatus(id: string, status: string) {
    return prisma.task.update({ where: { id }, data: { status } })  // parameterized
  },
}
```

**Verdict:** No SQL injection risks. All queries use Prisma parameterized API. Gate 4 submission approved from SQL safety perspective.
