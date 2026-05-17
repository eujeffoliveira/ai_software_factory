# Scope Boundary Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "artifact_path": "project/Scope_Boundary.md",
  "scope_checklist_passed": true,
  "features_without_coverage": [],
  "in_scope": [
    {
      "feature_name": "Everything the system should do",
      "description": "All scheduling features",
      "related_stories": []
    }
  ],
  "out_of_scope": []
}
```

<!-- PROBLEMA 1: "Everything the system should do" is not a feature name — it is a placeholder that communicates nothing. Feature names must be specific (e.g., "Client Self-Booking", "Staff Schedule Management").
     PROBLEMA 2: "All scheduling features" is not a description — it is circular. What specific capabilities are included?
     PROBLEMA 3: related_stories is empty — no user stories are linked. This makes the scope boundary unusable for traceability.
     PROBLEMA 4: out_of_scope is empty — a scope boundary with no exclusions is almost always wrong and is a strong indicator that the scope was not analyzed. What about payment processing? Mobile apps? Reporting? These are commonly discussed features that need explicit exclusion.
     PROBLEMA 5: scope_checklist_passed = true despite empty out_of_scope list — scope_boundary_checklist.md was not run (it explicitly requires out_of_scope to be non-empty).
     PROBLEMA 6: features_without_coverage = [] — but since in_scope has only one vague item and out_of_scope is empty, every specific feature from the input is effectively without coverage. The flag is false.
     
     CONSEQUENCE: The Architect and development team have no guidance on what is excluded. Any feature not explicitly excluded will be assumed in-scope. This leads to scope creep, where developers implement payment processing, mobile apps, and multi-location management because they were never told not to. -->
