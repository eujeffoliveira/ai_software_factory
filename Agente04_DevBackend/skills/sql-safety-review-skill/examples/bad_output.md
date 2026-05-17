# Bad Output Example — sql-safety-review-skill

**Input:** `files_to_review: ["lib/db/task.dal.ts"]`

**SQL Safety Report:**
```json
{
  "risk_level": "CRITICAL",
  "findings": [
    {
      "file": "lib/db/task.dal.ts",
      "line": 12,
      "issue": "SQL injection via string concatenation — user input directly interpolated into query",
      "fix": "Replace with prisma.task.findMany({ where: { userId } })",
      "severity": "CRITICAL"
    },
    {
      "file": "lib/db/task.dal.ts",
      "line": 18,
      "issue": "Template literal in $queryRaw without Prisma.sql tag — not parameterized",
      "fix": "Use Prisma.sql template tag: prisma.$queryRaw(Prisma.sql`SELECT * WHERE id = ${id}`)",
      "severity": "HIGH"
    }
  ],
  "sql_injection_safe": false,
  "uses_only_parameterized": false
}
```

**Offending code:**
```typescript
// line 12: CRITICAL
findByUser: async (userId: string) => {
  return prisma.$queryRawUnsafe("SELECT * FROM tasks WHERE user_id = '" + userId + "'")
},
// line 18: HIGH
findById: async (id: string) => {
  return prisma.$queryRaw`SELECT * FROM tasks WHERE id = ${id}`  // looks safe but isn't Prisma.sql
},
```

**Gate 4 action:** BLOCKED — fix CRITICAL and HIGH findings before submitting.
