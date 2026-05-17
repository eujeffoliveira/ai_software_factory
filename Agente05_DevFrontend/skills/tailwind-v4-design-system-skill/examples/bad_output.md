# Bad Output: tailwind-v4-design-system-skill

```json
{
  "design_token_compliant": true,
  "violations_found": 0,
  "violations_fixed": 0
}
```

But the component still contains:
```tsx
<div style={{ backgroundColor: "#3b82f6" }}>
<p className="text-gray-700">
```

This is a false "compliant" report. The skill failed to find violations that exist. The result: these violations reach Gate 4 and cause `BLOCKED_DESIGN_SYSTEM_VIOLATION`. The skill must scan thoroughly, not just report clean to move on.
