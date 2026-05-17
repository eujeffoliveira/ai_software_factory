# qa-reporting-skill

## Purpose

Assembles all QA evaluation results into the final `QA_Report.md` with all 8 mandatory sections and issues the authoritative Gate 4 status code. This skill is always the last one invoked in every evaluation cycle.

## When to Use

- After all other evaluation skills have completed
- Always the last skill run in every QA evaluation cycle — never before all other skills

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `acceptance_validation_result` | Output from acceptance-criteria-validation-skill | Yes |
| `api_contract_result` | Output from api-contract-test-skill | Yes |
| `test_execution_results` | Vitest and Playwright test output | Yes |
| `coverage_report` | Coverage percentages per file | Yes |
| `accessibility_result` | Output from accessibility-regression-skill | Yes |
| `bug_classifications` | Output from test-failure-classification-skill | If failures found |
| `regression_result` | Output from regression-analysis-skill | If cycle > 1 |

## Outputs

- `QA_Report.md` with all 8 mandatory sections
- Gate 4 status code (from authorized list)
- Handoff Package JSON (for gate routing)

## Procedure

1. **Determine gate decision** — apply the decision matrix from context_view.md Section 7
2. **Populate Section 1** (Gate Decision) — status code + rationale with specific evidence
3. **Populate Section 2** (Test Summary) — numbers from test execution results + coverage
4. **Populate Section 3** (Acceptance Criteria Coverage) — from acceptance-criteria-validation-skill
5. **Populate Section 4** (API Contract Validation) — from api-contract-test-skill
6. **Populate Section 5** (Accessibility Regression) — from accessibility-regression-skill
7. **Populate Section 6** (Bug List) — from test-failure-classification-skill
8. **Populate Section 7** (Regression Analysis) — from regression-analysis-skill (if cycle > 1), else omit
9. **Complete Section 8** (Sign-off Checklist) — verify all checklist items
10. **Produce Handoff Package JSON** — conforming to handoff_schema.json

## Constraints

- All 8 sections must be present before issuing the gate decision
- Gate decision rationale must cite specific evidence (test names, numbers, bug IDs)
- Never vague ("tests pass") — always specific ("18/18 Vitest tests passing, 87% line coverage")
- Decision matrix priority: BLOCKED_CRITICAL_RISK > BLOCKED_QA_FAILURE > BLOCKED_MISSING_TESTS > BLOCKED_MISSING_ACCEPTANCE_CRITERIA > RETURNED_FOR_REVISION

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/templates/QA_Report.md`, `Agente06_QaEngineer/handoff_schema.json`, and project input artifacts.
