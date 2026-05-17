# Bug Report — BUG-[NNN]

**Report ID:** BUG-[NNN]  
**QA Report:** QA-[NNN]-C[cycle]  
**Date:** YYYY-MM-DD  
**Reported by:** Agente06_QaEngineer  

---

## Summary

| Field | Value |
|-------|-------|
| **Bug ID** | BUG-[NNN] |
| **Severity** | [CRITICAL / HIGH / MEDIUM / LOW] |
| **Title** | [Short, precise title — what is wrong] |
| **Component** | [Feature component name] |
| **File** | `[path/to/file.ts]` |
| **Line** | [line number or range] |
| **Responsible Agent** | [Agente04_DevBackend / Agente05_DevFrontend] |
| **Acceptance Criterion Violated** | [AC-NNN / SECURITY / COVERAGE] |
| **Regression Test Required** | [YES / NO] |
| **Escalate to Security** | [YES / NO] |

---

## Severity Rationale

> CRITICAL = auth bypass / data loss / security vulnerability / data corruption  
> HIGH = feature broken, user completely blocked from primary workflow  
> MEDIUM = degraded UX, workaround available  
> LOW = cosmetic, minor inconvenience  

**Why [SEVERITY]:**  
[Explain specifically why this defect merits the assigned severity. Reference the severity matrix from context_view.md Section 8.]

---

## Description

[Precise description of the bug. Include:
- What condition triggers the defect
- What part of the system is affected
- Why this is a problem (impact on user / system / security)
- Any patterns observed (does it affect all users or specific conditions)]

---

## Reproduction Steps

1. [Step 1 — precondition or setup]
2. [Step 2 — action taken]
3. [Step 3 — additional action if needed]
4. [Step N — observe the defect]

---

## Expected Behavior

[What should happen according to the PRD acceptance criterion or the Golden Path rules.]

---

## Actual Behavior

[What actually happens — be precise. Include error messages, wrong values, or incorrect system state.]

---

## Test That Found This Bug

```
File: [path/to/test/file.test.ts]
Test: [describe block > it block name]
Failure: [Paste or summarize the failure message]
```

---

## Recommendation

[Specific, actionable fix recommendation. Do not say "fix the bug." Explain:
- What needs to change
- Where to make the change
- What the correct behavior should be
- Any reference to the pattern in context_view.md or a Golden Path rule]

**Example for a missing auth check:**
> Add `const session = await auth()` as the FIRST statement in `createTask.ts` (line 3), followed by `if (!session?.user?.id) { return { error: "Unauthorized" } }`. The auth check must precede all other operations including Zod validation. See context_view.md Section 2, Server Action Pattern.

---

## Regression Test Requirement

> Required for all CRITICAL and HIGH severity bugs.

When this bug is fixed, the developer must commit a regression test that:
1. **Fails** when the fix is reverted (proves the test catches the bug)
2. **Passes** with the fix in place (proves the fix is correct)

**Suggested test name:**  
`"does not [reproduce bug scenario] — regression for BUG-[NNN]"`

**Suggested test setup:**  
[Describe the test setup that reproduces the bug condition, so the developer knows what the regression test should look like]

---

*This bug report is produced by Agente06_QaEngineer as part of Gate 4 (QA Review). The responsible agent must address this before resubmitting for Gate 4 evaluation.*
