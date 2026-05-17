# Accessibility Checklist (WCAG AA)

**Agent:** Agente05_DevFrontend
**Skill:** accessibility-check-skill
**Standard:** WCAG 2.1 Level AA
**Run before:** Every Gate 4 submission (mandatory for all interactive components)

## Runtime Knowledge Policy

> Consult `Agente05_DevFrontend/knowledge/heuristics.md` (H6, H14, H15) and `Agente05_DevFrontend/knowledge/knowledge_cards.md` (Card 009) for detailed accessibility guidance. Do not consult external WCAG documentation at runtime.

---

## Section 1: Text Alternatives (WCAG 1.1.1)

- [ ] **TA-01** All `<Image>` components with meaningful content have descriptive `alt` attribute
- [ ] **TA-02** Decorative images have `alt=""` (empty string, not omitted)
- [ ] **TA-03** Icon SVGs inside buttons have `aria-hidden="true"` (the button has the accessible name)
- [ ] **TA-04** Charts have `role="img"` and descriptive `aria-label` on the wrapper
- [ ] **TA-05** Complex charts have a `<table class="sr-only">` data alternative for screen readers

---

## Section 2: Keyboard Navigation (WCAG 2.1.1, 2.1.2)

- [ ] **KEY-01** All interactive elements are reachable via `Tab` key in logical order
- [ ] **KEY-02** All buttons can be activated with `Enter` key
- [ ] **KEY-03** Custom interactive components respond to appropriate keyboard events
- [ ] **KEY-04** Modal dialogs trap focus (Tab cycles within the dialog, not outside)
- [ ] **KEY-05** Modals release focus trap when closed (focus returns to trigger element)
- [ ] **KEY-06** No keyboard traps outside intentional modal focus traps

---

## Section 3: Focus Visibility (WCAG 2.4.7)

- [ ] **FOC-01** All focusable elements have a visible focus ring
- [ ] **FOC-02** Focus rings use `focus:ring-2 focus:ring-[var(--primary-color)] focus:ring-offset-2` or equivalent
- [ ] **FOC-03** No `outline: none` without an alternative focus indicator
- [ ] **FOC-04** Focus order is logical (matches visual reading order)

---

## Section 4: Color and Contrast (WCAG 1.4.3, 1.4.11)

- [ ] **CON-01** Normal text contrast ratio ≥ 4.5:1 against its background
- [ ] **CON-02** Large text (≥ 18px regular or ≥ 14px bold) contrast ratio ≥ 3:1
- [ ] **CON-03** UI component borders (inputs, buttons) contrast ratio ≥ 3:1 against surrounding content
- [ ] **CON-04** Status colors (success green, error red) meet contrast requirements
- [ ] **CON-05** Information NOT conveyed by color alone (also icon, text, or pattern)

---

## Section 5: Semantic HTML (WCAG 1.3.1, 4.1.2)

- [ ] **SEM-01** Page has `<main>` landmark wrapping the primary content
- [ ] **SEM-02** Navigation is in `<nav>` element(s) with `aria-label` if multiple navs exist
- [ ] **SEM-03** Page header uses `<header>` element
- [ ] **SEM-04** Content sections use `<section>` with `aria-labelledby` or `<article>`
- [ ] **SEM-05** Headings are hierarchical: `<h1>` → `<h2>` → `<h3>` (no skipped levels)
- [ ] **SEM-06** Only one `<h1>` per page
- [ ] **SEM-07** Lists of items use `<ul>` or `<ol>` with `<li>` items (not divs)
- [ ] **SEM-08** Data tables use `<table>`, `<thead>`, `<tbody>`, `<th scope="col">` properly

---

## Section 6: Forms (WCAG 1.3.1, 2.5.3, 3.3.1, 3.3.2)

- [ ] **FORM-01** Every `<input>`, `<select>`, `<textarea>` has an associated `<label>` (via `for`/`id` or wrapping)
- [ ] **FORM-02** Required fields indicated with `aria-required="true"` and visual indicator
- [ ] **FORM-03** Error messages associated with fields via `aria-describedby` or inline
- [ ] **FORM-04** Error messages identify the field AND describe the problem AND suggest a fix
- [ ] **FORM-05** Form submission errors are announced via `role="alert"` or `aria-live="assertive"`
- [ ] **FORM-06** Success messages announced via `aria-live="polite"`

---

## Section 7: ARIA Attributes (WCAG 4.1.2)

- [ ] **ARIA-01** `aria-label` used when button/link text is absent or ambiguous
- [ ] **ARIA-02** `aria-expanded` reflects open/closed state on toggle controls
- [ ] **ARIA-03** `aria-selected` reflects selected state on tab panels, listbox options
- [ ] **ARIA-04** `aria-disabled` reflects disabled state (in addition to visual styling)
- [ ] **ARIA-05** `aria-busy` set to `true` during async operations on the affected element
- [ ] **ARIA-06** `aria-live="polite"` for non-critical dynamic content updates
- [ ] **ARIA-07** `aria-live="assertive"` ONLY for critical/urgent announcements (sparingly)
- [ ] **ARIA-08** No ARIA attributes that conflict with semantic HTML roles

---

## Section 8: Interactive Component Patterns

- [ ] **ICP-01** Modal: `role="dialog"`, `aria-modal="true"`, `aria-labelledby` pointing to modal title
- [ ] **ICP-02** Tabs: `role="tablist"`, `role="tab"`, `role="tabpanel"`, `aria-selected`
- [ ] **ICP-03** Disclosure: toggle button has `aria-expanded`, controlled section has `aria-hidden`
- [ ] **ICP-04** Dropdown menus: `role="menu"`, `role="menuitem"`, keyboard arrow navigation
- [ ] **ICP-05** Tooltips: `role="tooltip"`, triggered element has `aria-describedby`
- [ ] **ICP-06** Loading state: `role="status"`, `aria-live="polite"`, `aria-label="Loading..."`
- [ ] **ICP-07** Error state: `role="alert"`, `aria-live="assertive"`
- [ ] **ICP-08** Empty state: `role="status"`, `aria-label` describing what is empty

---

## Section 9: Compliance Sign-off

- [ ] **COMP-01** `accessibility-check-skill` run on all interactive components in this PR
- [ ] **COMP-02** Zero CRITICAL issues open
- [ ] **COMP-03** Zero HIGH issues open
- [ ] **COMP-04** `wcag_aa_compliant: true` in skill output
- [ ] **COMP-05** `gate_4_status: "READY_FOR_QA"` in accessibility review report

---

**Sign-off:** All items checked → submit to Gate 4
