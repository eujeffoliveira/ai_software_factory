# Good Output: accessibility-check-skill

```json
{
  "reviewed_files": ["features/entities/components/DeleteButton.tsx"],
  "review_date": "2026-05-17",
  "wcag_aa_compliant": true,
  "issues": [
    {
      "id": "A11Y-001",
      "file": "features/entities/components/DeleteButton.tsx",
      "severity": "HIGH",
      "wcag_criterion": "4.1.2 Name, Role, Value",
      "description": "Button contains only a trash icon SVG with no accessible name. Screen readers will announce 'button' with no context.",
      "current_code": "<button onClick={handleDelete}><TrashIcon /></button>",
      "corrected_code": "<button onClick={handleDelete} aria-label={`Delete ${entity.name}`}><TrashIcon aria-hidden=\"true\" /></button>",
      "status": "fixed"
    }
  ],
  "summary": { "total_issues": 1, "critical_count": 0, "high_count": 1, "fixed_count": 1, "open_count": 0 },
  "gate_4_status": "READY_FOR_QA"
}
```
