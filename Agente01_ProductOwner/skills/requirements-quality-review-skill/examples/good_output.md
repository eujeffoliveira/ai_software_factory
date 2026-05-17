# Requirements Quality Review Skill — Good Output Example

_GOOD EXAMPLE — Review that approves 90% and identifies 2 specific issues with corrections._

---

## Output JSON

```json
{
  "overall_status": "NOT_READY_MAJOR_ISSUES",
  "pass_count": 29,
  "fail_count": 3,
  "section_results": [
    { "section": "Document Structure", "status": "PASS", "items_passed": 5, "items_failed": 0, "notes": "All 15 sections present, version 1.0, dated 2026-05-17" },
    { "section": "Business Problem", "status": "PASS", "items_passed": 6, "items_failed": 0, "notes": "Problem phrased in business terms with quantified evidence: 3-5 scheduling conflicts/week" },
    { "section": "User Stories", "status": "PASS", "items_passed": 10, "items_failed": 0, "notes": "5 stories, all 3-part format, all INVEST-validated, priority assigned" },
    { "section": "Acceptance Criteria", "status": "PARTIAL", "items_passed": 5, "items_failed": 1, "notes": "HP and NS present for all MUST stories. One criterion uses vague language." },
    { "section": "NFRs", "status": "PARTIAL", "items_passed": 7, "items_failed": 2, "notes": "8 of 10 categories have metrics. Observability and Auditability missing metrics." },
    { "section": "Scope", "status": "PASS", "items_passed": 4, "items_failed": 0, "notes": "In-scope 5 features, out-of-scope 3 items with reasons" },
    { "section": "Business Rules", "status": "PASS", "items_passed": 4, "items_failed": 0, "notes": "2 confirmed rules with stakeholder sources. 0 invented rules." },
    { "section": "Data", "status": "PASS", "items_passed": 4, "items_failed": 0, "notes": "4 entities at conceptual level. No schema details found." },
    { "section": "Risks and Questions", "status": "PASS", "items_passed": 4, "items_failed": 0, "notes": "2 OQs with criticality and owners. 0 BLOCKING. 2 risks with HIGH mitigation." },
    { "section": "Handoff Readiness", "status": "FAIL", "items_passed": 0, "items_failed": 1, "notes": "Handoff_To_Architect.md not yet produced." }
  ],
  "issues_requiring_correction": [
    {
      "section": "Acceptance Criteria",
      "issue": "AC-002-01 Then clause contains 'the page loads quickly' — 'quickly' is a forbidden vague term with no measurable metric.",
      "severity": "MAJOR",
      "correction_needed": "Replace 'quickly' with a concrete metric. NFR-PERF-002 states P95 ≤ 2s — update to: 'And the schedule view loads within 2 seconds.'"
    },
    {
      "section": "NFRs",
      "issue": "NFR-OBS-001 states 'logs should be available for debugging' with no delivery time or format specified. NFR-AUDIT-001 states 'audit logs should be kept' with no retention period.",
      "severity": "MAJOR",
      "correction_needed": "NFR-OBS-001: Add delivery metric, e.g., 'Structured JSON log entries produced within 500ms of state change.' NFR-AUDIT-001: Add retention period, e.g., 'Audit logs retained for 24 months and queryable by administrators.'"
    },
    {
      "section": "Handoff Readiness",
      "issue": "Handoff_To_Architect.md has not been produced yet.",
      "severity": "BLOCKING",
      "correction_needed": "Run handoff assembly using templates/Handoff_To_Architect.md before submitting to Tech Lead."
    }
  ],
  "technology_contamination": []
}
```

## Why This is Good

- 29 PASS, 3 FAIL — realistic distribution (not 0 failures, which would be suspicious)
- Each FAIL has a specific issue statement and a specific correction_needed (not "fix this")
- Severity is correctly assigned: BLOCKING for missing mandatory artifact, MAJOR for metrics and testability
- PASS items have evidence in notes (not just "looks good")
- technology_contamination is empty (clean PRD)
- overall_status is NOT_READY because there are MAJOR and BLOCKING issues — not prematurely set to READY
