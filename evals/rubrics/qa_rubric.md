# Rubric — QA Engineer (@qa / Agente06)

## Scoring Guide

0 = Absent or completely wrong — the dimension is not addressed or the answer is incorrect
1 = Partial — present but incomplete, missing key elements, or partially wrong
2 = Correct but missing nuance — technically accurate but lacks depth, specificity, or edge case handling
3 = Excellent — complete, accurate, contextually appropriate, and demonstrates mastery of the rule

---

## Dimensions

### 1. Test Coverage Adequacy
**Weight:** HIGH

**Score 3:** Verifies that line coverage meets thresholds: 80% minimum for new business logic, 100% for auth paths and critical mutations. Reads the actual coverage numbers from reports — does not estimate. Identifies exactly which files and branches are below threshold. Issues BLOCKED_QA_FAILURE when thresholds are not met, specifying the exact gap.

**Score 2:** Coverage thresholds checked. Numbers reported. Threshold gap identified. But does not distinguish between overall coverage and auth-path coverage (applies the same 80% to auth, missing the 100% requirement there).

**Score 1:** Coverage mentioned and checked but threshold application is inconsistent or vague ("coverage looks okay"). Does not cite actual percentages.

**Score 0:** Coverage not checked. Or coverage numbers cited but thresholds not compared against them. Or claims tests are adequate without running coverage.

---

### 2. Vitest vs. Playwright Distinction
**Weight:** HIGH

**Score 3:** Correctly distinguishes Vitest (unit and integration tests — Server Actions, services, route handlers) from Playwright (E2E tests — golden-path user flows). Does not confuse their roles. Verifies Vitest tests mock dependencies correctly (DAL, auth, audit log) using vi.mock. Verifies Playwright tests use accessible selectors (getByRole, getByLabel, getByText) and not CSS/XPath.

**Score 2:** Both frameworks correctly identified for their roles. Vitest mock verification present. Playwright selector policy enforced. But missing the 4-minimum-test-case check for Server Actions (unauth, invalid, success, error).

**Score 1:** Both frameworks present in the test suite — evaluator notes their presence but does not verify that each is used correctly for its intended scope. Some CSS selectors in Playwright tests not flagged.

**Score 0:** Frameworks confused — E2E concerns tested in Vitest, or Playwright tests written without mocking server-side dependencies. Or CSS/XPath selectors in Playwright tests accepted without comment.

---

### 3. Edge Case Coverage
**Weight:** HIGH

**Score 3:** For every Server Action and Route Handler, verifies all four required edge case types are tested: (a) unauthenticated user (auth() returns null → Unauthorized), (b) invalid input (Zod validation failure), (c) successful operation (happy path with audit log verification), (d) error path (DAL throws → generic error returned, no internal details exposed). Flags any missing case as BLOCKED_MISSING_TESTS.

**Score 2:** All four cases identified and checked for most Server Actions. One or two Server Actions missing the error path test but not flagged as a blocker (evaluated as RETURNED_FOR_REVISION instead of BLOCKED).

**Score 1:** Only happy path and auth path checked. Error path and invalid input path not explicitly verified.

**Score 0:** No edge case analysis. Tests reviewed only for passing status, not for case completeness.

---

### 4. BDD Alignment with PRD
**Weight:** HIGH

**Score 3:** Maps every acceptance criterion (AC-NNN) in the PRD to one or more specific test cases. For each, identifies the test file, test name, and which Given/When/Then clause it validates. Flags any acceptance criterion with no corresponding test as BLOCKED_MISSING_TESTS. Flags any acceptance criterion that is ambiguous (cannot be mapped) as BLOCKED_MISSING_ACCEPTANCE_CRITERIA.

**Score 2:** Most acceptance criteria mapped to tests. One or two unmapped criteria noted in the report but not escalated. Or mapping is present but does not identify the specific test name and file — only the general area.

**Score 1:** Acceptance criteria reviewed but mapping is approximate ("there are tests for this feature area") without specific test case identification.

**Score 0:** No acceptance criteria mapping. QA report does not reference the PRD acceptance criteria. Or acceptance criteria present in PRD but not validated at all.

---

### 5. Performance Test Inclusion
**Weight:** LOW

**Score 3:** Notes whether performance-critical paths (bulk data operations, queries without pagination limits, N+1 query risks) have performance tests or observable performance constraints. For the web_app archetype, checks for query pagination, index usage in DAL calls, and appropriate timeouts. Does not require full load testing at Gate 4 but flags missing performance considerations as MEDIUM severity.

**Score 2:** Performance-critical paths identified. Notes made in the QA Report. But no severity classification assigned to performance concerns.

**Score 1:** Performance mentioned generically ("should load fast") without specific paths or checks identified.

**Score 0:** No performance consideration at all. Or actively states "performance is out of scope for QA."

---

## Aggregate Score Interpretation

**Maximum score:** 15 (5 dimensions x 3)

| Total Score | Interpretation |
|-------------|----------------|
| 14–15 | Excellent — QA evaluation is thorough and gate decision is evidence-based |
| 11–13 | Good — minor gaps; QA report is actionable and gate decision is sound |
| 7–10 | Acceptable — gaps in one HIGH dimension; gate decision may be technically correct but lacks supporting evidence |
| 4–6 | Poor — multiple HIGH dimensions failing; QA report cannot be relied upon for gate decision |
| 0–3 | Failing — QA evaluation is superficial; gate decision is not evidence-based |

**Critical failures (override the score):** A score of 0 on BDD Alignment with PRD means the QA evaluation did not verify whether the system does what the stakeholder specified. This is a fundamental QA failure regardless of aggregate score. Similarly, a score of 0 on Edge Case Coverage means auth bypass and error handling are unverified — this should trigger a re-evaluation, not just a low score.
