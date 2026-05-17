# Bug Report — BUG-001

**Report ID:** BUG-001  
**QA Report:** QA-003-C1  
**Date:** 2026-05-17  
**Reported by:** Agente06_QaEngineer  

---

## Summary

| Field | Value |
|-------|-------|
| **Bug ID** | BUG-001 |
| **Severity** | CRITICAL |
| **Title** | Auth check absent — unauthenticated users can create tasks |
| **Component** | Task Management |
| **File** | `features/tasks/actions/createTask.ts` |
| **Line** | Line 8 (missing auth check) |
| **Responsible Agent** | Agente04_DevBackend |
| **Acceptance Criterion Violated** | AC-003 |
| **Regression Test Required** | YES |
| **Escalate to Security** | YES |

---

## Severity Rationale

**Why CRITICAL:**  
This is an authentication bypass. Any unauthenticated HTTP request can successfully execute the `createTask` Server Action and create a task record in the database. There is no session check anywhere in the function. An attacker can call this action without logging in, creating arbitrary task records associated with any user ID supplied in the request body (because `userId` is taken from input, not from session). This meets the CRITICAL criteria: auth bypass + unauthorized data mutation + IDOR via input-supplied userId.

---

## Description

The `createTask` Server Action in `features/tasks/actions/createTask.ts` is missing the mandatory first-line auth check (`const session = await auth()`). The function proceeds directly to Zod validation and then to the DAL insert without verifying that the caller is authenticated.

Additionally, the `userId` field is taken from the request input (`data.userId`) instead of from the session object. This means an unauthenticated caller can supply any `userId` and create tasks attributed to any user in the system.

This violates Operating Principle 5 (Auth check is always first) and Golden Path rule: "The very first operation in any Server Action is `const session = await auth()`."

---

## Reproduction Steps

1. Open the application in an incognito window (no active session)
2. Using the browser's DevTools or a REST client, send a POST request directly to the Server Action endpoint
3. Body: `{ "title": "Injected Task", "userId": "[any valid user ID]" }`
4. Observe: the request succeeds with `{ success: true, task: { id: "...", title: "Injected Task" } }`
5. Verify in the database: a new task record was created for the specified userId

**Alternatively (via test):**  
The failing Vitest test case is:
```
File: features/tasks/actions/__tests__/createTask.test.ts
Test: "returns Unauthorized when user is not authenticated"
Failure: Expected: { error: "Unauthorized" }
         Received: { success: true, task: { id: "...", title: "..." } }
```

---

## Expected Behavior

Per AC-003: When an unauthenticated user calls `createTask`, the action must return `{ error: "Unauthorized" }` and must NOT create any database record.

The `userId` must ALWAYS come from `session.user.id` (the authenticated session), never from the request input.

---

## Actual Behavior

The action executes successfully for unauthenticated callers. A task record is created in the database. The `userId` in the created record is whatever value was passed in the request body.

---

## Test That Found This Bug

```
File: features/tasks/actions/__tests__/createTask.test.ts
Test: "returns Unauthorized when user is not authenticated"
Failure: Expected { error: "Unauthorized" }, received { success: true, task: {...} }
```

---

## Recommendation

1. Add `const session = await auth()` as the **absolute first line** of the `createTask` function body (before Zod validation, before any other code)
2. Immediately after: `if (!session?.user?.id) { return { error: "Unauthorized" } }`
3. Remove `userId` from the Zod input schema — it must not be a user-supplied field
4. Replace all references to `data.userId` with `session.user.id`
5. Verify: the test `"returns Unauthorized when user is not authenticated"` passes after the fix

Reference: `context_view.md` Section 2 (Server Action Pattern), `Agente04_DevBackend/context_view.md` Section 3 (Server Action Pattern line 1-2).

---

## Regression Test Requirement

When this fix is submitted, include a regression test named:

```typescript
it("does not create task for unauthenticated caller — regression for BUG-001", async () => {
  // Arrange: no session
  vi.mocked(auth).mockResolvedValue(null)
  
  // Act
  const result = await createTask({ title: "Should not be created" })
  
  // Assert: rejected, no DB call made
  expect(result).toEqual({ error: "Unauthorized" })
  expect(taskDAL.create).not.toHaveBeenCalled()
})
```

This test must FAIL when the auth check is absent, and PASS after the fix. Commit the test alongside the fix.

---

*This bug report is produced by Agente06_QaEngineer as part of Gate 4 (QA Review — QA-003-C1). Agente04_DevBackend must address this CRITICAL bug before resubmitting. Tech Lead has been notified per escalation policy.*
