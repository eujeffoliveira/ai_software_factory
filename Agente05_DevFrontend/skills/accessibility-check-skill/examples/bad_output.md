# Bad Output: accessibility-check-skill

```json
{
  "reviewed_files": ["features/entities/components/DeleteButton.tsx"],
  "review_date": "2026-05-17",
  "wcag_aa_compliant": true,
  "issues": [],
  "gate_4_status": "READY_FOR_QA"
}
```

But the component has: `<button onClick={handleDelete}><TrashIcon /></button>` — icon button with no aria-label (WCAG 4.1.2 HIGH violation). The skill reported "no issues" without actually auditing. This false clean report allows an accessibility violation to reach Gate 4, resulting in `BLOCKED_ACCESSIBILITY_FAILURE` from the QA Engineer.
