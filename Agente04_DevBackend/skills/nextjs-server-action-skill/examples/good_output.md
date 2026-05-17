# Good Output Example — nextjs-server-action-skill

**Task:** TASK-003 — Implement createTask Server Action  
**Result:** Correct, Gate 4-ready implementation

```typescript
// features/tasks/actions/createTask.ts
"use server"

import { auth } from "@/lib/auth"
import { z } from "zod"
import { taskDal } from "@/lib/db/task.dal"
import { auditLog } from "@/lib/audit"
import type { Task } from "@prisma/client"

const CreateTaskSchema = z.object({
  title: z.string().min(1, "Title is required").max(255),
  description: z.string().max(2000).optional(),
  priority: z.number().int().min(1).max(5).default(3),
})

type CreateTaskInput = z.infer<typeof CreateTaskSchema>

export async function createTask(rawInput: unknown): Promise<Task> {
  const session = await auth()
  if (!session?.user?.id) {
    throw new Error("Unauthorized")
  }

  const input = CreateTaskSchema.parse(rawInput)

  try {
    const task = await taskDal.create({
      title: input.title,
      description: input.description,
      priority: input.priority,
      userId: session.user.id,
    })

    await auditLog({
      actorId: session.user.id,
      actorEmail: session.user.email ?? "",
      action: "TASK_CREATED",
      entityType: "Task",
      entityId: task.id,
      metadata: { title: task.title, priority: task.priority },
    })

    return task
  } catch (error) {
    console.error("createTask failed:", { error, userId: session.user.id })
    throw new Error("Failed to create task. Please try again.")
  }
}
```

**Why this is correct:**
1. `"use server"` — required directive, first line
2. Schema at module level — testable and reusable
3. Auth check is the first statement in the function
4. `.parse()` used — throws ZodError on invalid input (caught by outer try/catch)
5. `taskDal.create()` — no direct prisma import
6. `auditLog()` after success — actorId/actorEmail from session, PAST_TENSE_VERB
7. Generic error thrown — no internal details exposed
8. `userId` from `session.user.id` — not from `input`
