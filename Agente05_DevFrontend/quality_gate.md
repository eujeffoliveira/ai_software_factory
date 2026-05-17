# Agente05_DevFrontend — Quality Gate 4 (QA Review)

## Gate Overview

| Field | Value |
|-------|-------|
| Gate number | 4 |
| Gate name | QA Review |
| Dev Frontend role | **Submitter** |
| Evaluator | Agente06_QaEngineer |
| Prerequisite | Gate 3 approved (Execution Plan from Agente03_SoftwareEngineer) |
| Output to next | Handoff Package for Agente06_QaEngineer |

---

## Entry Criteria (for submission)

Before submitting to Gate 4, ALL of the following must be true:

1. Gate 3 approved — Execution Plan with atomic frontend tasks delivered by Agente03_SoftwareEngineer
2. Atomic task completed — all acceptance criteria addressed
3. `Frontend_Implementation_Report.md` produced and complete
4. Self-review checklist (`checklists/frontend_quality_checklist.md`) run and all items checked
5. `accessibility-check-skill` run on all interactive components — zero CRITICAL or HIGH issues
6. `design-token-compliance-skill` run on all component files — zero violations
7. Test files created for all Client Components with business behavior
8. No open blocking issues (`blocking: true` questions must be escalated before submission)
9. `gate_ready: true` in the Handoff Package

---

## What Dev Frontend Must Prepare Before Gate 4 Submission

### 1. Source Code Files
All files listed in the task block must be created or modified:
- Server Component pages at `app/[domain]/page.tsx`
- Server Component layouts at `app/[domain]/layout.tsx`
- Client Components at `features/[domain]/components/[ComponentName].tsx`
- Loading states at `app/[domain]/loading.tsx`
- Error states at `app/[domain]/error.tsx`
- Chart components at `features/[domain]/components/[ChartName]Chart.tsx`
- SWR polling components at `features/[domain]/components/[Name]LiveWidget.tsx`

### 2. Test Files
For every Client Component with interactive behavior:
- Vitest test at `features/[domain]/components/__tests__/[ComponentName].test.tsx`
- Playwright E2E test at `e2e/[domain]/[feature].spec.ts` (for page-level flows)

### 3. Frontend_Implementation_Report.md
Complete report using `templates/Frontend_Implementation_Report.md`:
- Task summary
- Files created (with paths and component type)
- Files modified (with change summary)
- Server Components table
- Client Components table (with justification for each)
- Loading states table
- Error states table
- Empty states table
- Accessibility review summary
- Design token compliance summary
- Test coverage summary
- Self-review checklist (all items checked)
- Open issues (none blocking)
- Gate readiness confirmation

### 4. Handoff Package JSON
Conforms to `handoff_schema.json`:
- `required_next_agent: "Agente06_QaEngineer"`
- `gate_ready: true`
- `validation_checklist` fully populated

---

## Self-Review Checklist (Run Before Submitting)

Run `checklists/frontend_quality_checklist.md` in full. Key items:

### Component Architecture
- [ ] No `"use client"` without written justification in the code comment
- [ ] Server Components used by default for all data-reading components
- [ ] Client Components justified by: state / effect / handler / browser API / Recharts
- [ ] No business logic in components (belongs in `features/[domain]/`)
- [ ] Business logic called via Server Actions (`features/[domain]/actions/`)

### Data Fetching
- [ ] Server Components fetch data directly (no `useEffect` + `useState` for data)
- [ ] SWR used only for polling — not as a general data fetching strategy
- [ ] Every SWR endpoint exists in `API_Contract.json`
- [ ] No invented API endpoint paths (escalate if missing)
- [ ] Server Actions used for all mutations — no raw `fetch()` to internal routes

### UI States
- [ ] `loading.tsx` present for all async page routes
- [ ] Suspense boundaries present for nested async components
- [ ] `error.tsx` present for all page routes
- [ ] Empty state present for every list, table, or data-driven section
- [ ] Skeleton layout matches real content layout

### Images
- [ ] `<Image>` from `next/image` used for all images — zero `<img>` tags
- [ ] `alt` attribute present and descriptive on all `<Image>` components
- [ ] `width`+`height` or `fill` provided on every `<Image>`

### Styling
- [ ] Tailwind only — zero inline `style={{}}` props
- [ ] No hardcoded hex color values
- [ ] No `bg-blue-500` or similar non-token Tailwind colors
- [ ] Design tokens used: `var(--primary-color)`, `var(--bg-background)`, etc.
- [ ] Mobile-first responsive classes applied (`sm:`, `md:`, `lg:`)
- [ ] No CSS modules, no styled-components

### Accessibility (WCAG AA)
- [ ] Icon buttons have `aria-label`
- [ ] Form inputs have associated `<label>` elements
- [ ] Dynamic content has `aria-live` announcements
- [ ] Keyboard navigation works for all interactive elements
- [ ] Focus rings visible on all focusable elements
- [ ] Color contrast meets AA standard (4.5:1 text, 3:1 large text)
- [ ] Decorative images have empty `alt=""` attribute
- [ ] Semantic HTML used: `<nav>`, `<main>`, `<header>`, `<section>`, etc.

### Charts
- [ ] All charts use Recharts — no other charting library
- [ ] `ResponsiveContainer` wraps every chart
- [ ] Charts are Client Components (justified)
- [ ] Every chart handles empty data case
- [ ] Chart wrappers have `role="img"` and `aria-label`
- [ ] Chart colors use design tokens (CSS variables)

### Tests
- [ ] Vitest test file created for Client Components with behavior
- [ ] Playwright E2E test for page-level interactions
- [ ] Accessibility assertions in tests where applicable

---

## Status Codes

| Code | Meaning | Dev Frontend Action |
|------|---------|---------------------|
| `READY_FOR_QA` | All checks passed | Pipeline advances to Agente06_QaEngineer |
| `RETURNED_FOR_REVISION` | Code quality issues found | Fix the code issues cited, re-run self-review, resubmit |
| `BLOCKED_MISSING_TESTS` | Test files absent or insufficient | Create/complete test files, resubmit |
| `BLOCKED_ACCESSIBILITY_FAILURE` | WCAG AA violations found | Resolve all CRITICAL/HIGH issues, resubmit |
| `BLOCKED_DESIGN_SYSTEM_VIOLATION` | Inline styles, hardcoded colors, or forbidden library | Remove violations, resubmit |

---

## When to Escalate BEFORE Submitting to Gate 4

Do not submit to Gate 4 if any of the following are unresolved:

| Situation | Action |
|-----------|--------|
| API contract missing a needed endpoint | Escalate to Agente00_TechLead |
| Design token not defined in project | Escalate to Agente00_TechLead |
| Required UI library not in Golden Path | Escalate to Agente00_TechLead |
| New npm package needed | Escalate to Agente00_TechLead |
| Task requires layout conflicting with Architecture | Escalate to Agente00_TechLead |
| Authorization behavior of UI element ambiguous | Escalate to Agente00_TechLead |
| Component spec is contradictory | Escalate to Agente00_TechLead |

---

## Gate 4 Evaluation Scope (What QA Reviews)

The QA Engineer (`Agente06_QaEngineer`) will check:
1. All acceptance criteria from the task block are addressed
2. Code follows Golden Path patterns (Server Component default, "use client" justified)
3. No `<img>` tags — `next/image` used everywhere
4. Loading, error, and empty states present and correct
5. Tailwind only — no inline styles or hardcoded colors
6. WCAG AA accessibility compliance
7. Recharts with `ResponsiveContainer` for all charts
8. Tests cover required scenarios
9. `Frontend_Implementation_Report.md` is complete and accurate

The Dev Frontend does not evaluate Gate 4 — only submits to it.
