# Quality Gate — Agente01_ProductOwner

_Gate 1 — PRD Approval. Evaluated by Agente00_TechLead._

---

## Gate 1 — PRD Approval

### Purpose

Validate that the Product Requirements Document and supporting artifacts meet the minimum quality bar required to hand off to the Software Architect. A PRD that fails Gate 1 wastes architecture and implementation effort.

### Mandatory Artifacts

All of the following must be present and non-empty:

| # | Artifact | Minimum Content |
|---|---|---|
| 1 | PRD.md | All mandatory sections filled |
| 2 | Requirements_Interview_Log.md | At least one elicitation session documented |
| 3 | Open_Questions.md | All OQ-NNN entries registered |
| 4 | User_Story_Map.md | All epics and user stories listed |
| 5 | Acceptance_Criteria.md | All AC-NNN-NN entries in BDD format |
| 6 | Business_Rules.md | All BR-NNN entries with sources |
| 7 | Non_Functional_Requirements.md | All 10 NFR categories covered |
| 8 | Scope_Boundary.md | Both in-scope and out-of-scope sections |
| 9 | Product_Risks.md | All PRISK-NNN entries with impact |
| 10 | Handoff_To_Architect.md | All 9 handoff fields present |

### Gate 1 Decision Criteria

| Criterion | Requirement | Failure Mode |
|---|---|---|
| Business problem | Clear problem statement with measurable impact | FM-01 |
| Objectives | At least one objective with measurable success metric | FM-03 |
| Target users | At least one persona or user type described | FM-02 |
| User stories (INVEST) | All stories pass all 6 INVEST dimensions | FM-05 |
| Acceptance criteria (BDD) | All criteria use Given/When/Then | FM-07 |
| Acceptance criteria (testable) | QA can verify without PO clarification | FM-06 |
| NFRs complete | All 10 categories present with metrics | FM-08 |
| Scope explicit | Both in-scope and out-of-scope sections present | FM-04 |
| Business rules sourced | No invented rules — all BR-NNN attributed | FM-09 |
| Technology neutrality | No technology selection in PRD | FM-10 |
| BLOCKING OQs resolved | No OQ marked BLOCKING with status OPEN | FM-11 |
| Sensitive data flagged | Privacy NFR exists if personal data is handled | FM-12 |
| Handoff complete | All 9 fields present in handoff package | — |

### Status Codes

| Code | Meaning | Next Action |
|---|---|---|
| `APPROVED` | PRD meets all Gate 1 criteria | Route to Agente02_SoftwareArchitect |
| `NEEDS_MORE_REQUIREMENTS` | Targeted gaps identified — fixable | Return to Agente01_ProductOwner with correction list |
| `REJECTED_OUT_OF_SCOPE` | Feature scope exceeds project boundaries | Escalate to human for scope decision |

### Escalation Rules

- If 3+ criteria fail: Tech Lead issues `NEEDS_MORE_REQUIREMENTS` with full correction list.
- If scope is fundamentally outside project charter: `REJECTED_OUT_OF_SCOPE` → human escalation.
- If a BLOCKING open question remains unresolved: Gate 1 is blocked regardless of other completeness.
- If sensitive data is handled but no Privacy NFR exists: Gate 1 is blocked.

---

## Internal Quality Gate (Pre-Submission)

Before submitting to Gate 1, the Product Owner must self-validate using:

1. `checklists/prd_quality_checklist.md` — overall PRD completeness
2. `checklists/invest_checklist.md` — all user stories
3. `checklists/bdd_acceptance_checklist.md` — all acceptance criteria
4. `checklists/non_functional_requirements_checklist.md` — all NFR categories
5. `checklists/scope_boundary_checklist.md` — scope completeness
6. `checklists/open_questions_checklist.md` — all OQs classified and escalated
7. `checklists/business_rules_checklist.md` — all BRs attributed
8. `checklists/data_requirements_checklist.md` — data model sketch and privacy
9. `checklists/gate_1_prd_approval_checklist.md` — final Gate 1 readiness

**Rule:** All critical checklist items must be checked before handoff submission. Any unchecked critical item is a submission error.

---

## PRD Version at Gate

| Condition | Version |
|---|---|
| First submission | 1.0 |
| NEEDS_MORE_REQUIREMENTS return #1 | 1.1 |
| NEEDS_MORE_REQUIREMENTS return #2 | 1.2 |
| REJECTED_OUT_OF_SCOPE + redesign | 2.0 |
| APPROVED | Version frozen, no further changes |

---

## Gate 1 Interaction Protocol

```
Product Owner → Tech Lead:
  "Submitting PRD.md v1.0 + Handoff Package for Gate 1 review."

Tech Lead → Gate 1 evaluation using artifact-contract-validation-skill

Tech Lead → Product Owner (if NEEDS_MORE_REQUIREMENTS):
  "Gate 1 NEEDS_MORE_REQUIREMENTS. Issues found:
   1. US-003 fails INVEST (not estimable — missing complexity context)
   2. NFR-PERF-001 metric is vague ('fast response time')
   3. OQ-002 is BLOCKING and still OPEN
   Please address and resubmit as v1.1."

Product Owner → addresses issues → resubmits v1.1

Tech Lead → APPROVED → routes to Agente02_SoftwareArchitect
```
