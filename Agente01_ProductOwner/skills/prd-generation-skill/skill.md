# PRD Generation Skill

## Purpose
Assemble a complete, valid `PRD.md` from all previously collected elicitation artifacts, validate each section, and prepare the document for Gate 1 review.

## When to Use
- When all elicitation is complete: business objective confirmed, target users confirmed, core features identified, business rules sourced, NFRs drafted, scope boundary defined, open questions registered.
- When a PRD revision is requested after a Gate 1 `NEEDS_MORE_REQUIREMENTS` decision.

## Inputs
- `Requirements_Interview_Log.md` — structured answers from elicitation sessions
- `User_Story_Map.md` — stories organized by persona and activity
- `Acceptance_Criteria.md` — Gherkin criteria per user story
- `Non_Functional_Requirements.md` — all 10 NFR categories
- `Business_Rules.md` — confirmed and pending business rules
- `Open_Questions.md` — all registered open questions with criticality
- `Product_Risks.md` — all identified product risks
- `Scope_Boundary.md` — in-scope and out-of-scope definitions

## Outputs
- `PRD.md` — complete PRD valid against `schemas/prd.schema.json`, following `templates/PRD.md` structure

## Constraints
- No section may be left empty or contain placeholder text in the final output.
- No technology decisions may be embedded (no database names, frameworks, libraries).
- All user stories must pass INVEST validation before being included.
- All acceptance criteria must use Gherkin format.
- NFRs must have measurable metrics — vague NFRs are blocked.
- Business rules without sources must be moved to Open Questions, not included as confirmed rules.
- The PRD must include all 15 required sections as defined in `templates/PRD.md`.

## Step-by-Step Procedure

1. **Verify input completeness.** Check that all 8 input artifacts are present and non-empty. If any are missing, identify which stories or sections cannot be written and report the gap before proceeding.

2. **Write Section 1 (Summary).** 3–5 sentences: what is the product, who is it for, what problem does it solve. No technology choices.

3. **Write Section 2 (Business Problem).** Pull the problem statement, evidence, and impact from the interview log. Verify the problem is phrased in business terms, not feature terms.

4. **Write Section 3 (Objectives).** Extract measurable objectives confirmed during elicitation. Each objective must have a success criterion.

5. **Write Section 4 (Non-Objectives).** Pull from `Scope_Boundary.md` out-of-scope list. Summarize at PRD level; full boundary in `Scope_Boundary.md`.

6. **Write Section 5 (Target Users).** Pull personas from `User_Story_Map.md`. Verify each persona has a role description and a pain point.

7. **Write Section 6 (User Stories).** Pull from `User_Story_Map.md`. Validate each story against `checklists/invest_checklist.md` before inclusion. Assign priorities.

8. **Write Section 7 (Acceptance Criteria).** Pull from `Acceptance_Criteria.md`. Verify each story has at least one HP and one NS scenario in Gherkin format.

9. **Write Section 8 (Functional Requirements).** Derive FR-NNN entries from the confirmed user stories and business rules. Each FR must be verifiable.

10. **Write Section 9 (Non-Functional Requirements).** Pull from `Non_Functional_Requirements.md`. Verify all 10 categories present. Reject any NFR without a measurable metric.

11. **Write Section 10 (Business Rules).** Pull only confirmed rules from `Business_Rules.md`. Move unconfirmed rules to Section 14 as OQ-NNN.

12. **Write Section 11 (Data Requirements).** Document core entities at business level only. Remove any schema-level details (column names, ORM syntax).

13. **Write Section 12 (Product Risks).** Pull from `Product_Risks.md`. Verify HIGH-impact risks have mitigations.

14. **Write Section 13 (Assumptions).** Document all assumptions made during elicitation.

15. **Write Section 14 (Open Questions).** Pull from `Open_Questions.md`. Verify no BLOCKING questions remain unresolved.

16. **Write Section 15 (Handoff Status).** Set Gate 1 readiness status. If any BLOCKING questions exist, set to "Pending OQ Resolution."

17. **Run `checklists/prd_quality_checklist.md`.** Verify all 30+ items pass. Fix any failures before declaring the PRD complete.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
