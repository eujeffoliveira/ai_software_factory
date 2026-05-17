# Product Requirements Document — [PROJECT_NAME]

**Version:** [VERSION, e.g. 1.0]
**Date:** [DATE]
**Product Owner:** Agente01_ProductOwner
**Status:** <!-- FILL: Draft | Ready for Gate 1 | Approved -->
**Gate Target:** Gate 1

---

## 1. Summary

<!-- FILL: 3–5 sentences describing what this product/feature is, who it is for, and what problem it solves. No technology choices. -->

[SUMMARY_PARAGRAPH]

---

## 2. Business Problem

<!-- FILL: Describe the pain point, inefficiency, or opportunity being addressed. Include quantified evidence when available (e.g., "X% of users abandon at step Y"). No solution discussion here. -->

**Problem Statement:** [PROBLEM_STATEMENT]

**Evidence / Context:** [EVIDENCE_OR_CONTEXT]

**Impact of Not Solving:** [IMPACT_IF_NOT_SOLVED]

---

## 3. Objectives

<!-- FILL: 3–5 measurable objectives. Use outcome-oriented language, not feature-oriented. -->

- **OBJ-01:** [Objective with measurable success criterion]
- **OBJ-02:** [Objective with measurable success criterion]
- **OBJ-03:** [Objective with measurable success criterion]

---

## 4. Non-Objectives (Out of Scope)

<!-- FILL: List features and capabilities explicitly excluded from this version. Refer to Scope_Boundary.md for the full boundary definition. -->

- [OUT_OF_SCOPE_ITEM_1]
- [OUT_OF_SCOPE_ITEM_2]
- [OUT_OF_SCOPE_ITEM_3]

_Full scope boundary definition: `Scope_Boundary.md`_

---

## 5. Target Users

<!-- FILL: Describe the primary and secondary user personas. Include role, context, and pain points relevant to this product. -->

### Primary Users

**[PERSONA_1_NAME]** — [role description, key pain points, what they need]

### Secondary Users

**[PERSONA_2_NAME]** — [role description, context, what they need from this product]

---

## 6. User Stories

<!-- FILL: All stories must satisfy INVEST criteria. Format: "As a [user], I want [action], so that [benefit]". Priority: MUST / SHOULD / COULD -->

| ID | Title | User Story | Priority |
|---|---|---|---|
| US-001 | [TITLE] | As a [user], I want [action], so that [benefit] | MUST |
| US-002 | [TITLE] | As a [user], I want [action], so that [benefit] | MUST |
| US-003 | [TITLE] | As a [user], I want [action], so that [benefit] | SHOULD |
| US-004 | [TITLE] | As a [user], I want [action], so that [benefit] | SHOULD |
| US-005 | [TITLE] | As a [user], I want [action], so that [benefit] | COULD |

_Full story map: `User_Story_Map.md`_

---

## 7. Acceptance Criteria

<!-- FILL: Gherkin format (Given/When/Then) for each story. Cover happy path, at least one edge case, and one negative scenario per story. -->

### US-001 — [STORY_TITLE]

**AC-001-01 — Happy Path**
```gherkin
Given [precondition]
When [action]
Then [expected outcome]
```

**AC-001-02 — Edge Case**
```gherkin
Given [precondition with edge condition]
When [action]
Then [expected outcome for edge case]
```

**AC-001-03 — Negative Scenario**
```gherkin
Given [precondition]
When [invalid action or missing data]
Then [error message or fallback behavior]
```

### US-002 — [STORY_TITLE]

**AC-002-01 — Happy Path**
```gherkin
Given [precondition]
When [action]
Then [expected outcome]
```

**AC-002-02 — Negative Scenario**
```gherkin
Given [precondition]
When [invalid action]
Then [error or rejection with message]
```

_Full acceptance criteria: `Acceptance_Criteria.md`_

---

## 8. Functional Requirements

<!-- FILL: Numbered FR-NNN. Each must be verifiable and unambiguous. No technology choices. -->

- **FR-001:** [Functional requirement description — what the system must do]
- **FR-002:** [Functional requirement description]
- **FR-003:** [Functional requirement description]
- **FR-004:** [Functional requirement description]
- **FR-005:** [Functional requirement description]

---

## 9. Non-Functional Requirements

<!-- FILL: 10 mandatory categories. Each must have a measurable metric. Vague NFRs (e.g. "must be fast") are not accepted. -->

### 9.1 Performance
- **NFR-PERF-001:** [Metric — e.g., "P95 response time for list pages ≤ 2s under 200 concurrent users"]

### 9.2 Security
- **NFR-SEC-001:** [Metric — e.g., "All endpoints require authenticated session; unauthenticated access returns HTTP 401"]

### 9.3 Privacy
- **NFR-PRIV-001:** [Metric — e.g., "PII fields [list] must be stored encrypted at rest; not logged in plain text"]

### 9.4 Availability
- **NFR-AVAIL-001:** [Metric — e.g., "System uptime ≥ 99.5% measured monthly, excluding planned maintenance windows"]

### 9.5 Observability
- **NFR-OBS-001:** [Metric — e.g., "All state-changing operations produce structured audit log entries within 500ms"]

### 9.6 Auditability
- **NFR-AUDIT-001:** [Metric — e.g., "Audit trail must be retained for 24 months and queryable by admin users"]

### 9.7 Accessibility
- **NFR-ACC-001:** [Metric — e.g., "All interactive components comply with WCAG 2.1 Level AA"]

### 9.8 Maintainability
- **NFR-MAINT-001:** [Metric — e.g., "Zero circular dependencies between domain modules; enforced via lint rules"]

### 9.9 Scalability
- **NFR-SCALE-001:** [Metric — e.g., "System must support up to 10,000 active users without architectural changes"]

### 9.10 Data Retention
- **NFR-DRET-001:** [Metric — e.g., "User-submitted records must be retained for 5 years; deletable upon written request per applicable regulation"]

_Full NFR definitions: `Non_Functional_Requirements.md`_

---

## 10. Business Rules

<!-- FILL: BR-NNN. Each rule must have a confirmed source (stakeholder name, regulation, policy document). No invented rules. -->

| ID | Description | Source | Applies To | Status |
|---|---|---|---|---|
| BR-001 | [Rule description] | [Source: stakeholder / regulation] | [Features / Stories] | Confirmed |
| BR-002 | [Rule description] | [Source] | [Features / Stories] | To Confirm |

_Full rules register: `Business_Rules.md`_

---

## 11. Data Requirements

<!-- FILL: High-level data entities only. No database schema, no column names, no ORM decisions — those are the Architect's domain. -->

**Core Entities:**
- **[Entity 1]:** [What this entity represents, key attributes at business level]
- **[Entity 2]:** [What this entity represents, key attributes at business level]
- **[Entity 3]:** [What this entity represents, key attributes at business level]

**Data Sensitivity:**
- **PII Fields:** [List fields that contain personally identifiable information]
- **Sensitive Business Data:** [Fields requiring restricted access]

**Volume Expectations:**
- [Expected data volume, growth rate, or key thresholds]

---

## 12. Product Risks

<!-- FILL: PRISK-NNN. Include impact level (HIGH/MEDIUM/LOW) and proposed mitigation. -->

| ID | Description | Category | Impact | Probability | Mitigation |
|---|---|---|---|---|---|
| PRISK-001 | [Risk description] | [scope/business/user/data/regulatory] | HIGH | MEDIUM | [Mitigation strategy] |
| PRISK-002 | [Risk description] | [category] | MEDIUM | LOW | [Mitigation strategy] |

_Full risk register: `Product_Risks.md`_

---

## 13. Assumptions

<!-- FILL: List all assumptions made during requirements elicitation. Assumptions that cannot be validated become OQ-NNN. -->

- **A-01:** [Assumption — e.g., "Users have internet access with at least 4G speeds"]
- **A-02:** [Assumption — e.g., "Single-tenant deployment for initial release"]
- **A-03:** [Assumption — e.g., "Existing user base will be onboarded by system administrators, not self-registered"]

---

## 14. Open Questions

<!-- FILL: OQ-NNN. BLOCKING questions must be resolved before Gate 1 proceeds. -->

| ID | Question | Impact | Criticality | Owner | Deadline | Status |
|---|---|---|---|---|---|---|
| OQ-001 | [Question text] | [What is blocked if unanswered] | BLOCKING | [Owner role] | [Date] | Open |
| OQ-002 | [Question text] | [Impact description] | HIGH | [Owner role] | [Date] | Open |
| OQ-003 | [Question text] | [Impact description] | MEDIUM | [Owner role] | — | Open |

_Full questions register: `Open_Questions.md`_

---

## 15. Handoff Status

**PRD Version:** [VERSION]
**Gate 1 Readiness:** <!-- FILL: Ready | Pending OQ Resolution | Pending NFR Review -->
**Blocking Issues:** <!-- FILL: None | List any blocking items -->
**Handoff Package:** `Handoff_To_Architect.md`
