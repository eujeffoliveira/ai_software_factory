# Product Risk Analysis Skill — Bad Output Example

_BAD EXAMPLE — Technical risks instead of product risks, missing mitigations. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "artifact_path": "project/Product_Risks.md",
  "critical_count": 0,
  "technical_risks_excluded": [],
  "risks": [
    {
      "id": "PRISK-001",
      "description": "The database might not handle the load.",
      "category": "data",
      "impact": "HIGH",
      "probability": "MEDIUM",
      "mitigation": "Use a good database.",
      "contingency": null,
      "owner": "Developer",
      "status": "Open"
    },
    {
      "id": "PRISK-002",
      "description": "The React components might be slow.",
      "category": "user",
      "impact": "MEDIUM",
      "probability": "LOW",
      "mitigation": "Optimize the code.",
      "contingency": null,
      "owner": "Developer",
      "status": "Open"
    }
  ]
}
```

<!-- PROBLEMA 1: PRISK-001 "The database might not handle the load" — this is a technical architecture risk, not a product risk. Whether a specific database technology handles load is the Architect's concern. This should be in technical_risks_excluded and routed to the Architect, not in product risks.
     PROBLEMA 2: PRISK-001 mitigation "Use a good database" — not actionable. What constitutes "good"? This is not a mitigation strategy.
     PROBLEMA 3: PRISK-002 "React components might be slow" — a specific frontend technology risk. React is an implementation detail. The product risk would be: "Risk that the schedule view loads too slowly for staff members to trust it as their daily reference, leading to continued use of alternative tools." THAT is a product risk. Whether the implementation uses React optimally is not.
     PROBLEMA 4: PRISK-002 mitigation "Optimize the code" — not actionable. What aspect of code? Against what benchmark? "Optimize" without a target metric is meaningless.
     PROBLEMA 5: critical_count = 0 but PRISK-001 is HIGH×MEDIUM — priority is HIGH, which should surface in critical tracking.
     PROBLEMA 6: technical_risks_excluded is empty — but PRISK-001 and PRISK-002 are clearly technical risks. The skill failed to categorize them correctly and included them in product risks instead.
     PROBLEMA 7: Owner "Developer" — developers do not own product risks. Product risks are owned by Product Owner, Tech Lead, or a specific stakeholder role.
     
     CONSEQUENCE: These "product risks" provide no useful product-level guidance. The actual product risks — user adoption, scope creep, email deliverability — were not identified at all. The Architect will receive no useful signal from this risk register. -->
