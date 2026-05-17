# Bad Output: design-token-compliance-skill

```json
{
  "design_token_compliant": true,
  "violations_found": 0,
  "gate_4_status": "READY_FOR_QA",
  "violations": []
}
```

But the actual component contains:
- `style={{ backgroundColor: "#3b82f6" }}` — inline style with hex color (CRITICAL)
- `className="text-gray-700 bg-white"` — palette colors (HIGH)

False clean report. These violations reach Gate 4 → `BLOCKED_DESIGN_SYSTEM_VIOLATION`. The skill must exhaustively scan for all violation patterns.
