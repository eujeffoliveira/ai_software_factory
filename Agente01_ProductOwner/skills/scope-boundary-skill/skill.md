# Scope Boundary Skill

## Purpose
Explicitly define what is in-scope and out-of-scope for this product version, with justified exclusions, preventing implicit scope creep during architecture and development phases.

## When to Use
- When features have been identified during elicitation and the boundary between this release and future work needs to be formalized.
- When a scope dispute arises during a later phase and the source of truth must be established.

## Inputs
- `business_problem` — confirmed business problem statement
- `objectives` — confirmed measurable objectives for this release
- `feature_requests` — complete list of features discussed (including those that may not be in scope)
- `constraints` — time, budget, regulatory, or dependency constraints that drive exclusions

## Outputs
- `Scope_Boundary.md` — explicit scope definition using `templates/Scope_Boundary.md` format

## Constraints
- Both in-scope AND out-of-scope sections are mandatory. A scope document without out-of-scope is incomplete.
- Every out-of-scope item must have a reason for exclusion. "Out of scope" with no reason is not acceptable.
- Scope is defined at feature/capability level — not at task or story level.
- No implementation decisions are made in scope definition (scope = what, not how).
- The scope boundary must be consistent with the PRD's Non-Objectives section.

## Step-by-Step Procedure

1. **List all features discussed** during elicitation — include features that stakeholders mentioned even if they were not formally requested. This prevents implicit omissions.

2. **Evaluate each feature against the objectives.** For each feature: Does it directly serve OBJ-01, OBJ-02, or OBJ-03? Features that serve an objective are candidates for in-scope. Features that do not serve any objective are candidates for out-of-scope.

3. **Apply constraints.** Review `constraints` (time, budget, complexity, dependencies). If a feature serving an objective cannot be delivered within constraints, it becomes out-of-scope with reason "deferred — [constraint]".

4. **Write the in-scope list.** Each in-scope feature: name, description of what capability it covers, and the related user stories (US-NNN).

5. **Write the out-of-scope list.** Each out-of-scope item: name, reason for exclusion (from the approved set: "deferred to Phase N", "insufficient business case for v1", "regulatory complexity requires dedicated planning", "external dependency not controllable", "confirmed not required by stakeholders"), and whether it is a future scope candidate.

6. **Write boundary clarifications.** Identify 2–3 features that are commonly requested or likely to be assumed in-scope but are actually excluded. Write explicit Q&A entries for them.

7. **Document future scope notes.** Out-of-scope items that are likely to be requested in future phases should have a forward note, so the Architect can design the system to accommodate them without requiring architectural rework.

8. **Write the scope change protocol.** Document how scope changes are handled: who requests, who evaluates, what constitutes a Gate 1 re-review trigger.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
