# Good Output Example — zod-validation-skill

```typescript
// features/tasks/schemas/task.schema.ts
import { z } from "zod"

export const CreateTaskSchema = z.object({
  title: z.string().min(1, "Title is required").max(255),
  description: z.string().max(2000).optional(),
  priority: z.number().int().min(1).max(5).default(3),
})

export const UpdateTaskSchema = CreateTaskSchema.partial()

export const TaskIdSchema = z.object({
  id: z.string().uuid("Task ID must be a valid UUID"),
})

export const ListTasksQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
  status: z.enum(["draft", "active", "completed", "archived"]).optional(),
})

export type CreateTaskInput = z.infer<typeof CreateTaskSchema>
export type UpdateTaskInput = z.infer<typeof UpdateTaskSchema>
export type TaskIdInput = z.infer<typeof TaskIdSchema>
export type ListTasksQuery = z.infer<typeof ListTasksQuerySchema>
```

**Why correct:** Module-level schemas, proper constraints, inferred types, pagination schema with coerce for string-to-number conversion.
