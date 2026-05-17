# vitest-generation-skill — Execution Checklist

## Setup

- [ ] `vi.mock("next-auth", ...)` with `auth: vi.fn()` present
- [ ] `vi.mock("@/lib/db/[model].dal", ...)` for all DAL dependencies
- [ ] `vi.mock("@/lib/audit", ...)` if function calls auditLog
- [ ] Mock session object defined with generic identifiers (not real org names)
- [ ] `vi.clearAllMocks()` in `beforeEach`

## Required Test Cases (minimum 4)

- [ ] Test 1: `auth()` returns null → returns `{ error: "Unauthorized" }` AND DAL not called
- [ ] Test 2: Authenticated + invalid input → validation error AND DAL not called
- [ ] Test 3: Authenticated + valid input → success result + DAL called with correct args + auditLog called
- [ ] Test 4: Authenticated + valid input + DAL throws → generic error (no DB details in response)

## Test Quality

- [ ] Test names describe behavior: `"returns X when Y"`
- [ ] No `any` type assertions that bypass safety checks
- [ ] Tests verify behavior (return values, auditLog call) not implementation internals
- [ ] Error path test explicitly asserts the error does NOT contain internal DB details

## Acceptance Criteria Coverage

- [ ] Each AC-NNN input is covered by at least one test assertion

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 2 (Vitest Patterns), `knowledge/decision_rules.md` (DR001, DR016, DR017), `templates/Vitest_Test_Template.ts`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
