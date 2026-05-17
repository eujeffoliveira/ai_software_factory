# Progress Reporting Skill — Good Output Example

_GOOD EXAMPLE — EXECUTIVE report, project in QA phase._

## Output

```json
{
  "success": true,
  "health_status": "YELLOW",
  "key_metrics": {
    "gates_approved": 4,
    "gates_total": 7,
    "current_phase": "qa",
    "active_risks_critical": 0,
    "active_risks_high": 1,
    "active_risks_medium": 2,
    "open_questions_blocking": 1,
    "open_questions_total": 3,
    "pending_human_approvals": 0,
    "approved_artifacts": 4
  },
  "blocking_items": [
    {
      "type": "OPEN_QUESTION",
      "id": "Q-004",
      "description": "Inactive user handling (soft-delete vs hard-delete) — blocking QA test scenario design",
      "severity": "HIGH"
    },
    {
      "type": "RISK",
      "id": "RISK-002",
      "description": "Test environment data seeding incomplete — may delay QA completion",
      "severity": "HIGH"
    }
  ],
  "report": "# Enterprise Client Portal — Progress Report\n**Date:** 2026-05-17 | **Phase:** Quality Assurance | **Health:** 🟡 YELLOW\n\n## Executive Summary\nThe project is progressing well. Four of seven milestones have been completed, including product definition, system design, and the development plan. The system has been built and is currently in quality assurance testing.\n\n**What is on track:** The system is feature-complete. Automated test results are passing at 91% coverage.\n\n**What needs attention:** One open question about data retention policy (whether inactive users are deleted immediately or after a period) is delaying finalization of 3 test scenarios. This needs a business decision within 2 business days to avoid delaying the security review milestone.\n\n## Milestone Status\n| Milestone | Status |\n|-----------|--------|\n| Product Definition (Gate 1) | ✅ Complete |\n| System Design (Gate 2) | ✅ Complete |\n| Development Plan (Gate 3) | ✅ Complete |\n| Development Complete (Gate 4) | ✅ Complete |\n| Quality Assurance (Gate 5) | 🟡 In Progress |\n| Security Review (Gate 6) | ⏳ Pending |\n| Deployment (Gate 7) | ⏳ Pending |\n\n## Decision Needed\n**Data retention policy:** Should inactive users be soft-deleted (kept in system, marked inactive) or hard-deleted (removed after 90 days)? This affects user data compliance and needs a decision from the product owner by 2026-05-19.\n\n## Next Milestone\nQuality Assurance completion — expected by 2026-05-21, contingent on the data retention decision above."
}
```

## Why This is Good

- `health_status = YELLOW` — correct, there is an open HIGH risk and blocking question
- EXECUTIVE report uses plain language — no agent IDs, no stack names
- Blocking items in plain business terms ("data retention policy" not "Q-004 open_question.blocking=true")
- Key metrics sourced from State Ledger (not assumed)
- Milestone table uses ✅/🟡/⏳ for visual clarity
- "Decision Needed" section highlights exactly what human action is required
- `health_status` is consistent with `blocking_items` (no contradictions)
