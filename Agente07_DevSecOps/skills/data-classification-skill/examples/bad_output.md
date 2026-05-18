# Bad Output — Data Classification Skill

```json
{
  "highest_tier": "INTERNAL",
  "restricted_human_signoff_required": false,
  "privacy_review_required": false,
  "entities": [
    { "entity_name": "User", "classification": "INTERNAL" }
  ]
}
```

**Problems:** Classified the entire `User` table as INTERNAL — missed that `User.email` and `User.displayName` are CONFIDENTIAL (PII fields). Must classify at the FIELD level, not just the table level. `User.email` is directly identifying PII under LGPD/GDPR → CONFIDENTIAL. This error would cause privacy-review-skill to be skipped entirely, resulting in a privacy violation being missed at Gate 5.
