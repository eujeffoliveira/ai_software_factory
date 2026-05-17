# Council Mediation Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Output (WRONG)

```json
{
  "success": true,
  "persona_analyses": {
    "contrarian": { "analysis": "This is risky." },
    "first_principles": { "analysis": "Keep it simple." }
  },
  "consensus": ["Everyone agrees Redis is fine"],
  "recommendation": {
    "option": "Use Redis",
    "rationale": "The team likes Redis and it should work."
  },
  "one_thing_to_do_first": "Start coding",
  "requires_human_decision": false
}
```

## Violations

- Only 2 of 5 required personas present (Expansionist, Outsider, Executor missing)
- Both persona analyses are single sentences — not analyses, not citing the options
- `preferred_option` absent from both personas
- `concerns` and `core_tradeoff` fields missing from persona objects
- Consensus says "everyone agrees" but only 2 personas analyzed — cannot establish consensus
- No `clashes` field — disagreements between personas not surfaced
- No `blind_spots` field — blind spot analysis skipped
- Recommendation rationale is "the team likes it" — not valid reasoning
- `safeguards` absent from recommendation — no risk mitigations documented
- `one_thing_to_do_first` is "Start coding" — not specific, not tied to the decision
- `requires_human_decision = false` despite incomplete deliberation

## What Should Have Happened

- All 5 personas must complete their analysis — none can be skipped
- Each persona must evaluate all options, not just express a vague opinion
- Consensus must cite 3+ personas agreeing on specific points
- Clashes must name the personas and describe the specific disagreement
- Blind spots must identify gaps not covered by any option
- Recommendation must cite vote count and primary justification
- Safeguards must be concrete and tied to the decision's risks
- `one_thing_to_do_first` must be a single, specific, immediately actionable step
