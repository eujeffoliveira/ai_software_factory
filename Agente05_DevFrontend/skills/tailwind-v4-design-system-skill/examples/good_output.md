# Good Output: tailwind-v4-design-system-skill

```json
{
  "design_token_compliant": true,
  "violations_found": 2,
  "violations_fixed": 2,
  "violations": [
    {
      "file": "features/entities/components/EntityCard.tsx",
      "type": "non_token_class",
      "original": "text-gray-600",
      "replacement": "text-[var(--muted-foreground)]",
      "fixed": true
    },
    {
      "file": "features/entities/components/EntityCard.tsx",
      "type": "hardcoded_color",
      "original": "style={{ borderColor: '#e5e7eb' }}",
      "replacement": "className=\"border-[var(--border)]\"",
      "fixed": true
    }
  ]
}
```
