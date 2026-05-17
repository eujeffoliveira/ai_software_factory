# Knowledge Cards — Agente01_ProductOwner

_Concise reusable concept cards distilled at build-time. Runtime: read-only._

---

## Card 001 — User Story (INVEST)

**Definition:** A user story is a short description of a feature from the perspective of the person who desires it, following the format: "As a [user type], I want [action] so that [benefit]."

**INVEST Criteria:**
| Dimension | Test Question |
|-----------|--------------|
| Independent | Can this be developed without another story being done first? |
| Negotiable | Is the "how" flexible while the "what" and "why" are fixed? |
| Valuable | Does completing this deliver observable value to the user? |
| Estimable | Can the team estimate the effort in story points? |
| Small | Can it be completed and demonstrated in one sprint (≤ 8 points)? |
| Testable | Does it have acceptance criteria QA can execute? |

**Priority Levels:** P0 (must-have, blocker), P1 (must-have), P2 (should-have), P3 (nice-to-have)

**Anti-patterns:**
- "As a developer, I want to create a database schema" — this is a technical task, not a user story
- "As a user, I want a good system" — not specific enough to be estimable or testable

**Correct format:** `US-001 | P1 | As a [role], I want [capability] so that [benefit].`

---

## Card 002 — BDD / Gherkin

**Definition:** Behavior-Driven Development (BDD) is a practice of specifying software behavior in a structured natural language that can be directly used to write automated tests.

**Gherkin Format:**
```
Scenario: [scenario title]
  Given [a precondition or initial context]
  And [additional context, if needed]
  When [an action is performed]
  And [additional action, if needed]
  Then [the expected observable outcome]
  And [additional outcome, if needed]
```

**Three required scenario types:**
1. **Happy Path** — the main success flow
2. **Edge Case** — boundary conditions (empty input, maximum values, zero items)
3. **Negative Scenario** — invalid input, unauthorized access, error conditions

**Quality test for a criterion:** Can a QA engineer automate this test without asking the PO any questions? If no → rewrite.

**Anti-pattern:** "Then the system should work correctly." — not testable.
**Correct:** "Then the user sees a confirmation message: 'Your changes have been saved.'"

---

## Card 003 — PRD Structure

**Definition:** A Product Requirements Document (PRD) is the canonical artifact that defines what a product or feature must do. It is the input to Gate 1.

**Mandatory sections:**
1. Document header (ID, version, status, author, date)
2. Business Problem — the problem being solved, user pain, business impact
3. Objectives and Success Criteria — measurable outcomes
4. Target Users / Personas — who uses the product
5. Scope — in-scope features and explicit out-of-scope list
6. User Story Map — all epics and stories (INVEST validated)
7. Functional Requirements — what the system does
8. Acceptance Criteria — BDD/Gherkin for each story
9. Non-Functional Requirements — all 10 categories with metrics
10. Business Rules — BR-NNN registry
11. Data Requirements — entities, relationships, data sensitivity
12. Product Risks — PRISK-NNN registry
13. Assumptions — listed explicitly
14. Open Questions — OQ-NNN registry with criticality

**Version control:** PRD versions increment on each Gate 1 revision (v1.0, v1.1, v1.2).

---

## Card 004 — Gate 1 — PRD Approval

**Definition:** Gate 1 is the quality checkpoint that validates the PRD before architecture work begins.

**Trigger:** Product Owner submits PRD + Handoff Package to Tech Lead.

**Decision authority:** Tech Lead (Agente00)

**Possible outcomes:**
| Status | Meaning | Next action |
|--------|---------|-------------|
| APPROVED | All criteria met | Route to Agente02_SoftwareArchitect |
| NEEDS_MORE_REQUIREMENTS | Specific gaps identified | Return to PO for revision |
| REJECTED_OUT_OF_SCOPE | Project not feasible as specified | Human escalation |

**Minimum criteria for APPROVED:**
- Business problem articulated (not just solution described)
- At least one measurable success criterion
- Target users defined (not "users" generically)
- All stories pass INVEST
- All criteria in BDD/Gherkin
- NFRs cover all 10 categories
- In-scope and out-of-scope explicitly defined
- Business rules attributed to sources
- No BLOCKING open questions unresolved
- Handoff Package complete

---

## Card 005 — Non-Functional Requirements (10 Categories)

**Definition:** Non-functional requirements (NFRs) define how a system must operate, not just what it must do. They set quality standards.

**10 Mandatory Categories:**

| # | Category | Key Metrics |
|---|----------|------------|
| 1 | Performance | Response time (P95/P99), throughput (req/s), concurrent users |
| 2 | Security | Authentication method, session timeout, encryption standard |
| 3 | Availability | Uptime SLA (%), RTO, RPO |
| 4 | Scalability | Max concurrent users, data volume growth, horizontal scaling support |
| 5 | Usability | Task completion rate, error rate, time on task |
| 6 | Maintainability | Test coverage %, code quality threshold, documentation |
| 7 | Data Retention | Retention period, archival policy, deletion SLA |
| 8 | Compliance | Applicable regulations (GDPR, HIPAA, LGPD, PCI-DSS) |
| 9 | Accessibility | WCAG level (2.1 AA minimum), supported assistive technologies |
| 10 | Observability | Log format, monitoring coverage, alerting thresholds |

**Quality rule:** Every NFR must have a measurable metric. "System must be secure" is not an NFR.

**Defaults when stakeholder provides no specification:**
- Performance: < 200ms read at P95, < 500ms write at P95
- Availability: ≥ 99.5% uptime
- Accessibility: WCAG 2.1 Level AA
- Security: Authentication required for all non-public routes

---

## Card 006 — Open Question (OQ)

**Definition:** An Open Question is a documented information gap — something the PRD needs to be complete, but the answer is not yet known.

**Format:**
```
OQ-NNN
Question: [precise, specific question — not vague]
Impact: [what cannot be decided, written, or implemented without this answer]
Criticality: BLOCKING | HIGH | MEDIUM | LOW
Owner: Tech Lead (routes to stakeholder)
Deadline: [sprint or gate]
Status: OPEN | ESCALATED | RESOLVED
Resolution: [text when resolved]
```

**Criticality definitions:**
- **BLOCKING**: PRD cannot advance to Gate 1 without this answer
- **HIGH**: PRD can be submitted but the downstream agent will need this before Gate 2
- **MEDIUM**: Can be resolved post-Gate 1 without blocking architecture
- **LOW**: Nice to know; doesn't block any phase

**Rule:** A PRD with zero open questions should be reviewed again — real PRDs always have OQs.

---

## Card 007 — Scope Boundary

**Definition:** The scope boundary explicitly defines what the product will and will not do in the current version.

**Structure of Scope_Boundary.md:**
- **In-Scope**: List of features/capabilities explicitly included in this version
- **Out-of-Scope**: List of features/capabilities explicitly excluded from this version
- **Rationale for Exclusions**: Why each out-of-scope item was deferred or excluded

**Why it matters:**
- Prevents scope creep during implementation
- Gives the team authority to decline requests not in the PRD
- Prevents the Architect from designing for features that were excluded

**Anti-pattern:** PRD that only lists features — without saying what is NOT included.

**Scope expansion protocol:** If stakeholder requests new features mid-PRD, register them in a separate backlog list and set status "out-of-scope v1.0." Never absorb new scope silently.

---

## Card 008 — Business Rule

**Definition:** A business rule is a constraint, calculation, or policy that defines how the business operates and that the software must enforce.

**Format:**
```
BR-NNN
Description: [the rule, precisely stated]
Source: [stakeholder name / document / regulation / "to confirm"]
Status: confirmed | to_confirm
Applies to: [list of user stories or features]
```

**Examples of business rules:**
- "An order cannot be placed if the user's account has an outstanding balance." (BR-001)
- "Discount codes expire 30 days after issuance." (BR-002)
- "Reports can only be accessed by users in the Manager or Admin role." (BR-003)

**Critical rule:** If you cannot answer "who told me this rule?", mark the rule as `to_confirm` and register OQ-NNN.

**Business rules vs. functional requirements:** A functional requirement says what the system does. A business rule says why it does it that way. BR-001 explains the constraint behind the requirement "prevent checkout for accounts with outstanding balance."

---

## Card 009 — Product Risk

**Definition:** A product risk is a condition that, if it materializes, could prevent the product from delivering its intended value or cause harm to users or the business.

**Format:**
```
PRISK-NNN
Description: [what could go wrong]
Impact: HIGH | MEDIUM | LOW
Likelihood: HIGH | MEDIUM | LOW
Risk Score: Impact × Likelihood
Mitigation: [action to reduce likelihood or impact]
Status: OPEN | MITIGATED | ACCEPTED | ESCALATED
```

**Risk categories in product ownership:**
- **Scope Risk**: Scope is too large for the timeline
- **Stakeholder Risk**: Stakeholder alignment is unclear; requirements may change
- **Compliance Risk**: Regulatory requirements may add unplanned scope
- **Dependency Risk**: Product depends on external system not yet available
- **User Adoption Risk**: Target users may not adopt the product as designed
- **Data Risk**: Required data may not be available or may be inconsistent

**Escalation rule:** Compliance risks and HIGH-impact risks with no mitigation → escalate to Tech Lead.

---

## Card 010 — Requirements Interview

**Definition:** A requirements interview is a structured conversation designed to elicit, clarify, and validate the information needed to write complete, unambiguous requirements.

**Interview structure:**
1. **Context setting**: Understand the business domain and stakeholder role
2. **Problem exploration**: Understand the current pain, the gap, the business impact
3. **User exploration**: Understand who uses the system and their goals
4. **Solution expectations**: Understand what success looks like
5. **Constraint identification**: Understand deadlines, regulatory constraints, technical constraints
6. **Scope clarification**: Understand what is and is not expected in this version
7. **Priority discussion**: Understand what must ship vs. what can be deferred

**Question types:**
- **Context questions**: "Who are the primary users?"
- **Problem questions**: "What specific pain does this solve today?"
- **Goal questions**: "How will you know this project succeeded?"
- **Constraint questions**: "Are there any legal or compliance requirements we must meet?"
- **Priority questions**: "If you could only deliver three features, which would they be?"
- **Edge case questions**: "What happens when a user tries to [unusual scenario]?"

**Interview log format:** All questions and answers must be recorded in `Requirements_Interview_Log.md` with: question ID, question text, stakeholder answer, date, clarification needed (yes/no).

**Rule:** Never make an assumption instead of asking a question. The cost of a question is one conversation. The cost of a wrong assumption is one rework cycle.

---

## Card 011 — BPMN Notation Essentials

**Definition:** Business Process Model and Notation (BPMN) is the standard visual language for mapping business processes. It captures who does what, when, and in what sequence — including exception paths.

**Key elements:**
| Element | Shape | Purpose |
|---------|-------|---------|
| Start Event | Circle (thin border) | Triggers the process |
| Intermediate Event | Circle (double border) | Occurs during the process (timer, message, error) |
| End Event | Circle (thick border) | Terminates the process |
| Task | Rectangle (rounded corners) | A single unit of work performed by an actor |
| Sub-process | Rectangle with + icon | A collapsed set of tasks |
| XOR Gateway | Diamond with X | Exclusive choice — exactly one outgoing path is taken |
| AND Gateway | Diamond with + | Parallel — all outgoing paths are taken simultaneously |
| OR Gateway | Diamond with O | Inclusive — one or more outgoing paths are taken |
| Sequence Flow | Solid arrow | Order of activities within a pool/lane |
| Message Flow | Dashed arrow | Communication between pools (organizations) |
| Pool | Large rectangle | Represents an organization or participant |
| Lane | Subdivision of a pool | Represents a role or system within the organization |

**Requirement generation rules:**
- Each lane in a BPMN = potential user role requiring system support
- Each XOR gateway = at least 2 requirements (one per branch)
- Each exception path = edge-case requirement that interviews commonly miss
- Each AND gateway = synchronization requirement

**Operational rule:** Every in-scope business process must be documented as a BPMN swimlane diagram in the PRD appendix or a linked document. Requirements derived from exception flows must be explicitly labeled in the requirements list.

**Source:** Módulo 02 — Mapear processos de negócio.

---

## Card 012 — ISO 25010 Quality Model

**Definition:** ISO/IEC 25010 is the international standard defining the software product quality model. It provides a structured taxonomy of 8 quality characteristics used as the canonical NFR checklist.

**8 Quality Characteristics:**

| # | Characteristic | Key Sub-characteristics |
|---|---------------|------------------------|
| 1 | Functional Suitability | Completeness, Correctness, Appropriateness |
| 2 | Reliability | Maturity, Availability, Fault tolerance, Recoverability |
| 3 | Performance Efficiency | Time behavior, Resource utilization, Capacity |
| 4 | Usability | Learnability, Operability, User error protection, Accessibility |
| 5 | Security | Confidentiality, Integrity, Non-repudiation, Accountability, Authenticity |
| 6 | Compatibility | Co-existence, Interoperability |
| 7 | Maintainability | Modularity, Reusability, Analysability, Modifiability, Testability |
| 8 | Portability | Adaptability, Installability, Replaceability |

**How to apply:**
1. For each of the 8 characteristics, explicitly assess applicability to the project
2. For each applicable characteristic, define ≥1 measurable NFR with a quantified threshold
3. Document "N/A" with a rationale for characteristics that do not apply — silence is not acceptable

**Relationship to existing NFR categories:** ISO 25010 complements the 10 NFR categories in Card 005. ISO 25010 provides the theoretical taxonomy; the 10 categories in Card 005 are the operational implementation for this factory's PRD template.

**Operational rule:** Use ISO 25010 as a completeness check during NFR elicitation. If a characteristic has no coverage in the PRD and no documented "N/A" rationale, the NFR section is incomplete.

**Source:** Módulo 03 — Identificar requisitos não-funcionais.

---

## Card 013 — Requirements Traceability Matrix (RTM)

**Definition:** A Requirements Traceability Matrix (RTM) is an artifact that links requirements to their origins and to the verification artifacts that confirm them. It enables both forward traceability (requirement → implementation → test) and backward traceability (test result → requirement → business need).

**Mandatory columns:**

| Column | Description |
|--------|-------------|
| Requirement ID | FR-NNN or NFR-NNN |
| Description | Short requirement statement |
| Source | Stakeholder name / document / regulation |
| Priority (MoSCoW) | M / S / C / W |
| Acceptance Criterion ID | AC-NNN |
| Test Case Reference | Test case ID or "pending" |
| Status | proposed / approved / implemented / verified |

**Traceability directions:**
- **Forward traceability:** Requirement → Acceptance Criterion → Test Case → Test Result. Ensures every requirement has a verification path.
- **Backward traceability:** Test Result → Acceptance Criterion → Requirement → Stakeholder Need. Ensures every test maps to a real requirement — no orphan tests.

**Lifecycle:** The RTM is created during PRD development and must be updated whenever: (1) requirements are added or modified, (2) test cases are created or changed, (3) requirements are implemented and verified.

**Gate 1 requirement:** An RTM with requirements that have no test case reference or acceptance criterion is incomplete. These gaps must be resolved before Gate 1 submission.

**Operational rule:** Any requirement in the PRD that cannot be verified by a test case or acceptance criterion is incomplete. The RTM is the evidence that verification is planned — not a post-implementation artifact.

**Source:** Módulo 02 — Proposta para melhorar o rastreamento de requisitos; Módulo 03 — Gerenciamento de Requisitos.
