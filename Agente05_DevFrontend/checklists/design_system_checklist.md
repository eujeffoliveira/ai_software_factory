# Design System Checklist

**Agent:** Agente05_DevFrontend
**Skill:** tailwind-v4-design-system-skill, design-token-compliance-skill
**Run:** After implementing each component AND before Gate 4 submission

## Runtime Knowledge Policy

> Consult only `Agente05_DevFrontend/knowledge/` and `Agente05_DevFrontend/context_view.md`. The design token reference in `context_view.md` § 12 is the authoritative token list at runtime.

---

## Section 1: Color — No Hardcoded Values

- [ ] **COL-01** No `style={{ color: "#..." }}` — inline hex color (blocks Gate 4)
- [ ] **COL-02** No `style={{ backgroundColor: "#..." }}` — inline hex background (blocks Gate 4)
- [ ] **COL-03** No `className="bg-[#hex]"` — Tailwind arbitrary hex value (blocks Gate 4)
- [ ] **COL-04** No `className="bg-blue-500"` or any Tailwind palette color (not a token)
- [ ] **COL-05** No `className="text-gray-700"` — Tailwind gray scale (not a token)
- [ ] **COL-06** No `className="border-gray-200"` — Tailwind gray border (not a token)

---

## Section 2: Color — Correct Token Usage

- [ ] **TOK-01** Primary actions: `bg-[var(--primary-color)] text-white`
- [ ] **TOK-02** Page background: `bg-[var(--bg-background)]` or `bg-background`
- [ ] **TOK-03** Primary text: `text-[var(--text-foreground)]` or `text-foreground`
- [ ] **TOK-04** Secondary/muted text: `text-[var(--muted-foreground)]`
- [ ] **TOK-05** Borders: `border-[var(--border)]` or `border-border`
- [ ] **TOK-06** Muted backgrounds: `bg-[var(--muted)]` or `bg-muted`
- [ ] **TOK-07** Error/destructive: `text-[var(--destructive)]` or `text-destructive`
- [ ] **TOK-08** Secondary actions: `bg-[var(--secondary-color)]`
- [ ] **TOK-09** Chart colors use tokens: `stroke="var(--primary-color)"` in SVG/Recharts

---

## Section 3: Spacing — Tailwind Scale Only

- [ ] **SPC-01** No `style={{ margin: "16px" }}` or similar inline margin/padding
- [ ] **SPC-02** No `className="mt-[16px]"` arbitrary pixel spacing without documented reason
- [ ] **SPC-03** Standard spacing uses Tailwind scale: `p-4`, `m-6`, `gap-4`, `space-y-2`, etc.
- [ ] **SPC-04** Consistent spacing vocabulary: `4` = 1rem, `8` = 2rem, `12` = 3rem, `16` = 4rem

---

## Section 4: Typography — Tailwind Only

- [ ] **TYP-01** No `style={{ fontSize: "..." }}` inline font sizes
- [ ] **TYP-02** No `style={{ fontWeight: "..." }}` inline font weight
- [ ] **TYP-03** Font sizes from Tailwind scale: `text-sm`, `text-base`, `text-lg`, `text-xl`, `text-2xl`
- [ ] **TYP-04** Font weights from Tailwind: `font-normal`, `font-medium`, `font-semibold`, `font-bold`
- [ ] **TYP-05** Line height from Tailwind: `leading-tight`, `leading-normal`, `leading-relaxed`

---

## Section 5: Layout — No Inline Styles

- [ ] **LAY-01** No `style={{ display: "flex" }}` — use `className="flex"`
- [ ] **LAY-02** No `style={{ gridTemplateColumns: "..." }}` — use Tailwind grid utilities
- [ ] **LAY-03** No `style={{ width: "..." }}` — use Tailwind width utilities (`w-full`, `w-1/2`, etc.)
- [ ] **LAY-04** No `style={{ height: "..." }}` — use Tailwind height utilities (exception: Recharts wrapper needs explicit height for ResponsiveContainer)
- [ ] **LAY-05** No `style={{ position: "..." }}` — use `className="relative"`, `"absolute"`, etc.

---

## Section 6: CSS Alternatives — Not Permitted

- [ ] **ALT-01** No `.module.css` files imported in any component
- [ ] **ALT-02** No `styled-components`, `@emotion`, or `@stitches` imports
- [ ] **ALT-03** No `<style>` tags in component files
- [ ] **ALT-04** No global CSS overrides in component files (global CSS lives in `app/globals.css`)

---

## Section 7: Dark Mode

- [ ] **DRK-01** Components using tokens automatically support dark mode (tokens handle it)
- [ ] **DRK-02** Custom `dark:` variants added only when tokens don't cover the case
- [ ] **DRK-03** No hardcoded light-mode colors that break in dark mode
- [ ] **DRK-04** Recharts chart colors use CSS variables (adapt to dark mode automatically)

---

## Section 8: Compliance Verification

- [ ] **VER-01** `design-token-compliance-skill` run on all files in the PR
- [ ] **VER-02** Zero inline style violations reported
- [ ] **VER-03** Zero hardcoded color violations reported
- [ ] **VER-04** `design_token_compliant: true` in the skill output

---

**Sign-off:** All items checked → ready for `accessibility-check-skill` → then Gate 4 submission
