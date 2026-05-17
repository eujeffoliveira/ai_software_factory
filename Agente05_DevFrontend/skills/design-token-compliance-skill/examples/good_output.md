# Good Output: design-token-compliance-skill

```json
{
  "design_token_compliant": true,
  "violations_found": 1,
  "violations_fixed": 1,
  "gate_4_status": "READY_FOR_QA",
  "violations": [
    {
      "file": "features/projects/components/ProjectCard.tsx",
      "type": "non_token_class",
      "severity": "HIGH",
      "original": "text-gray-500",
      "replacement": "text-[var(--muted-foreground)]",
      "fixed": true
    }
  ]
}
```
