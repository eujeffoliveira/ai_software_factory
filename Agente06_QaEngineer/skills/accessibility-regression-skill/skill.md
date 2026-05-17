# accessibility-regression-skill

## Purpose

Validates WCAG 2.1 AA accessibility compliance for all primary user flows. Checks keyboard navigation, focus management, ARIA labels, form labeling, and error announcement patterns using Playwright. Classifies accessibility violations by severity.

## When to Use

- In every Gate 4 evaluation cycle — after E2E test review
- For every primary user flow (login, main CRUD operation, navigation)

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `primary_flows` | List of primary user flows to test | Yes |
| `playwright_test_files` | Submitted Playwright tests | Yes |
| `feature_paths` | URL paths for each primary flow | Yes |

## Outputs

- Accessibility regression results (per-flow table)
- Bug reports for any accessibility violations (CRITICAL/HIGH/MEDIUM by severity)

## Procedure

1. For each primary flow: verify Playwright tests exist that check keyboard navigation
2. Verify Tab sequence tests: `page.keyboard.press("Tab")` + `expect(page.locator(":focus")).toBeVisible()`
3. Verify ARIA label tests: interactive elements have `aria-label` or accessible name
4. Verify form label tests: `getByLabel(...)` works for all form inputs
5. Verify error announcement: errors use `getByRole("alert")` not CSS class selectors
6. Classify any violations: primary flow = HIGH severity, secondary flow = MEDIUM
7. Report results in the accessibility section of QA_Report.md

## Constraints

- Primary flow violations are HIGH severity — blocks gate (unless isolated and workaround exists)
- Cannot automate color contrast checking — note as "manual check required" in report
- Focus trap detection requires manual verification in addition to automated Tab tests

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/checklists/accessibility_regression_checklist.md`, and project input artifacts.
