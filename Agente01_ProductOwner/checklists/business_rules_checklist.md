# Business Rules Checklist

Use this checklist to verify that every business rule in `Business_Rules.md` is properly formed, traceable, and suitable for inclusion in the PRD.

---

## Source Traceability

- [ ] Every confirmed rule has a traceable source (stakeholder role + session, regulation article, or named policy document)
- [ ] Source is specific enough to be looked up: "Product Manager, Session 1, 2026-05-10" — not just "Product Manager"
- [ ] No rule has a blank or vague source field (e.g., "business", "common sense", "obvious")
- [ ] Rules derived from regulatory sources include the regulation name and article number
- [ ] Rules that came from assumptions rather than confirmed statements are marked "To Confirm" with an OQ-NNN reference

---

## Rule Quality

- [ ] Each rule is expressed as a clear constraint, policy, or mandate — not a feature description
- [ ] Each rule is verifiable: a QA engineer could check whether the rule is enforced
- [ ] Rules describe what the system must enforce — not how to implement the enforcement
- [ ] No rule contains technology choices (e.g., "must use Redis for session management" is an architectural decision, not a business rule)
- [ ] No rule is a restatement of a user story acceptance criterion
- [ ] Rules are written in plain business language accessible to a non-technical stakeholder

---

## Applicability

- [ ] Each rule specifies which user stories or features it applies to (US-NNN or feature name)
- [ ] Rules with broad applicability (e.g., "applies to all user data") are labeled accordingly
- [ ] Rules with exceptions have the exceptions documented

---

## Conflicts and Overlaps

- [ ] No two rules directly contradict each other
- [ ] If rules are related or interdependent, the relationship is noted
- [ ] Rules that may conflict with each other under specific conditions have a resolution documented

---

## Status Completeness

- [ ] Every rule has a status: Confirmed / To Confirm
- [ ] "To Confirm" rules have an associated OQ-NNN entry in `Open_Questions.md`
- [ ] No "To Confirm" rule with HIGH impact on MUST stories is left unresolved before Gate 1
- [ ] Rule IDs follow convention BR-NNN (zero-padded, sequential)

---

**Business Rules register is ready when:** All items above are checked. Rules without traceable sources will be returned at Gate 1. Technology decisions masquerading as business rules will be removed and routed to the Architect.
