# qa-review-skill

## Purpose

Orchestrates the full Gate 4 evaluation cycle — from validating the Definition of Ready through all evaluation steps to the final gate decision. This is the entry point for every QA review. It coordinates all other skills in the correct sequence and ensures no step is skipped.

## When to Use

- At the start of every Gate 4 evaluation, when the Handoff Package from Dev agents is received
- Always — no other skill should be invoked without first running qa-review-skill

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `backend_handoff_package` | Agente04_DevBackend Handoff Package JSON | Yes |
| `frontend_handoff_package` | Agente05_DevFrontend Handoff Package JSON | Yes |
| `api_contract` | `API_Contract.json` | Yes |
| `prd_acceptance_criteria` | PRD document with AC-NNN in Given/When/Then format | Yes |
| `vitest_test_files` | All submitted Vitest test files | Yes |
| `playwright_test_files` | All submitted Playwright test files | Yes |
| `coverage_report` | Coverage tool output (`vitest --coverage`) | Yes |
| `implementation_reports` | Backend and Frontend implementation reports | Yes |

## Outputs

- Orchestration plan (which skills to invoke, in what order)
- Gate 4 decision (one of the 6 authorized status codes)
- `QA_Report.md` (primary Gate 4 artifact)
- Handoff Package for Gate 5 (if APPROVED) or return packages (if BLOCKED/RETURNED)

## Procedure

1. **Validate Definition of Ready** — check that all required inputs are present. If any are missing, return immediately with the appropriate status code (do not proceed without complete inputs).

2. **Run acceptance-criteria-validation-skill** — map every AC-NNN to tests. Flag ambiguous criteria for escalation. Any NO_TEST criterion triggers BLOCKED_MISSING_TESTS.

3. **Run api-contract-test-skill** — validate every endpoint in API_Contract.json. Any missing endpoint test triggers BLOCKED_MISSING_TESTS.

4. **Review and execute Vitest tests** — verify test quality (4 cases per action, proper mocks, behavior-based assertions). Review coverage report against thresholds.

5. **Review and execute Playwright tests** — verify accessible selectors, no CSS/XPath, keyboard accessibility coverage.

6. **Run accessibility-regression-skill** — validate primary user flows for WCAG 2.1 AA.

7. **Run test-failure-classification-skill** — classify all failures by severity. Any CRITICAL finding triggers immediate BLOCKED_CRITICAL_RISK.

8. **Run regression-analysis-skill** (if evaluation cycle > 1) — verify all bugs from previous cycle are fixed with regression tests.

9. **Run qa-reporting-skill** — assemble all results into `QA_Report.md` and issue the gate decision.

## Constraints

- Never skip a step — all 9 steps must be completed before a gate decision
- Never issue APPROVED if any step has outstanding failures
- Escalate to Tech Lead before issuing BLOCKED_CRITICAL_RISK
- Do NOT invoke skills in parallel — they have dependencies on each other

## Quality Gate

Produces the Gate 4 decision. See `quality_gate.md` for complete specification.

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/quality_gate.md`, and project input artifacts.
