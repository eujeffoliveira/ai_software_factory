# playwright-e2e-skill — Execution Checklist

## Selector Policy Audit

- [ ] No CSS selectors found (`.className`, `[class=...]`)
- [ ] No XPath found (`//element`, `xpath=...`)
- [ ] No raw `#id` selectors
- [ ] Only allowed selectors: `getByRole`, `getByLabel`, `getByText`, `getByTestId`, `getByPlaceholder`

## Test Coverage

- [ ] Happy path test present (AC-NNN Given/When/Then covered)
- [ ] Error state test present (invalid submit → `getByRole("alert")` visible)
- [ ] Keyboard navigation test present (Tab through elements, Enter to submit)
- [ ] Each test has a clear, behavior-describing name

## Async Handling

- [ ] No `page.waitForTimeout()` — replaced with `await expect(element).toBeVisible()`
- [ ] Form submissions wait for response: `waitForResponse` or role-based assertion
- [ ] Navigation waits with `await expect(page).toHaveURL(...)`

## Accessibility

- [ ] Error states use `getByRole("alert")` — not `.error-text` CSS class
- [ ] Keyboard navigation test Tab sequence is logical
- [ ] Focus visibility verified after Tab press

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 2 (Playwright Patterns), `knowledge/decision_rules.md` (DR002), `templates/Playwright_Test_Template.ts`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
