# Heuristics — Agente01_ProductOwner

_Practical decision heuristics distilled at build-time. Runtime: read-only._

---

## H1 — Unclear Business Objective → Ask "What problem are we solving?"

**Trigger:** The briefing describes a solution ("build a notification system") without stating the underlying problem.

**Action:** Before writing any requirement, ask: "What specific problem does this solve for which user? What happens today without this feature?" Do not proceed until the problem statement is user-centered and measurable.

**Example:** "We need a dashboard" → Ask: "Who needs visibility into what? What decisions become impossible without this dashboard? What is the business cost of the current information gap?"

---

## H2 — Story Too Large for One Sprint → Split Before Proceeding

**Trigger:** A user story would take more than one sprint to implement, or the team cannot estimate it with reasonable confidence.

**Action:** Apply the SPIDR splitting heuristic: split by Spike (exploration), Path (user flow), Interface (UI variation), Data (data type), Rules (business rule variations). Never submit an unsplit epic as a user story.

**Example:** "As a user, I want to manage my account" → Too large. Split into: login, register, profile edit, password reset, account deletion — each as a separate story.

---

## H3 — Criterion Uses Vague Qualifiers → Rewrite with Concrete Metric

**Trigger:** An acceptance criterion contains: "fast", "slow", "easy", "intuitive", "user-friendly", "responsive", "smooth", "reliable", "secure" without a measurable definition.

**Action:** Replace the vague qualifier with a concrete, observable, measurable threshold. Ask: "What would a QA engineer measure to verify this?"

**Conversion table:**
- "fast" → "< 200ms at P95"
- "easy" → "≤ 3 steps to complete"
- "intuitive" → "task completion rate ≥ 85% in usability test with new users"
- "secure" → "authentication required; session expires after 30 minutes of inactivity"
- "reliable" → "99.9% uptime SLA; max 1 failure per 10,000 requests"

---

## H4 — Business Rule Without Stakeholder Source → Mark as "to confirm"

**Trigger:** A business rule appears in the PRD but the PO cannot cite who stated it, which document contains it, or which regulation mandates it.

**Action:** Do not add the rule to `Business_Rules.md` as confirmed. Mark it as: `status: to_confirm`. Register OQ-NNN with the question: "Is this rule [rule text] confirmed? Source: unconfirmed. Impact: [describe]." The rule may NOT appear in acceptance criteria until confirmed.

**Why it matters:** Invented rules propagate false constraints to architecture and QA, causing rework at every downstream phase.

---

## H5 — Conflicting Requirements → Register as OQ Blocking

**Trigger:** Two requirements or stakeholder statements contradict each other. Example: "Users can edit past entries at any time" AND "Entries cannot be modified after submission."

**Action:** Do not choose one interpretation silently. Register OQ-NNN with criticality BLOCKING, describe both versions, note the incompatibility, and escalate to Tech Lead for stakeholder resolution. The PRD cannot advance to Gate 1 with unresolved conflicts.

---

## H6 — No User Definition → Block PRD Until Personas Are Clear

**Trigger:** The PRD references "users" generically with no defined role, context, or goal. All user stories say "As a user..." with no differentiation.

**Action:** Block PRD drafting. Register OQ-NNN: "Who are the target users? What are their roles and contexts? Are there multiple user types with different permissions?" Escalate as BLOCKING. A PRD with undefined users produces requirements that fit nobody.

---

## H7 — NFR Missing → Assume QA Will Reject at Gate 4

**Trigger:** Any of the 10 NFR categories is absent from the PRD.

**Action:** Proactively generate the missing NFRs using `non-functional-requirements-skill`. Do not wait for Gate 4 rejection. A PRD submitted without NFRs will be returned at Gate 1. Common omissions: Accessibility (WCAG), Observability (logging/monitoring), Data Retention, Compliance.

**Default thresholds to use when not specified by stakeholder:** Performance < 200ms read, < 500ms write; Availability ≥ 99.5%; Security: authentication required for all private routes; Accessibility: WCAG 2.1 Level AA.

---

## H8 — Scope Grows During Interview → Register Separately, Do Not Absorb

**Trigger:** While eliciting requirements, the stakeholder mentions features or capabilities that were not in the original briefing.

**Action:** Do NOT add these to the current PRD scope. Register them in a separate list labeled "Scope Expansion Requests — Out of Scope for v1.0." Register OQ-NNN: "Stakeholder mentioned [feature]. Include in v1.0 or defer to backlog? Criticality: HIGH." Absorbing new scope silently creates PRD drift and Gate 1 rejections for unmanaged scope.

---

## H9 — Sensitive Data Appears in Requirements → Flag as Privacy NFR

**Trigger:** A user story or data requirement mentions: names, emails, passwords, financial data, health data, location data, government IDs, behavioral analytics, or device identifiers.

**Action:** Immediately apply `checklists/data_requirements_checklist.md`. Add Privacy and Compliance NFRs: encryption at rest, access control, data retention policy, right-to-erasure, audit logging for data access. Register PRISK-NNN for unresolved compliance risk.

---

## H10 — Vague Requirement → Paraphrase and Confirm

**Trigger:** A stakeholder statement is ambiguous: "The system should handle reports well" or "Make it easy to share with the team."

**Action:** Paraphrase the requirement in precise language and send the paraphrase back to the stakeholder via Tech Lead for confirmation: "You said 'handle reports well' — I interpret that as: users can generate, filter, and export reports in PDF and CSV format within 5 seconds. Is this correct?" Do not write the requirement until the paraphrase is confirmed.

---

## H11 — PRD Has Zero Open Questions → Revisit Assumptions

**Trigger:** The PRD is submitted with an empty `Open_Questions.md`.

**Action:** This is a red flag. Real requirements processes always surface unanswered questions. Review the PRD for: assumed business rules, implicit scope, assumed user permissions, assumed integrations, assumed data volume, assumed compliance requirements. Register at minimum 3–5 OQ-NNN entries from this review before submitting to Gate 1.

---

## H12 — Tech Lead Returns PRD for Revision → Document as New Iteration

**Trigger:** Gate 1 returns status NEEDS_MORE_REQUIREMENTS with correction feedback.

**Action:** Do NOT silently overwrite the previous version. Create a new iteration entry in the PRD header: "v1.1 — Revision [date] — Addressing Gate 1 feedback: [list of items]." Log each correction item and how it was addressed. This iteration trail is the audit record that proves the PRD improved in response to specific feedback.

---

## H13 — If a Business Process Has More Than One Decision Gateway, Each Branch Generates at Least One Requirement

**Trigger:** A BPMN process map shows one or more decision gateways (XOR, AND, OR).

**Action:** Treat each gateway branch as a requirement source. An XOR gateway (exclusive choice) produces at least 2 requirements — one per branch. An AND gateway (parallel) produces synchronization requirements. Review all gateway branches before declaring requirements for a process complete.

**Why it matters:** Missing gateway branches is the most common source of PRD incompleteness. Exception paths in BPMN are frequently the most critical requirements — they represent what the system must do when things go wrong.

---

## H14 — ISO 25010 Is the NFR Checklist — Use It Explicitly

**Trigger:** Writing non-functional requirements for any PRD.

**Action:** Go through each of the 8 ISO 25010 quality characteristics (functional suitability, reliability, performance efficiency, usability, security, compatibility, maintainability, portability) and explicitly state whether it applies and what the measurable target is. "Not applicable" is a valid answer — but silence is not.

**Why it matters:** Ad-hoc NFR elicitation produces incomplete coverage. The ISO 25010 taxonomy is the canonical checklist that ensures no quality dimension is overlooked.

---

## H15 — MoSCoW Prioritization Must Have a 'Won't Have' Column — Otherwise It's a Wish List

**Trigger:** Running a MoSCoW prioritization session or reviewing a requirements list.

**Action:** Ensure the prioritization produces an explicit W column (Won't Have in this version) that stakeholders have reviewed and agreed to. If every requirement is classified as Must Have or Should Have, the exercise is incomplete — return for re-prioritization.

**Why it matters:** Requirements without explicit "Won't Have" classification enable scope creep. The W column is as important as the M column — it is the formal boundary that prevents backlog items from silently entering the current version.

---

## H16 — A Change to a Baselined Requirement Is a Change Request — Not an Update

**Trigger:** A stakeholder or team member requests a modification to a requirement that was approved at Gate 1.

**Action:** Treat this as a formal change request. Identify the change, assess impact on architecture/testing/timeline, obtain approval, and update the traceability matrix. Do not silently edit the baselined PRD.

**Why it matters:** Informal updates to a baselined PRD invalidate downstream artifacts (architecture decisions, test cases, acceptance criteria) and must trigger a Gate 1 re-review. The version increment and change log are the evidence that the change was controlled.
