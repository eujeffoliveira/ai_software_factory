# Bad Output Example — backend-test-generation-skill

```typescript
// features/tasks/actions/createTask.test.ts — INSUFFICIENT
import { describe, it, expect } from "vitest"
import { createTask } from "@/features/tasks/actions/createTask"
// No mocks — will hit real DB and auth

describe("createTask", () => {
  // ONLY 1 test case — missing: unauthenticated, invalid input, error path
  it("creates a task", async () => {
    // No mock session — depends on real auth
    const result = await createTask({ title: "Test" })
    expect(result).toBeTruthy()  // vague assertion — doesn't verify specific fields
  })
})
```

| Violation | Impact | Fix |
|-----------|--------|-----|
| No mocks | Hits real DB (slow, brittle, CI-breaking) | Add `vi.mock("@/lib/auth")` etc. |
| Only 1 test | Auth/validation bugs undetected | Add null session, invalid input, error path tests |
| `expect(result).toBeTruthy()` | Doesn't verify actual return shape | `expect(result).toEqual(expect.objectContaining({ id: ..., title: ... }))` |
| No `beforeEach` cleanup | State leaks between tests | Add `vi.clearAllMocks()` in `beforeEach` |

**Gate 4 result:** BLOCKED_MISSING_TESTS
