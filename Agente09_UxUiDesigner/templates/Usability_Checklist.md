# Usability Checklist
## Feature: [Feature Name]
## Date: [YYYY-MM-DD]
## Evaluator: Agente09_UxUiDesigner (self-review before submission)

> This checklist must be completed and all items confirmed before submitting the Design Package for Design Review. Items marked FAIL block submission.

---

## Section 1: Cognitive Load (P1, P3 — Hick's Law, Miller's Law)

- [ ] **Primary actions per screen ≤ 3** — screens with more than 3 primary actions have been simplified or overflow moved to "More" menus
- [ ] **Navigation items ≤ 7** — top-level navigation has a maximum of 7 items (ideally 5)
- [ ] **Form fields grouped logically** — related fields are in labeled sections; no form has more than 6 ungrouped fields
- [ ] **Progressive disclosure applied to complex sections** — advanced options, bulk actions, and secondary information are hidden until needed
- [ ] **Tables and lists limited to most relevant columns/information** — more available on row expansion

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Section 2: Navigation Clarity (P5 — Convention over Novelty, H2)

- [ ] **Standard navigation patterns used** — hamburger for mobile, top nav for desktop; no novel navigation patterns without justification
- [ ] **Standard icon semantics preserved** — search = magnifying glass, close = X, settings = gear, menu = hamburger; no repurposed icons
- [ ] **Active navigation state specified** — current page/section is visually distinguished with `primary-color` token and `aria-current="page"`
- [ ] **Breadcrumbs included for deep hierarchy** — pages more than 2 levels deep from root have breadcrumb navigation
- [ ] **Back navigation available** — detail pages have a clear way back to the list without using the browser back button

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Section 3: Form Usability (P10, H4, Card 011)

- [ ] **All forms use single-column layout** (exceptions require explicit justification)
- [ ] **Visible labels above all inputs** — no input relies on placeholder text as its only label
- [ ] **Required fields marked visually AND via `aria-required="true"`**
- [ ] **Validation fires on blur** (not only on submit)
- [ ] **Error messages are specific and actionable** — "Enter a valid email address" not just "Invalid email"
- [ ] **Error messages are inline**, near the field that caused the error
- [ ] **Character counters present** for all text inputs with character limits
- [ ] **Password fields have show/hide toggle** with `aria-label="Show password"` / `"Hide password"`
- [ ] **Submit button disabled during processing** to prevent double-submit
- [ ] **Destructive actions require confirmation** — single-click delete does not exist; confirmation dialog or type-to-confirm applied
- [ ] **Success feedback specified** after form submission (toast, redirect, or confirmation message with exact copy)

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Section 4: Error Prevention and Recovery (P9, P10, H9)

- [ ] **All async components have error states designed** (not just loading and populated)
- [ ] **Error messages are user-friendly** — no HTTP status codes, stack traces, or internal error names exposed
- [ ] **Error messages follow the formula**: "[What went wrong]. [What to do next]."
- [ ] **Retry action available** in all error states where retry is meaningful
- [ ] **Form errors persist** until corrected — they do not disappear before the user has fixed them
- [ ] **Destructive operations are reversible where possible** — soft delete with undo, or hard delete with explicit irreversibility warning

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Section 5: Visual Hierarchy (P4, H1, H6)

- [ ] **Labels are visually proximate to their inputs** — no label separated from its input by other elements
- [ ] **Primary action is visually dominant** — one primary button per screen/section with `bg-primary-color`; secondary actions are visually subordinate
- [ ] **Page title is the most prominent text** on each screen — establishes context within 5 seconds (H1 rule)
- [ ] **Empty states designed before populated states** — empty states communicate what the page is for and how to proceed
- [ ] **Related actions are grouped** — save and cancel are in the same row; delete is not placed next to save

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Section 6: Mobile Usability (P12, H10, DR010)

- [ ] **Mobile wireframes produced for all primary screens** — no screen exists only in desktop
- [ ] **All primary actions reachable without horizontal scroll** on mobile
- [ ] **Touch targets minimum 44×44px** on mobile — `min-h-[44px]` applied to all interactive elements
- [ ] **Primary CTA at thumb-reachable position** on mobile — bottom of screen content or sticky footer, not top
- [ ] **Mobile navigation pattern consistent** — hamburger or bottom tab bar (specified in wireframes)
- [ ] **Bottom sheet pattern used for modals on mobile** (instead of centered modal)
- [ ] **Keyboard push-up handled in mobile forms** — spec notes that layout shifts when native keyboard appears

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Section 7: Feedback and System Status (P9, H9, H14)

- [ ] **Loading states designed for all async operations** — not just page-level, but also button loading states during form submissions
- [ ] **Success feedback specified** for all user-triggered mutations (create, update, delete, submit)
- [ ] **Async operation duration considered** — operations > 2s have active feedback; operations > 10s have progress indication
- [ ] **Navigation shows active state** — current page highlighted in navigation
- [ ] **Form submit button shows loading state** during processing

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Section 8: Component Reuse (P9, DR003, H8)

- [ ] **All components checked against design system** before proposing new ones (ran `design-system-application-skill`)
- [ ] **New components justified in writing** — `new_components_proposed` in Handoff Package has justification for each
- [ ] **No duplicate patterns introduced** — if a similar component already exists, it is reused

**Status**: [ ] PASS [ ] FAIL — Issues: _[describe any issues found]_

---

## Overall Usability Verdict

| Section | Status |
|---------|--------|
| 1: Cognitive Load | [ ] PASS [ ] FAIL |
| 2: Navigation Clarity | [ ] PASS [ ] FAIL |
| 3: Form Usability | [ ] PASS [ ] FAIL |
| 4: Error Prevention and Recovery | [ ] PASS [ ] FAIL |
| 5: Visual Hierarchy | [ ] PASS [ ] FAIL |
| 6: Mobile Usability | [ ] PASS [ ] FAIL |
| 7: Feedback and System Status | [ ] PASS [ ] FAIL |
| 8: Component Reuse | [ ] PASS [ ] FAIL |

**Overall**: [ ] PASS — All sections pass; no critical or high issues unresolved
**Overall**: [ ] PASS WITH NOTES — Medium/low issues deferred to backlog (list below)
**Overall**: [ ] FAIL — Critical or high issues not resolved; cannot submit

### Deferred Issues (medium/low only)

| Issue | Section | Severity | Deferred Reason |
|-------|---------|----------|-----------------|
| [Issue text] | [N] | medium/low | [Why deferred] |
