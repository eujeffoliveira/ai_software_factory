// BAD EXAMPLE: Incorrect Fat Route Handler
// File: app/api/tasks/route.ts (WRONG VERSION)
//
// This example demonstrates 5 VIOLATIONS that collapse the thin-handler principle.

import { NextRequest, NextResponse } from "next/server"
import { prisma } from "@/lib/db/prisma"  // VIOLATION 1: Direct prisma import in route.ts
// Route handlers must NEVER import prisma directly.
// All DB access goes through features/ → DAL.
// FIX: Remove prisma import. Delegate to taskService from features/.

export async function GET(req: NextRequest): Promise<NextResponse> {
  // VIOLATION 2: No auth check
  // Any unauthenticated HTTP request to /api/tasks will execute this handler
  // and return other users' data. Zero authentication.
  // FIX: Add const session = await auth(); if (!session) return 401; as FIRST two lines.

  const { searchParams } = req.nextUrl
  const userId = searchParams.get("userId")  // VIOLATION 3: No Zod validation
  // Raw query param used directly without validation.
  // userId could be null, undefined, an SQL injection string, or anything.
  // FIX: Use z.object({ userId: z.string().uuid() }).safeParse(Object.fromEntries(searchParams))

  // VIOLATION 4: Business logic in route handler — DB query directly in route.ts
  // This handler now:
  // - Manages pagination logic
  // - Applies filters
  // - Calls the database directly
  // - Handles error states
  // Route handlers should be thin: auth + parse + delegate + respond.
  // None of this belongs here — it belongs in taskService or taskDal.
  // FIX: Extract to taskService.list() in features/tasks/task.service.ts
  const page = parseInt(searchParams.get("page") ?? "1")  // fragile — no validation
  const skip = (page - 1) * 20

  try {
    const tasks = await prisma.task.findMany({
      where: { userId: userId ?? undefined },
      orderBy: { createdAt: "desc" },
      skip,
      take: 20,
      include: { user: true, comments: true },
    })

    const total = await prisma.task.count({
      where: { userId: userId ?? undefined },
    })

    return NextResponse.json({ tasks, total, page, pageSize: 20 })
  } catch (error: any) {
    // VIOLATION 5: Stack trace / error details exposed to client
    // The client now receives the raw Prisma error message, which may include:
    // - Database connection strings
    // - Table and column names
    // - Constraint names
    // This gives an attacker detailed information about the DB schema.
    // FIX: console.error("[GET /api/tasks] failed:", { error }); return { error: "Internal server error" }
    return NextResponse.json(
      { error: error.message, stack: error.stack },  // NEVER DO THIS
      { status: 500 }
    )
  }
}
// Total: 45+ lines — well over the 30-line target
// Violates: thin handler, no auth, no Zod, direct DB, exposes internals
