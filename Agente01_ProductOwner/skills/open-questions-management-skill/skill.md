# Open Questions Management Skill

## Purpose
Register, classify, track, and escalate unresolved questions that arise during requirements elicitation, ensuring each question has an owner, criticality, and impact description.

## When to Use
- Whenever an unresolved question arises during any phase of requirements work.
- When the Open_Questions.md register needs to be updated after stakeholder responses are received.
- When a PRD review identifies new ambiguities that must be registered before Gate 1.

## Inputs
- `unresolved_items[]` — list of questions or ambiguities discovered (from interview log, PRD review, or external input)
- `context` — current project context (which stories and artifacts are affected)
- `existing_open_questions` (optional) — current `Open_Questions.md` for deduplication and ID sequencing

## Outputs
- Updated `Open_Questions.md` with OQ-NNN entries following `templates/Open_Questions.md` format

## Constraints
- Every question must have: ID (OQ-NNN), question text, impact description, criticality, and owner
- Criticality must be justified by the impact — not assigned arbitrarily
- BLOCKING questions must be escalated to Tech Lead immediately — they cannot remain unresolved before Gate 1
- IDs must be sequential with no gaps
- Questions that have been answered must be moved to the Resolved section with their resolution documented
- Do not invent answers to questions — unresolved items remain as OQ-NNN until answered

## Criticality Classification Rules

- **BLOCKING:** Cannot finalize a mandatory PRD section (e.g., cannot define business rule, cannot complete acceptance criteria for a MUST story). Must be resolved before Gate 1.
- **HIGH:** Significantly impacts scope definition, NFRs, or multiple user stories. Should be resolved before Gate 1 if possible; if not, document the assumption taken.
- **MEDIUM:** Affects a specific story's detail or a non-critical section. Can proceed with a documented assumption if resolution is not available before Gate 1.
- **LOW:** Clarification that would be nice to have but does not affect any artifact decision. Document assumption and proceed.

## Step-by-Step Procedure

1. **For each unresolved item:** formulate it as a specific, answerable question. "What about security?" is not a question. "Should unauthenticated clients be redirected to the login page or shown an HTTP 403 error?" is a question.

2. **Identify the impact.** What artifact is blocked by the unanswered question? What cannot be written until this is answered? Impact must reference specific artifacts (AC-NNN, BR-NNN, NFR-NNN, or a PRD section).

3. **Assign criticality** using the rules above. If unsure between two levels, choose the higher level.

4. **Identify the owner.** Who can provide the authoritative answer? A stakeholder role — not the Product Owner.

5. **Assign a deadline** for BLOCKING and HIGH questions. No deadline for MEDIUM and LOW is acceptable if the risk is documented.

6. **Check for duplicates** against existing open questions. If a question duplicates an existing OQ-NNN, add it as a note to the existing entry rather than creating a new one.

7. **Update Open_Questions.md.** Add new entries in the appropriate criticality section. Move resolved entries to the Resolved section with resolution text.

8. **Escalate BLOCKING questions** by including them in the next Tech Lead communication before Gate 1.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
