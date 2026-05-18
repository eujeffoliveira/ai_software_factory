# Good Output — design-system-application-skill

## Example: Token Audit for Task Management

**Feature**: Task Management
**Verdict**: PASS

---

## Audit Summary

- Hardcoded hex values found: 0
- Org-specific token names found: 0
- Token gaps: 1 (information state — escalated)
- New component proposals: 1 justified, 0 replaced

---

## Violations Fixed

None — initial spec was clean (common after thorough ui-state-design-skill execution).

---

## Token Gaps

| Token Needed | Usage | Escalation Status |
|-------------|-------|-------------------|
| `info` | Used for informational badge on Task detail page ("This task is linked to [Project] — info level, not warning or success"). No existing token semantically covers neutral informational highlighting. | pending — escalated to Tech Lead as ESC-002 |

---

## New Component Proposals

| Component | Status |
|-----------|--------|
| `TaskStatusBadge` | Justified — Badge component exists, but the TaskStatusBadge requires a specific `status: 'pending' | 'in_progress' | 'complete'` prop type with three distinct icon + label + token combinations. Existing generic Badge only supports `variant` prop without typed status enum. |

---

## Token Mapping Confirmed

- All CTA buttons: `bg-primary-color` ✓
- All secondary actions: `variant="outline"` with `border` token ✓
- All headings: `text-foreground` ✓
- All helper text: `text-muted-foreground` ✓
- All page backgrounds: `bg-background` ✓
- All card surfaces: `bg-muted` ✓
- All borders: `border` ✓
- Destructive actions (delete task): `destructive` ✓
- Overdue status: `destructive` token + `⚠` icon + "Overdue" text label ✓

---

## Why This is a Good Example:
# 1. Zero violations found (clean after thorough execution)
# 2. Token gap is legitimate — "info" is semantically different from warning/success
# 3. Gap is escalated (not ignored, not hardcoded to compensate)
# 4. New component proposal is justified — existing Badge cannot satisfy the typed status requirement
# 5. Token mapping confirmation shows thoroughness
# 6. Verdict correctly reflects state (PASS because violations are zero; gap is escalated)
