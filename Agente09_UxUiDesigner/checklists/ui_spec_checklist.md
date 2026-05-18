# UI Spec Checklist
## Agente09_UxUiDesigner
## Apply before finalizing UI_Spec.md

---

## Pre-Execution Checks

- [ ] `Wireframes.md` is complete — UI spec follows wireframes, not precedes them
- [ ] `API_Contract.json` or `Architecture.md` schema is available for TypeScript interface derivation
- [ ] Wireframe component inventory has been transferred to the UI_Spec component list

---

## For Each Component in UI_Spec

Apply the following checks to every component section:

### Props Interface

- [ ] **TypeScript `interface` is present** — not just prose description of props
- [ ] **Every field in the interface exists in `API_Contract.json` or `Architecture.md` schema** (DR015)
- [ ] **Field types are specific** — `string | null` not just `string` where null is possible; `string` for ISO 8601 dates not `Date`
- [ ] **Component type declared** — `Server Component` or `Client Component`
- [ ] **Client Component justification provided** if applicable — reason must be: interactivity / browser API / real-time

---

### Loading State

- [ ] **Skeleton layout described** — number of skeleton items, their dimensions, animation class
- [ ] **Skeleton mirrors populated state layout** — same number of content areas, same approximate dimensions
- [ ] **`animate-pulse` or equivalent animation class specified**
- [ ] **Skeleton color token used** — `bg-muted` or `bg-muted-foreground/20` (no hardcoded hex)
- [ ] **`role="status"` specified** on the loading container
- [ ] **`aria-label="Loading [content type]..."` specified** on the loading container
- [ ] **No generic spinner used** — skeleton matching content shape, not a centered spinner

---

### Error State

- [ ] **Icon specified** — name from design system, size, color token
- [ ] **Heading is user-friendly** — no HTTP codes, no stack traces, no internal error names
- [ ] **Body copy explains what to do** — not just what went wrong
- [ ] **Retry button specified** — label, action (what it triggers), variant
- [ ] **`role="alert"` specified** on the error container
- [ ] **Error message copy is exact** — no placeholder text like "[error message]"

---

### Empty State

- [ ] **Icon specified** — name from design system, size, color token
- [ ] **Heading text is exact** — not "[entity type] list is empty"
- [ ] **Body copy text is exact** — guides user to action, not just confirms emptiness
- [ ] **CTA specified when user can take action** — label, action/route, button variant
- [ ] **CTA omitted when user has read-only access** — spec notes this condition
- [ ] **Multiple empty state variants documented** if applicable (new user / search empty / filter empty)

---

### Populated State

- [ ] **All interactive elements listed in the Interactive Elements table**
- [ ] **Every element in the table has**: element name, component type, all relevant states, design token, ARIA label

---

### Interactive Elements Table

- [ ] **Default state specified** for every interactive element
- [ ] **Hover state specified** for every interactive element (desktop)
- [ ] **Active/pressed state specified** for click/tap interactions
- [ ] **Disabled state specified** for elements that can be disabled
- [ ] **Loading state specified** for buttons that trigger async operations
- [ ] **Design token specified** for each state (no hardcoded hex values)
- [ ] **ARIA label or aria-description specified** for every interactive element

---

### Responsive Behavior Table

- [ ] **Table covers all relevant breakpoints** — mobile (default), sm:, md:, lg:, xl: as applicable
- [ ] **Each row describes a specific layout change** — not just "becomes responsive"
- [ ] **Mobile row is the default** (first row) — Tailwind mobile-first convention
- [ ] **Navigation change at mobile breakpoint specified** — hamburger vs inline nav

---

### Accessibility Section

- [ ] **Focus order specified** — numbered list of elements in Tab order
- [ ] **Keyboard shortcuts documented** — Enter, Esc, Arrow keys for any custom interaction
- [ ] **Screen reader announcements specified** — `aria-live` regions, count announcements, status updates
- [ ] **ARIA roles specified** — `role="list"` on lists, `role="listitem"` on items, etc.
- [ ] **Image alt text specified** — meaningful alt for informative images, `alt=""` for decorative
- [ ] **Color independence verified** — every status indicator has a non-color secondary indicator (icon + text)

---

## Global UI_Spec Checks

- [ ] **Zero hardcoded hex values** in the entire document — all colors use generic tokens
- [ ] **Zero org-specific token names** — no `raiz-orange`, `brand-teal`, or similar
- [ ] **All copy text is final** — no placeholder text like "[message text]" or "[button label]" or "[description]"
- [ ] **All image dimensions specified** for `next/image` components — width and height in pixels
- [ ] **Charts fully specified** per DR012 — component type, data interface, axis config, tooltip, legend, empty state
- [ ] **All form fields fully specified** per DR008 — label, placeholder, validation rules, error messages, character limits

---

## Final Gate Check

- [ ] All components have `has_loading_state: true`, `has_error_state: true`, `has_empty_state: true`, `has_populated_state: true` (for async components)
- [ ] All components have `has_props_interface: true`, `has_responsive_table: true`, `has_accessibility_section: true`
- [ ] All components have `has_exact_copy_text: true`, `design_tokens_only: true`

---

## Runtime Knowledge Policy

This checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR006, DR007, DR008, DR009, DR012, DR013, DR014
- `Agente09_UxUiDesigner/knowledge/principles.md` — P8, P11
- `Agente09_UxUiDesigner/context_view.md §5, §6, §7, §8` — UI spec conventions, tokens, state specs, WCAG
- `Agente09_UxUiDesigner/templates/UI_Spec.md` — template reference

**Never reads at runtime**: `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
