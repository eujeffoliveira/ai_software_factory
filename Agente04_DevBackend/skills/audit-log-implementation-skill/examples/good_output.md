# Good Output Example — audit-log-implementation-skill

```typescript
// Correct auditLog placement — inside try, AFTER successful operation
try {
  const task = await taskDal.create({ title: input.title, userId: session.user.id })

  await auditLog({
    actorId: session.user.id,        // from session — not from input
    actorEmail: session.user.email ?? "",  // from session
    action: "TASK_CREATED",          // PAST_TENSE_VERB
    entityType: "Task",              // Prisma model name
    entityId: task.id,               // the created record's ID
    metadata: { title: task.title, priority: task.priority },
  })

  return task
} catch (error) {
  // auditLog NOT called here — operation failed, nothing to audit
  console.error("createTask failed:", { error, userId: session.user.id })
  throw new Error("Failed to create task.")
}
```

**Why correct:** Called after success, both IDs from session, PAST_TENSE_VERB, not called on failure.
