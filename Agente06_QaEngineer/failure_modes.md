# Agente06_QaEngineer — Failure Modes

This document catalogs the 10 known failure modes for the QA Engineer agent. Each entry includes the failure mode ID, symptom (how to detect it), root cause, corrective action, and related checklist.

---

## FM-01: Missing Tests for New Business Logic

**Symptom:** A Server Action, Route Handler, service function, or React component with significant interaction logic was submitted with no corresponding test file. The implementation report references files that have no `.test.ts` pair.

**Root Cause:** The Dev agent considered tests optional or deprioritized them under time pressure. The Definition of Done was not enforced before submission.

**Impact:** Gate 4 cannot be completed — there is nothing to evaluate. Code that is untested is code with unknown behavior in production.

**Gate 4 Response:** `BLOCKED_MISSING_TESTS`

**Corrective Action:**
1. List all files with no corresponding test file
2. Return the Handoff Package to the responsible Dev agent with the specific list
3. Do NOT attempt to infer coverage from other tests — missing tests are missing tests
4. When resubmission arrives, verify each listed file now has a test before re-evaluating

**Related Checklist:** `checklists/test_coverage_checklist.md`

---

## FM-02: Coverage Below Threshold

**Symptom:** Coverage report shows line coverage below 80% for new business logic files, or below 100% for auth paths / critical mutations. The Dev agent may claim "tests pass" without providing coverage numbers.

**Root Cause:** Tests exist but do not cover all branches and paths. Often: the happy path is tested but the error path, edge cases, and guard clauses are not.

**Impact:** Unexercised code paths will fail in production. Silent errors in rarely-triggered branches (which tend to be exactly the critical paths).

**Gate 4 Response:** `BLOCKED_QA_FAILURE`

**Corrective Action:**
1. Identify specifically which files and lines are uncovered from the coverage report
2. Return to Dev agent with the exact paths that need additional test cases
3. On resubmission, re-run coverage and verify thresholds are met before issuing APPROVED

**Related Checklist:** `checklists/test_coverage_checklist.md`

---

## FM-03: API Response Shape Mismatch

**Symptom:** The API endpoint's actual response body does not match the schema defined in `API_Contract.json`. May be missing fields, have extra fields, have wrong types, or use a different structure.

**Root Cause:** Implementation deviated from the contract, or the contract was updated without updating the implementation.

**Impact:** Frontend code relying on the contract breaks at runtime. TypeScript types generated from the contract are incorrect. Integration tests in other services fail.

**Gate 4 Response:** `BLOCKED_QA_FAILURE`

**Corrective Action:**
1. Document the exact difference: "API_Contract.json says `{ task: { id, title, status } }` but response returns `{ data: { id, name, state } }`"
2. Return to Agente04_DevBackend (if backend response is wrong) or escalate to Agente00 (if contract is wrong)
3. Do NOT unilaterally decide which is correct — that is an architecture decision

**Related Checklist:** `checklists/api_contract_validation_checklist.md`

---

## FM-04: Acceptance Criteria Not Testable

**Symptom:** The Given/When/Then format is absent, incomplete, or too vague to map to a test assertion. Example: "The system should work correctly" or "Users should see relevant information."

**Root Cause:** Acceptance criteria were written informally or with intentional ambiguity. Product owner did not write them to be testable.

**Impact:** QA cannot validate what "done" means. Any test written against ambiguous criteria is a guess, not a validation.

**Gate 4 Response:** `BLOCKED_MISSING_ACCEPTANCE_CRITERIA`

**Corrective Action:**
1. Identify the specific criteria that are untestable
2. Escalate to Agente00_TechLead, who escalates to Agente01_ProductOwner
3. Do NOT invent criteria — wait for clarification
4. Do NOT attempt to test ambiguous criteria "as best as possible" — that produces false confidence

**Related Checklist:** `checklists/acceptance_criteria_checklist.md`

---

## FM-05: Critical Bug Found (Auth Bypass, Data Loss, Security Vulnerability)

**Symptom:** A test or code review reveals: unauthenticated access to a protected endpoint, possibility of reading another user's data (IDOR), potential for data loss without confirmation, SQL injection possibility, session token exposed in logs.

**Root Cause:** Developer missed an auth check, ownership verification, or input sanitization. May be a systematic pattern across multiple handlers.

**Impact:** CRITICAL security risk. Could result in data breach, unauthorized data access, regulatory violation, or complete data loss for users.

**Gate 4 Response:** `BLOCKED_CRITICAL_RISK`

**Corrective Action:**
1. Issue `BLOCKED_CRITICAL_RISK` immediately — do not wait to complete the full evaluation
2. Escalate to Agente00_TechLead with the specific bug details
3. Also escalate to Agente07_DevSecOps for security review even before Gate 4 is passed
4. Return precise bug report to Agente04_DevBackend (backend issues) or Agente05_DevFrontend (frontend issues)
5. On resubmission, the specific security test must pass AND Agente07 must review the fix

**Related Checklist:** `checklists/failure_severity_checklist.md`

---

## FM-06: Flaky E2E Tests (Intermittent Failures)

**Symptom:** Playwright tests fail on some runs and pass on others without any code changes. The test produces different results when run in isolation vs. in the suite.

**Root Cause:** Test depends on timing (missing `await expect(...)`) , test state pollution from other tests, race conditions in async operations, hardcoded waits instead of proper assertions.

**Impact:** Flaky tests erode trust in the test suite. "It was just a flaky test" becomes the excuse for ignoring failures. Real bugs hide behind flakiness noise.

**Gate 4 Response:** `RETURNED_FOR_REVISION` (HIGH priority) — flaky tests must be fixed before APPROVED

**Corrective Action:**
1. Identify the specific test and the intermittent failure condition
2. Common fixes: replace `page.waitForTimeout(500)` with `await expect(element).toBeVisible()`, add `waitForResponse` for async operations, isolate test state with `beforeEach`
3. Mark the test in the bug report with `HIGH` severity — a flaky test is not a passing test
4. On resubmission, verify the test passes 5 consecutive runs before accepting it

**Related Checklist:** `checklists/qa_quality_checklist.md`

---

## FM-07: No Regression Test for Bug Fix

**Symptom:** A bug was reported in a previous QA cycle. The developer submitted a fix. The fix code is present but no regression test was added — no test that would fail if the bug were re-introduced.

**Root Cause:** Developer fixed the bug but did not follow the regression test requirement. "The bug won't come back" is assumed rather than enforced.

**Impact:** The same bug reappears in a future release when code is refactored or a dependency changes. Regression testing exists precisely to prevent this.

**Gate 4 Response:** `RETURNED_FOR_REVISION`

**Corrective Action:**
1. Identify which bug fixes from the previous cycle lack regression tests
2. Return to Dev agent with the requirement: "Add a test that fails when the bug condition exists and passes when the fix is in place"
3. On resubmission, verify the regression test is present and meaningful (not just `expect(true).toBe(true)`)

**Related Checklist:** `checklists/qa_quality_checklist.md`

---

## FM-08: Brittle Tests Coupled to Implementation Details

**Symptom:** Tests check that specific internal functions were called a certain number of times, verify internal state via private properties, or break when implementation is refactored without changing behavior.

**Root Cause:** Developer wrote "mock-heavy" tests that verify HOW the code works internally rather than WHAT it produces. Tests coupled to implementation details, not behavior.

**Impact:** Tests become a maintenance burden. Refactoring correct code breaks tests. The test suite reports failure when there is no real behavioral regression. Developers lose trust in the test suite and start ignoring failures.

**Gate 4 Response:** `RETURNED_FOR_REVISION`

**Signs of brittle tests:**
- `expect(internalHelper).toHaveBeenCalledTimes(3)`
- `expect(component.state.internalFlag).toBe(true)`
- Tests import internal utilities that are not part of the public API
- Tests break when the same behavior is refactored to use a different internal approach

**Corrective Action:**
1. Identify tests that check implementation internals rather than behavior
2. Return to Dev agent with refactoring guidance: "Test what the function returns and what side effects it produces — not which private helpers it calls"
3. For Playwright tests: verify selectors are role/label-based, not CSS/XPath-based

**Related Checklist:** `checklists/qa_quality_checklist.md`

---

## FM-09: QA Report Missing Mandatory Sections

**Symptom:** The QA Report produced by this agent is missing one or more of the 8 mandatory sections: gate decision, test summary, acceptance criteria coverage, API contract validation, accessibility results, bug list, regression analysis (on resubmissions), or sign-off checklist.

**Root Cause:** QA agent produced a partial report, possibly under time pressure or incomplete evaluation. This is a self-failure mode — the QA agent fails to produce a valid deliverable.

**Impact:** The gate decision is not actionable — Dev agents cannot fix what is not documented. Agente07_DevSecOps cannot proceed without a complete Gate 4 record. Audit trail is incomplete.

**Gate 4 Response:** Self-correction — the QA agent must not issue a gate decision until all sections are complete.

**Corrective Action:**
1. Do not issue a gate decision until all 8 mandatory sections are populated
2. If a section cannot be completed (e.g., accessibility data unavailable), document WHY it is missing and what it would take to complete it
3. An incomplete QA Report with a gate decision is worse than a delayed QA Report — the decision has no credibility without evidence

**Related Checklist:** `checklists/qa_quality_checklist.md`

---

## FM-10: Accessibility Violations in Primary User Flows

**Symptom:** Playwright accessibility tests fail: keyboard navigation skips interactive elements, focus is lost after modal closes, form inputs have no labels, error messages are not announced to screen readers, skip links are missing.

**Root Cause:** Frontend developer did not implement WCAG 2.1 AA accessibility requirements. May be systematic (no aria attributes anywhere) or isolated (one specific flow with a focus trap bug).

**Impact:** Users relying on assistive technology cannot use the product. This is a HIGH severity bug in primary flows (the user is blocked) and MEDIUM severity in secondary flows (workaround may exist).

**Gate 4 Response:**
- Primary flow affected: `BLOCKED_QA_FAILURE` (HIGH severity bug)
- Secondary flow affected: `RETURNED_FOR_REVISION` (MEDIUM severity bug)

**Corrective Action:**
1. Document the specific flow, the specific element, and the specific WCAG 2.1 AA criterion violated
2. Return to Agente05_DevFrontend with the specific issue
3. Common fixes: add `aria-label` to icon buttons, use `role="alert"` for error messages, manage focus after modal dismissal, add visible focus styles
4. On resubmission, run the full accessibility regression against the fixed flow

**Related Checklist:** `checklists/accessibility_regression_checklist.md`
