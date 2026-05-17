# Backend Test Checklist

**When to run:** After implementing any Server Action or Route Handler.  
**Purpose:** Ensure test coverage meets Definition of Done requirements.

---

## File Creation

- [ ] Test file created for every Server Action in this task
- [ ] Test file created for every Route Handler in this task
- [ ] Test file is in the same directory as the source OR in `__tests__/[domain]/`
- [ ] Test file name follows convention: `[source-file-name].test.ts`

## Mocks

- [ ] `@/lib/auth` is mocked: `vi.mock("@/lib/auth")`
- [ ] DAL modules are mocked: `vi.mock("@/lib/db/[model].dal")`
- [ ] `@/lib/audit` is mocked (if source calls auditLog): `vi.mock("@/lib/audit")`
- [ ] `@/lib/sync` is mocked (if source calls syncLog): `vi.mock("@/lib/sync")`
- [ ] External integration clients are mocked: `vi.mock("@/lib/integrations/[service].client")`
- [ ] `vi.clearAllMocks()` called in `beforeEach` — prevents state leakage between tests

## Required Test Cases

For every Server Action:
- [ ] **Unauthenticated**: `auth()` returns null → action throws "Unauthorized"
  - Verify DAL was NOT called
- [ ] **Invalid input**: empty string, missing required field, wrong type → action throws ZodError or similar
  - Verify DAL was NOT called
- [ ] **Success path**: valid input, DAL returns mock result → action returns expected result
  - Verify DAL called with correct arguments
  - Verify `auditLog()` called with correct `action` and `entityId` (if applicable)
- [ ] **Error path**: DAL throws → action throws GENERIC error (not the raw DB error)
  - Verify the thrown error message does NOT expose internal error details

For every Route Handler:
- [ ] **Unauthenticated**: `auth()` returns null → 401 response
- [ ] **Invalid params/body**: malformed query or body → 400 response
- [ ] **Success path**: valid request → 200/201 with correct response body
  - Verify service/action called with correct arguments
- [ ] **Error path**: service throws → 500 with `{ error: "Internal server error" }`

## Test Quality

- [ ] Test descriptions use `it("does X when Y")` format — describes behavior, not implementation
- [ ] No `it("test 1")` or `it("should work")` — descriptions must be specific
- [ ] No assertions on `console.error` call count — test behavior, not logging
- [ ] No real DB calls — all DB operations mocked
- [ ] No real external API calls — all external clients mocked
- [ ] `expect` assertions match actual function behavior (not just "truthy")

## Authorization Test Cases (When Applicable)

- [ ] Test for IDOR: authenticated user tries to access another user's resource → 403 or "Forbidden"

## Coverage Verification

- [ ] Count test cases matches: `[number] tests` in the describe block summary
- [ ] Each acceptance criterion from the task spec has at least one corresponding test

---

## Test File Structure Reference

```typescript
// Standard Vitest test file structure
import { describe, it, expect, vi, beforeEach } from "vitest"

// Import the function under test
// Import mocked dependencies

vi.mock("@/lib/auth")
vi.mock("@/lib/db/[model].dal")
vi.mock("@/lib/audit")

describe("[functionName]", () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.mocked(auth).mockResolvedValue(mockSession)
  })

  it("throws Unauthorized when session is null", async () => { ... })
  it("throws when [field] is empty", async () => { ... })
  it("returns [result] on valid input", async () => { ... })
  it("throws generic error when DAL fails", async () => { ... })
})
```

---

## Runtime Knowledge Policy

This checklist is part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, or global architecture documents.  
All required patterns are in `context_view.md`, `templates/Backend_Test_Template.ts`, and `knowledge/decision_rules.md` (DR010).
