# Bad Output Example — zod-validation-skill

```typescript
// features/tasks/actions/createTask.ts — WRONG: schema inline in function
export async function createTask(input: any) {
  // VIOLATION: schema inside function body — not module level, not reusable
  const schema = z.object({ title: z.string() })  // no min/max constraints
  
  // VIOLATION: manually written interface instead of z.infer
  interface CreateTaskInput { title: string }  // diverges from schema silently
  
  schema.parse(input)
  // ...
}
```

| Violation | Impact | Fix |
|-----------|--------|-----|
| Schema inline in function | Not testable, not reusable | Move to module level in `schemas/task.schema.ts` |
| No constraints on `z.string()` | Empty title `""` passes validation | `z.string().min(1).max(255)` |
| Manual interface instead of `z.infer` | Types diverge from schema | `type CreateTaskInput = z.infer<typeof CreateTaskSchema>` |
