# Human Escalation Skill — Good Output Example

_GOOD EXAMPLE — Gate 6 production deployment approval escalation._

## Output

```json
{
  "success": true,
  "pipeline_halt": true,
  "escalation_request": {
    "urgency": "HIGH",
    "context": "Enterprise Client Portal v1.0 has passed Gate 5 (Security Review). All automated checks are green: 94% unit test coverage, 0 critical security findings, deploy runbook reviewed. This is the first production deployment of the system. Gate 6 requires explicit human approval before production deploy proceeds.",
    "decision_required": "Approve production deployment of Enterprise Client Portal v1.0 to Vercel production environment?",
    "options": [
      {
        "label": "Option A: Deploy now",
        "description": "Proceed with full production deployment immediately",
        "pros": ["Delivers value to users today", "All automated checks passed", "Deploy runbook is complete"],
        "cons": ["Off-hours rollback would require on-call engineer", "No canary period"],
        "risk": "LOW"
      },
      {
        "label": "Option B: Deploy during business hours tomorrow",
        "description": "Schedule deployment for 10:00 AM local time with team standing by",
        "pros": ["Full team available for any issues", "Rollback team present", "Lower stress deployment"],
        "cons": ["24-hour delay in value delivery"],
        "risk": "LOW"
      },
      {
        "label": "Option C: Canary deployment (10% traffic)",
        "description": "Deploy to 10% of users first, monitor for 24h, then full rollout",
        "pros": ["Lowest blast radius if issues appear", "Real user validation before full rollout"],
        "cons": ["More complex deployment pipeline", "48h delay to full rollout"],
        "risk": "LOW"
      }
    ],
    "tech_lead_recommendation": {
      "recommended_option": "Option B: Deploy during business hours tomorrow",
      "rationale": "All signals are green, so the system is ready. Business hours deployment is a low-risk default for first production deploys — the team can respond to any unexpected issues in real time. Canary is unnecessary overhead given the small initial user base (< 200 users in pilot)."
    },
    "impact_of_delay": "Gate 6 is blocked until approval received. Agente07_DevOps cannot execute the deploy runbook. No user impact — system is not yet live. Pilot users are expecting access by end of week.",
    "blocking": {
      "gate": 6,
      "next_agent": "Agente07_DevOps",
      "unblock_condition": "Human approves one of the three options above"
    }
  },
  "state_ledger_update": {
    "human_approvals_required": [
      {
        "id": "APPROVAL-001",
        "type": "production_deploy",
        "description": "Gate 6 production deployment approval",
        "urgency": "HIGH",
        "requested_at": "2026-05-17T16:00:00Z",
        "status": "PENDING"
      }
    ]
  }
}
```

## Why This is Good

- `pipeline_halt = true` — correctly halts pipeline
- Options are meaningfully different (now vs. tomorrow vs. canary)
- Each option has ≥2 pros, ≥1 con, and a risk level
- Tech Lead recommendation is specific and has a concrete rationale
- `impact_of_delay` quantifies what is blocked without being alarmist
- `blocking.unblock_condition` is specific and actionable
- `state_ledger_update` ready to append to human_approvals_required
