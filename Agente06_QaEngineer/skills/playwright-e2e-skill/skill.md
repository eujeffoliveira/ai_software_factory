# playwright-e2e-skill

## Purpose

Validates existing Playwright E2E tests for correctness and generates new E2E tests for golden-path user flows. Enforces the accessible selector policy (getByRole / getByLabel / getByText only — no CSS selectors or XPath). Validates keyboard accessibility in primary flows.

## When to Use

- E2E tests are missing for an acceptance criterion that requires user-facing validation
- Existing E2E tests use forbidden CSS or XPath selectors (must be rewritten)
- A golden-path flow needs keyboard accessibility validation
- Reviewing the quality of submitted Playwright tests

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `feature_path` | URL path for the feature under test | Yes |
| `acceptance_criteria` | AC-NNN(s) this flow must satisfy | Yes |
| `flow_steps` | Given/When/Then breakdown of the user journey | Yes |
| `form_fields` | Label text for every form input in the flow | For form-based flows |
| `interactive_elements` | Button names, link texts in the flow | Yes |

## Outputs

- Playwright test file with: happy path test, error state test, keyboard navigation test
- Accessible selector audit of existing tests (if reviewing)

## Procedure

1. Parse the Given/When/Then flow into test setup (Given), user actions (When), and assertions (Then)
2. Identify whether the flow spans a single page or multiple pages/routes. For cross-page flows: use `await page.waitForURL("**/expected-path")` after each navigation action before proceeding to the next step assertions
3. Write happy path test using accessible selectors only
4. Write error state test (submit without required fields, verify `getByRole("alert")` visible)
5. Write keyboard navigation test (Tab through elements, verify focus visibility, test Enter submission)
6. If reviewing existing tests: scan for `.locator(".")`, `.locator("/")`, `$("[class")` — any CSS/XPath usage → flag as violation; verify every interactive element has an accessible name by checking that `getByRole("<role>", { name: "<name>" })` resolves without `exact: false` workarounds

## Constraints

- ALLOWED selectors: `getByRole`, `getByLabel`, `getByText`, `getByTestId`, `getByPlaceholder`, `getByAltText`, `getByTitle`
- FORBIDDEN: CSS class selectors, XPath expressions, `#id` selectors
- All interactive elements must have accessible names (verified by using `getByRole` with `name` option)
- Error states must use `role="alert"` — verified by `getByRole("alert")`
- No `page.waitForTimeout()` — use `await expect(element).toBeVisible()` instead

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/templates/Playwright_Test_Template.ts`, and project input artifacts.
