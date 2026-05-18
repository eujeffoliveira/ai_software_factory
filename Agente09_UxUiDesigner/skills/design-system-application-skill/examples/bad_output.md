# Bad Output — design-system-application-skill

## Example: Failed Token Audit

**Feature**: Task Management
**Verdict**: PASS (INCORRECT — should be FAIL)

---

## Audit Summary

Design looks good! Tokens are being used appropriately.

---

## Violations Fixed

None found.

---

## Why This is a BAD Example:
# 1. "Design looks good! Tokens are being used appropriately." is not an audit.
#    It is a rubber stamp. A real audit scans for specific patterns.
#
# 2. If the original bad_ui_spec.md were audited this way:
#    - #3B82F6 would not be caught
#    - #EF4444 would not be caught
#    - #22C55E would not be caught
#    - #FFFFFF would not be caught
#    - raiz-orange (if present) would not be caught
#
# 3. These violations would then reach Agente05_DevFrontend, who would:
#    - Implement hardcoded colors in the codebase
#    - Cause visual inconsistency with the client's brand
#    - Create maintenance debt that costs 10× more to fix later
#
# 4. The correct audit explicitly:
#    - Searches for hex patterns (#xxx, #xxxxxx)
#    - Searches for rgb(, hsl( patterns
#    - Checks every button, card, text, and background for token usage
#    - Documents any violations found with location and correction
#    - Identifies token gaps with escalation records
#
# 5. Even if the spec is clean, the output should say:
#    "Searched for #, rgb(, hsl( — 0 matches found.
#     All [N] interactive elements verified against token list.
#     0 violations found.
#     1 token gap escalated (ESC-002).
#     Verdict: PASS."
#    Not: "Looks good!"
