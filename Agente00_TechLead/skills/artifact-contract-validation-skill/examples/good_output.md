# Artifact Contract Validation Skill — Good Output Example

_GOOD EXAMPLE — Gate 1 validation with complete per-criterion evidence._

## Input

```json
{
  "gate_number": 1,
  "handoff_package": {
    "artifact_produced": "PRD_v1.0.md",
    "summary": "Complete PRD for Enterprise Client Portal covering 8 epics, all user roles, and non-functional requirements. Acceptance criteria written in BDD format for all epics. Data model sketch included.",
    "assumptions": ["Single-tenant deployment initially", "Google OAuth as sole identity provider"],
    "open_questions": [
      { "question": "Should inactive users be soft-deleted or hard-deleted?", "blocking": false, "owner": "Product Owner" }
    ],
    "risks": [
      { "description": "Third-party OAuth provider outage", "severity": "MEDIUM", "mitigation": "Fallback to email/password auth in Phase 2" }
    ],
    "required_next_agent": "Agente02_SoftwareArchitect",
    "validation_checklist": [
      { "criterion": "All epics have BDD acceptance criteria", "status": "PASS" }
    ]
  }
}
```

## Output

```json
{
  "success": true,
  "validation_result": "PASS",
  "validation_table": [
    { "criterion": "PRD document present", "status": "PASS", "evidence": "PRD_v1.0.md submitted, 42 pages", "blocker": true },
    { "criterion": "All epics have BDD acceptance criteria", "status": "PASS", "evidence": "8 epics, each with Given/When/Then criteria — verified sections 3.1–3.8", "blocker": true },
    { "criterion": "Non-functional requirements with measurable thresholds", "status": "PASS", "evidence": "Section 5: P95 latency ≤ 300ms, 99.9% uptime, < 2s page load on 4G", "blocker": true },
    { "criterion": "Data model sketch present", "status": "PASS", "evidence": "ER diagram in Appendix A with 7 entities", "blocker": false },
    { "criterion": "Handoff package complete (all 7 fields)", "status": "PASS", "evidence": "All fields present and non-empty", "blocker": true }
  ],
  "issues_found": [],
  "conditions": [],
  "adr_required": false,
  "recommended_gate_status": "APPROVED"
}
```

## Why This is Good

- Every criterion evaluated individually with specific evidence
- Evidence cites document sections, page counts, and specific metrics
- No blanket approvals — each check is traceable
- `adr_required` correctly set to false (no Golden Path deviations detected)
- `recommended_gate_status` matches `validation_result`
- Blocker flag correctly set on critical criteria
