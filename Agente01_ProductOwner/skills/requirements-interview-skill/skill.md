# Requirements Interview Skill

## Purpose
Transform a raw project briefing and initial description into a structured set of elicitation questions, then record stakeholder answers in a categorized interview log.

## When to Use
- When a Tech Lead briefing is received and one or more of the following is unclear: business objective, target users, core features, success criteria, constraints, or acceptance conditions.
- When a PRD revision is requested and additional elicitation is needed to fill specific gaps.
- At the start of any new project engagement before drafting the PRD.

## Inputs
- `agent_briefing` — the briefing document provided by Agente00_TechLead
- `initial_description` — raw project description from stakeholder or context
- `previous_prd_version` (optional) — if this is a revision cycle, the existing PRD with gaps marked

## Outputs
- `Requirements_Interview_Log.md` — structured log with questions per category and recorded answers
- `Open_Questions.md` (initial) — questions that could not be answered in the interview session, classified by criticality

## Constraints
- Questions must be routed through Agente00_TechLead — the Product Owner does not contact stakeholders directly.
- Technology questions ("which database?", "which framework?") must not be asked — those are the Architect's domain.
- Do not ask questions whose answers are already provided in the briefing — re-read the briefing before generating questions. A question is redundant only if the briefing provides sufficient detail to write acceptance criteria: specific thresholds, named user personas, explicit business rules, or defined constraints. A briefing that merely names a feature without describing its behavior does not answer the question.
- The interview log must use the `templates/Requirements_Interview_Log.md` format.
- All unanswered questions become OQ-NNN entries, not assumptions.

## Step-by-Step Procedure

1. **Read the briefing thoroughly.** Identify what is known (do not re-ask) and what is unknown.

2. **Categorize unknowns into 6 areas:**
   - **Business Context:** What is the problem? What does success look like? Who benefits?
   - **Target Users:** Who are the users? What are their goals, pain points, and context?
   - **Scope:** What is explicitly in and out of scope? What are the constraints?
   - **Data:** What data is created, stored, processed, or read? Any PII? Any migration needs?
   - **Business Rules:** What policies, constraints, or domain logic governs the system?
   - **Risks and Constraints:** What deadlines, regulatory requirements, or dependencies exist?

3. **Prioritize questions by blocking status.** Questions whose answers are needed before any story can be written are BLOCKING. Questions that affect a single story's detail are MEDIUM or LOW.

4. **Generate questions.** Each question must:
   - Have a specific, answerable form (yes/no, or a concrete value/option)
   - State its category
   - Be written from a business perspective (no technology choices)

5. **Submit questions to Tech Lead** for routing to the appropriate stakeholder. Expected response times: BLOCKING questions within 2 business days, HIGH within 5 business days. If no response is received by the deadline, escalate via `human-escalation-skill` with `escalation_reason = "requirements_gap_unresolved"` and include which artifacts are blocked.

6. **Record answers.** For each answer received: record verbatim or accurately summarized, note follow-up needed, and identify the artifact action (create BR-NNN, create OQ-NNN, document as assumption).

7. **Produce outputs.** Write `Requirements_Interview_Log.md` using the template. Extract unanswered questions into initial `Open_Questions.md` with criticality, impact, and owner.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
