# Skill: design-system-application-skill
## Agente09_UxUiDesigner

---

## Purpose

Maps every visual element in the design artifacts to a generic design token from the authorized set. Audits `UI_Spec.md` for hardcoded colors, org-specific token names, and missing token coverage. Ensures the design package is fully tokenized, white-label-ready, and compatible with instantiation-time token resolution.

---

## When to Use

- `UI_Spec.md` is being written or reviewed for the first time
- A returned design package was flagged for hardcoded values or token violations
- A new visual pattern is being introduced and needs token mapping
- Final pre-submission check before assembling the Handoff Package

**Do NOT trigger when:**
- Only structural wireframes are being reviewed (no colors to check)
- UX_Flow.md only is being reviewed (no visual specifications)

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `UI_Spec.md` (draft or complete) | Yes | The specification to audit and correct |
| `context_view.md §6` | Auto | Authorized token set (local knowledge) |
| `agent_config.json` | Auto | `golden_path.design_tokens` section |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| `UI_Spec.md` (corrected) | All visual properties mapped to generic tokens; zero hardcoded values |
| Token gap report | Any visual properties that needed a token not in the authorized set |
| `checklists/design_system_application_checklist.md` (completed) | Signed-off token audit |

Schema: `output.schema.json`

---

## Procedure

1. **Scan for hardcoded hex values.** Search `UI_Spec.md` for any string matching: `#[0-9A-Fa-f]{3,6}`, `rgb(...)`, `hsl(...)`, `rgba(...)`. Every match is a violation. Replace with the appropriate generic token.

2. **Scan for org-specific token names.** Search for patterns like: `raiz-*`, `brand-*`, `corporate-*`, or any token name that references an organization or product line. These are white-label violations. Replace with the nearest generic token.

3. **Scan for generic color name values.** Names like `blue`, `green`, `red`, `gray`, `white`, `black` used as CSS color values (not as Tailwind utility prefixes) are violations. Map to semantic tokens.

4. **Map each visual property to its token.** For each component, go through every visual specification:
   - Text colors → `text-foreground` or `text-muted-foreground`
   - Background colors → `bg-background` or `bg-muted`
   - Primary action backgrounds → `bg-primary-color`
   - Secondary action backgrounds → `bg-secondary-color` or `bg-muted`
   - Borders → `border`
   - Error/destructive states → `destructive`
   - Success states → `success`
   - Warning states → `warning`
   - Border radius → `radius`

5. **Check interactive element tokens.** Every row in the Interactive Elements table must use token-based state definitions: `opacity-90` for hover (not a different hex), `scale-95` for active, `opacity-50` for disabled.

6. **Check status indicator compliance.** Every status indicator must have: (1) a token for color, AND (2) a secondary indicator (icon + text). Color-only is a DR006 violation.

7. **Identify token gaps.** If a visual property genuinely needs a semantic value not in the authorized set (e.g., "information state" that is distinct from "success" and "warning"), document it as a token gap.

8. **Document token gaps as escalations.** For each gap, create an entry in the Handoff Package `implementation_notes.design_token_gaps` array with `token_name`, `usage`, and `escalation_status`. Allowed values for `escalation_status`: `"pending"` (created, not yet reviewed), `"approved"` (Tech Lead approved new token), `"rejected"` (Tech Lead rejected — use nearest existing token), `"implemented"` (token added to design system). Start all new gaps as `"pending"`. Escalate to Tech Lead.

9. **Verify component reuse.** Check each component specified against the design system component list (DR003). If a component listed in `new_components_proposed` can be satisfied by an existing component, remove the new proposal and use the existing one.

10. **Complete `checklists/design_system_application_checklist.md`.** Run all 8 sections. Sign off.

---

## Authorized Token Reference

| Token | Typical Usage |
|-------|--------------|
| `primary-color` | Brand primary — CTA buttons, links, active states, focus rings |
| `secondary-color` | Brand secondary — secondary actions, badges, accents |
| `text-foreground` | Primary text — headings, body, labels |
| `text-muted-foreground` | Secondary text — helper text, meta, placeholders |
| `bg-background` | Page background |
| `bg-muted` | Cards, sidebars, inputs, skeleton blocks |
| `border` | Dividers, card borders, input outlines |
| `radius` | Border radius applied to cards, buttons, inputs |
| `destructive` | Error states, delete actions, irreversibility warnings |
| `success` | Success states, completion, confirmation |
| `warning` | Warning states, pending, attention required |

---

## Quality Gate Reference

`READY_FOR_FRONTEND` requires `design_tokens_only: true` for all components in the Handoff Package. Any hardcoded value is a blocker.

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR003, DR006, DR013
- `Agente09_UxUiDesigner/context_view.md §6` — authorized token definitions
- `Agente09_UxUiDesigner/agent_config.json` — `golden_path.design_tokens`
- `Agente09_UxUiDesigner/checklists/design_system_application_checklist.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
