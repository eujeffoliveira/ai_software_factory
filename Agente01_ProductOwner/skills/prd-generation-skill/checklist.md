# PRD Generation Skill — Checklist

## Before Execution
- [ ] All 8 input artifacts are present and non-empty
- [ ] User stories in User_Story_Map.md have been pre-validated against invest_checklist.md
- [ ] All BLOCKING open questions have been resolved or escalated
- [ ] No confirmed business rule lacks a traceable source

## During Execution
- [ ] Each section is written in order (1–15) — no skipping
- [ ] Each section is validated before moving to the next
- [ ] NFRs are checked for measurable metrics before writing Section 9
- [ ] Technology decisions are removed if found in any input artifact before transcribing
- [ ] Business rules without sources are moved to OQ-NNN, not included as confirmed
- [ ] Data requirements section contains only entity-level descriptions (no schema, no column names)

## Output Validation
- [ ] All 15 PRD sections are present and non-empty
- [ ] `prd_quality_checklist.md` has been run and all items pass
- [ ] No section contains placeholder text or "TODO" items
- [ ] No technology stack decisions appear in the PRD
- [ ] All user stories have accepted INVEST validation
- [ ] All acceptance criteria use Gherkin format
- [ ] All 10 NFR categories have measurable metrics
- [ ] PRD version and date are set correctly

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
- [ ] PRD structure follows `templates/PRD.md` — no external template references
- [ ] Validation uses only `checklists/prd_quality_checklist.md` — not external sources
