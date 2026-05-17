# Agent Routing Skill — Good Output Example

_GOOD EXAMPLE — Gate 1 APPROVED, routing to Agente02_SoftwareArchitect._

## Input

```json
{
  "current_phase": "requirements",
  "gate_status": "APPROVED",
  "gate_number": 1,
  "open_adrs": [],
  "conditions": []
}
```

## Output

```json
{
  "success": true,
  "next_agent": "Agente02_SoftwareArchitect",
  "routing_rationale": "Gate 1 APPROVED — PRD validated. Per routing table, Gate 1 APPROVED routes to Agente02_SoftwareArchitect to begin architecture phase.",
  "agent_briefing": {
    "target_agent": "Agente02_SoftwareArchitect",
    "task": "Design system architecture for Enterprise Client Portal based on the approved PRD",
    "inputs": [
      "PRD_v1.0.md — Gate 1 APPROVED",
      "State_Ledger.json — current project state",
      "context_view.md — Golden Model tech stack constraints"
    ],
    "expected_outputs": [
      "Architecture_Document.md",
      "API_Contract.json",
      "DB_Schema.sql or Prisma schema",
      "ADR_Register.md (if any Golden Path deviations)"
    ],
    "constraints": [
      "Tech stack must follow Golden Model: Next.js 16, Prisma 7, Supabase/PostgreSQL, Vercel",
      "Use proxy.ts (NOT middleware.ts) in Next.js 16",
      "All migrations via prisma migrate dev (dev) or prisma migrate deploy (staging/prod)",
      "No architecture decisions deviating from Golden Model without an approved ADR"
    ],
    "golden_model_reminders": [
      "App Router only — no Pages Router",
      "Server Components by default; Client Components only when needed",
      "Supabase Row Level Security (RLS) must be enabled on all tables",
      "All jobs must be idempotent (upsert patterns)"
    ],
    "adrs_in_scope": [],
    "gate_target": 2,
    "escalation_policy": "Escalate to Agente00_TechLead for any scope expansion, irreversible architectural decision, or Golden Model deviation not covered by existing ADRs"
  },
  "state_ledger_update": {
    "next_agent": "Agente02_SoftwareArchitect",
    "current_agent": "Agente00_TechLead",
    "next_action": "Route Agent_Briefing to Agente02_SoftwareArchitect — begin architecture phase targeting Gate 2",
    "current_phase": "architecture"
  }
}
```

## Why This is Good

- `next_agent` is a specific valid agent ID
- `routing_rationale` cites the routing table rule explicitly
- Briefing has all required fields including `golden_model_reminders`
- `constraints` references concrete Golden Model rules
- `gate_target` tells the receiving agent which gate they are building toward
- `state_ledger_update` advances `current_phase` to "architecture"
