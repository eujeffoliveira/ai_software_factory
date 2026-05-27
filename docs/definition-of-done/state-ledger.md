# Definition of Done — State_Ledger.json

## Overview

The State Ledger is the Tech Lead's source of truth for the current state of any project running through the factory pipeline. It tracks which gate the project is at, which artifacts are approved, which risks are open, which ADRs have been made, and what the next concrete action is. A State Ledger that is out of date or inconsistent is more dangerous than no ledger at all — it causes agents to act on false assumptions about what has been approved.

## Owner Agent

- **Primary:** `@techlead` (Agente00_TechLead)
- **Updated by:** All agents update their relevant sections via handoff packages; Tech Lead merges and approves

## Required Fields / Sections

### Project Identity
- [ ] `project_id` — unique identifier for this project
- [ ] `project_name` — human-readable name
- [ ] `project_archetype` — one of the 8 valid archetypes; must match the value in the approved PRD
- [ ] `golden_model` — path to the applicable Golden Model spec file
- [ ] `created_at` — ISO 8601 timestamp of ledger creation
- [ ] `last_updated_at` — ISO 8601 timestamp of most recent update (updated on every state change)
- [ ] `tech_lead` — name or identifier of the Tech Lead responsible for this project

### Current Phase
- [ ] `current_gate` — the gate the project is currently at or waiting for (e.g., `"gate_3"`, `"gate_5"`)
- [ ] `current_phase` is consistent with `approved_artifacts` — if `current_gate` is `"gate_4"`, then gates 1, 2, and 3 must all appear as `approved` in `approved_artifacts`
- [ ] `current_status` — one of: `in_progress`, `blocked`, `waiting_for_approval`, `approved`, `deployed`
- [ ] `blocking_reason` is populated if and only if `current_status` is `blocked`
- [ ] `blocking_reason` is null when `current_status` is not `blocked`

### Approved Artifacts
- [ ] `approved_artifacts` contains an entry for every gate that has been passed
- [ ] Each entry has: `gate`, `artifact_name`, `approved_at`, `approved_by`, `version`
- [ ] No gate appears as approved if the prerequisite gate is not also approved
- [ ] Gate A0 entry is present if the archetype required classification (and the project is not immediately obvious)
- [ ] The artifact version in each entry matches the version in the artifact file itself

### Gate History
- [ ] `gate_history` contains a complete chronological record of every gate submission and decision
- [ ] Each entry has: `gate`, `submitted_at`, `decision`, `decision_at`, `decision_by`, `notes`
- [ ] `RETURNED_FOR_REVISION` entries include the specific reason in `notes`
- [ ] `BLOCKED_*` entries include the specific blocking condition in `notes`
- [ ] No gaps in the gate history — every submission is recorded, not just approvals
- [ ] The most recent entry for each gate matches the `current_gate` and `current_status` fields

### Open Risks
- [ ] `open_risks` lists all risks that have been identified and not yet resolved
- [ ] Each risk has: `risk_id` (e.g., `RISK-001`), `description`, `severity` (Critical/High/Medium/Low), `probability` (High/Medium/Low), `impact` (High/Medium/Low), `owner`, `mitigation`, `status` (open/mitigated/accepted/resolved), `identified_at`
- [ ] No `Critical` risk has `status: open` without a mitigation plan
- [ ] No `High` risk has `status: open` at Gate 6 (must be mitigated or accepted before deployment)
- [ ] `status: accepted` risks have a written acceptance note from the Tech Lead
- [ ] Risk IDs are unique and sequential (`RISK-001`, `RISK-002`, ...)
- [ ] Risks resolved in a previous gate are moved to `resolved_risks` (not deleted)

### ADR Index
- [ ] `adrs` lists every Architecture Decision Record associated with this project
- [ ] Each entry has: `adr_id` (e.g., `ADR-001`), `title`, `status` (proposed/accepted/superseded/deprecated), `decided_at`, `file_path`
- [ ] No ADR in `proposed` status after Gate 2 — all architectural decisions must be resolved before implementation begins
- [ ] Superseded ADRs reference the ADR that replaced them
- [ ] ADR IDs are unique and sequential

### MCP Status
- [ ] `mcp_status` field is populated with the current state of the MCP Knowledge Server
- [ ] `mcp_status.healthy` is `true` if the factory's MCP Knowledge Search is operational
- [ ] `mcp_status.last_checked` is populated with an ISO 8601 timestamp
- [ ] `mcp_status.knowledge_db_version` matches the installed `knowledge.db`
- [ ] If `mcp_status.healthy` is `false`, `mcp_status.error` describes the failure and `blocking` is `true`

### Next Action
- [ ] `next_action` is populated with a single, specific, actionable instruction
- [ ] `next_action.agent` identifies the specific agent responsible
- [ ] `next_action.action` is a concrete instruction, not a vague directive ("Implement `createTask` Server Action in `features/tasks/actions/createTask.ts`" not "continue implementation")
- [ ] `next_action.deadline` is populated if the action has a time constraint
- [ ] `next_action` is updated every time the ledger changes state
- [ ] `next_action` is never left stale — if a gate was just approved, `next_action` already points to the next gate's agent and task

### Handoff Package References
- [ ] `handoff_packages` lists the path to every handoff package received from each agent
- [ ] Each entry has: `agent`, `gate`, `received_at`, `path`
- [ ] Handoff packages are not deleted when superseded — the history is retained

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| `current_gate` matches `approved_artifacts` | Read `current_gate` value; count entries in `approved_artifacts`; if `current_gate` is `"gate_N"`, then gates 1 through N-1 must all be approved |
| No gaps in gate history | Count unique gate values in `gate_history`; every gate from 1 to the current gate must have at least one entry |
| No `RETURNED_FOR_REVISION` entries without notes | Read each return entry; `notes` field must be non-empty |
| No open Critical risks without mitigation | Filter `open_risks` by severity `Critical` and status `open`; count must be zero unless mitigation is described |
| No `proposed` ADRs after Gate 2 | Filter `adrs` by status `proposed`; if `current_gate` > `gate_2`, count must be zero |
| `next_action.agent` is specific | Value must be a valid agent ID (e.g., `"Agente04_DevBackend"`), not a generic role name |
| `last_updated_at` is current | Timestamp must be within the current working session; a stale timestamp indicates the ledger was not updated after the last action |
| All risk IDs are unique | Extract all `risk_id` values; no duplicates |

## Related Gates

- **Maintained throughout:** All gates from A0 through Gate 7
- **Critical at:** Gate 6 (all risks must be resolved or accepted before deployment)
- **Audited by:** Tech Lead before every gate decision; the ledger must be consistent before `APPROVED` is issued

## Failure Examples

- **FAIL:** `current_gate` is `"gate_5"` but `approved_artifacts` shows Gate 4 as not yet approved. The ledger is inconsistent — the pipeline cannot be at Gate 5 without Gate 4 approval.
- **FAIL:** `RISK-003` has severity `Critical` and status `open` with no mitigation field. This is a pipeline blocker — Critical risks cannot be left without a mitigation plan.
- **FAIL:** A `RETURNED_FOR_REVISION` entry in `gate_history` for Gate 2 has `notes: ""`. The Tech Lead cannot verify what the issue was or whether it was resolved.
- **FAIL:** `next_action.action` reads "continue with implementation." This is not actionable — which implementation, which agent, which file, which function?
- **FAIL:** `ADR-002` has status `proposed` and `current_gate` is `"gate_4"`. No implementation should proceed when an architectural decision is unresolved.
- **FAIL:** `last_updated_at` shows a timestamp from 3 days ago but the gate history shows a Gate 3 approval from today. The ledger was not updated after the approval.
- **FAIL:** `mcp_status` is absent from the ledger. The Tech Lead cannot confirm whether agents have access to the knowledge base.

## When to Block

The Tech Lead must not issue `APPROVED` for any gate when:
- `current_gate` is inconsistent with `approved_artifacts`
- Any `Critical` risk has status `open` without a mitigation plan
- Any ADR is in `proposed` status and `current_gate` >= `gate_3`
- `next_action` is stale (not updated to reflect the current gate decision)
- `gate_history` is missing an entry for the gate being evaluated

At Gate 6, additionally block when:
- Any `High` risk has status `open` (must be mitigated or formally accepted)
- Any ADR is `proposed` or `superseded` without a replacement

The ledger must be updated atomically with the gate decision — approval and ledger update happen together, not as separate steps.
