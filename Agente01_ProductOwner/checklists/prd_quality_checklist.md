# PRD Quality Checklist

Run this checklist before declaring the PRD ready for Gate 1. Every item must be checked.

---

## 1. Document Structure

- [ ] PRD file exists and is named `PRD.md`
- [ ] PRD has a version number and date
- [ ] All 15 required sections are present (Summary through Handoff Status)
- [ ] No section is empty or contains placeholder text
- [ ] Document language is consistent throughout

---

## 2. Business Problem

- [ ] Problem statement is clearly articulated (not vague — not "improve user experience")
- [ ] Problem is described in business terms, not technical terms
- [ ] Evidence or context for the problem is provided (data, observation, or stakeholder statement)
- [ ] Impact of not solving the problem is stated
- [ ] Objectives are outcome-oriented (not feature-oriented)
- [ ] Each objective has a measurable success criterion

---

## 3. User Stories

- [ ] All user stories use the canonical format: "As a [user], I want [action], so that [benefit]"
- [ ] Each story identifies a specific user type (not "user" generically)
- [ ] Each story has a clear user action (what they want to do)
- [ ] Each story has an explicit business benefit (the "so that" is meaningful — not restating the action)
- [ ] No story is a technical task (e.g., "As a developer, I want to create a database table...")
- [ ] Stories are independent of each other where possible
- [ ] Stories are small enough to be estimated (no epics masquerading as stories)
- [ ] Stories are testable (can be verified as done or not done)
- [ ] Priority assigned to each story (MUST / SHOULD / COULD)
- [ ] Story IDs follow convention US-NNN

---

## 4. Acceptance Criteria

- [ ] Every user story has at least one acceptance criterion
- [ ] All acceptance criteria use Gherkin format (Given / When / Then)
- [ ] At least one happy path scenario per story
- [ ] At least one negative scenario per MUST story
- [ ] No acceptance criterion uses vague terms: "fast", "easy", "intuitive", "user-friendly", "seamless"
- [ ] Acceptance criteria with performance thresholds include measurable metrics (e.g., "< 2s", "≤ 10 results")
- [ ] Criterion IDs follow convention AC-NNN-NN
- [ ] No criterion describes implementation details (no code, libraries, or patterns)

---

## 5. Non-Functional Requirements

- [ ] All 10 NFR categories are present: performance, security, privacy, availability, observability, auditability, accessibility, maintainability, scalability, data retention
- [ ] Every NFR has a measurable metric — no NFR says "should be fast" without a threshold
- [ ] At least one MUST-priority NFR in security category
- [ ] At least one MUST-priority NFR in availability category
- [ ] Privacy NFR identifies which fields are PII
- [ ] Data retention NFR specifies retention period
- [ ] Accessibility NFR references a standard (e.g., WCAG 2.1 AA)
- [ ] NFR IDs follow convention NFR-[CATEGORY]-NNN

---

## 6. Scope

- [ ] In-scope features are explicitly listed
- [ ] Out-of-scope items are explicitly listed (not assumed)
- [ ] Each out-of-scope item has a reason for exclusion
- [ ] Scope boundary references `Scope_Boundary.md`
- [ ] Non-objectives section is present in the PRD

---

## 7. Business Rules

- [ ] Every business rule has a traceable source (stakeholder, regulation, policy)
- [ ] No rule has been invented without a source
- [ ] Rules describe what must be enforced — not how to implement it
- [ ] Rules pending confirmation are linked to OQ-NNN entries
- [ ] Rule IDs follow convention BR-NNN

---

## 8. Data Requirements

- [ ] Core data entities identified at business level
- [ ] PII fields explicitly flagged
- [ ] No database schema, column names, or ORM details present (those are Architect decisions)
- [ ] Data volume expectations noted if known
- [ ] Data retention requirements covered in NFRs

---

## 9. Risks and Open Questions

- [ ] All open questions have IDs (OQ-NNN)
- [ ] Each open question has a criticality level (BLOCKING / HIGH / MEDIUM / LOW)
- [ ] Each open question has an identified owner
- [ ] BLOCKING questions have been escalated to Tech Lead
- [ ] Product risks have been assessed (PRISK-NNN)
- [ ] Each HIGH-impact risk has a documented mitigation strategy

---

## 10. Handoff Readiness

- [ ] No BLOCKING open questions remain unresolved
- [ ] Handoff_To_Architect.md is complete with all required fields
- [ ] validation_checklist in handoff has no unchecked MUST items
- [ ] No technology decisions are embedded in the PRD
- [ ] No implementation assumptions are embedded in the requirements
- [ ] All assumptions are listed explicitly in the handoff package

---

**Gate 1 can proceed when:** All items in sections 1–10 are checked ✅
