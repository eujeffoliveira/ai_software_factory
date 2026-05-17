# Non-Functional Requirements Skill — Checklist

## Before Execution
- [ ] PII fields from data requirements have been identified and are available as input
- [ ] Scale expectations (concurrent users, data volume) have been confirmed through elicitation

## During Execution
- [ ] All 10 categories are addressed in sequence — no category skipped
- [ ] Each NFR draft is checked for vague terms before being added: "fast", "good", "reasonable", "adequate"
- [ ] Each performance metric specifies a percentile (P50/P95/P99), not just "average"
- [ ] Privacy NFRs name specific PII fields — not generic "personal data"
- [ ] No technology decisions are embedded in any NFR

## Output Validation
- [ ] All 10 categories_complete values are true
- [ ] Every NFR has a metric field with a specific value (not "TBD" or empty)
- [ ] nfr_checklist_passed is true
- [ ] NFR IDs follow NFR-[CATEGORY]-NNN convention
- [ ] vague_nfrs_found documents any corrections made during this run

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
- [ ] NFR category definitions applied from `knowledge/principles.md` and `knowledge/heuristics.md`
