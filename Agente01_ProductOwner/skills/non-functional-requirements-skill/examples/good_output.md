# Non-Functional Requirements Skill — Good Output Example

_GOOD EXAMPLE — NFRs with concrete metrics for all 10 categories._

---

## Output JSON (Excerpt — showing 4 of 10 categories)

```json
{
  "artifact_path": "project/Non_Functional_Requirements.md",
  "nfr_checklist_passed": true,
  "vague_nfrs_found": [],
  "categories_complete": {
    "performance": true, "security": true, "privacy": true, "availability": true,
    "observability": true, "auditability": true, "accessibility": true,
    "maintainability": true, "scalability": true, "data_retention": true
  },
  "nfr_entries": [
    {
      "id": "NFR-PERF-001",
      "category": "performance",
      "description": "Public booking page response time under peak load",
      "metric": "P95 response time ≤ 2 seconds under 100 concurrent sessions",
      "priority": "MUST",
      "acceptance_criterion": "Load test with 100 virtual users, measure P95 latency — must be ≤ 2000ms"
    },
    {
      "id": "NFR-SEC-001",
      "category": "security",
      "description": "Staff and admin route authentication enforcement",
      "metric": "All staff and admin routes return HTTP 401 for unauthenticated requests; unauthenticated clients are redirected to the login page",
      "priority": "MUST",
      "acceptance_criterion": "Automated test: access staff route without session cookie → verify HTTP 401 response"
    },
    {
      "id": "NFR-PRIV-001",
      "category": "privacy",
      "description": "PII fields excluded from application logs",
      "metric": "Fields: client full name, client email address, client phone number — must not appear in application logs in plain text",
      "priority": "MUST",
      "acceptance_criterion": "Log audit: search application logs after booking flow — verify none of the three PII fields appear in plain text"
    },
    {
      "id": "NFR-DRET-001",
      "category": "data_retention",
      "description": "Appointment record retention period",
      "metric": "Appointment records retained for 5 years from the appointment date",
      "priority": "MUST",
      "acceptance_criterion": "Verified by data retention policy documentation and system configuration review"
    }
  ]
}
```

## Why This is Good

- All 10 categories_complete values are true
- NFR-PERF-001 specifies P95 (not "average"), specific threshold (2s), and load condition (100 concurrent)
- NFR-SEC-001 specifies HTTP status code (401) and behavior (redirect) — not just "must be secure"
- NFR-PRIV-001 names the 3 specific PII fields — not just "personal data"
- NFR-DRET-001 specifies "5 years from appointment date" — exact period and starting point
- vague_nfrs_found is empty — no vague NFRs were drafted
- Each NFR has an acceptance_criterion that describes how to verify it
