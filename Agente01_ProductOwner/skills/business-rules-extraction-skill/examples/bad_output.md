# Business Rules Extraction Skill — Bad Output Example

_BAD EXAMPLE — Invented rules, technical decisions disguised as rules, no sources. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "artifact_path": "project/Business_Rules.md",
  "technical_decisions_found": [],
  "statements_without_rules": [],
  "pending_rules": [],
  "confirmed_rules": [
    {
      "id": "BR-001",
      "description": "Users must authenticate using OAuth 2.0 and JWT tokens with a 30-minute expiry.",
      "source": "Best practices",
      "applies_to": ["US-001"],
      "exceptions": "None"
    },
    {
      "id": "BR-002",
      "description": "The system must validate all inputs using server-side validation before processing.",
      "source": "Security standards",
      "applies_to": ["US-001", "US-002", "US-003"],
      "exceptions": "None"
    },
    {
      "id": "BR-003",
      "description": "Appointments can be cancelled at any time before the start time.",
      "source": "Assumed",
      "applies_to": ["US-003"],
      "exceptions": "None"
    }
  ]
}
```

<!-- PROBLEMA 1: BR-001 "OAuth 2.0 and JWT tokens with 30-minute expiry" — this is a technical implementation decision (authentication mechanism, token type, session expiry strategy). This belongs in the Architecture phase, not as a product business rule. Source "Best practices" is not a stakeholder statement. technical_decisions_found should contain this, not confirmed_rules.
     PROBLEMA 2: BR-002 "server-side validation" — another technical implementation decision. "Server-side vs client-side validation" is an architectural choice. "Input validation is required" might be a loose requirement, but the mechanism is the Architect's domain. Source "Security standards" is not a traceable source.
     PROBLEMA 3: BR-003 source is "Assumed" — rules cannot be confirmed if they were assumed, not stated by a stakeholder. This rule contradicts BR-001 (which should have been the 24-hour cancellation window rule). Creating a rule "cancellations allowed at any time" without stakeholder confirmation introduces a business policy that was never agreed upon.
     PROBLEMA 4: pending_rules is empty — BR-003 should be a pending rule with an OQ-NNN, not a confirmed rule.
     PROBLEMA 5: technical_decisions_found is empty — but BR-001 and BR-002 are clearly technical decisions. The skill failed to identify them as such.
     PROBLEMA 6: statements_without_rules is empty — but "Best practices" and "Security standards" are not stakeholder statements. The input data appears to have been fabricated, not extracted from a real interview log. -->
