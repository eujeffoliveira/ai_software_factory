// GOOD EXAMPLE: Correct Thin Route Handler
// File: app/api/tasks/route.ts
//
// This example demonstrates:
// ✓ Auth check as first statement
// ✓ Zod for query params with safeParse
// ✓ Delegates to features/ service — no business logic
// ✓ Proper status codes and error handling
// ✓ Total: ~28 lines per handler — under the 30-line target
// ✓ No prisma import, no DAL import, no DB calls in this file

import { auth } from "@/lib/auth"
import { NextRequest, NextResponse } from "next/server"
import { z } from "zod"
import { taskService } from "@/features/tasks/task.service"

// ✓ Query schema at module level — typed and reusable
const ListTasksQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
  status: z.enum(["draft", "active", "completed", "archived"]).optional(),
})

// ✓ GET handler — thin by design
export async function GET(req: NextRequest): Promise<NextResponse> {
  // ✓ Step 1: Auth — ALWAYS FIRST. 401 returned before anything else.
  const session = await auth()
  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  // ✓ Step 2: Validate query params with safeParse (not parse — Route Handlers return 400)
  const { searchParams } = req.nextUrl
  const query = ListTasksQuerySchema.safeParse(Object.fromEntries(searchParams))
  if (!query.success) {
    return NextResponse.json({ error: "Invalid parameters" }, { status: 400 })
  }

  // ✓ Step 3: Delegate to features/ — NO business logic in this file
  // taskService handles the actual query logic, pagination, filtering
  try {
    const result = await taskService.list({
      userId: session.user.id,
      page: query.data.page,
      pageSize: query.data.pageSize,
      status: query.data.status,
    })
    return NextResponse.json(result)
  } catch (error) {
    // ✓ Internal log with context, generic message to client
    console.error("[GET /api/tasks] failed:", { error })
    return NextResponse.json({ error: "Internal server error" }, { status: 500 })
  }
}
// Total: ~28 lines for GET handler ✓
// No prisma, no taskDal, no business logic ✓
// 4 responsibilities only: auth, validate, delegate, respond ✓
