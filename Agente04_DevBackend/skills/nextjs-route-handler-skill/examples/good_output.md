# Good Output Example — nextjs-route-handler-skill

**Task:** Implement GET /api/tasks route handler  
**Result:** Thin, correct, ≤ 28 lines

```typescript
// app/api/tasks/route.ts
import { auth } from "@/lib/auth"
import { NextRequest, NextResponse } from "next/server"
import { z } from "zod"
import { taskService } from "@/features/tasks/task.service"

const QuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  status: z.enum(["draft", "active", "completed"]).optional(),
})

export async function GET(req: NextRequest): Promise<NextResponse> {
  const session = await auth()
  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  const query = QuerySchema.safeParse(
    Object.fromEntries(req.nextUrl.searchParams)
  )
  if (!query.success) {
    return NextResponse.json({ error: "Invalid parameters" }, { status: 400 })
  }

  try {
    const result = await taskService.list({ userId: session.user.id, ...query.data })
    return NextResponse.json(result)
  } catch (error) {
    console.error("[GET /api/tasks] failed:", { error })
    return NextResponse.json({ error: "Internal server error" }, { status: 500 })
  }
}
```

**Why correct:** Auth first, safeParse with 400, delegates entirely to service, 27 lines, generic error on 500.
