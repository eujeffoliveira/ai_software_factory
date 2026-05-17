# Bad Output Example — nextjs-route-handler-skill

**Task:** Implement GET /api/tasks route handler  
**Result:** 4 violations — FM-01, FM-02, FM-03, FM-10

```typescript
// app/api/tasks/route.ts — FAT HANDLER (45+ lines)
import { NextRequest, NextResponse } from "next/server"
import { prisma } from "@/lib/db/prisma"  // WRONG: direct prisma import (FM-01)

export async function GET(req: NextRequest) {
  // MISSING: auth check (FM-03) — any request proceeds
  const userId = req.nextUrl.searchParams.get("userId")  // WRONG: no Zod (FM-02)
  const page = parseInt(req.nextUrl.searchParams.get("page") ?? "1")  // no validation

  try {
    // WRONG: business logic + DB call in route.ts (FM-01)
    const tasks = await prisma.task.findMany({
      where: { userId: userId ?? undefined },
      skip: (page - 1) * 20,
      take: 20,
    })
    const total = await prisma.task.count({ where: { userId: userId ?? undefined } })
    return NextResponse.json({ tasks, total })
  } catch (error: any) {
    // WRONG: exposes error.message to client (FM-10)
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
```

| Violation | FM | Fix |
|-----------|-----|-----|
| No auth check | FM-03 | Add `await auth()` as first line |
| No Zod validation | FM-02 | Add `QuerySchema.safeParse(...)` |
| DB logic in route.ts | FM-01 | Delegate to `taskService.list()` |
| `error.message` in response | FM-10 | Return `{ error: "Internal server error" }` |
