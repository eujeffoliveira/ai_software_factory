# Good Output — Data Classification Skill

```json
{
  "highest_tier": "CONFIDENTIAL",
  "restricted_human_signoff_required": false,
  "privacy_review_required": true,
  "data_classification_md_produced": true,
  "entities": [
    { "entity_name": "User.email", "classification": "CONFIDENTIAL", "pii_fields": ["email"], "regulatory_obligations": ["LGPD Art. 5(I)", "GDPR Art. 4(1)"] },
    { "entity_name": "User.displayName", "classification": "CONFIDENTIAL", "pii_fields": ["displayName"], "regulatory_obligations": ["LGPD Art. 5(I)"] },
    { "entity_name": "User.id", "classification": "INTERNAL", "pii_fields": [], "regulatory_obligations": [] },
    { "entity_name": "audit_log", "classification": "INTERNAL", "pii_fields": ["actorEmail (session-controlled)"], "regulatory_obligations": [] }
  ],
  "immediate_action": "PROCEED_WITH_PRIVACY_REVIEW"
}
```
