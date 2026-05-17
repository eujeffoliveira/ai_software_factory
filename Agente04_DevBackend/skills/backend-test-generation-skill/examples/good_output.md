# Good Output Example — backend-test-generation-skill

```typescript
// features/tasks/actions/createTask.test.ts
import { describe, it, expect, vi, beforeEach } from "vitest"
import { createTask } from "@/features/tasks/actions/createTask"
import { taskDal } from "@/lib/db/task.dal"
import { auth } from "@/lib/auth"
import { auditLog } from "@/lib/audit"

vi.mock("@/lib/auth")
vi.mock("@/lib/db/task.dal")
vi.mock("@/lib/audit")

const mockSession = { user: { id: "user-1", email: "user@example.com" } }
const validInput = { title: "Test Task", priority: 3 }
const mockTask = { id: "task-1", title: "Test Task", priority: 3, userId: "user-1", createdAt: new Date() }

describe("createTask", () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.mocked(auth).mockResolvedValue(mockSession as any)
  })

  it("throws Unauthorized when session is null", async () => {
    vi.mocked(auth).mockResolvedValue(null)
    await expect(createTask(validInput)).rejects.toThrow("Unauthorized")
    expect(taskDal.create).not.toHaveBeenCalled()
  })

  it("throws when title is empty string", async () => {
    await expect(createTask({ title: "" })).rejects.toThrow()
    expect(taskDal.create).not.toHaveBeenCalled()
  })

  it("returns created task on valid input", async () => {
    vi.mocked(taskDal.create).mockResolvedValue(mockTask as any)
    const result = await createTask(validInput)
    expect(result).toEqual(mockTask)
    expect(auditLog).toHaveBeenCalledWith(
      expect.objectContaining({ actorId: "user-1", action: "TASK_CREATED" })
    )
  })

  it("throws generic error when DAL fails", async () => {
    vi.mocked(taskDal.create).mockRejectedValue(new Error("DB error"))
    await expect(createTask(validInput)).rejects.toThrow("Failed to create task.")
    await expect(createTask(validInput)).rejects.not.toThrow("DB error")
  })
})
```

**Why correct:** 4 required cases, all dependencies mocked, auth null test verifies DAL not called, error test verifies generic (not raw) message.
