# Agente06_QaEngineer — Knowledge Cards

> Distilled from build-time bibliography. Each card is a self-contained reference for a key concept used in QA evaluation. Consult at runtime when applying the corresponding technique.

---

## Card 001 — The Red-Green-Refactor Cycle

**Source:** TDD by Example (Beck) — Chapters 1-5

The fundamental TDD cycle is three steps:
1. **Red** — Write a failing test that describes the desired behavior
2. **Green** — Write the minimum code to make the test pass
3. **Refactor** — Improve the code structure without changing behavior (tests must still pass)

**QA relevance:** When reviewing test quality, check whether tests were written before or alongside implementation. Tests written after the fact tend to be weaker — they are written to pass existing code rather than to specify desired behavior.

**Applied check:** Are the test names written in the language of requirements (what should happen) or in the language of implementation (how it was built)?

---

## Card 002 — The Four Pillars of a Good Unit Test

**Source:** Unit Testing Principles, Practices, and Patterns (Khorikov) — Chapter 4

A good unit test must have all four properties:
1. **Protection against regressions** — Detects bugs when code changes break behavior
2. **Resistance to refactoring** — Does not break when code is refactored without behavior change
3. **Fast feedback** — Runs quickly (milliseconds, not seconds)
4. **Maintainability** — Easy to read, understand, and modify

**QA relevance:** Tests that fail property 2 (brittle tests) are FM-08. Tests that fail property 1 (no assertions) are FM-09 equivalents in test quality. Resistance to refactoring is the hardest property — it requires testing behavior, not implementation.

**Anti-pattern indicator:** A test that mocks every internal function to verify call counts fails property 2. It will break on every refactoring even when behavior is identical.

---

## Card 003 — Test Doubles Taxonomy

**Source:** Growing Object-Oriented Software, Guided by Tests (Freeman & Pryce) — Chapter 13; Unit Testing (Khorikov) — Chapter 8

There are 5 types of test doubles. Understanding them prevents misuse:

| Type | How it works | When to use |
|------|-------------|-------------|
| **Stub** | Returns predefined values for queries | When you need to control inputs to the unit under test (e.g., DAL returns specific data) |
| **Mock** | Verifies calls were made (checked by test) | When testing a command — e.g., `expect(auditLog).toHaveBeenCalledWith(...)` |
| **Spy** | Records calls for later verification | Similar to mock, but using Vitest `vi.spyOn` |
| **Fake** | Simplified implementation that works | An in-memory DB used in integration tests |
| **Dummy** | Placeholder passed but never used | An argument that satisfies a type but is irrelevant to the test |

**QA relevance:** Overusing mocks (verifying every call count) couples tests to implementation. Use stubs to control state. Use mocks only to verify the one meaningful side effect (e.g., auditLog was called with correct params).

---

## Card 004 — Characterization Tests for Legacy Code

**Source:** Working Effectively with Legacy Code (Feathers) — Chapter 2, Chapter 13

When existing code has no tests and must be changed, write characterization tests before making changes:

1. Write a test that calls the legacy function with known inputs
2. Run it — it will fail with some unexpected output
3. Change the assertion to match what the code currently does
4. Now you have a characterization test — it documents existing behavior
5. Add new behavior tests for the desired change
6. Make the change — existing characterization tests will catch regressions

**QA relevance:** Any PR that modifies previously untested code must include characterization tests in addition to the new behavior tests. If the Implementation Report modifies legacy code without adding characterization tests, return as `BLOCKED_MISSING_TESTS`.

---

## Card 005 — Seam Model for Breaking Dependencies

**Source:** Working Effectively with Legacy Code (Feathers) — Chapter 4

A seam is a place in the code where behavior can be changed without modifying the code itself. The two main types in our context:

- **Object seam**: Inject a dependency through the constructor or parameter (instead of instantiating it inside)
- **Link seam**: Mock at the module level (Vitest `vi.mock()`)

**QA relevance:** In the Golden Path, the DAL is the primary seam. `vi.mock("@/lib/db/[model].dal")` is a link seam that makes Server Actions testable without hitting the real database. If tests hit the real DB, they are not using the seam correctly — return for revision.

---

## Card 006 — London vs. Detroit Schools of TDD

**Source:** Unit Testing Principles, Practices, and Patterns (Khorikov) — Chapter 3 (Mocks and test fragility)

Two philosophies of unit testing:

| School | Mock strategy | Test style |
|--------|--------------|-----------|
| **London (Mockist)** | Mock all collaborators | Tests one object in complete isolation, verifies interactions |
| **Detroit (Classical)** | Use real objects where possible, mock only external I/O | Tests a cluster of objects together, verifies outcomes |

The Golden Path uses a pragmatic combination:
- Mock external I/O (DB via DAL, auth, external APIs, audit log)
- Use real Zod schemas (not mocked)
- Use real business logic (not mocked)

**QA relevance:** Tests that mock domain logic (services calling other services) are over-mocked. Tests that skip mocking of DB or auth are under-mocked. Find the right seam (Card 005) at the I/O boundary.

---

## Card 007 — Given/When/Then Anatomy

**Source:** GOOS (Freeman & Pryce) — Chapter 2; BDD practices

The Given/When/Then format maps directly to test structure:

```
Given [system state / preconditions]   → arrange (setup: mocks, initial state)
When  [user/system action]             → act    (call the function under test)
Then  [expected outcome]               → assert (verify return value, side effects)
```

Example mapping:
```
AC-003: Given the user is authenticated
        When they submit a task with title "Q4 Report" and valid data
        Then a task record is created in the database
        And an audit_log entry is recorded
        And the response returns { success: true, task: { id, title } }
```

Maps to:
- `it("creates task and records audit log when authenticated user submits valid data")`
- Arrange: mock `auth()` returning valid session, mock `taskDAL.create` returning `{ id: "1", title: "Q4 Report" }`
- Act: `const result = await createTask({ title: "Q4 Report" })`
- Assert: `expect(taskDAL.create).toHaveBeenCalledWith(...)`, `expect(auditLog).toHaveBeenCalledWith(...)`, `expect(result.task.title).toBe("Q4 Report")`

---

## Card 008 — API Contract Testing Checklist (Per Endpoint)

**Source:** API contract testing best practices; Módulo 06 — Teste de Software I

For every endpoint in `API_Contract.json`, verify all of the following:

| Check | Test type | What to look for |
|-------|----------|-----------------|
| Happy path status code | Vitest with supertest | `expect(response.status).toBe(200)` or 201/204 |
| Unauthenticated → 401 | Vitest with supertest | No session → `expect(response.status).toBe(401)` |
| Invalid body → 400 | Vitest with supertest | Bad Zod schema → `expect(response.status).toBe(400)` |
| Response shape | Zod parse | `const result = ResponseSchema.safeParse(body); expect(result.success).toBe(true)` |
| Error format | Check body | Error body is `{ error: "string" }` — not `{ message, stack, code }` |
| 403 for wrong owner | Vitest with supertest | Authenticated but accessing another user's resource → 403 or 404 |

---

## Card 009 — Playwright Page Object Pattern

**Source:** Playwright official documentation; GOOS (Freeman & Pryce) — Chapter 20 (higher-level DSL for tests)

For complex multi-step flows, the Page Object pattern reduces duplication and makes tests readable:

```typescript
// page-objects/TaskFormPage.ts
export class TaskFormPage {
  constructor(private page: Page) {}

  async navigate() {
    await this.page.goto("/tasks/new")
  }

  async fillTitle(title: string) {
    await this.page.getByLabel("Task Title").fill(title)
  }

  async submit() {
    await this.page.getByRole("button", { name: "Create Task" }).click()
  }

  async getSuccessMessage() {
    return this.page.getByRole("alert").textContent()
  }
}
```

**QA relevance:** If E2E tests have duplicate selector calls across multiple tests for the same page, recommend the Page Object pattern. Not required for simple flows, but essential for complex multi-step tests.

---

## Card 010 — Coverage Tool Usage with Vitest

**Source:** Vitest documentation; Módulo 07 — Teste de Software II

Running Vitest coverage:
```bash
npx vitest run --coverage
```

Coverage report is generated in `coverage/` folder. Key files:
- `coverage/index.html` — visual report
- `coverage/lcov.info` — machine-readable (used by CI)
- Console output shows per-file coverage summary

**Reading the coverage report:**
- `% Stmts` — statement coverage (lines executed)
- `% Branch` — conditional branch coverage (if/else, ternary)
- `% Funcs` — function coverage (functions called at all)
- `% Lines` — line coverage (distinct lines hit)

**QA threshold check:** Gate 4 uses `% Lines` (line coverage) as the primary threshold. However, low `% Branch` on auth checks and error handlers is a HIGH severity finding even when `% Lines` meets the threshold.

---

## Card 011 — ISO 25010 Quality Characteristics Mapped to Gate 4

**Source:** Módulo 09 — Qualidade de Software II; ISO/IEC 25010:2011

Gate 4 validates these ISO 25010 sub-characteristics:

| ISO 25010 Sub-characteristic | What QA validates |
|-----------------------------|-------------------|
| Functional completeness | All acceptance criteria have passing tests |
| Functional correctness | Tests verify correct outputs for defined inputs |
| Functional appropriateness | API contract matches PRD requirements |
| Fault tolerance | Error paths tested — system handles errors gracefully |
| Recoverability | No unrecoverable state on partial failure |
| Confidentiality | Auth checks present, no data leakage across user boundaries |
| Integrity | Data mutations have audit logs; no partial writes without rollback |
| Accessibility | WCAG 2.1 AA checks in primary flows |
| Testability | Test coverage metrics meet thresholds |

**QA implication:** When writing the QA Report summary, framing findings in ISO 25010 terms strengthens the report's professional credibility and connects findings to recognized quality standards.

---

## Card 012 — Vitest Mock Patterns Quick Reference

**Source:** Vitest documentation; Unit Testing (Khorikov) — Chapter 8

```typescript
// Mock entire module
vi.mock("@/lib/db/task.dal", () => ({
  taskDAL: {
    create: vi.fn(),
    findById: vi.fn(),
    update: vi.fn(),
    delete: vi.fn(),
  },
}))

// Reset between tests
beforeEach(() => {
  vi.clearAllMocks()  // Clears call history but keeps mock implementation
  // vs
  vi.resetAllMocks()  // Resets to undefined return value
  // vs
  vi.restoreAllMocks() // Restores original implementation (use with vi.spyOn)
})

// Control mock return value per test
const dal = await import("@/lib/db/task.dal")
vi.mocked(dal.taskDAL.create).mockResolvedValue({ id: "1", title: "Test" } as any)

// Verify mock was called
expect(dal.taskDAL.create).toHaveBeenCalledWith(
  expect.objectContaining({ title: "Test" })
)
expect(dal.taskDAL.create).toHaveBeenCalledTimes(1)

// Simulate error
vi.mocked(dal.taskDAL.create).mockRejectedValue(new Error("DB connection failed"))
```

**QA usage:** When generating Vitest tests (vitest-generation-skill), use `mockResolvedValue` for success cases and `mockRejectedValue` for error cases. Always `vi.clearAllMocks()` in `beforeEach`.
