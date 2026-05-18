# design-system-application-skill Execution Checklist
## Agente09_UxUiDesigner

---

## Pre-Execution

- [ ] `UI_Spec.md` is available as the primary audit target
- [ ] Authorized token set reviewed: `context_view.md §6`

---

## Hex Value Scan

- [ ] Searched `UI_Spec.md` for `#` — confirmed no matches are hex color values
- [ ] Searched `UI_Spec.md` for `rgb(` — confirmed no inline RGB colors
- [ ] Searched `UI_Spec.md` for `hsl(` — confirmed no inline HSL colors
- [ ] Searched `UI_Spec.md` for `rgba(` — confirmed no inline RGBA colors

---

## Org-Specific Name Scan

- [ ] Searched `UI_Spec.md` for `raiz-` — no matches
- [ ] Searched `UI_Spec.md` for `brand-` — no matches (unless it is a token from the authorized set)
- [ ] Searched `UI_Spec.md` for `corporate-` — no matches
- [ ] Searched `UI_Spec.md` for any organization-specific name — no matches

---

## Per-Token Mapping Verification

- [ ] All primary button backgrounds use `bg-primary-color` or `primary-color`
- [ ] All secondary button backgrounds use `bg-secondary-color`, `bg-muted`, or `outline` variant
- [ ] All primary text uses `text-foreground`
- [ ] All secondary/helper text uses `text-muted-foreground`
- [ ] All page backgrounds use `bg-background`
- [ ] All card/surface backgrounds use `bg-muted`
- [ ] All border colors use `border`
- [ ] All border radii use `radius` token
- [ ] All error/destructive states use `destructive`
- [ ] All success states use `success`
- [ ] All warning states use `warning`
- [ ] All skeleton blocks use `bg-muted` or `bg-muted-foreground/20`

---

## Interactive States Verification

- [ ] Hover states use modifiers (`opacity-90`, `bg-muted/80`) — not separate hex colors
- [ ] Active states use modifiers (`scale-95`, `opacity-80`) — not separate hex colors
- [ ] Disabled states use `opacity-50` — not hardcoded disabled colors
- [ ] Focus rings reference `primary-color` — not hardcoded focus ring colors

---

## Status Indicator Compliance (DR006)

- [ ] Every status indicator uses color token + secondary indicator (icon + text label)
- [ ] No status communicated by color alone

---

## Component Reuse Audit (DR003)

- [ ] Each new component in `new_components_proposed` verified against component list
- [ ] Any removable proposals replaced with existing component specifications
- [ ] Remaining new proposals have documented justification

---

## Token Gap Report

- [ ] Token gaps documented in output schema `token_gaps` array
- [ ] Each gap has an escalation record in Handoff Package

---

## Final Confirmation

- [ ] `hardcoded_values_found: 0` confirmed
- [ ] `org_specific_tokens_found: 0` confirmed
- [ ] `design_system_application_checklist.md` completed and signed off

---

## Runtime Knowledge Policy

This skill checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR003, DR006, DR013
- `Agente09_UxUiDesigner/context_view.md §6` — token definitions
- `Agente09_UxUiDesigner/agent_config.json` — `golden_path.design_tokens`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
