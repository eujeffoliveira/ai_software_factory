# vitest-generation-skill — Good Output Example

## Input
- function_name: `deleteTask`
- file_path: `features/tasks/actions/deleteTask.ts`
- acceptance_criteria: ["AC-004", "AC-005"]

## Generated Test File

```typescript
// features/tasks/actions/__tests__/deleteTask.test.ts
import { describe, it, expect, vi, beforeEach } from "vitest"
import { deleteTask } from "@/features/tasks/actions/deleteTask"

vi.mock("@/lib/db/task.dal", () => ({
  taskDAL: { findById: vi.fn(), delete: vi.fn() }
}))
vi.mock("@/lib/audit", () => ({ auditLog: vi.fn() }))
vi.mock("next-auth", () => ({ auth: vi.fn() }))

describe("deleteTask Server Action", () => {
  const mockSession = { user: { id: "user-test-001", email: "user@organization.com" }, expires: "2099-12-31" }

  beforeEach(() => { vi.clearAllMocks() })

  it("returns Unauthorized when user is not authenticated", async () => {
    const { auth } = await import("next-auth")
    vi.mocked(auth).mockResolvedValue(null)
    const result = await deleteTask({ taskId: "task-1" })
    expect(result).toEqual({ error: "Unauthorized" })
    const { taskDAL } = await import("@/lib/db/task.dal")
    expect(taskDAL.delete).not.toHaveBeenCalled()
  })

  // ...3 more test cases
})
```

## Output
```json
{
  "test_file_path": "features/tasks/actions/__tests__/deleteTask.test.ts",
  "test_cases_count": 5,
  "mocks_applied": ["next-auth", "@/lib/db/task.dal", "@/lib/audit"],
  "acceptance_criteria_covered": ["AC-004", "AC-005"]
}
```
