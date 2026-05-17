// GOOD EXAMPLE: Correct Server Action Implementation
// File: features/tasks/actions/createTask.ts
// Task: TASK-003 — Implement createTask Server Action
//
// This example demonstrates:
// ✓ "use server" directive
// ✓ Zod schema at module level
// ✓ Auth check as first statement
// ✓ DAL used for DB access (no direct prisma)
// ✓ auditLog() called after success
// ✓ try/catch with internal logging and generic rethrow
// ✓ TypeScript types throughout

"use server"

import { auth } from "@/lib/auth"
import { z } from "zod"
import { taskDal } from "@/lib/db/task.dal"
import { auditLog } from "@/lib/audit"
import type { Task } from "@prisma/client"

// ✓ Schema defined at MODULE LEVEL — not inside the function
// ✓ Constraints match API contract: title 1-255 chars, description optional max 2000
const CreateTaskSchema = z.object({
  title: z.string().min(1, "Title is required").max(255, "Title is too long"),
  description: z.string().max(2000).optional(),
  priority: z.number().int().min(1).max(5).default(3),
})

// ✓ Type inferred from Zod — never written manually
type CreateTaskInput = z.infer<typeof CreateTaskSchema>

export async function createTask(rawInput: unknown): Promise<Task> {
  // ✓ Step 1: Auth check — FIRST, before anything else
  // No parsing, no logging, no variable declarations before this
  const session = await auth()
  if (!session?.user?.id) {
    throw new Error("Unauthorized")
  }

  // ✓ Step 2: Validate input — .parse() throws ZodError on invalid
  // rawInput is typed as unknown — we don't trust the caller
  const input = CreateTaskSchema.parse(rawInput)

  try {
    // ✓ Step 3: Business logic via DAL — NEVER direct prisma import
    const task = await taskDal.create({
      title: input.title,
      description: input.description,
      priority: input.priority,
      userId: session.user.id,  // userId from session — not from input
    })

    // ✓ Step 4: Audit log AFTER successful operation
    // actorId and actorEmail from session — never from input
    // action in PAST_TENSE_VERB format
    await auditLog({
      actorId: session.user.id,
      actorEmail: session.user.email ?? "",
      action: "TASK_CREATED",
      entityType: "Task",
      entityId: task.id,
      metadata: {
        title: task.title,
        priority: task.priority,
      },
    })

    return task
  } catch (error) {
    // ✓ Step 5: Log internally with context, throw generic to caller
    // NEVER: throw error (exposes internals)
    // NEVER: return NextResponse with error.message (exposes internals)
    console.error("createTask failed:", {
      error,
      userId: session.user.id,
      title: input.title,
    })
    throw new Error("Failed to create task. Please try again.")
  }
}
