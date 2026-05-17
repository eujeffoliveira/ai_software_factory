# Scope Boundary Skill — Checklist

## Before Execution
- [ ] All discussed features (not just requested ones) are included in the input feature_requests list
- [ ] Constraints that drive exclusions are explicitly listed

## During Execution
- [ ] Every discussed feature is evaluated against the objectives
- [ ] Every feature is placed in either in-scope or out-of-scope (no feature silently omitted)
- [ ] Every out-of-scope item has a specific reason — not just "out of scope"

## Output Validation
- [ ] in_scope list is non-empty
- [ ] out_of_scope list is non-empty (a boundary without exclusions is suspicious)
- [ ] Every out_of_scope item has a reason_for_exclusion of at least 10 characters
- [ ] features_without_coverage array is empty — all input features are placed
- [ ] scope_checklist_passed is true — scope_boundary_checklist.md passed
- [ ] Scope is consistent with PRD's Non-Objectives section

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
