# Acceptance Validation Report — [Feature / Sprint Name]

**Report ID:** AV-[NNN]-C[cycle]  
**QA Report:** QA-[NNN]-C[cycle]  
**PRD Version:** [version or document reference]  
**Date:** YYYY-MM-DD  
**Evaluator:** Agente06_QaEngineer  

---

## Overview

This report maps every acceptance criterion defined in the PRD for this feature to specific test cases. It is the primary evidence that the implementation meets the product requirements.

**Total criteria:** [N]  
**Passed:** [N]  
**Failed:** [N]  
**No test:** [N]  
**Ambiguous:** [N]  

---

## Criterion Coverage Table

| Criterion ID | Given | When | Then | Test File | Test Name | Status | Notes |
|-------------|-------|------|------|-----------|-----------|--------|-------|
| AC-001 | [User is authenticated] | [Submits valid task form] | [Task is created] | `features/tasks/__tests__/createTask.test.ts` | `creates task when authenticated user submits valid data` | PASSED | — |
| AC-001 | [User is authenticated] | [Submits valid task form] | [Audit log is recorded] | `features/tasks/__tests__/createTask.test.ts` | `creates task when authenticated user submits valid data` | PASSED | Same test, second Then clause |
| AC-002 | [User is authenticated] | [Submits empty form] | [Validation error shown] | `e2e/tasks/create-task.spec.ts` | `shows validation error when required field is missing` | PASSED | — |
| AC-003 | [User is unauthenticated] | [Accesses task creation page] | [Redirected to login] | `e2e/auth/protected-routes.spec.ts` | `redirects to login when unauthenticated user visits /tasks/new` | PASSED | — |
| AC-004 | [User owns the task] | [Clicks delete] | [Task is deleted] | `features/tasks/__tests__/deleteTask.test.ts` | `deletes task and records audit log` | PASSED | — |
| AC-005 | [User does not own the task] | [Attempts to delete it] | [403 returned] | `features/tasks/__tests__/deleteTask.test.ts` | `returns 403 when user attempts to delete another user task` | PASSED | — |

---

## Ambiguous Criteria

> Criteria that are too vague to map to a test assertion. These require clarification from Agente01_ProductOwner before testing can proceed.

| Criterion ID | Original Text | Why Ambiguous | Clarification Needed |
|-------------|--------------|--------------|---------------------|
| AC-[NNN] | "[Paste the original criterion text]" | [Explain why it cannot be tested: no measurable outcome, undefined "correctly", missing Given or Then clause, etc.] | [What specific clarification is needed from the product owner] |

---

## Criteria Without Tests

> Criteria for which no test was found in the submitted implementation.

| Criterion ID | Description | Required Test Type | Blocking |
|-------------|-------------|-------------------|----------|
| AC-[NNN] | [Description of the criterion] | Vitest / Playwright / Either | YES |

**Impact on Gate 4:** Criteria without tests → `BLOCKED_MISSING_TESTS`

---

## Failing Criteria

> Criteria for which a test exists but the test is failing.

| Criterion ID | Then Clause | Test Name | Failure Message | Severity | Bug ID |
|-------------|-------------|-----------|-----------------|----------|--------|
| AC-[NNN] | [The Then clause that failed] | `[test name]` | [Failure message from test runner] | [CRITICAL/HIGH/MEDIUM/LOW] | BUG-[NNN] |

---

## Methodology

**How criteria are mapped:**

Each acceptance criterion is parsed into its Given/When/Then clauses. Each `Then` clause represents an observable outcome that must have at least one corresponding test assertion. The mapping follows this pattern:

```
Given [precondition]     → test arrange phase (mock setup)
When  [action]           → test act phase (function/action call)
Then  [outcome A]        → expect(result.fieldA).toBe(expectedA)
Then  [outcome B]        → expect(auditLog).toHaveBeenCalledWith(...)
Then  [outcome C]        → Playwright: await expect(page.getByRole("alert")).toContainText(...)
```

Multiple `Then` clauses may be validated in a single test case, or across multiple test cases, as long as each clause has at least one test assertion.

---

*Acceptance Validation Report produced by Agente06_QaEngineer as part of Gate 4 (QA Review). Every acceptance criterion must reach PASSED status for Gate 4 to issue APPROVED.*
