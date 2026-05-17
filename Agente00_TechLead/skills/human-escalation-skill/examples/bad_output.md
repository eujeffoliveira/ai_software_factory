# Human Escalation Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Output (WRONG)

```json
{
  "success": true,
  "pipeline_halt": false,
  "escalation_request": {
    "urgency": "LOW",
    "context": "We need approval for the deploy.",
    "decision_required": "What should we do?",
    "options": [
      { "label": "Deploy", "description": "Deploy the app" }
    ],
    "tech_lead_recommendation": {
      "recommended_option": "whatever works",
      "rationale": "I'm not sure"
    }
  }
}
```

## Violations

- `pipeline_halt = false` — CRITICAL violation; pipeline must always halt during human escalation
- `urgency = LOW` — production deployment approval is always HIGH urgency at minimum
- `context` is 6 words — does not explain project state, what decision is needed, or why it cannot be made autonomously
- `decision_required` is "What should we do?" — not a specific, answerable question
- Only 1 option provided — minimum is 2
- The single option has no `pros`, `cons`, or `risk` fields — human has no basis for decision
- `tech_lead_recommendation.recommended_option` is "whatever works" — not a specific option
- `tech_lead_recommendation.rationale` is "I'm not sure" — not a valid rationale; Tech Lead must have a position
- `impact_of_delay` field absent — human cannot assess urgency
- `blocking` field absent — human doesn't know what is blocked or the unblock condition
- `state_ledger_update` absent — escalation will not be tracked

## What Should Have Happened

- Set `pipeline_halt = true` — non-negotiable
- Set appropriate urgency: HIGH for production deployment
- Write context explaining full project state (what system, what gate, what checks passed)
- Write specific decision_required question (approve/reject/schedule)
- Provide 2–4 meaningful options each with pros, cons, risk
- State a specific recommendation with concrete rationale
- Include impact_of_delay and blocking fields
- Return state_ledger_update for human_approvals_required
