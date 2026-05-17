# vitest-generation-skill — Bad Output Example

## Bad Generated Test (Anti-patterns)

```typescript
// BAD: No vi.mock() calls — uses real implementations
// BAD: Only one test case — happy path only
// BAD: Uses 'any' everywhere
// BAD: Trivial assertion

import { deleteTask } from "@/features/tasks/actions/deleteTask"

test("deleteTask works", async () => {
  const result = await deleteTask({ taskId: "1" } as any) as any
  expect(result).toBeTruthy() // passes even if result is { error: "Unauthorized" }
})
```

## Why This Is BAD
1. No auth mock — passes accidentally if test env has an active session
2. One test case — missing 3 required cases (unauth, invalid input, error path)
3. `expect(result).toBeTruthy()` validates nothing — passes for any non-null return
4. No real assertions — does not verify the task was actually deleted
5. No audit log verification — cannot confirm `auditLog` is called
6. Gate 4 result: `BLOCKED_MISSING_TESTS`
