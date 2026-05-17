# Accessibility Regression Checklist

> Use when running `accessibility-regression-skill`. Validates WCAG 2.1 AA compliance for primary user flows.

---

## Scope Definition

Before starting, list the primary user flows to test:
- [ ] Flow 1: [Login / Authentication]
- [ ] Flow 2: [Main feature — Create/Edit primary entity]
- [ ] Flow 3: [Navigation between major sections]
- [ ] Flow 4: [View/Report — primary data viewing]
- [ ] Flow 5: [Any other flow critical to the user's primary job]

Secondary flows (audit, settings, admin) are MEDIUM severity if they fail — note them but they do not block APPROVED.

---

## For Each Primary Flow

Repeat this section for every flow listed above:

**Flow:** [Flow Name — e.g., "Create Task"]

### Keyboard Navigation

- [ ] User can reach every interactive element (button, input, link, select) by pressing Tab
- [ ] Tab order is logical (matches visual flow top-left to bottom-right)
- [ ] No Tab trap: user can Tab OUT of every element, including modals and dropdowns
- [ ] Shift+Tab reverses navigation correctly
- [ ] Playwright test: `await page.keyboard.press("Tab")` cycles through elements without getting stuck

### Focus Management

- [ ] Focus indicator is ALWAYS visible — never invisible on focused element
- [ ] After opening a modal/dialog: focus moves INTO the modal (not stays behind)
- [ ] After closing a modal/dialog: focus returns to the trigger element
- [ ] After form submission (success or error): focus moves to meaningful place
- [ ] Playwright check: `await expect(page.locator(":focus")).toBeVisible()`

### ARIA Attributes

- [ ] All icon buttons have `aria-label` with a meaningful action name
  - BAD: `aria-label="icon"`, `aria-label="button"`, `aria-label=""`
  - GOOD: `aria-label="Delete task: Q4 Report"`, `aria-label="Close dialog"`
- [ ] All interactive elements have an accessible name (via `aria-label`, `aria-labelledby`, or visible text)
- [ ] Modal/dialog has `role="dialog"` and `aria-labelledby` pointing to its heading
- [ ] Loading states announced: `aria-live="polite"` or `aria-busy="true"`

### Form Labels

- [ ] Every `<input>`, `<select>`, and `<textarea>` has an associated `<label>` (or `aria-label`)
- [ ] `getByLabel("[Label Text]")` works for every form field
- [ ] Required fields are marked: `aria-required="true"` or `required` attribute
- [ ] Error messages are associated with their input via `aria-describedby`

### Error Announcement

- [ ] Validation errors appear in a `role="alert"` container
- [ ] Error container exists in the DOM before the error occurs (empty, then filled)
- [ ] OR: `aria-live="polite"` on the error container for non-critical messages
- [ ] Error messages are specific and actionable ("Title is required" not "Error")
- [ ] Playwright check: `await expect(page.getByRole("alert")).toBeVisible()` after invalid submit

### Skip Navigation

- [ ] Skip link is present: `<a href="#main-content">Skip to main content</a>`
- [ ] Skip link is the first focusable element on the page
- [ ] Skip link is visible on focus (not hidden at all times)
- [ ] Playwright check: first `Tab` press focuses the skip link

### Color and Visual

- [ ] Note only (cannot automate): check that focus indicator has sufficient contrast
- [ ] Note only: check error state is NOT communicated by color alone (icon or text also present)
- [ ] These are LOW/MEDIUM severity cosmetic items — flag but do not block gate

---

## Flow-Level Result

After checking all items for a flow, assign a result:

- **PASSED** — All required checks pass
- **FAILED** — One or more required checks fail → classify failing items by severity
- **NOT_TESTED** — Flow was not tested in this cycle (note in QA Report)

---

## Severity Classification for Accessibility Violations

| Violation | Severity | Example |
|-----------|----------|---------|
| Primary flow completely unusable by keyboard | CRITICAL | Login form cannot be submitted with keyboard |
| Interactive element unreachable by keyboard | HIGH | Primary action button not in Tab order |
| Missing ARIA label on primary action | HIGH | Delete button with no accessible name |
| Focus trapped in modal | HIGH | Modal cannot be dismissed with keyboard |
| Form error not announced | MEDIUM | Validation error shown visually but not in `role="alert"` |
| Missing skip link | MEDIUM | Page has long navigation but no skip link |
| Low contrast focus indicator | LOW | Focus visible but not high contrast |

---

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 10 (Accessibility Standards), `knowledge/decision_rules.md` (DR012), `failure_modes.md` (FM-10).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
