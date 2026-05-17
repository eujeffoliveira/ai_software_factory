// BAD EXAMPLE: Incorrect Server Action Implementation
// File: features/tasks/actions/createTask.ts (WRONG VERSION)
//
// This example demonstrates 7 VIOLATIONS that must NEVER appear in production.
// Each violation is annotated with a comment explaining why it's wrong.

// VIOLATION 1: Missing "use server" directive
// Without this, Next.js does not treat this as a Server Action.
// Client components calling this function will fail silently or expose the function
// to client-side execution, bypassing server-side security checks.
// FIX: Add "use server" as the very first line.

import { prisma } from "@/lib/db/prisma"  // VIOLATION 2: Direct prisma import
// Direct prisma calls in features/ break the DAL abstraction.
// The function is now untestable without a real DB connection.
// Changes to Prisma config (e.g., read replicas, connection pooling) won't apply.
// FIX: Import taskDal from "@/lib/db/task.dal" instead.

export async function createTask(input: any) {
  // VIOLATION 3: No auth check
  // Any caller — authenticated or not — can execute this function.
  // Server Actions are callable from the browser. Without auth check, this
  // is an open mutation endpoint accessible to anyone.
  // FIX: Add const session = await auth(); if (!session?.user?.id) throw new Error("Unauthorized")
  // as the FIRST two lines.

  // VIOLATION 4: No Zod validation — raw input used directly
  // The `input` parameter is typed as `any` and used without validation.
  // Malformed data (empty title, wrong types) goes directly to the database.
  // FIX: Define const CreateTaskSchema = z.object({...}) at module level,
  // then call const validated = CreateTaskSchema.parse(input)

  const task = await prisma.task.create({
    // VIOLATION 5: userId from client input — can be spoofed
    // The client can send any userId, allowing them to create tasks for other users.
    // FIX: userId must come from session.user.id — never from input.
    data: {
      title: input.title,
      userId: input.userId,  // WRONG: attacker can supply any userId
    },
  })

  // VIOLATION 6: No audit_log entry
  // This mutation creates user data with no audit trail.
  // If data is corrupted or disputed, there's no record of who created what and when.
  // FIX: Add await auditLog({ actorId: session.user.id, actorEmail: ..., action: "TASK_CREATED", ... })
  // after the successful creation.

  return task
}

// Elsewhere in the codebase, the caller does:
// try {
//   const task = await createTask(formData)
// } catch (error) {
//   return { error: error.message }  // VIOLATION 7: Exposes internal error details
//   // If prisma throws "Unique constraint failed on the fields: ('title')", the client
//   // now knows the DB schema. If the server throws "connect ECONNREFUSED 127.0.0.1:5432",
//   // the attacker knows the DB is on localhost:5432.
//   // FIX: Catch internally, log with context, throw/return generic message.
// }
