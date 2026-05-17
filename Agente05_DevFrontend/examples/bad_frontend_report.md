# Frontend Implementation Report — BAD EXAMPLE (annotated)

**Task ID:** TASK-042
**Title:** Projects page
**Date:** 2026-05-17
**Agent:** Agente05_DevFrontend

---

> ANNOTATION: This is a bad report. It is intentionally incomplete, vague, and missing required information. Each issue is annotated with [BAD:] and the correct approach.

---

## 1. Summary

[BAD: The summary is too vague — it does not mention what was created, modified, or what feature domain this covers.]

Done the projects page. Added some components.

---

## 2. Files Created

[BAD: Missing the component type column. Missing line counts. File paths are vague and incomplete.]

| Path | Notes |
|------|-------|
| `page.tsx` | projects page |
| `ProjectList.tsx` | list of projects |
| `Chart.tsx` | chart |

---

## 3. Files Modified

[BAD: "Various files" is not acceptable — every modified file must be listed with a change summary.]

Various files were modified.

---

## 4. Component Inventory

[BAD: No Client Component justification. Client Components listed without explaining why they need "use client".]

### 4.1 Server Components
- ProjectList

### 4.2 Client Components
- Chart (has "use client")
- ProjectList page (has "use client")

[BAD: "ProjectList page has 'use client'" suggests the page is incorrectly a Client Component — it should be a Server Component.]

---

## 5. UI States Inventory

[BAD: Empty section — not documented. This suggests no loading/error/empty states were implemented.]

N/A

[BAD: "N/A" for UI states means loading.tsx, error.tsx, and empty states were NOT created. This blocks Gate 4.]

---

## 6. Images

[BAD: Question not answered. Were `<img>` tags used? Was `next/image` used? This is a Gate 4 concern and must be explicitly confirmed.]

Using images in the component.

---

## 7. Accessibility Review

[BAD: `accessibility-check-skill` was not run. WCAG compliance is not verified. This blocks Gate 4.]

Looks accessible.

[BAD: "Looks accessible" is not a review. The skill must be run and its output documented.]

---

## 8. Design Token Review

[BAD: `design-token-compliance-skill` was not run. Violations may exist and block Gate 4.]

Used Tailwind classes.

[BAD: "Used Tailwind classes" does not confirm token compliance. The skill output must be documented.]

---

## 9. Test Coverage

[BAD: No test files listed. No test counts. No scenarios documented. This blocks Gate 4 as BLOCKED_MISSING_TESTS.]

Will add tests later.

[BAD: "Will add tests later" means tests won't be added. Tests are part of the Definition of Done for every task.]

---

## 10. Self-Review Checklist

[BAD: Checklist not run — no items checked. This is required before Gate 4 submission.]

(not run)

---

## 11. Assumptions

None.

[BAD: Even simple implementations have assumptions. If thumbnail image domains, routes, or data formats were assumed, they must be documented.]

---

## 12. Open Questions

None.

---

## 13. Gate Readiness

[BAD: gate_ready is set to true despite multiple blocking issues: no UI states, no accessibility review, no tests, no design token review. Setting gate_ready: true without completing the checklist is a process violation.]

**Gate 4 ready:** Yes

---

## What Makes This Report Unacceptable

1. **Summary too vague** — no file count, no feature domain, no implementation scope
2. **Files created missing component type** — QA cannot verify what was built
3. **Modified files not documented** — "various files" is not auditable
4. **UI States section is empty** — loading.tsx, error.tsx, empty states may be missing
5. **No image audit** — `<img>` tag violations can slip through undetected
6. **Accessibility review not run** — `accessibility-check-skill` is mandatory before Gate 4
7. **Design token review not run** — `design-token-compliance-skill` is mandatory before Gate 4
8. **"Will add tests later"** — violates Definition of Done; blocks Gate 4 as `BLOCKED_MISSING_TESTS`
9. **Self-review checklist not run** — mandatory before setting `gate_ready: true`
10. **gate_ready: true set without completing requirements** — misrepresents readiness to QA

---

*See `examples/good_frontend_report.md` for the correct format and level of detail.*
