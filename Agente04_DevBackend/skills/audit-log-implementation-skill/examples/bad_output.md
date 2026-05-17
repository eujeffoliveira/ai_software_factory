# Bad Output Example — audit-log-implementation-skill

```typescript
export async function createTask(input: any) {
  const session = await auth()
  if (!session) throw new Error("Unauthorized")

  // VIOLATION 1: auditLog called BEFORE the operation
  // If create() fails, this audit entry records an action that never happened
  await auditLog({
    actorId: input.userId,          // VIOLATION 2: actorId from INPUT — can be spoofed
    action: "CREATE_TASK",          // VIOLATION 3: wrong format — not PAST_TENSE_VERB
    entityType: "task",             // VIOLATION 4: lowercase — must match Prisma model name "Task"
    entityId: "unknown",            // VIOLATION 5: no entityId — not auditable
    metadata: { password: input.password },  // VIOLATION 6: PII/sensitive in metadata
  })

  const task = await taskDal.create(input)
  return task
}
```

| Violation | Impact | Fix |
|-----------|--------|-----|
| auditLog before operation | Audits failed operations | Move AFTER `taskDal.create()` |
| actorId from input | Can be spoofed | Use `session.user.id` |
| `CREATE_TASK` not PAST_TENSE | Inconsistent audit trail | Use `TASK_CREATED` |
| `"task"` not `"Task"` | Doesn't match Prisma model | Use exact Prisma model name |
| No entityId | Unauditable | Use `task.id` after creation |
| Password in metadata | Security violation | Remove — never log passwords |
