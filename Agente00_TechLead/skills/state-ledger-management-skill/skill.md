# State Ledger Management Skill

## Purpose
Create, update, validate, summarize, and detect inconsistencies in the project State Ledger.

## When to Use
- Project initialization
- After every gate decision
- After every agent handoff
- When registering a risk, ADR, open question, or human approval
- When generating a progress report
- When resolving a blocked task

## Inputs
- Operation: CREATE | UPDATE | VALIDATE | SUMMARIZE | DETECT_INCONSISTENCY
- Current `State_Ledger.json` (if exists)
- Update payload (gate decision, risk, ADR, question, decision, approval)

## Outputs
- Updated `State_Ledger.json` — conforms to `schemas/State_Ledger.json`. Required fields and types:
  - `project_name` (string), `project_id` (string, UUID)
  - `created_at`, `updated_at` (ISO 8601 datetime)
  - `current_phase` (enum: `requirements` | `architecture` | `planning` | `implementation` | `security` | `deployment` | `post-deploy` | `closed`)
  - `current_agent` (string, valid agent ID from approved roster)
  - `next_agent` (string, valid agent ID or empty string if phase is `closed`)
  - `approved_artifacts` (object with boolean fields: `prd`, `architecture`, `execution_plan`, `qa`, `security`, `deployment`, `post_deploy`)
  - `gate_history` (array of gate decision records), `risks` (array), `adrs` (array), `open_questions` (array), `decisions` (array), `human_approvals_required` (array)
- Validation report (if VALIDATE operation)
- Summary text (if SUMMARIZE operation)
- Inconsistency report (if DETECT_INCONSISTENCY operation)

## Procedure

### CREATE
1. Use template from `templates/State_Ledger.json`
2. Set `project_name`, `project_id`, `created_at`, `updated_at`
3. Set `current_phase = "requirements"`
4. Set `current_agent = "Agente00_TechLead"`, `next_agent = "Agente01_ProductOwner"`
5. Initialize all arrays as empty
6. Set `approved_artifacts` all false
7. Set `next_action` = "Route to Agente01_ProductOwner with initial briefing"

### UPDATE
1. Load current State Ledger
2. Apply the specific update (add to array, change field)
3. Set `updated_at` = current timestamp
4. Verify consistency after update (see DETECT_INCONSISTENCY)
5. Write updated State Ledger

### VALIDATE
1. Check all required fields exist
2. Check `current_phase` enum is valid
3. Check `current_agent` and `next_agent` are valid agent IDs
4. Check `approved_artifacts` is consistent with gate_history
5. Check all CRITICAL risks have escalation or mitigation
6. Report any violations

### SUMMARIZE
1. Report current phase and active agent
2. List approved artifacts
3. List open questions (focus on blocking ones)
4. List active risks (focus on HIGH and CRITICAL)
5. List pending human approvals
6. State next action

### DETECT_INCONSISTENCY
- Phase is "deploy" but `approved_artifacts.prd` has **never been set to true** in `gate_history` (i.e., no Gate 1 with status APPROVED or APPROVED_WITH_CONDITIONS exists) → INCONSISTENCY. A prior Gate 1 APPROVED satisfies the prd requirement even if `approved_artifacts.prd` was later toggled.
- `next_agent` is empty → INCONSISTENCY
- CRITICAL risk with no escalation or mitigation → INCONSISTENCY
- Gate history missing for completed phases → INCONSISTENCY
- `updated_at == created_at` after activity → INCONSISTENCY

## Quality Gate
State Ledger must always reflect actual project state. Never leave it outdated.

## Failure Modes
- File missing → initialize from template, log warning
- Inconsistency detected → halt update, report inconsistency to operator

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
