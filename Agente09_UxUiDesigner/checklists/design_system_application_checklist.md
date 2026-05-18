# Design System Application Checklist
## Agente09_UxUiDesigner
## Apply during and after UI_Spec.md authoring

---

## Purpose

This checklist supports `design-system-application-skill`. It ensures that every visual property in the design artifacts maps to a generic design token and that no hardcoded values or org-specific token names appear anywhere.

---

## Section 1: Token Inventory Scan

For each component in `UI_Spec.md`, verify that every specified color, background, border, and border-radius maps to a token from the authorized set:

**Authorized tokens:**
- `primary-color`
- `secondary-color`
- `text-foreground`
- `text-muted-foreground`
- `bg-background`
- `bg-muted`
- `border`
- `radius`
- `destructive`
- `success`
- `warning`

Checks:
- [ ] **Zero hardcoded hex values** — scan all component specs for any string matching `#[0-9A-Fa-f]{3,6}` or `rgb(...)` or `hsl(...)`
- [ ] **Zero RGB/HSL values** — no `rgb(255, 87, 51)` or equivalent inline color values
- [ ] **Zero org-specific token names** — no `raiz-orange`, `brand-teal`, `corporate-blue`, or any name that references an organization
- [ ] **Zero generic color names** — no `blue`, `green`, `red` used as color values (token names must be semantic)

---

## Section 2: Interactive Element Tokens

For each interactive element in the `Interactive Elements` table:

- [ ] **Default state token is from the authorized set** — `bg-primary-color`, `border`, etc.
- [ ] **Hover state is a token modifier** — `opacity-90`, `bg-muted/80`, not a different hex
- [ ] **Active/pressed state uses a modifier** — `scale-95`, `opacity-80`, not a custom color
- [ ] **Disabled state uses `opacity-50`** or a token-based approach — not a hardcoded disabled color
- [ ] **Destructive actions use `destructive` token** — delete buttons, confirmation dialogs, irreversible warning messages

---

## Section 3: Typography Tokens

- [ ] **All text colors use `text-foreground` or `text-muted-foreground`** — no hardcoded text colors
- [ ] **Headings, body, meta text hierarchy uses Tailwind utility classes** — `text-lg`, `text-base`, `text-sm`, `text-xs` (size classes, not font-specific tokens)
- [ ] **No `font-family` specified** — font stack is resolved by Tailwind CSS configuration at instantiation time

---

## Section 4: Background and Surface Tokens

- [ ] **Page background uses `bg-background`** — not `white`, `#fff`, or `bg-white`
- [ ] **Card and surface backgrounds use `bg-muted`** — not `bg-gray-50` or hardcoded surface colors
- [ ] **Skeleton blocks use `bg-muted` or `bg-muted-foreground/20`** — not `bg-gray-200`

---

## Section 5: Status Indicators

- [ ] **Success states use `success` token** — not hardcoded green
- [ ] **Error/destructive states use `destructive` token** — not hardcoded red
- [ ] **Warning states use `warning` token** — not hardcoded amber/yellow
- [ ] **All status indicators have a secondary indicator** (icon + text) alongside the color token (DR006)

---

## Section 6: Border and Radius Tokens

- [ ] **All border colors use `border` token** — not `border-gray-200` or hardcoded border colors
- [ ] **All border-radius uses `radius` token** — `rounded-[radius]` — not fixed values like `rounded-md` or `rounded-lg`

---

## Section 7: Component Reuse Audit

- [ ] **Every proposed new component has been checked against the existing component list** (DR003)
- [ ] **Existing components reused before proposing new ones**: Button, Card, Dialog, Sheet, Select, Tabs, Badge, Alert, Accordion, DataTable
- [ ] **New component proposals documented** in `new_components_proposed` array with explicit justification

---

## Section 8: Token Gap Report

_List any visual property that required a token not in the authorized set:_

| Property Needed | Usage | Token Requested | Escalation Status |
|-----------------|-------|-----------------|-------------------|
| [e.g., info state color] | [Badge indicating informational status] | [e.g., info] | [pending / approved] |

_If no token gaps: write "None" in the table._

---

## Final Scan Checklist

Before signing off, perform a final search through all design artifacts:

- [ ] Search `UI_Spec.md` for `#` — verify no matches are hex color values
- [ ] Search `UI_Spec.md` for `rgb(` — verify no inline RGB colors
- [ ] Search `UI_Spec.md` for `raiz` or `brand` or `corporate` — verify no org-specific names
- [ ] Search `Wireframes.md` for any color specifications — wireframes should have none

---

## Verdict

- [ ] **PASS** — Zero hardcoded values found, all tokens from authorized set, no org-specific names
- [ ] **PASS WITH TOKEN GAPS** — All existing elements use authorized tokens, but [N] token gaps identified and escalated to Tech Lead
- [ ] **FAIL** — Hardcoded values or org-specific token names found; cannot submit until corrected

---

## Runtime Knowledge Policy

This checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR003, DR006, DR013
- `Agente09_UxUiDesigner/context_view.md §6` — design token definitions
- `Agente09_UxUiDesigner/agent_config.json` — golden_path.design_tokens

**Never reads at runtime**: `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
