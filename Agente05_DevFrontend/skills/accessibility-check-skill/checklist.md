# Accessibility Check — Checklist

## Pre-Execution
- [ ] All interactive component files identified

## Audit Categories
- [ ] Text alternatives (images, icon buttons, charts)
- [ ] Keyboard navigation (Tab order, Enter/Space, focus trap)
- [ ] Focus visibility (visible :focus ring on all elements)
- [ ] Color contrast (4.5:1 text, 3:1 large/UI)
- [ ] Semantic HTML (landmarks, headings, lists)
- [ ] Forms (labels, error descriptions)
- [ ] ARIA (expanded, selected, live regions)
- [ ] Dynamic content (live regions for updates)

## Output
- [ ] All issues documented with severity
- [ ] Corrected code provided for each issue
- [ ] `wcag_aa_compliant` reflects zero CRITICAL/HIGH open

## Gate Status
- [ ] If zero CRITICAL/HIGH: `gate_4_status: "READY_FOR_QA"`
- [ ] If any CRITICAL/HIGH open: `gate_4_status: "BLOCKED_ACCESSIBILITY_FAILURE"`

## Runtime Knowledge Policy
- [ ] Accessibility rules from `knowledge/heuristics.md` H6, H14, H15 used
- [ ] No external WCAG documentation consulted at runtime
