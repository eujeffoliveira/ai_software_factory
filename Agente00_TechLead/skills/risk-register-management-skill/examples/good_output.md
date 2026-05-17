# Risk Register Management Skill — Good Output Example

_GOOD EXAMPLE — ADD operation: registering a new CRITICAL security risk._

## Output

```json
{
  "success": true,
  "risk_id": "RISK-003",
  "updated_risks": [
    {
      "id": "RISK-001",
      "description": "Third-party OAuth provider (Google) outage",
      "severity": "MEDIUM",
      "likelihood": "LOW",
      "category": "EXTERNAL",
      "status": "MITIGATED",
      "mitigation": "Email/password fallback planned for Phase 2. Acceptable for Phase 1 pilot.",
      "owner": "Agente02_SoftwareArchitect",
      "reported_by": "Agente01_ProductOwner",
      "reported_at": "2026-05-10T09:00:00Z"
    },
    {
      "id": "RISK-002",
      "description": "Prisma migration rollback complexity in production",
      "severity": "HIGH",
      "likelihood": "MEDIUM",
      "category": "OPERATIONAL",
      "status": "MITIGATED",
      "mitigation": "All migrations reversible by design (no DROP statements in v1). Rollback runbook documented in deploy plan.",
      "owner": "Agente07_DevOps",
      "reported_by": "Agente00_TechLead",
      "reported_at": "2026-05-14T11:00:00Z"
    },
    {
      "id": "RISK-003",
      "description": "Row Level Security (RLS) misconfiguration could expose cross-tenant data",
      "severity": "CRITICAL",
      "likelihood": "MEDIUM",
      "category": "SECURITY",
      "status": "OPEN",
      "mitigation": "Supabase RLS policies must be reviewed by Agente06_SecurityReviewer before Gate 5. Automated RLS policy tests added to test suite.",
      "owner": "Agente06_SecurityReviewer",
      "reported_by": "Agente02_SoftwareArchitect",
      "reported_at": "2026-05-17T16:30:00Z"
    }
  ],
  "escalation_required": false,
  "state_ledger_update": {
    "risks": "<<full updated_risks array above>>"
  }
}
```

## Why This is Good

- RISK-ID assigned sequentially (RISK-003 after RISK-001 and RISK-002)
- CRITICAL risk has a mitigation documented — `escalation_required = false`
- Mitigation is specific: names the reviewing agent, names the gate, names the automated test
- All existing risks retained in `updated_risks` — no data loss
- `state_ledger_update` ready to apply
- Each risk has: id, description, severity, likelihood, category, status, mitigation, owner, reported_by, reported_at
