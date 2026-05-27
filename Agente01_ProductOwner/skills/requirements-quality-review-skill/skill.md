# Requirements Quality Review Skill

## Purpose
Review the complete PRD package against all quality dimensions and declare Gate 1 readiness, identifying specific items that must be corrected before submission.

## When to Use
- When all PRD artifacts are drafted and the Product Owner performs final self-review before submitting the handoff package to the Tech Lead.
- When a Gate 1 `NEEDS_MORE_REQUIREMENTS` decision is received and a targeted review of the gap areas is needed.

## Inputs
- `PRD.md` — the complete PRD draft
- `checklists/prd_quality_checklist.md` — the quality checklist to apply
- Supporting artifacts: `User_Story_Map.md`, `Acceptance_Criteria.md`, `Non_Functional_Requirements.md`, `Business_Rules.md`, `Open_Questions.md`, `Product_Risks.md`, `Scope_Boundary.md`

## Outputs
- `quality_review_report` — structured report including: (1) **overall status** (`READY` / `NOT_READY`), (2) **section-by-section results** (PASS/FAIL per checklist section with evidence), (3) **failure list grouped by severity** (BLOCKING → MAJOR → MINOR), (4) **recommended action** for each failure (specific correction, not generic advice). The report must not declare READY if any BLOCKING or MAJOR failure is present.

## Constraints
- Every checklist item must be evaluated individually — no blanket approvals ("it looks complete" is never valid)
- Evidence must be cited for each PASS (section name, item count, or specific artifact reference)
- FAIL items must include a specific correction needed (not just "this is wrong")
- No criterion may be marked PASS without being verified in the actual artifact
- Technology decisions found in the PRD are flagged as FAIL items (not warnings)
- BLOCKING open questions found unresolved are Gate 1 blockers and must be escalated immediately

## Step-by-Step Procedure

1. **Load `checklists/prd_quality_checklist.md`.** Process all 10 sections in order.

2. **For each section:** review the corresponding section in `PRD.md` and supporting artifacts. Mark each item PASS or FAIL with evidence.

3. **Document failures precisely.** For each FAIL: state the section, the specific item, what was found, and what the correction must be (e.g., "Section 9.5 Observability — NFR-OBS-001 states 'logs should be available' with no delivery metric. Must specify delivery time, e.g., 'within 500ms of state change'").

4. **Classify failures by severity:**
   - BLOCKING: prevents Gate 1 submission (unresolved BLOCKING OQ, missing mandatory section, no INVEST stories)
   - MAJOR: will cause Gate 1 rejection if not fixed (NFR without metric, acceptance criteria without Gherkin)
   - MINOR: quality gap that should be fixed but may pass at Tech Lead discretion

5. **Detect technology contamination.** Scan for database names, framework names, library references, and infrastructure decisions. Technology contamination is a **MAJOR failure** if found in: Objectives, Acceptance Criteria, Functional Requirements, Business Rules, or NFRs (except the Scalability category, where infrastructure sizing may appear). Technology mentions in Data Requirements or Assumptions sections are **acceptable** if accompanied by a business justification — do not flag those as failures.

6. **Produce the report.** Include: overall status (READY / NOT_READY), section-by-section results, list of items requiring correction, and a recommended action for each failure.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
