# Skill: context-window-risk-analysis-skill
## Agente03 Software Engineer / Task Planner

---

## Purpose

Performs a full-plan analysis of context window exhaustion risks. Produces a risk report with per-task risk scores, an aggregated plan-level risk level, and mitigation recommendations. Ensures no dev agent receives a task that would require more context than they can hold in one session.

---

## When to Use

- After all tasks are defined and sized
- As the final validation step before Gate 3 submission
- When a task is suspected of having hidden complexity
- After any plan revision that adds or modifies tasks

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| execution_plan | Yes | Full Execution_Plan.json object |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| plan_id | Reference to the analyzed plan |
| risk_level | Overall plan risk (LOW/MEDIUM/HIGH/CRITICAL) |
| xl_tasks[] | List of XL tasks (must be empty) |
| l_tasks_flagged[] | List of L tasks with risk annotations |
| risk_factors[] | Per-task risk factors, scores, and recommendations |
| overall_recommendation | Human-readable recommendation for the plan |
| gate_ready | false if risk_level is CRITICAL |

Schema: `output.schema.json`

---

## Risk Scoring (Per Task)

Each task is scored based on the following risk factors. Sum the factors to get the task's risk score.

| Risk Factor | Score | Condition |
|------------|-------|-----------|
| Complexity L | +2 | estimated_complexity == "L" |
| Complexity XL | +4 | estimated_complexity == "XL" |
| Many function signatures | +1 | function_signatures.length > 5 |
| Long dependency chain | +2 | depends_on.length > 5 |
| Missing file_path | +3 | file_path is null or empty |
| No pre-specified signatures (M+ task) | +1 | complexity M or L + function_signatures empty |
| References >3 existing files in context | +2 | description implies reading many files |
| No context_summary on L task | +1 | complexity L + no context_summary field |

**Risk Score → Risk Level (per task):**
- 0–2: none/low
- 3–4: medium
- 5–7: high
- 8+: critical

**Plan-Level Risk = highest individual task risk level.**

---

## Mitigations

| Risk | Recommended Mitigation |
|------|------------------------|
| XL task | Split into 2+ tasks (required — DR001) |
| L task without context_summary | Add `context_summary` field to the task object. Required format: 150–200 words of plain text summarizing: (1) which existing files must be read before starting, (2) key types and interfaces the implementation must conform to, (3) external dependencies or side effects the task produces. |
| No pre-specified signatures | Add function_signatures to task object |
| Long depends_on chain | Consider extracting intermediate output as artifact |
| Missing file_path | Add exact file path immediately — DR004 |

---

## Quality Gate Reference

- `gate_ready: false` if risk_level is CRITICAL
- `gate_ready: false` if xl_tasks is non-empty
- Plan with CRITICAL risk cannot be submitted to Gate 3

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente03_SoftwareEngineer/knowledge/principles.md` — P2 (context window is a resource)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` — DR001, DR011
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` — Card003 (context window budget)
- `Agente03_SoftwareEngineer/context_view.md` — risk thresholds

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any external source.
