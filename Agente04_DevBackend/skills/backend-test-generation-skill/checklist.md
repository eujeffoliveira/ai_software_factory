# backend-test-generation-skill — Execution Checklist

---

## Setup

- [ ] `vi.mock("@/lib/auth")` present
- [ ] `vi.mock("@/lib/db/[model].dal")` present
- [ ] `vi.mock("@/lib/audit")` present (if source uses auditLog)
- [ ] `vi.clearAllMocks()` in `beforeEach`
- [ ] Default mock: `vi.mocked(auth).mockResolvedValue(mockSession)` in beforeEach

## Required Test Cases

- [ ] Test 1: null session → throws "Unauthorized" (or 401 for route handlers)
  - Verify DAL was NOT called
- [ ] Test 2: invalid input → throws (ZodError or similar)
  - Verify DAL was NOT called
- [ ] Test 3: success path → returns expected result
  - Verify DAL called with correct arguments
  - Verify auditLog called (if applicable)
- [ ] Test 4: error path → generic error (not raw DB error)
  - Verify error message does NOT expose internals

## Test Quality

- [ ] Descriptions use `it("throws X when Y")` format
- [ ] No real DB or external API calls
- [ ] Assertions on function behavior, not on console.error counts

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md`, `templates/Backend_Test_Template.ts`, `knowledge/decision_rules.md` (DR010).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
