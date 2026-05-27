# Business Rules Extraction Skill

## Purpose
Identify and formally document business rules from stakeholder statements and interview logs, ensuring every rule has a traceable source, without inventing rules that were not explicitly stated.

## When to Use
- When business logic or domain constraints appear in elicited information from the interview log.
- When review of user stories reveals implicit rules that need to be made explicit before acceptance criteria can be finalized.
- When an acceptance criterion references a rule that has not yet been formally documented.

## Inputs
- `interview_log` — the `Requirements_Interview_Log.md` with stakeholder answers
- `stakeholder_statements` — direct quotes or summarized statements from elicitation sessions

## Outputs
- `Business_Rules.md` — formal rule register with BR-NNN entries following `templates/Business_Rules.md` format

## Constraints
- Every rule must have a traceable source: stakeholder role + session, named regulation + article, or named policy document
- Rules without sources become OQ-NNN entries — never confirmed rules
- Rules describe what the system must enforce — not how to implement the enforcement
- No technology decisions may appear in a business rule (e.g., "must validate using a regex" is an implementation detail)
- Rules must be distinguishable from acceptance criteria — a rule is a policy; an acceptance criterion is a test scenario
- "To Confirm" rules must have an associated OQ-NNN in `Open_Questions.md`

## Step-by-Step Procedure

1. **Read the interview log.** For each stakeholder answer, ask: "Does this answer state a constraint, a policy, or a mandate about how the business operates?" If yes, it is a candidate business rule.

2. **Formulate the rule.** A business rule has the form: "[Entity/Actor] [must/must not/can/cannot] [action/state] [under condition]". It should be unambiguous and non-technical. For rules with multiple conditions, list each condition in the `[under condition]` clause separated by AND/OR. Example: "Administrators [must] [audit all state changes] [under condition: the change affects user data OR the change is to a security setting]." Avoid nesting more than two conditions in a single rule — split compound rules into two BR-NNN entries if needed.

3. **Verify the source.** Identify the stakeholder role and session where this rule was stated. If the rule cannot be traced to a specific statement, do not create a confirmed rule — create an OQ-NNN instead: "Proposed rule: [X]. Was this explicitly confirmed? If yes, provide source."

4. **Check: is this a rule or a decision?**
   - **Business rule:** "Clients cannot cancel within 24 hours of the appointment." (Policy — from Business Owner)
   - **Technical decision:** "Client sessions must expire after 30 minutes of inactivity." (Session management — belongs to the Architect)
   - When in doubt, ask: "Would a non-technical stakeholder recognize this as a business policy?" If no, it is a technical decision.

5. **Identify applicability.** List the user stories (US-NNN) or features where this rule must be enforced.

6. **Check for conflicts.** If a new rule contradicts an existing rule, flag the conflict as an OQ-NNN before adding either rule.

7. **Assign BR-NNN ID** and add to `Business_Rules.md`. Set status to Confirmed or To Confirm.

8. **Link to acceptance criteria.** For each confirmed rule, verify that at least one negative scenario in `Acceptance_Criteria.md` tests the rule's enforcement. If no acceptance criterion exists for the rule: (a) create a new negative scenario AC-NNN and add it to `Acceptance_Criteria.md`, OR (b) if acceptance criteria are not yet finalized, move the rule to "To Confirm" status and add an OQ-NNN: "AC needed to test enforcement of BR-NNN."

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
