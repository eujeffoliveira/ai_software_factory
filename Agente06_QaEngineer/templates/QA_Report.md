# QA Report — [Feature / Sprint Name]

**Report ID:** QA-[NNN]-C[cycle]  
**Evaluation Cycle:** [1 = first submission, 2 = resubmission, etc.]  
**Date:** YYYY-MM-DD  
**Evaluator:** Agente06_QaEngineer  
**Backend PR:** [PR reference]  
**Frontend PR:** [PR reference]  

---

## 1. Gate Decision

| Field | Value |
|-------|-------|
| **Gate 4 Status** | `[APPROVED / RETURNED_FOR_REVISION / BLOCKED_MISSING_TESTS / BLOCKED_QA_FAILURE / BLOCKED_MISSING_ACCEPTANCE_CRITERIA / BLOCKED_CRITICAL_RISK]` |
| **Decision Rationale** | [One to three sentences with specific evidence. Reference test names, coverage %, bug IDs. No vague "tests pass" — use numbers.] |

> **Reminder:** This decision is final. The Tech Lead cannot override a BLOCKED Gate 4 status.

---

## 2. Test Summary

| Metric | Value |
|--------|-------|
| Vitest total | [N] |
| Vitest passed | [N] |
| Vitest failed | [N] |
| Playwright total | [N] |
| Playwright passed | [N] |
| Playwright failed | [N] |
| **Line coverage (new code)** | [X]% |
| Coverage threshold met | [YES / NO — 80% minimum for new logic] |
| Auth path coverage | [100% / BELOW THRESHOLD] |

### Coverage Details

| File | Line Coverage | Branch Coverage | Meets Threshold |
|------|-------------|----------------|----------------|
| `features/[domain]/actions/[name].ts` | [X]% | [X]% | [YES/NO] |
| `features/[domain]/[domain].service.ts` | [X]% | [X]% | [YES/NO] |

---

## 3. Acceptance Criteria Coverage

| Criterion | Description (Then clause) | Test File | Test Name | Status |
|-----------|--------------------------|-----------|-----------|--------|
| AC-001 | [Then: entity is created] | `features/[domain]/__tests__/[name].test.ts` | `creates entity when user is authenticated` | PASSED |
| AC-002 | [Then: error message shown] | `e2e/[domain]/[flow].spec.ts` | `shows error when form is submitted empty` | PASSED |
| AC-003 | [Then: ...] | — | — | NO_TEST |

**Summary:** [N] PASSED / [N] FAILED / [N] NO_TEST / [N] AMBIGUOUS  
**Unmet criteria block APPROVED:** [YES / NO]

---

## 4. API Contract Validation

| Endpoint | Method | Status Code | Response Shape | 401 (Auth) | 400 (Validation) | Error Format | Overall |
|----------|--------|-------------|----------------|-----------|-----------------|--------------|---------|
| `/api/[resource]` | GET | PASSED | PASSED | PASSED | N/A | PASSED | FULLY_VALIDATED |
| `/api/[resource]` | POST | PASSED | PASSED | PASSED | PASSED | PASSED | FULLY_VALIDATED |
| `/api/[resource]/:id` | PUT | FAILED | PASSED | PASSED | PASSED | PASSED | PARTIALLY_VALIDATED |

**Total endpoints:** [N]  
**Fully validated:** [N]  
**Partially validated:** [N] — details in Bug List  
**Not validated:** [N] — blocks APPROVED  

---

## 5. Accessibility Regression

| User Flow | Keyboard Navigable | Focus Visible | ARIA Labels | Form Labels | Error Announced | Overall |
|-----------|--------------------|--------------|-------------|------------|-----------------|---------|
| Login | PASSED | PASSED | PASSED | PASSED | PASSED | PASSED |
| Create [Entity] | PASSED | PASSED | FAILED | PASSED | PASSED | FAILED |
| [Flow Name] | NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED | NOT_TESTED |

**Violations:** [N] FAILED flows  
**Primary flow violations block APPROVED:** [YES / NO]

---

## 6. Bug List

> Severity: CRITICAL = auth bypass / data loss / security | HIGH = feature broken | MEDIUM = degraded UX | LOW = cosmetic

| Bug ID | Severity | Title | Component | File | Responsible | Status |
|--------|----------|-------|-----------|------|-------------|--------|
| BUG-001 | CRITICAL | [Short title] | [Component] | `[file.ts]` | Agente04_DevBackend | OPEN |
| BUG-002 | HIGH | [Short title] | [Component] | `[file.tsx]` | Agente05_DevFrontend | OPEN |

### BUG-001 Detail

**Severity:** CRITICAL  
**Title:** [Precise bug title]  
**Component:** [Component name]  
**File:** `[file path]`  
**Line:** [line number or range]  

**Description:**  
[Precise description of the bug. What condition triggers it. Why it is a problem.]

**Reproduction steps:**  
1. [Step 1]
2. [Step 2]
3. [Step 3 — observe the defect]

**Expected behavior:** [What should happen according to AC-NNN]  
**Actual behavior:** [What actually happens — the defect]  
**Acceptance criterion violated:** AC-NNN

**Recommendation:**  
[Specific fix recommendation. Do not say "fix the bug" — explain HOW to fix it.]

**Regression test required:** YES  
**Escalate to security:** [YES / NO]

---

### BUG-002 Detail

**Severity:** HIGH  
[... same structure as BUG-001 ...]

---

## 7. Regression Analysis

> Section only present in evaluation cycles > 1 (resubmissions).

| Bug ID | Previous Severity | Title | Fix Status | Regression Test |
|--------|------------------|-------|-----------|----------------|
| BUG-001 | CRITICAL | [Title] | FIXED_WITH_REGRESSION_TEST | `[test file] — [test name]` |
| BUG-002 | HIGH | [Title] | FIXED_NO_REGRESSION_TEST | MISSING |

**Verdict:** [ALL_FIXED_WITH_REGRESSION_TESTS / PARTIAL_FIX_MISSING_TESTS / BUGS_NOT_FIXED / NEW_BUGS_INTRODUCED]

---

## 8. Sign-Off Checklist

> All items must be checked for APPROVED. Any unchecked item blocks the gate.

### Acceptance Criteria
- [ ] All AC-NNN criteria mapped to tests
- [ ] No ambiguous criteria (or escalated and clarified)
- [ ] All mapped tests are PASSING

### Test Completeness
- [ ] Test file exists for every new Server Action
- [ ] Test file exists for every new Route Handler
- [ ] Minimum 4 test cases per Server Action (unauth, invalid, success, error)
- [ ] Auth null test present in every Server Action test suite
- [ ] Error path test verifies generic message (no internal details exposed)

### Coverage
- [ ] Coverage report reviewed (tool output, not estimated)
- [ ] ≥ 80% line coverage for all new business logic files
- [ ] 100% line coverage for auth paths
- [ ] 100% line coverage for critical mutation paths (create/update/delete)

### API Contract
- [ ] Every endpoint in API_Contract.json has tests
- [ ] Status codes verified for all endpoints
- [ ] Response shapes validated with Zod
- [ ] 401 behavior verified for all protected endpoints
- [ ] Error format verified (no stack traces in responses)

### Bug Classification
- [ ] All test failures classified by severity
- [ ] No CRITICAL bugs unresolved
- [ ] No HIGH bugs unresolved
- [ ] Bug reports written for all CRITICAL and HIGH findings

### Accessibility
- [ ] Keyboard navigation tested for all primary flows
- [ ] Focus management tested
- [ ] ARIA labels verified
- [ ] Form labels verified
- [ ] Error announcement verified (role="alert")

### QA Report
- [ ] All 8 mandatory sections present
- [ ] Gate status code from authorized list
- [ ] Evidence cited for every decision (test names, coverage %, bug IDs)
- [ ] No vague "tests pass" without numbers

---

*Gate 4 decision issued by Agente06_QaEngineer. This decision cannot be overridden by the Tech Lead. Only QA can lift a Gate 4 block.*
