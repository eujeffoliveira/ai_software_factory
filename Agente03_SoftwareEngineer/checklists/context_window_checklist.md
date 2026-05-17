# Context Window Checklist
## Agente03 Software Engineer / Task Planner
## Version: 1.0.0

Run this checklist on every task and on the full plan before Gate 3 submission.
The goal is to ensure dev agents can complete tasks without context exhaustion.

---

## Task-Level Checks

Run for each individual task:

### 1. No XL Task in Plan
- [ ] Task `estimated_complexity` is NOT `XL`
- [ ] If XL was initially assigned, the task has been split and this check is being run on the split result

_Failure: BLOCK — XL task cannot proceed to Gate 3. DR001._

### 2. L Tasks Flagged and Annotated
- [ ] If complexity is `L`, `context_summary` is present in the task object
- [ ] `context_summary` is ≤ 200 words
- [ ] `context_summary` explains: what exists, what to build, key patterns, what NOT to do
- [ ] If complexity is `L`, function_signatures are pre-specified (reduces guesswork)

_Failure: Add context_summary to all L-complexity tasks. Advisory — not gate-blocking but should be resolved._

### 3. Single File Focus
- [ ] `file_path` is a single specific file — not a directory, not a glob
- [ ] The task description does not describe creating multiple files
- [ ] function_signatures all belong to the same file

_Failure: Split task. A task with multiple files is not atomic._

### 4. Minimal Existing File Reading
- [ ] The task does not require reading more than 3 existing files to implement
- [ ] If more than 3 existing files must be read, either: add a context_summary that pre-digests them, or split the task

_Advisory: Each existing file the dev agent must read consumes context budget._

### 5. Context Summary Bounded
- [ ] If `context_summary` is present, it is ≤ 200 words
- [ ] Context summary focuses on essential information only — not a full tutorial
- [ ] Context summary does not duplicate information already in acceptance_criteria

### 6. Function Signatures Pre-Defined
- [ ] For M and L complexity tasks: `function_signatures[]` is populated
- [ ] Function signatures are TypeScript-valid (correct syntax)
- [ ] Function signatures include parameter types and return types
- [ ] Dev agent does not need to invent the function API from scratch

_Advisory: Pre-specified signatures reduce context load significantly._

### 7. No Architectural Decision Required During Implementation
- [ ] The task does not require the dev agent to choose between multiple valid architectural approaches
- [ ] The implementation approach is unambiguous from Architecture.md + function signatures
- [ ] If a choice exists (e.g., Server Component vs Client Component), the task specifies which one

_Failure: Add the decision to the task description. If the decision requires the architect's input, escalate._

---

## Plan-Level Checks

Run once after all tasks are defined:

### 8. Total XL Count is Zero
- [ ] Count of tasks with `estimated_complexity: "XL"` = 0
- [ ] `xl_tasks_count` in the context-window risk report = 0

_Failure: Find and split all XL tasks before proceeding._

### 9. L Tasks Reviewed
- [ ] All L-complexity tasks are listed in the risk report
- [ ] Each L task has a mitigation note (context_summary, pre-specified signatures, or scope reduction)
- [ ] L tasks represent ≤ 20% of the total plan (if more, reconsider decomposition strategy)

_Advisory: High proportion of L tasks suggests the decomposition is not fine-grained enough._

### 10. Dependency Chain Length
- [ ] No single task has more than 5 direct dependencies in `depends_on[]`
- [ ] If a task has 5+ dependencies, each dependency has been verified as genuinely necessary
- [ ] Long dependency chains do not force the dev agent to re-read all prior task outputs

_Advisory: Long dependency chains suggest the task may be too central to the plan (hub node). Consider intermediate outputs._

### 11. Plan-Level Risk Assessment
- [ ] `context-window-risk-analysis-skill` has been run on the full plan
- [ ] Overall risk level is LOW or MEDIUM
- [ ] If risk level is HIGH: all L tasks have mitigations applied
- [ ] If risk level is CRITICAL: plan cannot proceed (DR001 + DR011)

---

## Runtime Knowledge Policy

This checklist is executed using only local artifacts:
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` (DR001, DR011)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card003)
- `Agente03_SoftwareEngineer/context_view.md` (context window thresholds)

Never reads: `context/`, `lib/`, `*.pdf`

---

## Result

- **PASS:** All items checked → Context window risks are managed; proceed to Gate 3
- **FAIL (BLOCKING):** Any XL task → Must split before Gate 3
- **FAIL (ADVISORY):** L tasks without context_summary → Add summaries before submission
