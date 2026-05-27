# Definition of Done — PRD.md (Product Requirements Document)

## Overview

The PRD is the authoritative statement of what the product must do, for whom, and why. It is the contract between the Product Owner and the rest of the factory: every downstream artifact (Architecture.md, Execution_Plan.json, test plans) traces back to the requirements defined here. A PRD that is vague, incomplete, or out of scope causes rework in every subsequent gate.

## Owner Agent

- **Primary:** `@po` (Agente01_ProductOwner)
- **Gate:** Gate 1 — Requirements Review

## Required Fields / Sections

### Title Block
- [ ] `title` — product or feature name, specific enough to distinguish from other work
- [ ] `version` — semantic version (e.g., `1.0.0`) incremented on every substantive change
- [ ] `project_archetype` — one of: `web_app`, `automation_script`, `data_pipeline`, `api_service`, `cli_tool`, `mcp_server`, `integration_worker`, `notebook_analysis`
- [ ] `date` — ISO 8601 date of last update
- [ ] `author` — name or role of the PO who wrote this version
- [ ] `status` — one of: `draft`, `under_review`, `approved`

### User Stories
- [ ] Each story follows INVEST format: Independent, Negotiable, Valuable, Estimable, Small, Testable
- [ ] Each story is written as: "As a [persona], I want [action], so that [benefit]"
- [ ] Every story has at least 2 BDD acceptance criteria in Gherkin format (`Given / When / Then`)
- [ ] Stories are grouped by feature or epic
- [ ] Each story has a unique ID (e.g., `US-001`)
- [ ] No story spans more than one sprint's worth of scope (estimated 1–5 days)
- [ ] Edge cases and error scenarios are covered as separate scenarios within the story's BDD criteria

### Functional Requirements
- [ ] Every functional requirement is numbered (e.g., `FR-001`)
- [ ] Each requirement is atomic — one behavior per requirement
- [ ] Each requirement uses "shall" for mandatory, "should" for desired
- [ ] Each requirement is traceable to at least one user story
- [ ] Requirements specify behavior, not implementation
- [ ] No ambiguous language: "fast", "easy", "user-friendly" are not requirements — measurable thresholds are

### Non-Functional Requirements
- [ ] Performance: specific thresholds defined (e.g., "p95 response time < 300ms under 100 concurrent users")
- [ ] Availability: uptime target stated (e.g., "99.5% monthly")
- [ ] Security: authentication and authorization requirements stated
- [ ] Scalability: expected load range and growth projection stated
- [ ] Accessibility: standard referenced if applicable (e.g., WCAG 2.1 AA)
- [ ] Data retention and privacy requirements stated (LGPD compliance noted where applicable)
- [ ] Browser/environment support stated for `web_app` archetype

### Out of Scope
- [ ] At least one explicit out-of-scope statement (prevents scope creep)
- [ ] Deferred features listed with rationale for deferral
- [ ] Adjacent features that may be confused with in-scope items are explicitly excluded

### Open Questions
- [ ] All open questions have an owner (name or role)
- [ ] Each question has a resolution deadline
- [ ] Questions that would block architecture are flagged as `[BLOCKING]`
- [ ] No `[BLOCKING]` questions remain unresolved at Gate 1 submission

### Handoff Package
- [ ] `required_next_agent` field set to `"Agente02_SoftwareArchitect"`
- [ ] `gate_ready` set to `true`
- [ ] `open_questions` list confirms no blocking items remain
- [ ] `assumptions` list populated with any assumption made in the absence of confirmed requirements
- [ ] `risks` list populated with product-level risks (not technical risks — those belong in Architecture.md)

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| All user stories have unique IDs | Scan document for `US-NNN` pattern; count must match story count |
| Every story has at least 2 BDD scenarios | Read each story's acceptance criteria section; reject if fewer than 2 Given/When/Then blocks |
| Every functional requirement traces to a story | Check `FR-NNN` traceability column or inline references |
| No blocking open questions | Search for `[BLOCKING]` tag; count must be zero |
| NFRs include measurable thresholds | Reject any NFR that uses adjectives without numbers |
| Out-of-scope section is non-empty | Section must contain at least one item |
| `project_archetype` is a valid value | Value must be one of the 8 recognized archetypes |
| Handoff package is complete | JSON/YAML block present with all required fields populated |
| Version number incremented from last gate | Compare to previous approved version in git history |

## Related Gates

- **Prerequisite:** Gate A0 (project archetype classification) must be complete before Gate 1 if archetype was ambiguous
- **This gate:** Gate 1 — Requirements Review (evaluated by Agente00_TechLead)
- **Unblocks:** Gate 2 — Architecture Review (Agente02_SoftwareArchitect consumes PRD)

## Gate 1 Status Codes

| Code | Meaning |
|------|---------|
| `APPROVED` | PRD meets all criteria; pipeline advances to Gate 2 |
| `NEEDS_MORE_REQUIREMENTS` | Requirements are insufficient or too vague; returned to PO |
| `REJECTED_OUT_OF_SCOPE` | Feature or product is outside the factory's mandate or the sprint's scope |

## Failure Examples

- **FAIL:** A user story reads "As a user, I want a fast dashboard" with no BDD criteria and no measurable performance threshold. The word "fast" is not a requirement.
- **FAIL:** The PRD has 12 user stories but no out-of-scope section. The architect cannot distinguish what is deferred from what is missing.
- **FAIL:** `project_archetype` field is absent. The Software Architect cannot select the correct Golden Model without it.
- **FAIL:** Open question "Should we support SSO?" is marked `[BLOCKING]` and has no owner or deadline. Architecture cannot proceed without this answer.
- **FAIL:** NFR reads "The system must be secure." No specific authentication mechanism, authorization model, or data classification is stated.
- **FAIL:** Functional requirements use first person ("I want the system to...") and contain multiple behaviors in a single sentence.

## When to Block

Return `NEEDS_MORE_REQUIREMENTS` when:
- More than 20% of user stories lack BDD acceptance criteria
- Any `[BLOCKING]` open question has no owner or no deadline
- NFRs contain no measurable thresholds for performance, availability, or security
- Functional requirements are implementation instructions rather than behavioral specifications

Return `REJECTED_OUT_OF_SCOPE` when:
- The PRD describes functionality that contradicts a previous approved PRD without a change request
- The requested feature exceeds the current sprint scope without a scope change approval
- The product described requires infrastructure or integrations not available in this factory instance

Issue `APPROVED` only when every checkbox in this document is checked and no open questions are marked `[BLOCKING]`.
