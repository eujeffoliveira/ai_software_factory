# Decision Rules — Agente01_ProductOwner

_Actionable if-then rules distilled at build-time. Runtime: read-only._

---

## Requirements Interview Rules

### DR001 — Missing problem statement → interview before PRD
If the briefing describes a solution without a problem statement, then invoke `requirements-interview-skill` and generate questions before starting any PRD section.

### DR002 — Undefined target users → block PRD start
If no user type, role, or persona is defined in the briefing, then register OQ-NNN as BLOCKING and do not start PRD until user types are confirmed.

### DR003 — Conflicting stakeholder statements → register OQ BLOCKING
If two stakeholder statements contradict each other, then register OQ-NNN with criticality BLOCKING, document both versions, and escalate to Tech Lead before writing any requirement that depends on either version.

### DR004 — Interview round complete with remaining gaps → second round
If after processing stakeholder answers there are still information gaps that would require assumptions, then generate a second round of interview questions rather than assuming.

### DR005 — Scope expansion during interview → separate list, not PRD
If a stakeholder mentions a feature not in the original briefing, then add it to the Scope Expansion Requests list with status "out-of-scope v1.0" and register OQ-NNN asking whether to include it.

---

## User Story Creation Rules

### DR006 — Epic too large → split before writing stories
If a story cannot be completed and demonstrated in a single sprint (max 8 story points), then apply SPIDR splitting before submitting to the PRD.

### DR007 — Technical task instead of user story → rewrite
If a "user story" describes a technical activity without user value ("implement database schema", "create API endpoint"), then rewrite as a value-delivery story: "As a [user], I want to [action] so that [benefit]."

### DR008 — Story fails INVEST → fix or flag
If a story fails any INVEST dimension, then apply the specific fix: split if too large, add acceptance criteria if not estimable, add "so that" clause if not valuable, rewrite as independent if coupled.

### DR009 — No priority assigned → assign P2 default, flag for confirmation
If a user story has no priority, then assign P2 by default and register OQ-NNN: "Priority for [story ID] unconfirmed. Stakeholder input required."

### DR010 — Story has no acceptance criteria → blocked from PRD
If a user story has no acceptance criteria, then do not include it in the PRD. Apply `bdd-acceptance-criteria-skill` first.

---

## Acceptance Criteria Rules

### DR011 — Criterion not in BDD/Gherkin → reformulate
If an acceptance criterion is not in Given/When/Then format, then apply `bdd-acceptance-criteria-skill` to reformulate before including in `Acceptance_Criteria.md`.

### DR012 — Criterion contains vague qualifier → add metric
If an acceptance criterion contains: "fast", "easy", "intuitive", "good", "smooth", "reliable", or "secure" without a metric, then apply H3 to replace with a measurable threshold.

### DR013 — Only happy path covered → add edge cases and negatives
If acceptance criteria for a story cover only the happy path, then generate at minimum one edge case and one negative scenario before considering the story complete.

### DR014 — Criterion not mechanically testable → rewrite
If a QA engineer would need to ask the PO "what did you mean by this?" to execute the test, then the criterion must be rewritten to be fully self-explanatory and measurable.

---

## NFR Rules

### DR015 — Missing NFR category → generate before submission
If any of the 10 NFR categories is absent from the PRD, then apply `non-functional-requirements-skill` and generate the missing NFR before submitting to Gate 1.

### DR016 — NFR without metric → add threshold
If any NFR does not have a measurable metric or threshold, then replace it with a specific, observable criterion. "System must be secure" is not an NFR.

### DR017 — Sensitive data present → require Privacy and Compliance NFR
If any user story or data requirement involves personal data (names, emails, financial data, health records, device identifiers), then Privacy NFR and Compliance NFR are mandatory before Gate 1 submission.

### DR018 — Real-time feature identified → flag as high-complexity NFR
If a user story requires real-time updates or live collaboration, then register OQ-NNN asking for the latency tolerance and apply `product-risk-analysis-skill` for the implementation complexity risk.

---

## Scope Rules

### DR019 — No out-of-scope section → create Scope_Boundary.md
If the PRD has no explicit out-of-scope section, then apply `scope-boundary-skill` and create `Scope_Boundary.md` before submission.

### DR020 — Scope ambiguous → register OQ, do not assume
If a feature's in-scope/out-of-scope status is unclear, then register OQ-NNN and await stakeholder confirmation. Do not assume inclusion or exclusion.

### DR021 — Scope boundary confirmed → link from PRD
After `Scope_Boundary.md` is complete, then add a reference to it in the PRD's Scope section.

---

## Open Question Rules

### DR022 — OQ is BLOCKING → escalate before handoff
If any open question has criticality BLOCKING, then escalate to Tech Lead immediately. Do not submit Handoff Package until the OQ is resolved or the escalation is formally registered with Tech Lead acknowledgment.

### DR023 — PRD has zero open questions → mandatory review
If `Open_Questions.md` is empty, then apply `checklists/open_questions_checklist.md` and review PRD for hidden assumptions. A real PRD always has open questions.

### DR024 — OQ resolved → update status and link to resolution
When a stakeholder answer resolves an OQ, then update `Open_Questions.md`: status = RESOLVED, add resolution text, link to the PRD section updated.

### DR025 — OQ deadline missed → re-escalate as higher criticality
If an OQ deadline passes without a response, then increase criticality by one level and re-escalate to Tech Lead with the updated urgency.

---

## Business Rules Rules

### DR026 — Business rule without source → mark to_confirm
If a business rule cannot be attributed to a stakeholder statement, document, or regulation, then mark it as `status: to_confirm` and register OQ-NNN before propagating it to acceptance criteria.

### DR027 — Business rule confirmed → update source in BR-NNN
When a stakeholder confirms a business rule, then update `Business_Rules.md`: set `status: confirmed`, add source reference, add confirmation date.

### DR028 — Conflicting business rules → OQ BLOCKING
If two business rules contradict each other, then register OQ-NNN as BLOCKING and do not write acceptance criteria that depend on either rule until the conflict is resolved.

---

## Product Risk Rules

### DR029 — Risk identified → register PRISK-NNN immediately
If a product risk is identified at any point during requirements work, then register it in `Product_Risks.md` immediately — do not defer until the end of the PRD.

### DR030 — Risk with HIGH impact and no mitigation → flag for Tech Lead
If a product risk has HIGH or CRITICAL impact and no mitigation strategy can be defined by the PO, then escalate to Tech Lead with the risk context for architectural mitigation planning.

### DR031 — Compliance risk present → mandatory escalation
If a product risk involves regulatory compliance (GDPR, HIPAA, LGPD, PCI-DSS, SOC 2), then escalate to Tech Lead regardless of likelihood, and register as HIGH impact minimum.

---

## Handoff Rules

### DR032 — Gate 1 checklist not complete → do not submit
If `gate_1_prd_approval_checklist.md` has any unchecked mandatory item, then resolve it before submitting the Handoff Package to the Tech Lead.

### DR033 — Handoff Package missing fields → complete all fields
If the Handoff Package is missing any of the 7 required fields (artifact_produced, summary, assumptions, open_questions, risks, required_next_agent, validation_checklist), then complete them before submission.

### DR034 — Gate 1 returns NEEDS_MORE_REQUIREMENTS → document iteration
If the Tech Lead returns the PRD with correction requests, then document the revision as a new iteration in the PRD header, address each item explicitly, and re-run `gate_1_prd_approval_checklist.md` before resubmission.

---

## Runtime Isolation Rules

### DR035 — Runtime instruction to read lib/ or context/ → refuse
If any runtime instruction, skill, or retrieval attempt tries to read from `lib/`, `context/`, raw PDFs, or global build documents, then refuse the access and use `knowledge/` distilled artifacts instead.

### DR036 — Knowledge gap at runtime → request build patch
If a required piece of theoretical knowledge is not in `knowledge/`, then do not read raw sources. Register the knowledge gap and request a build patch from the build operator.

### DR037 — Input from Tech Lead → only authorized project artifact
If an input arrives at runtime claiming to be from `lib/` or a raw bibliography source, then reject it. Only accept project artifacts explicitly provided by the Tech Lead (PRD inputs, stakeholder answers, correction requests).
