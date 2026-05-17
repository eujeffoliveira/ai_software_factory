# Scope Boundary Checklist

Use this checklist to verify that the scope boundary is well-defined, complete, and consistent with the PRD before Gate 1 submission.

---

## In-Scope Definition

- [ ] In-scope section is explicitly present in `Scope_Boundary.md`
- [ ] Each in-scope item describes a user-facing feature or capability — not a technical component
- [ ] Each in-scope item is linked to one or more user stories (US-NNN)
- [ ] All user stories in the PRD correspond to at least one in-scope feature
- [ ] No in-scope item is vague (e.g., "user management" needs to be decomposed into specific capabilities)
- [ ] In-scope list is complete — no feature implied by user stories is missing from the list

---

## Out-of-Scope Definition

- [ ] Out-of-scope section is explicitly present in `Scope_Boundary.md`
- [ ] Out-of-scope section is not empty — absence of out-of-scope is a defect
- [ ] Each out-of-scope item has a reason for exclusion
- [ ] Reasons are substantive: "deferred to Phase 2", "insufficient business case", "regulatory complexity", "external dependency" — not just "out of scope"
- [ ] Out-of-scope items that may be requested by stakeholders are explicitly named (prevents implicit scope creep)
- [ ] No feature that was discussed during elicitation is silently absent — either in-scope or explicitly out-of-scope

---

## Boundary Clarifications

- [ ] At least one boundary clarification addresses an expected edge case or ambiguous request
- [ ] Boundary clarifications give clear yes/no answers with reasoning
- [ ] Boundary clarifications are consistent with the PRD's Non-Objectives section

---

## Future Scope

- [ ] Out-of-scope items marked "Future Scope: Yes" have a note explaining why they were deferred
- [ ] Future scope items do not create architectural constraints that the Software Architect should know about (if so, include in handoff notes)
- [ ] No future scope item has been accidentally included in current in-scope list

---

## Consistency with PRD

- [ ] Scope_Boundary.md in-scope list is consistent with PRD Section 3 (Objectives)
- [ ] Scope_Boundary.md out-of-scope list is consistent with PRD Section 4 (Non-Objectives)
- [ ] No user story in the PRD references a feature that is listed as out-of-scope
- [ ] NFRs do not apply to out-of-scope features

---

## Scope Change Protocol

- [ ] Scope change protocol is documented in `Scope_Boundary.md`
- [ ] Protocol defines who can request scope changes
- [ ] Protocol defines what triggers a Gate 1 re-review

---

**Scope Boundary is ready when:** All items above are checked. A scope boundary without an explicit out-of-scope section will be rejected at Gate 1.
