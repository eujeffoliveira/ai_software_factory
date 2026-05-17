# Scope Boundary Skill — Good Output Example

_GOOD EXAMPLE — Scope definition for an Appointment Management System with 5 in-scope and 4 out-of-scope features._

---

## Output JSON

```json
{
  "artifact_path": "project/Scope_Boundary.md",
  "scope_checklist_passed": true,
  "features_without_coverage": [],
  "in_scope": [
    {
      "feature_name": "Client Self-Booking",
      "description": "Public booking interface for clients to select a service, date, and time slot without requiring an account",
      "related_stories": ["US-001"]
    },
    {
      "feature_name": "Staff Schedule Management",
      "description": "Interface for staff members to view their daily schedule and block unavailable time slots",
      "related_stories": ["US-002", "US-004"]
    },
    {
      "feature_name": "Appointment Cancellation",
      "description": "Mechanism for clients to cancel appointments via confirmation link within the allowed 24-hour window",
      "related_stories": ["US-003"]
    },
    {
      "feature_name": "Email Notifications",
      "description": "Automated email confirmation and cancellation notifications sent to clients",
      "related_stories": ["US-001", "US-003"]
    },
    {
      "feature_name": "Administrator Dashboard",
      "description": "View and reporting interface for the business administrator to monitor appointment volumes",
      "related_stories": ["US-005"]
    }
  ],
  "out_of_scope": [
    {
      "feature_name": "Payment Processing",
      "reason_for_exclusion": "Insufficient business case for v1: payment is handled in-person. Integrating a payment provider adds regulatory and PCI-DSS scope beyond the immediate scheduling problem.",
      "future_scope": "yes"
    },
    {
      "feature_name": "SMS Notifications",
      "reason_for_exclusion": "Deferred pending stakeholder decision on OQ-001. Email-only is confirmed sufficient for v1.",
      "future_scope": "yes"
    },
    {
      "feature_name": "Multi-Location Management",
      "reason_for_exclusion": "Single-location confirmed by Business Owner (Session 1). Multi-location introduces location-based routing, cross-location scheduling rules, and additional admin complexity not needed for v1.",
      "future_scope": "yes"
    },
    {
      "feature_name": "Mobile Native Application",
      "reason_for_exclusion": "Web application sufficient for v1 confirmed by Operations Manager. Native app development doubles delivery scope and timeline.",
      "future_scope": "yes"
    }
  ]
}
```

## Why This is Good

- All 5 in-scope features link to user stories (complete traceability)
- 4 out-of-scope items, each with a specific and substantive reason
- "Out of scope" reasons are not just "not in scope" — each explains the business rationale
- features_without_coverage is empty — every discussed feature is placed
- scope_checklist_passed is true
- Future scope noted as "yes" for all 4 exclusions — helps Architect design for extensibility
