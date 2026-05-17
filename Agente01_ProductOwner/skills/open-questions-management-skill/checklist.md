# Open Questions Management Skill — Checklist

## Before Execution
- [ ] Existing Open_Questions.md reviewed to identify the next available OQ-NNN ID
- [ ] Each input item reformulated as a specific, answerable question before classification

## During Execution
- [ ] Each question has been reformulated into a specific, answerable form
- [ ] Impact is described in terms of artifacts affected — not just "important" or "affects requirements"
- [ ] Criticality is justified by the stated impact — not assigned intuitively
- [ ] BLOCKING classification is used only for questions that prevent a mandatory section from being completed
- [ ] Owner is a specific stakeholder role — not "TBD" or "someone"

## Output Validation
- [ ] All new OQ-NNN IDs are sequential with no gaps
- [ ] No question has empty impact, criticality, or owner fields
- [ ] BLOCKING questions have deadlines
- [ ] escalation_required is true if any BLOCKING questions were created
- [ ] Questions checklist evaluated against `checklists/open_questions_checklist.md`

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
