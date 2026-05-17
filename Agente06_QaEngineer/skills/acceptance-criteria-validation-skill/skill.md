# acceptance-criteria-validation-skill

## Purpose

Maps every acceptance criterion (AC-NNN) from the PRD to specific test cases. Identifies criteria without test coverage. Flags criteria that are too ambiguous to test. Produces the Acceptance Validation Report as evidence for the Gate 4 decision.

## When to Use

- At the beginning of every Gate 4 evaluation cycle — before any test execution
- Always the first evaluation skill run (after Definition of Ready check)

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `prd_document` | PRD with acceptance criteria in Given/When/Then | Yes |
| `vitest_test_files` | All submitted Vitest test files | Yes |
| `playwright_test_files` | All submitted Playwright test files | Yes |

## Outputs

- Acceptance Validation Report (AV-NNN-C1) — table mapping every AC-NNN to tests
- List of criteria without tests (triggers BLOCKED_MISSING_TESTS)
- List of ambiguous criteria (triggers BLOCKED_MISSING_ACCEPTANCE_CRITERIA and escalation)

## Procedure

1. **List all AC-NNN** — enumerate every acceptance criterion in the PRD
2. **Parse each criterion** — extract Given, When, and all Then clauses
3. **Check testability** — verify each Then clause has a measurable, observable outcome. If not → AMBIGUOUS
4. **Map to tests** — for each Then clause, find the test file and test case that asserts it
5. **Verify test passes** — confirm the test is present, not skipped, and not failing
6. **Record results** — PASSED, FAILED, NO_TEST, or AMBIGUOUS for each criterion
7. **Produce report** — generate Acceptance Validation Report using `templates/Acceptance_Validation_Report.md`

## Constraints

- Do NOT attempt to test ambiguous criteria — escalate immediately
- Do NOT invent acceptance criteria when they are missing
- A criterion is PASSED only when ALL its Then clauses have passing test assertions
- PARTIAL coverage (some Then clauses covered, some not) counts as NO_TEST for the uncovered clauses

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/checklists/acceptance_criteria_checklist.md`, `Agente06_QaEngineer/templates/Acceptance_Validation_Report.md`, and project input artifacts.
