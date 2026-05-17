// TEMPLATE: Replace all [PLACEHOLDER] values with your implementation.
// File location: features/[domain]/actions/[actionName].ts
"use server"

import { auth } from "@/lib/auth"
import { z } from "zod"
import { [DomainDal] } from "@/lib/db/[domain].dal"
import { auditLog } from "@/lib/audit"
// import { env } from "@/lib/env"  // uncomment if env vars needed

// ── Input Schema ───────────────────────────────────────────────────────────────
// Define at MODULE LEVEL — not inside the function body.
// This makes the schema testable and reusable.
const [ActionName]Schema = z.object({
  // id: z.string().uuid(),
  // name: z.string().min(1).max(255),
  // status: z.enum(["active", "inactive"]),
})

type [ActionName]Input = z.infer<typeof [ActionName]Schema>

// ── Server Action ──────────────────────────────────────────────────────────────
export async function [actionName](rawInput: unknown): Promise<[ReturnType]> {
  // ── Step 1: Auth check — ALWAYS FIRST ───────────────────────────────────────
  // Auth is checked before ANYTHING else — before parsing, before logging.
  const session = await auth()
  if (!session?.user?.id) {
    throw new Error("Unauthorized")
  }

  // ── Step 2: Validate input with Zod ─────────────────────────────────────────
  // .parse() throws ZodError on invalid input.
  // The outer try/catch will catch it and re-throw a generic message.
  const input = [ActionName]Schema.parse(rawInput)

  try {
    // ── Step 3: Authorization check (if needed) ────────────────────────────────
    // If the operation targets a specific resource, verify ownership.
    // Example:
    // const resource = await [DomainDal].findById(input.id)
    // if (!resource) throw new Error("Not found")
    // if (resource.userId !== session.user.id) throw new Error("Forbidden")

    // ── Step 4: Business logic via DAL ──────────────────────────────────────────
    // NEVER call prisma directly here — always go through the DAL.
    const result = await [DomainDal].[operation](input)

    // ── Step 5: Audit log AFTER successful operation ─────────────────────────────
    // auditLog is called AFTER success — not before, not in catch.
    // actorId and actorEmail come from SESSION — never from input.
    await auditLog({
      actorId: session.user.id,
      actorEmail: session.user.email ?? "",
      action: "[ACTION_PAST_TENSE]",   // e.g. "TASK_CREATED", "STATUS_UPDATED"
      entityType: "[EntityType]",       // Prisma model name, e.g. "Task"
      entityId: result.id,
      metadata: {
        // Include relevant context without PII (no passwords, no tokens)
        // Example: title: result.title
      },
    })

    return result
  } catch (error) {
    // ── Step 6: Log internally, return generic to caller ─────────────────────────
    // NEVER: throw error (exposes internals)
    // NEVER: throw new Error(error.message) (exposes internals)
    // ALWAYS: log with context, throw generic message
    console.error("[actionName] failed:", {
      error,
      userId: session.user.id,
      // include operation-specific context for debugging
    })
    throw new Error("Operation failed. Please try again.")
  }
}
