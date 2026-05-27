# User Story Mapping Skill

## Purpose
Decompose confirmed features and personas into a structured user story map, organizing stories by activity and flow, ensuring each story satisfies INVEST criteria.

## When to Use
- When features and user types have been confirmed through elicitation and the Product Owner is ready to structure the stories before drafting the PRD.
- When a story map needs to be reorganized after a PRD revision that changes scope.

## Inputs
- `target_users` — list of confirmed personas with roles and goals
- `business_problem` — confirmed business problem statement
- `feature_list` — list of confirmed features from elicitation

## Outputs
- `User_Story_Map.md` — stories organized by persona and activity using `templates/User_Story_Map.md` format

## Constraints
- Stories must follow canonical format: "As a [user], I want [action], so that [benefit]"
- "So that [benefit]" must be a real business benefit, not a restatement of the action. A business benefit answers "why does the user care?": faster task completion (time savings), reduced errors (quality), compliance (legal risk reduction), less friction (adoption). Technical restatements are not benefits (e.g., "so that the system stores the record" or "so that the API receives the data"). If the benefit describes an internal system state rather than a user outcome, rewrite it.
- Stories must be small enough to fit in one sprint — epics must be decomposed
- No story may be a technical task (no developer persona, no infrastructure stories)
- Each story must be validated against `checklists/invest_checklist.md` before being added to the map
- Assign priority: MUST (MVP) / SHOULD (next release) / COULD (nice-to-have)
- Stories are organized by persona first, then by activity

## Step-by-Step Procedure

1. **List confirmed personas** with role, goal, and primary activities.

2. **For each persona, identify activities** — high-level goals the persona tries to achieve using the system. An activity is broader than a story (e.g., "Manage appointments" is an activity; "Book a new appointment" is a task within that activity).

3. **For each activity, identify tasks.** A task is one step within the activity that a user wants to accomplish. Each task maps to one user story.

4. **Write the user story for each task.** Format: "As a [persona], I want [task], so that [business benefit]."

5. **Validate each story against INVEST.** Run `checklists/invest_checklist.md` for each story. Apply these rules by failing criterion: if it fails **Independent** → decompose into smaller stories with explicit dependency notes; if it fails **Negotiable** → rewrite to remove implementation prescriptions; if it fails **Small** → decompose into two or more stories; if it fails **Valuable** or **Estimable** → rewrite the story for clarity; if it fails **Testable** → add at least one acceptance criterion before rewriting.

6. **Assign priorities.** MUST stories constitute the MVP. SHOULD and COULD stories are candidates for later releases. Document the MVP boundary explicitly.

7. **Check for completeness.** Every feature from the `feature_list` must be traceable to at least one user story. If a feature has no story, it cannot be delivered.

8. **Check for independence.** Stories within the same activity that have implied dependencies should have those dependencies noted.

9. **Write `User_Story_Map.md`** using the template. Include the MVP boundary and the coverage summary table.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
