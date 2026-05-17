# Gate 1 — PRD Approval Checklist

Run this checklist immediately before submitting the handoff package for Gate 1. All items must pass.

---

## Business Problem and Objectives

- [ ] Business problem is clearly articulated — specific and evidence-backed
- [ ] Problem is not phrased as a feature request ("we need a dashboard" fails; "managers spend 3h/week extracting reports manually" passes)
- [ ] At least 3 measurable objectives defined (outcome-oriented, not feature-oriented)
- [ ] Impact of not solving the problem is stated

---

## Target Users

- [ ] At least one primary user persona defined with role, context, and goals
- [ ] User personas are realistic and grounded in the business problem
- [ ] User types referenced in user stories match the personas defined in Section 5

---

## User Stories

- [ ] All user stories follow the canonical format: "As a [user], I want [action], so that [benefit]"
- [ ] Every story has been evaluated against `checklists/invest_checklist.md`
- [ ] No story is a technical task (no developer perspective, no infrastructure tasks)
- [ ] Every story has a priority (MUST / SHOULD / COULD)
- [ ] Story IDs are sequential: US-001, US-002, etc.
- [ ] Every story delivers standalone value to a real user

---

## Acceptance Criteria

- [ ] Every user story has at least one acceptance criterion
- [ ] All acceptance criteria use Gherkin format (Given/When/Then)
- [ ] At least one happy path scenario per story
- [ ] At least one negative scenario per MUST story
- [ ] Zero acceptance criteria contain vague terms: "fast", "easy", "user-friendly", "seamless"
- [ ] Performance criteria have concrete measurable thresholds
- [ ] Acceptance criteria evaluated against `checklists/bdd_acceptance_checklist.md`

---

## Non-Functional Requirements

- [ ] All 10 NFR categories present: performance, security, privacy, availability, observability, auditability, accessibility, maintainability, scalability, data retention
- [ ] Every NFR has a measurable metric — no NFR is vague
- [ ] Security NFRs cover authentication and authorization
- [ ] Privacy NFRs identify PII fields explicitly
- [ ] Data retention NFRs specify retention periods
- [ ] NFRs evaluated against `checklists/non_functional_requirements_checklist.md`

---

## Scope Boundary

- [ ] In-scope list is explicit and complete
- [ ] Out-of-scope list is explicit and non-empty
- [ ] Each out-of-scope item has a reason for exclusion
- [ ] Scope boundary evaluated against `checklists/scope_boundary_checklist.md`

---

## Business Rules

- [ ] All business rules have traceable sources
- [ ] No rule is a technology decision disguised as a business rule
- [ ] All "To Confirm" rules have OQ-NNN references
- [ ] Business rules evaluated against `checklists/business_rules_checklist.md`

---

## Data Requirements

- [ ] Core entities identified at conceptual level
- [ ] PII fields flagged
- [ ] No schema or implementation decisions embedded
- [ ] Data requirements evaluated against `checklists/data_requirements_checklist.md`

---

## Open Questions

- [ ] All open questions have IDs (OQ-NNN), criticality, and owners
- [ ] Zero BLOCKING questions remain unresolved
- [ ] All BLOCKING questions escalated to Tech Lead
- [ ] Open questions evaluated against `checklists/open_questions_checklist.md`

---

## Product Risks

- [ ] At least one product risk identified and registered (PRISK-NNN)
- [ ] All HIGH-impact risks have documented mitigation strategies
- [ ] Risks are product-level (scope, business, user, data, regulatory) — not technical implementation risks

---

## Handoff Package

- [ ] `Handoff_To_Architect.md` is complete
- [ ] `artifact_produced` field lists all generated artifacts
- [ ] `summary` is at least 3 sentences — not boilerplate
- [ ] `assumptions` lists all unconfirmed assumptions
- [ ] `open_questions` matches `Open_Questions.md` (no omissions)
- [ ] `risks` matches `Product_Risks.md` (no omissions)
- [ ] `required_next_agent` is `Agente00_TechLead`
- [ ] `suggested_following_agent` is `Agente02_SoftwareArchitect`
- [ ] `validation_checklist` is complete with no unchecked MUST items

---

## Technology Cleanliness

- [ ] No database technology named in PRD (no PostgreSQL, MySQL, Redis)
- [ ] No frontend framework named as a requirement (no React, Vue, Next.js)
- [ ] No API design pattern specified (no REST vs GraphQL decision)
- [ ] No infrastructure topology specified (no serverless, no containers)
- [ ] No library or package versions specified

---

**Gate 1 can be submitted when:** All 42 items above are checked ✅
**Gate 1 will be blocked if:** Any BLOCKING open question is unresolved, any NFR has no metric, any user story fails INVEST, or the handoff package is incomplete.
