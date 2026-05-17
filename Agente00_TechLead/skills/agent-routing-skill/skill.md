# Agent Routing Skill

## Purpose
Determine which agent should receive control next, compose a valid briefing package, and update the State Ledger routing fields accordingly.

## When to Use
- After a gate is APPROVED or APPROVED_WITH_CONDITIONS
- After a gate is RETURNED_FOR_REVISION (route back to originating agent)
- After resolving a blocker that was pending human approval
- When the Tech Lead needs to delegate a specific sub-task to a specialist agent

## Inputs
- `current_phase` from State Ledger
- `gate_status` (APPROVED / APPROVED_WITH_CONDITIONS / RETURNED_FOR_REVISION)
- `gate_number` (1–7)
- `open_adrs` list (if any)
- `conditions` list (if APPROVED_WITH_CONDITIONS)
- `target_agent_override` (optional — for explicit delegation)

## Outputs
- `next_agent` — valid agent ID from the approved roster
- `agent_briefing` — complete Agent_Briefing following the schema
- `routing_rationale` — why this agent was selected
- `state_ledger_update` — fields to update: `next_agent`, `next_action`, `current_agent`

## Routing Table

| Gate | Status | Phase After | Next Agent |
|------|--------|-------------|------------|
| 1 | APPROVED | architecture | Agente02_SoftwareArchitect |
| 1 | RETURNED | requirements | Agente01_ProductOwner |
| 2 | APPROVED | planning | Agente03_TechLead (execution plan) |
| 2 | RETURNED | architecture | Agente02_SoftwareArchitect |
| 3 | APPROVED | implementation | Agente04_SoftwareDeveloper |
| 3 | RETURNED | planning | Agente03_TechLead |
| 4 | APPROVED | security | Agente06_SecurityReviewer |
| 4 | RETURNED | implementation | Agente04_SoftwareDeveloper |
| 5 | APPROVED | deployment | Agente07_DevOps |
| 5 | RETURNED | implementation | Agente04_SoftwareDeveloper |
| 6 | APPROVED | post-deploy | Agente08_PostDeployValidator |
| 6 | RETURNED | deployment | Agente07_DevOps |
| 7 | APPROVED | closed | — |

## Procedure

1. Identify `current_phase` and `gate_status`
2. Look up routing table — select `next_agent`
3. If `target_agent_override` provided, validate it is in the approved agent roster; use if valid
4. If APPROVED_WITH_CONDITIONS: include all conditions in briefing `constraints` section
5. If open ADRs exist: include ADR IDs in briefing `adrs_in_scope` section
6. Compose `Agent_Briefing` using `templates/Agent_Briefing.md`
7. Populate `golden_model_reminders` based on known risk patterns for the target phase
8. Return routing result + briefing + State Ledger update payload

## Quality Gate
Every routing output MUST name a specific valid agent ID. Empty or null `next_agent` is a hard failure.

## Failure Modes
- Unknown gate/status combination → escalate to human operator
- Target agent not in approved roster → reject override, use routing table default
- Gate APPROVED_WITH_CONDITIONS but conditions list empty → halt, request conditions from gate decision source

## RAG Authorized
- `factory_architecture` — agent roster and phase routing rules
- `project_state` — current State Ledger

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
