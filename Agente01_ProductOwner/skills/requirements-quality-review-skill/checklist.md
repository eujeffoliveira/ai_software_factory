# Requirements Quality Review Skill — Checklist

## Before Execution
- [ ] PRD.md and all 7 supporting artifacts are available for review
- [ ] prd_quality_checklist.md is loaded and will be applied item-by-item

## During Execution
- [ ] Every checklist item is evaluated individually — no section is blanket-approved
- [ ] Evidence is cited for each PASS (section reference, count, or specific value)
- [ ] Each FAIL includes the exact issue and the specific correction needed
- [ ] Technology contamination scan is performed on all PRD sections
- [ ] BLOCKING open questions are identified and flagged immediately

## Output Validation
- [ ] overall_status is set correctly: READY only if 0 BLOCKING and 0 MAJOR issues
- [ ] pass_count + fail_count matches total checklist items evaluated
- [ ] issues_requiring_correction has a correction_needed for every FAIL item
- [ ] technology_contamination array is complete (not skipped)
- [ ] No PASS was awarded without evidence

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
- [ ] Quality criteria applied from `checklists/prd_quality_checklist.md` — not from external sources
