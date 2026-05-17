# Responsive Layout Checklist

**Agent:** Agente05_DevFrontend
**Skill:** responsive-layout-skill
**Run:** After implementing any layout component or page

## Runtime Knowledge Policy

> Consult `Agente05_DevFrontend/knowledge/heuristics.md` (H7, H11) and `Agente05_DevFrontend/context_view.md` § 14 for responsive layout patterns. Do not consult external CSS documentation at runtime.

---

## Section 1: Mobile-First Foundation

- [ ] **MOB-01** Default CSS (no Tailwind prefix) defines the mobile layout (≥ 375px viewport)
- [ ] **MOB-02** No layout that only specifies `lg:` or `xl:` classes with no mobile default
- [ ] **MOB-03** Single-column layout on mobile for all multi-column grids (`grid-cols-1` default)
- [ ] **MOB-04** Stacked (column) layout on mobile for all side-by-side flex layouts (`flex-col` default)
- [ ] **MOB-05** Content readable at 375px without horizontal scroll
- [ ] **MOB-06** No fixed pixel widths that exceed 375px without overflow strategy

---

## Section 2: Breakpoint Application

- [ ] **BP-01** `sm:` (≥ 640px) — adds layout enhancements for large mobile / small tablet
- [ ] **BP-02** `md:` (≥ 768px) — adds layout enhancements for tablet
- [ ] **BP-03** `lg:` (≥ 1024px) — primary desktop layout switch
- [ ] **BP-04** `xl:` (≥ 1280px) — used for large desktop when justified (not required on every component)
- [ ] **BP-05** Breakpoints used in logical ascending order (don't apply `lg:` without `sm:` and `md:` if needed)

---

## Section 3: Grid Layouts

- [ ] **GRID-01** Grid containers use `grid` class (not `display: grid` inline style)
- [ ] **GRID-02** Column count specified at each relevant breakpoint (e.g., `grid-cols-1 sm:grid-cols-2 lg:grid-cols-3`)
- [ ] **GRID-03** Gap specified with Tailwind `gap-*` class (not inline margins)
- [ ] **GRID-04** Dashboard stat grids: 2 columns mobile → 4 columns desktop minimum
- [ ] **GRID-05** Card grids: 1 column mobile → 2 columns tablet → 3 or 4 columns desktop
- [ ] **GRID-06** No `grid-cols-3` as the only column definition (missing mobile)

---

## Section 4: Flex Layouts

- [ ] **FLEX-01** Flex containers use `flex` class (not inline style)
- [ ] **FLEX-02** Direction specified with `flex-col` (mobile) → `flex-row` (desktop) when applicable
- [ ] **FLEX-03** `flex-wrap` or `flex-nowrap` explicitly set when behavior matters
- [ ] **FLEX-04** `gap-*` used for spacing between flex items (not margin hacks)
- [ ] **FLEX-05** `min-w-0` added to flex children that contain text that should truncate
- [ ] **FLEX-06** `shrink-0` added to flex children that should not shrink (icons, avatars, fixed elements)

---

## Section 5: Container and Spacing

- [ ] **CONT-01** Page container uses `max-w-7xl mx-auto` or project standard max-width
- [ ] **CONT-02** Horizontal padding applied: `px-4 sm:px-6 lg:px-8`
- [ ] **CONT-03** Vertical spacing consistent with page rhythm (use `py-8` or `py-12` for section spacing)
- [ ] **CONT-04** Sidebar layouts: `w-full lg:w-[size] shrink-0` for sidebar, `flex-1 min-w-0` for content

---

## Section 6: Typography Responsiveness

- [ ] **TYP-01** Page headings scale appropriately: `text-2xl sm:text-3xl lg:text-4xl`
- [ ] **TYP-02** Body text remains readable at all viewport widths (no `text-xs` at desktop)
- [ ] **TYP-03** Long text has appropriate `max-w-*` constraint to prevent overly wide lines (max ~75 chars)
- [ ] **TYP-04** Text does not overflow its container on small viewports

---

## Section 7: Overflow and Scrolling

- [ ] **OVF-01** Tables on mobile use `overflow-x-auto` wrapper to enable horizontal scrolling
- [ ] **OVF-02** Long text truncates with `truncate` class when appropriate (with `title` tooltip)
- [ ] **OVF-03** No unintended horizontal overflow (content wider than viewport)
- [ ] **OVF-04** Scrollable containers have keyboard access: `tabindex="0"` + `overflow-auto`

---

## Section 8: Show/Hide at Breakpoints

- [ ] **SHOW-01** Elements hidden on mobile have a mobile-appropriate alternative or the content is non-essential
- [ ] **SHOW-02** `hidden lg:block` used intentionally — content available another way on mobile
- [ ] **SHOW-03** `block lg:hidden` for mobile-only elements — not duplicating significant content
- [ ] **SHOW-04** Sidebars hidden on mobile have a toggle (drawer, hamburger menu) to access their content

---

**Sign-off:** All items checked → layout is responsive
