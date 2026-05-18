# Bad Output — ui-state-design-skill
## See: Agente09_UxUiDesigner/examples/bad_ui_spec.md
## This file references the canonical bad example.

The bad_ui_spec.md in the parent examples/ folder demonstrates incorrect output
from ui-state-design-skill. Key defects shown:

1. No TypeScript props interface — "receives tasks from the API" (FM-05)
2. Loading state is "show spinner" — no skeleton, no ARIA (FM-01, FM-05)
3. Error state is "show error message" — no icon, no copy, no role="alert" (FM-01, FM-05)
4. No empty state designed at all (FM-01, BLOCKED_MISSING_STATES)
5. Hardcoded hex values: #3B82F6, #EF4444, #22C55E (token violation)
6. No accessibility section (P8 violation, BLOCKED_ACCESSIBILITY_VIOLATION)
7. Responsive behavior: "make it mobile-friendly" — not specific (FM-05)
8. Overdue status communicated by color only — no secondary indicator (DR006)

Gate impact: BLOCKED_MISSING_STATES + BLOCKED_ACCESSIBILITY_VIOLATION

See the full annotated bad example at: Agente09_UxUiDesigner/examples/bad_ui_spec.md
