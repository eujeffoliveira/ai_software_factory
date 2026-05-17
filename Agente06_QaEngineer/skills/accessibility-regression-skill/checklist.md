# accessibility-regression-skill — Execution Checklist

## Per Primary Flow

- [ ] Keyboard navigation test present (Tab sequence covered)
- [ ] Focus visibility test present (`page.locator(":focus")` visible)
- [ ] ARIA labels verified for all interactive elements (buttons, links)
- [ ] Form labels verified (`getByLabel` works for all inputs)
- [ ] Error announcement verified (`getByRole("alert")` used)
- [ ] Skip link present (if application has nav header)

## Classification

- [ ] Primary flow violations classified as HIGH severity
- [ ] Secondary flow violations classified as MEDIUM severity
- [ ] Bug reports produced for all HIGH violations
- [ ] Color contrast noted as "manual check required" (cannot automate)

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 10 (Accessibility Standards), `knowledge/decision_rules.md` (DR012), `checklists/accessibility_regression_checklist.md`, `failure_modes.md` (FM-10).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
