# Design Token Compliance — Checklist

## Pre-Execution
- [ ] All component files in the PR identified

## Violation Scans
- [ ] Inline `style={{}}` props scanned
- [ ] Hardcoded hex colors (`#...`, `rgb(...)`) scanned
- [ ] Tailwind palette colors (`bg-blue-500`, `text-gray-700`) scanned
- [ ] CSS module imports scanned
- [ ] SVG/Recharts hardcoded colors scanned (`stroke="#..."`)

## Fix Application
- [ ] All CRITICAL violations (inline styles, hex colors) fixed
- [ ] All HIGH violations (palette colors) fixed or documented as exceptions
- [ ] Corrected code uses design tokens from token map

## Gate Status
- [ ] If zero CRITICAL/HIGH: `gate_4_status: "READY_FOR_QA"`
- [ ] If any CRITICAL/HIGH: `gate_4_status: "BLOCKED_DESIGN_SYSTEM_VIOLATION"`

## Runtime Knowledge Policy
- [ ] Token map from `context_view.md` § 12 used
- [ ] No external design system documentation consulted
