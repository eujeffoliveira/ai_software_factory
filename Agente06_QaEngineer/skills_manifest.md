# Agente06_QaEngineer — Skills Manifest

This document indexes all skills available to the QA Engineer at runtime. Each entry describes the skill's purpose, the trigger conditions, and a reference to the full skill specification.

---

## Skill Index

| # | Skill ID | When to Trigger | Primary Output |
|---|----------|----------------|----------------|
| 1 | `qa-review-skill` | Start of every Gate 4 evaluation cycle | Orchestration plan + final gate decision |
| 2 | `vitest-generation-skill` | Missing Vitest tests for new logic (authorized by pipeline) | Vitest test file |
| 3 | `playwright-e2e-skill` | Missing or reviewing E2E tests for golden-path flows | Playwright test file |
| 4 | `acceptance-criteria-validation-skill` | Mapping PRD acceptance criteria to test cases | Acceptance Validation Report |
| 5 | `regression-analysis-skill` | Reviewing bug fixes submitted for re-evaluation | Regression Report |
| 6 | `api-contract-test-skill` | Validating API endpoints against API_Contract.json | API contract validation results |
| 7 | `qa-reporting-skill` | Producing the final Gate 4 QA Report | QA_Report.md with gate decision |
| 8 | `accessibility-regression-skill` | Accessibility validation of primary user flows | Accessibility section in QA Report |
| 9 | `test-failure-classification-skill` | Classifying any test failure or defect by severity | Bug classification table |

---

## Skill Descriptions

### 1. qa-review-skill

**Location:** `skills/qa-review-skill/`

**Purpose:** Orchestrates the full Gate 4 evaluation cycle from initial intake to final gate decision. This is the primary entry point for any QA evaluation — it coordinates all other skills in the correct sequence.

**Trigger:** At the start of every Gate 4 review cycle — when the Handoff Package from Dev agents is received.

**Sequence:** Validates Definition of Ready → maps acceptance criteria → validates API contract → reviews tests → analyzes coverage → runs accessibility regression → classifies failures → produces QA Report.

**Output:** Gate 4 decision (one of: APPROVED, RETURNED_FOR_REVISION, BLOCKED_MISSING_TESTS, BLOCKED_QA_FAILURE, BLOCKED_MISSING_ACCEPTANCE_CRITERIA, BLOCKED_CRITICAL_RISK).

---

### 2. vitest-generation-skill

**Location:** `skills/vitest-generation-skill/`

**Purpose:** Generates Vitest test files for Server Actions, Route Handlers, and service functions when they are identified as missing during QA review. Note: QA generates these to unblock the pipeline when authorized — the preferred path is the Dev agent providing them.

**Trigger:** 
- Missing test files identified during Gate 4 review
- Explicitly authorized by the pipeline (not autonomous) 
- The Dev agent has been notified and confirmed the gap

**Required inputs:** Function signature, mock dependencies list, acceptance criteria for the function.

**Output:** Vitest test file with minimum 4 test cases (unauthenticated, invalid input, success, error).

---

### 3. playwright-e2e-skill

**Location:** `skills/playwright-e2e-skill/`

**Purpose:** Validates existing Playwright E2E tests for correctness and generates new E2E tests for golden-path flows. Enforces accessible selector policy (getByRole / getByLabel / getByText only).

**Trigger:**
- E2E tests missing for a golden-path acceptance criterion
- Existing E2E tests use forbidden CSS/XPath selectors
- A golden-path flow needs accessibility validation

**Output:** Playwright test file with happy path, error state, and accessibility keyboard navigation tests.

---

### 4. acceptance-criteria-validation-skill

**Location:** `skills/acceptance-criteria-validation-skill/`

**Purpose:** Maps every acceptance criterion (AC-NNN) from the PRD to specific test cases. Identifies criteria without test coverage. Flags criteria that are too ambiguous to test.

**Trigger:** At the beginning of every Gate 4 evaluation cycle — before any test execution.

**Output:** Acceptance Validation Report — table mapping every AC-NNN to test file, test name, and PASSED/FAILED/NO_TEST status.

---

### 5. regression-analysis-skill

**Location:** `skills/regression-analysis-skill/`

**Purpose:** Verifies that every bug fix submitted in a re-evaluation cycle includes a regression test that failed before the fix and passes after. Identifies missing regression tests.

**Trigger:** Whenever a resubmission is received after a RETURNED_FOR_REVISION or BLOCKED status.

**Output:** Regression Report listing every bug from the previous cycle, its fix status, and whether a regression test was committed.

---

### 6. api-contract-test-skill

**Location:** `skills/api-contract-test-skill/`

**Purpose:** Validates that every endpoint defined in `API_Contract.json` has a test that checks: HTTP status code (success + error), response shape (Zod-validated), auth behavior (401 without session), and error format (`{ error: "..." }` with no stack traces).

**Trigger:** After acceptance criteria mapping — always runs as part of every Gate 4 evaluation.

**Output:** API contract validation results table — per-endpoint, per-check status.

---

### 7. qa-reporting-skill

**Location:** `skills/qa-reporting-skill/`

**Purpose:** Produces the final `QA_Report.md` with all mandatory sections. Assembles evidence from other skills into the Gate 4 decision document. Issues the exact gate status code.

**Trigger:** After all other evaluation steps are complete — this is the last skill run in every QA cycle.

**Output:** `QA_Report.md` with all 8 mandatory sections and the Gate 4 status code.

---

### 8. accessibility-regression-skill

**Location:** `skills/accessibility-regression-skill/`

**Purpose:** Validates accessibility compliance for all primary user flows. Checks keyboard navigation, focus management, ARIA semantics, form labeling, and error announcement patterns.

**Trigger:** In every Gate 4 evaluation cycle — after E2E test review.

**Output:** Accessibility regression results section for the QA Report. Bug reports for any HIGH severity accessibility violations found.

---

### 9. test-failure-classification-skill

**Location:** `skills/test-failure-classification-skill/`

**Purpose:** Classifies every test failure and defect by severity (CRITICAL / HIGH / MEDIUM / LOW) using the bug severity matrix. CRITICAL findings trigger an immediate gate block and Tech Lead escalation.

**Trigger:** After test execution, when any failures are present. Also triggered when reviewing the implementation for non-test-visible defects.

**Output:** Bug classification table with severity, description, component, reproduction steps, and recommendation for each finding.

---

## Skill Interaction Diagram

```
Handoff Received
      │
      ▼
┌─────────────────────────┐
│ qa-review-skill          │  ← Orchestrator (always first)
│ (Definition of Ready)    │
└──────────┬──────────────┘
           │
           ├──► acceptance-criteria-validation-skill
           │         │
           ├──► api-contract-test-skill
           │         │
           ├──► vitest-generation-skill (if tests missing)
           │         │
           ├──► playwright-e2e-skill (if E2E missing/invalid)
           │         │
           ├──► accessibility-regression-skill
           │         │
           ├──► test-failure-classification-skill (if failures)
           │         │
           ├──► regression-analysis-skill (if resubmission)
           │         │
           └──► qa-reporting-skill  ← Always last
                     │
                     ▼
              QA_Report.md + Gate 4 Decision
```

---

## Notes

- `qa-review-skill` is always run first — it orchestrates all others
- `qa-reporting-skill` is always run last — it assembles the final report
- `test-failure-classification-skill` runs whenever any failure is detected
- `regression-analysis-skill` only runs on resubmissions (cycle > 1)
- All skills enforce the runtime isolation rule — no `context/` or `lib/` access
