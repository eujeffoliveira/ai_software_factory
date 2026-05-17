# regression-analysis-skill

## Purpose

Verifies that every bug reported in a previous QA cycle has been fixed and that each fix is accompanied by a regression test. Identifies fixes submitted without regression tests and new bugs introduced in the resubmission.

## When to Use

- Only on resubmissions — evaluation cycle > 1
- After a BLOCKED or RETURNED_FOR_REVISION Gate 4 decision
- Before re-running the full evaluation on a resubmission

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `previous_qa_report` | QA_Report.md from the previous evaluation cycle | Yes |
| `bugs_from_previous_cycle` | List of BUG-NNN from previous QA Report | Yes |
| `submitted_test_files` | All test files in the resubmission | Yes |
| `submitted_source_files` | Modified source files in the resubmission PR | Yes |

## Outputs

- Regression Report (REG-NNN-C[N]) — per-bug resolution status
- List of bugs missing regression tests (triggers RETURNED_FOR_REVISION)
- List of new bugs introduced in the resubmission

## Procedure

1. **List bugs from previous cycle** — extract all BUG-NNN from previous QA Report
2. **For each bug**: search the submitted test files for a regression test (look for bug ID in comments or test names)
3. **Verify fix**: check that the code change addresses the root cause described in the bug report
4. **Verify regression test**: confirm the test would FAIL if the fix were reverted (mental model: does the test check exactly the condition that was broken?)
5. **Check for new bugs**: review changes introduced in the resubmission for unrelated regressions
6. **Produce Regression Report** using `templates/Regression_Report.md`

## Constraints

- A bug with no regression test is FIXED_NO_REGRESSION_TEST → RETURNED_FOR_REVISION
- A bug that was "fixed" with a test that doesn't actually test the bug condition is FIXED_NO_REGRESSION_TEST
- New bugs introduced in the resubmission must be classified by severity and may trigger a new block

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/templates/Regression_Report.md`, and project input artifacts.
