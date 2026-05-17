# Open Questions Checklist

Use this checklist to verify that every open question in `Open_Questions.md` is properly formed and actionable before Gate 1 submission.

---

## ID and Format

- [ ] Every question has a unique ID in format OQ-NNN (zero-padded, e.g., OQ-001)
- [ ] IDs are sequential with no gaps (OQ-001, OQ-002, OQ-003 — not OQ-001, OQ-003)
- [ ] Question text is written as a complete, clear question — not a note or observation
- [ ] Question is specific enough that a stakeholder can give a yes/no or concrete answer

---

## Criticality Classification

- [ ] Every question has a criticality level: BLOCKING / HIGH / MEDIUM / LOW
- [ ] Criticality assignment is justified by the impact field (not assigned arbitrarily)
- [ ] BLOCKING classification is used only for questions that prevent a PRD section from being completed
- [ ] HIGH classification is used for questions that significantly affect scope, stories, or NFRs
- [ ] MEDIUM classification is used for questions that affect a specific story's detail
- [ ] LOW classification is used for clarifications where a reasonable assumption can be documented

---

## Impact Description

- [ ] Every question has a non-empty impact description
- [ ] Impact describes what artifact or decision is blocked by the unanswered question
- [ ] Impact is specific: "Cannot define AC-003-02" not just "affects requirements"
- [ ] Impact level is consistent with the criticality assigned

---

## Owner Assignment

- [ ] Every question has an identified owner (a role, not a person name)
- [ ] Owner is the person or role who can provide the answer — not the Product Owner
- [ ] BLOCKING questions have owners who can be reached within the deadline
- [ ] Owner assignments are realistic given the project context

---

## Deadlines and Status

- [ ] BLOCKING questions have explicit deadlines
- [ ] HIGH questions have deadlines or a note explaining why no deadline is set
- [ ] Status field is present for every question: Open / In Progress / Resolved / Deferred
- [ ] Resolved questions have a resolution note and resolution date
- [ ] Deferred questions have a note explaining why they were deferred and any assumption applied

---

## BLOCKING Question Escalation

- [ ] All BLOCKING questions have been communicated to Tech Lead via the handoff package
- [ ] No Gate 1 handoff is submitted with unresolved BLOCKING questions
- [ ] If a BLOCKING question cannot be resolved before the deadline, a PRD assumption is documented and the risk is escalated as PRISK-NNN

---

## Cross-Reference Consistency

- [ ] Questions that generated business rules (BR-NNN) are marked as resolved with the BR reference
- [ ] Questions that remain unresolved are referenced in the PRD Section 14 (Open Questions table)
- [ ] Open questions referenced in the handoff package match the questions in `Open_Questions.md`

---

**Open Questions register is ready when:** All items above are checked. Any BLOCKING question without an owner or deadline is a Gate 1 blocker itself.
