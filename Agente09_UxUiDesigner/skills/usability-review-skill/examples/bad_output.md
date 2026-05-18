# Bad Output — usability-review-skill

## Example: Incomplete Usability Review

**Feature**: Task Management
**Verdict**: PASS

---

## Issues Found

None found. Design looks good!

---

## Sections Review

All sections pass.

---

## Overall Verdict: PASS

ready_for_handoff: true

---

## Why This is a BAD Example:
# 1. "None found — design looks good!" is not a review. It is a rubber stamp.
#    A real review will ALWAYS find at least some medium/low issues to note.
#    "No issues" signals the review was not performed.
#
# 2. "All sections pass" without checking specific items is not verification.
#    Each section in the usability checklist has specific items that must be
#    confirmed individually — not assessed as a block.
#
# 3. The verdict "PASS" after zero effort does not protect the design from
#    usability problems. If a high-severity issue exists and was not found here,
#    it will be found by a real user after implementation — at much higher cost.
#
# 4. Specific violations that SHOULD have been caught in this example:
#    - The Create Task modal likely has >3 primary actions (Hick's Law — P1)
#    - The overdue status might use only red color with no secondary indicator (DR006)
#    - The error message copy might not follow the "[What happened]. [What to do]." formula (H9)
#    - Mobile empty state CTA might be hard to reach (DR010)
#    - Form might validate on submit only (H4)
#
# The correct output is shown in good_output.md — specific issues, principle references,
# documented resolutions, accurate verdict.
