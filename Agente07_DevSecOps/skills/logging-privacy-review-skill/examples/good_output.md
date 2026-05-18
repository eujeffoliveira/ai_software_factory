# Good Output — Logging Privacy Review Skill

```json
{
  "status": "PASS",
  "call_sites_reviewed": 8,
  "audit_log_calls_reviewed": 3,
  "sync_log_calls_reviewed": 2,
  "console_calls_reviewed": 3,
  "findings": []
}
```

audit_log at `features/tasks/actions/create-task.action.ts:32`:
- actorId: session.user.id ✅
- actorEmail: session.user.email ✅
- action: "task.create" (constant) ✅
- entityType: "Task" (constant) ✅
- entityId: task.id (internal ID) ✅
- metadata: `{ status: "created" }` (no user content) ✅
