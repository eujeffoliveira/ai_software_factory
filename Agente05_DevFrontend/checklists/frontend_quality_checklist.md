# Frontend Quality Checklist

**Agent:** Agente05_DevFrontend
**Run before:** Every Gate 4 submission
**All items must be checked before `gate_ready: true`**

## Runtime Knowledge Policy

> This checklist references only local knowledge from `Agente05_DevFrontend/`. Do not consult `context/` or `lib/` at runtime. Principles and decision rules cited below are from `knowledge/principles.md` and `knowledge/decision_rules.md`.

---

## Section 1: Component Architecture

- [ ] **SC-01** Every `"use client"` directive has a code comment documenting which trigger applies (DR001–DR005)
- [ ] **SC-02** No `"use client"` added "just in case" or "for safety" — only when a specific trigger applies
- [ ] **SC-03** Server Components used for all data-reading components (no hooks, no handlers, no browser APIs) (P1)
- [ ] **SC-04** Client Components are the exception, not the rule (fewer than 30% of new components, unless justified)
- [ ] **SC-05** No business logic in components — domain logic extracted to `features/[domain]/` (P10, FM-08)
- [ ] **SC-06** Data mutations use Server Actions imported from `features/[domain]/actions/` — not raw `fetch()` (DR017)

---

## Section 2: Data Fetching

- [ ] **DF-01** Server Components fetch data directly with `await serverAction()` — no `useEffect` + `useState` (DR006)
- [ ] **DF-02** SWR only used where `refreshInterval` is specified and polling requirement is documented (DR014, P7)
- [ ] **DF-03** Every SWR endpoint exists in `API_Contract.json` — no invented routes (DR015, P8)
- [ ] **DF-04** No raw `fetch()` to internal API routes from Client Components (DR017)
- [ ] **DF-05** TypeScript interfaces for API responses derived from `API_Contract.json` fields (DR018, P12)
- [ ] **DF-06** No `any` type used for API response data

---

## Section 3: UI States

- [ ] **US-01** `loading.tsx` present for every async page route OR `<Suspense>` with skeleton (DR007)
- [ ] **US-02** `error.tsx` present for every page route (DR008)
- [ ] **US-03** `error.tsx` is a Client Component (`"use client"` on first line) (DR008)
- [ ] **US-04** `error.tsx` does NOT display `error.message` — uses generic user-friendly message (FM-03)
- [ ] **US-05** `error.tsx` includes a `reset()` button for recovery (DR008)
- [ ] **US-06** Empty state present for every list, table, and data-driven section (DR009, P5)
- [ ] **US-07** Empty state has: icon + message + optional description (not just blank space) (H13)
- [ ] **US-08** Loading skeleton matches approximate layout of actual content (H4)

---

## Section 4: Images

- [ ] **IMG-01** Zero `<img>` tags in any component file (DR010, FM-05)
- [ ] **IMG-02** All images use `<Image>` from `next/image`
- [ ] **IMG-03** Every `<Image>` has an `alt` attribute (descriptive or `""` for decorative)
- [ ] **IMG-04** Every `<Image>` has `width`+`height` props OR `fill` prop
- [ ] **IMG-05** `fill` images have a positioned parent container (`relative`/`absolute` parent)
- [ ] **IMG-06** Above-the-fold images use `priority` prop to avoid LCP penalty
- [ ] **IMG-07** `sizes` prop added to `fill` images for responsive optimization

---

## Section 5: Styling

- [ ] **STY-01** Zero inline `style={{...}}` props in any component (DR011, FM-06)
- [ ] **STY-02** Zero hardcoded hex colors anywhere (`#hex`, `rgb(...)`) (DR012, FM-10)
- [ ] **STY-03** Zero Tailwind palette colors (`bg-blue-500`, `text-gray-700`) — use tokens (DR012)
- [ ] **STY-04** Design tokens used: `var(--primary-color)`, `var(--text-foreground)`, etc. (P3)
- [ ] **STY-05** No CSS modules, no `styled-components`, no emotion (P3)
- [ ] **STY-06** All spacing uses Tailwind scale (no arbitrary pixel values without justification)
- [ ] **STY-07** `design-token-compliance-skill` run and passed (zero violations)

---

## Section 6: Responsiveness

- [ ] **RES-01** Default CSS (no prefix) targets mobile viewport (DR020, P11)
- [ ] **RES-02** `sm:`, `md:`, `lg:` breakpoints add layout enhancements for larger screens
- [ ] **RES-03** No layout that only works on desktop (no `lg:grid-cols-3` without a `grid-cols-1` default)
- [ ] **RES-04** Text is readable at 375px viewport width without horizontal scroll
- [ ] **RES-05** All images are responsive (no fixed pixel widths that overflow mobile)
- [ ] **RES-06** `responsive-layout-skill` run on all layout components

---

## Section 7: Accessibility (WCAG AA)

- [ ] **A11Y-01** All interactive elements (`<button>`, `<a>`) have descriptive text OR `aria-label`
- [ ] **A11Y-02** All form inputs have an associated `<label>` (via `id`/`for` or wrapping label)
- [ ] **A11Y-03** Dynamic content changes have `aria-live="polite"` (status updates)
- [ ] **A11Y-04** Error messages have `role="alert"` and `aria-live="assertive"`
- [ ] **A11Y-05** Loading states have `role="status"` and `aria-label="Loading content"`
- [ ] **A11Y-06** Empty states have `role="status"` and `aria-label`
- [ ] **A11Y-07** All keyboard-accessible elements have visible focus rings
- [ ] **A11Y-08** Decorative images have `alt=""` (empty string, not missing `alt`)
- [ ] **A11Y-09** Semantic HTML used: `<main>`, `<nav>`, `<header>`, `<section>`, `<article>`, `<aside>`
- [ ] **A11Y-10** `accessibility-check-skill` run — zero CRITICAL or HIGH issues

---

## Section 8: Charts

- [ ] **CHT-01** All charts use Recharts — no other charting library (P6, DR005)
- [ ] **CHT-02** Every chart wrapped in `<ResponsiveContainer width="100%" height="...">`  (DR013)
- [ ] **CHT-03** Parent container has explicit height (Recharts requires it for ResponsiveContainer)
- [ ] **CHT-04** Every chart handles empty data with an empty state (DR009)
- [ ] **CHT-05** Chart wrappers have `role="img"` and descriptive `aria-label`
- [ ] **CHT-06** Chart colors use design tokens (`var(--primary-color)`, not `#hex`)
- [ ] **CHT-07** All chart components are Client Components with DR005 justification

---

## Section 9: Tests

- [ ] **TST-01** Vitest test file created for each Client Component with business behavior
- [ ] **TST-02** Playwright E2E test for each page-level interaction flow
- [ ] **TST-03** Test scenarios cover: render success, empty state, error state, loading state
- [ ] **TST-04** No `any` types in test files

---

## Section 10: Gate Readiness

- [ ] **GATE-01** `Frontend_Implementation_Report.md` produced and complete
- [ ] **GATE-02** All acceptance criteria from task block are addressed
- [ ] **GATE-03** No blocking open questions (escalated to Agente00 if needed)
- [ ] **GATE-04** `gate_ready: true` in Handoff Package JSON
- [ ] **GATE-05** Handoff Package conforms to `handoff_schema.json`

---

**Sign-off:** All items above checked → `gate_ready: true` → deliver to `Agente06_QaEngineer`
