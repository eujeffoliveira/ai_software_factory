# Failure Modes — Agente01_ProductOwner

_Catalog of known failure modes for the Product Owner agent. Runtime: read-only._

---

## FM-01 — Ambiguous Business Problem

**Symptom:** PRD summary describes the solution ("we will build a dashboard") instead of the problem ("operations managers lack real-time visibility into pipeline failures"). No problem statement references user pain or business impact.

**Probable Cause:** Briefing accepted at face value without asking "what problem are we solving?" Stakeholder described the desired feature, not the underlying need.

**Action:**
1. Apply `requirements-interview-skill` — generate question: "What specific problem does this feature solve for the user?"
2. Rewrite the business problem section using the stakeholder's answer.
3. Validate that the problem section answers: Who is affected? What is the pain? What is the measurable impact?

**When to Escalate to Tech Lead:** If the stakeholder answer remains vague after two rounds of clarification, register OQ-NNN as BLOCKING and escalate.

**Artifact to Fix:** `PRD.md` — section "Business Problem / Problem Statement"

---

## FM-02 — Undefined Target User

**Symptom:** PRD references "users" generically throughout. No persona, role, or user type is defined. Acceptance criteria say "the user should be able to..." without specifying which user.

**Probable Cause:** Briefing mentioned the product domain but not who specifically benefits. PO did not ask "who is this for?" during elicitation.

**Action:**
1. Apply `requirements-interview-skill` — ask: "Who specifically will use this? What is their role, context, and goal?"
2. Define at least one concrete user type with context.
3. Re-anchor all user stories with "As a [specific user type]..."

**When to Escalate to Tech Lead:** If the target user cannot be determined without business stakeholder input, register OQ-NNN as BLOCKING.

**Artifact to Fix:** `PRD.md` — section "Target Users / Personas"; all user stories in `User_Story_Map.md`

---

## FM-03 — PRD Without Measurable Objective

**Symptom:** Objectives section contains phrases like "improve the user experience", "make the system faster", "increase engagement". No metric, threshold, or success criterion is defined.

**Probable Cause:** Business objectives were stated in qualitative terms during briefing and PO accepted them without pressing for metrics.

**Action:**
1. Apply `requirements-interview-skill` — ask: "How will you know this objective was achieved? What metric changes and by how much?"
2. Rewrite each objective with: [what changes] + [by how much] + [by when].
3. Example fix: "Improve UX" → "Achieve task completion rate ≥ 85% for the primary workflow in usability testing."

**When to Escalate to Tech Lead:** If the business cannot define a measurable success criterion, register OQ-NNN as HIGH and note the PRD cannot be fully validated at Gate 7 without it.

**Artifact to Fix:** `PRD.md` — section "Objectives and Success Criteria"

---

## FM-04 — PRD Without Out-of-Scope Section

**Symptom:** PRD defines features but has no explicit out-of-scope section. When asked what is NOT included, the answer is unclear or contradictory.

**Probable Cause:** PO documented what will be built but did not explicitly draw the boundary. Scope crept during drafting.

**Action:**
1. Apply `scope-boundary-skill`.
2. List every feature or capability that was mentioned in briefing but will NOT be in this version.
3. Document the rationale for each exclusion.
4. Add `Scope_Boundary.md` and link it from the PRD.

**When to Escalate to Tech Lead:** If scope cannot be bounded without a stakeholder decision (e.g., "should we include reporting?"), register OQ-NNN as BLOCKING.

**Artifact to Fix:** `Scope_Boundary.md`; `PRD.md` — section "Scope"

---

## FM-05 — User Stories Not INVEST-Compliant

**Symptom:** Stories are too large (cannot be completed in one sprint), tightly coupled to other stories (not independent), cannot be estimated (no acceptance criteria), or have no user value on their own.

**Probable Cause:** PO wrote technical tasks ("implement database schema for users") instead of user stories. Stories were not split.

**Action:**
1. Apply `checklists/invest_checklist.md` to each story.
2. Split stories that fail the S (Small) or E (Estimable) dimension.
3. Rewrite technical tasks as stories with user value: "As a registered user, I want to... so that..."
4. Ensure each story can be independently developed and tested.

**When to Escalate to Tech Lead:** If a story cannot be made small enough without losing value (e.g., complex regulatory workflow), register OQ-NNN as HIGH and flag for architectural consultation.

**Artifact to Fix:** `User_Story_Map.md`; all US-NNN entries in `PRD.md`

---

## FM-06 — Acceptance Criteria Not Testable

**Symptom:** QA engineer cannot execute the acceptance criterion without asking the PO for clarification. Criteria contain subjective language: "should look good", "must work well", "should be intuitive".

**Probable Cause:** PO wrote acceptance criteria from a product vision perspective instead of a QA-executable perspective.

**Action:**
1. Apply `checklists/bdd_acceptance_checklist.md` to each criterion.
2. Replace subjective language with observable, measurable outcomes.
3. Examples of fixes:
   - "Should look good" → "Renders without horizontal scroll on 1280px viewport"
   - "Must work well" → "Returns results within 2 seconds for input datasets up to 10,000 records"
   - "Should be intuitive" → "User completes registration without help in ≤ 3 minutes in usability test"

**When to Escalate to Tech Lead:** None — this is always fixable by the PO.

**Artifact to Fix:** `Acceptance_Criteria.md`; all AC-NNN-NN entries

---

## FM-07 — Acceptance Criteria Not in BDD/Gherkin Format

**Symptom:** Acceptance criteria are written as bullet points, free prose, or checklists — not in `Given / When / Then` format.

**Probable Cause:** PO wrote criteria from product notes or user interview quotes without applying the BDD structure.

**Action:**
1. Apply `bdd-acceptance-criteria-skill` to reformulate each criterion.
2. Ensure every criterion follows: `Given [precondition], When [action], Then [expected outcome]`.
3. Identify edge cases and negative scenarios — not just happy path.

**When to Escalate to Tech Lead:** None — this is always fixable by the PO.

**Artifact to Fix:** `Acceptance_Criteria.md`

---

## FM-08 — NFRs Absent or Incomplete

**Symptom:** PRD has no NFR section, or NFRs exist only for one or two categories (e.g., only performance). The remaining 8 categories are missing.

**Probable Cause:** PO treated NFRs as optional. Business briefing focused exclusively on features. PO did not proactively generate NFRs.

**Action:**
1. Apply `non-functional-requirements-skill` to generate NFRs for all 10 categories.
2. Apply `checklists/non_functional_requirements_checklist.md`.
3. Each NFR must have a concrete metric — not "system must be secure" but "all endpoints require authentication; session tokens expire after 1 hour of inactivity."

**When to Escalate to Tech Lead:** If compliance requirements (GDPR, HIPAA, SOC 2) are applicable but the PO does not have the specific requirements, register OQ-NNN as BLOCKING.

**Artifact to Fix:** `Non_Functional_Requirements.md`; `PRD.md` — section "Non-Functional Requirements"

---

## FM-09 — Business Rule Invented by PO

**Symptom:** A business rule (BR-NNN) appears in the PRD with no stakeholder source. When asked "who told you this rule?", the PO cannot cite a specific stakeholder statement or document.

**Probable Cause:** PO inferred a rule from context, filled a gap with assumed logic, or copied a rule from another project without verification.

**Action:**
1. Remove the rule from `Business_Rules.md` or mark it as "status: to_confirm".
2. Register an OQ-NNN: "Is this rule confirmed? Source: [assumed]. Impact if wrong: [describe]."
3. Set OQ criticality to HIGH or BLOCKING depending on how much of the PRD depends on this rule.
4. Do not propagate unconfirmed rules into acceptance criteria.

**When to Escalate to Tech Lead:** If multiple core rules are unconfirmed and the PRD cannot be completed without them, escalate as BLOCKING.

**Artifact to Fix:** `Business_Rules.md`; `Open_Questions.md`

---

## FM-10 — Technology Decision Embedded in PRD

**Symptom:** PRD contains statements like "use PostgreSQL for data storage", "implement with Next.js Server Actions", "use Redis for caching", or "create a REST API". Architecture decisions appear inside requirements.

**Probable Cause:** PO incorporated technical suggestions from stakeholders, briefing, or prior experience directly into the PRD without separation of concerns.

**Action:**
1. Remove all technology references from the PRD.
2. Replace technology references with requirements: "data must persist durably" (not "use PostgreSQL").
3. If a stakeholder expressed a technology preference, register it as an assumption: "Stakeholder prefers PostgreSQL — to be confirmed by Architect."
4. Technology selection is exclusively the Software Architect's domain.

**When to Escalate to Tech Lead:** If the stakeholder insists on a specific technology as a business constraint (e.g., "we have an existing Oracle contract"), register it as an organizational constraint OQ-NNN and escalate to Tech Lead.

**Artifact to Fix:** `PRD.md` — all sections; remove technology names

---

## FM-11 — BLOCKING Open Question Not Escalated

**Symptom:** PRD is submitted with one or more OQ-NNN entries marked BLOCKING and status OPEN. Tech Lead cannot approve Gate 1 because the PRD relies on information that is unknown.

**Probable Cause:** PO submitted the PRD without running `checklists/open_questions_checklist.md`. BLOCKING questions were documented but not escalated.

**Action:**
1. Apply `checklists/open_questions_checklist.md` — verify all BLOCKING items are ESCALATED or RESOLVED.
2. For each BLOCKING OQ: send to Tech Lead for human resolution before handoff.
3. Do not submit to Gate 1 until all BLOCKING OQs have status ESCALATED or RESOLVED.

**When to Escalate to Tech Lead:** Immediately — BLOCKING questions are by definition Tech Lead escalations.

**Artifact to Fix:** `Open_Questions.md`; hold `Handoff_To_Architect.md` submission

---

## FM-12 — Sensitive Data Not Flagged

**Symptom:** PRD involves personal data (names, emails, financial data, health data, user behavior) but has no Privacy or Compliance NFR. Data retention policy is unspecified. No right-to-erasure or access control NFR exists.

**Probable Cause:** PO did not apply `checklists/data_requirements_checklist.md`. Privacy implications of the feature were not identified.

**Action:**
1. Apply `checklists/data_requirements_checklist.md`.
2. Identify all personal data fields involved in user stories.
3. Apply `non-functional-requirements-skill` to generate privacy NFRs: data retention policy, encryption at rest, right-to-erasure, access logging.
4. Register PRISK-NNN for any unresolved compliance risk.

**When to Escalate to Tech Lead:** If the applicable compliance framework (GDPR, HIPAA, LGPD, etc.) is unclear, register OQ-NNN as BLOCKING.

**Artifact to Fix:** `Non_Functional_Requirements.md` — add COMP and DRET entries; `Product_Risks.md` if compliance risk identified

---

## FM-13 — Attempted Direct Human Communication

**Symptom:** PO attempts to directly message, email, or contact a stakeholder without routing through the Tech Lead. Or PO embeds personal contact information in PRD artifacts.

**Probable Cause:** Urgency or frustration at slow responses caused PO to bypass the established communication protocol.

**Action:**
1. Stop. All human communication goes through the Tech Lead.
2. Register the unresolved question as OQ-NNN.
3. Submit the OQ to the Tech Lead with context and urgency level.
4. The Tech Lead decides whether to escalate to human and routes the answer back.

**When to Escalate to Tech Lead:** Immediately — this is what the Tech Lead is for.

**Artifact to Fix:** `Open_Questions.md` — register the question; do not send direct messages

---

## FM-14 — Runtime Access to Blocked Source

**Symptom:** A runtime instruction, skill, or retrieval attempt tries to read from `lib/`, `context/`, raw PDFs, raw books, or global build documents. The agent proceeds with information from those sources.

**Probable Cause:** A skill or prompt references a raw source path, or a user instructed the agent to "read the requirements book."

**Action:**
1. Refuse the access immediately.
2. Use `knowledge/` distilled artifacts instead.
3. Log the attempt: "Runtime access to [source] refused — policy violation. Using knowledge/ instead."
4. If the needed knowledge is not in `knowledge/`, request a build patch from the build operator.

**When to Escalate to Tech Lead:** If a critical decision requires theoretical knowledge not in `knowledge/`, escalate to Tech Lead with a build patch request.

**Artifact to Fix:** None — prevent the access. Update `knowledge/` via build patch if knowledge gap identified.
