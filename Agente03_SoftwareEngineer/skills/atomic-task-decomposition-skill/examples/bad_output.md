# Bad Output — Atomic Task Decomposition Skill

## Input: Same User Authentication Feature (XL component)

---

## Bad Decomposition Output (Incorrect)

Only 1 task produced — no decomposition actually happened:

**TASK-001: Implement user authentication feature**
- file_path: null (not set)
- type: backend | complexity: L (should be XL)
- depends_on: []
- acceptance_criteria: []
- decomposition_rationale: "User auth is one feature so it's one task"

---

## Problems

1. **No actual decomposition:** XL component remains as XL task — DR001 violation
2. **file_path: null:** Which file? NextAuth config? Prisma schema? Login page? All 5 files? — DR004
3. **Complexity marked L not XL:** Underestimate hides the real problem
4. **Empty acceptance_criteria:** Nothing to verify against — P4
5. **decomposition_rationale is wrong:** "One feature = one task" is the exact anti-pattern this skill exists to prevent

## Correct Behavior

The skill should output 5 tasks (as shown in good_output.md), not 1. The skill is supposed to DECOMPOSE, not copy-paste the component as a task.

**xl_eliminated:** false (XL task still exists — blocks Gate 3)
**coverage_confirmed:** false (criteria not mapped)
