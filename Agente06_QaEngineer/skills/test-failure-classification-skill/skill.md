# test-failure-classification-skill

## Purpose

Classifies every test failure and defect by severity (CRITICAL / HIGH / MEDIUM / LOW) using the bug severity matrix. CRITICAL findings trigger an immediate gate block and Tech Lead escalation. Produces bug classification table and bug reports for all CRITICAL and HIGH findings.

## When to Use

- After test execution, whenever any test failures are present
- Also triggered when reviewing code for non-test-visible defects (e.g., missing auth check visible in code review)
- Always run before qa-reporting-skill when any failures exist

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `test_failures` | List of test failures from Vitest/Playwright output | When failures exist |
| `code_review_findings` | Defects found during code review (not from tests) | When found |
| `coverage_gaps` | Specific uncovered lines from coverage report | When gaps exist |

## Outputs

- Bug classification table (severity × count)
- Bug reports (BUG-NNN) for all CRITICAL and HIGH findings
- Gate decision trigger: BLOCKED_CRITICAL_RISK if any CRITICAL, or BLOCKED_QA_FAILURE if any HIGH

## Procedure

1. For each test failure or defect, apply the classification decision tree from `checklists/failure_severity_checklist.md`
2. CRITICAL check first — auth bypass, data loss, SQL injection, secrets exposed
3. HIGH check — feature broken, user blocked, accessibility violation in primary flow
4. MEDIUM check — degraded UX, workaround available
5. LOW — cosmetic only
6. Produce BUG-NNN for every CRITICAL and HIGH finding
7. For CRITICAL bugs: trigger immediate escalation to Tech Lead

## Constraints

- CRITICAL must be escalated immediately — do not wait for full evaluation to complete
- Every defect must have a classification — "medium maybe" is not an acceptable output
- Apply the severity matrix strictly — do not downgrade CRITICAL to avoid blocking

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/checklists/failure_severity_checklist.md`, `Agente06_QaEngineer/templates/Bug_Report.md`, and project input artifacts.
