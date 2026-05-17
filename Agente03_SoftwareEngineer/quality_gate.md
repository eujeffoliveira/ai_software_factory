# Quality Gate 3 — Execution Plan Review
## Agente03 Software Engineer / Task Planner
### Edition: Generic / White-Label | Version: 1.0.0

---

## Objective

Gate 3 validates that the `Execution_Plan.json` produced by Agente03 is:
- **Complete** — all architectural components are covered by tasks
- **Atomic** — every task has single responsibility, single file focus, bounded scope
- **Ordered** — topological sort is valid, implementation sequence is safe
- **Traceable** — every task traces to a PRD criterion or architectural decision
- **Ready** — no XL tasks, no circular dependencies, no missing artifacts

A plan that passes Gate 3 is safe to hand directly to Agente04_DevBackend and Agente05_DevFrontend without further clarification.

---

## Entry Criteria

Gate 3 may only be entered when ALL of the following are true:

| Criterion | Verification |
|-----------|-------------|
| Gate 2 status is APPROVED | Check Architecture.md handoff package gate_status |
| Architecture.md is present | File exists and is referenced in plan |
| API_Contract.json is present | File exists and is referenced in plan |
| DB schema is present (SQL or Prisma) | File exists and is referenced in plan |
| Architecture_Decisions.md is present | ADRs exist and constraints are reflected in tasks |
| No outstanding BLOCKED status from Gate 2 | Handoff package from Agente02 shows APPROVED |

If any entry criterion is unmet, return `BLOCKED_MISSING_ARTIFACT` before processing.

---

## Mandatory Artifacts

| Artifact | Schema/Template | Required | Status if Missing |
|----------|-----------------|----------|-------------------|
| Execution_Plan.json | schemas/execution_plan.schema.json | Yes | BLOCKED_MISSING_ARTIFACT |
| Task_Backlog.md | templates/Task_Backlog.md | Yes | BLOCKED_MISSING_ARTIFACT |
| Dependency_Graph.md | templates/Dependency_Graph.md | Yes | BLOCKED_MISSING_ARTIFACT |
| Task_Handoff_Packages.md | templates/Task_Handoff_Package.md | Yes | BLOCKED_MISSING_ARTIFACT |
| Handoff Package (JSON) | handoff_schema.json | Yes | BLOCKED_MISSING_ARTIFACT |

---

## Status Codes

| Code | Meaning | Next Step |
|------|---------|-----------|
| `APPROVED` | Plan passes all criteria; proceed to dev agents | Route to Agente04 + Agente05 |
| `RETURNED_FOR_REVISION` | Fixable issues found; agent must correct and resubmit | Agente03 revises and resubmits |
| `BLOCKED_MISSING_ARTIFACT` | Required input or output artifact is absent | Agente03 identifies what is missing, escalates if needed |
| `BLOCKED_PENDING_HUMAN` | A conflict, ambiguity, or scope decision requires human approval | Agente00 escalates to human |
| `BLOCKED_SCOPE_EXCEEDED` | Plan includes work not in approved Architecture.md | Agente03 removes out-of-scope tasks and resubmits |
| `BLOCKED_AMBIGUOUS_DEPENDENCY` | Dependency chain is ambiguous, circular, or unresolvable | Agente03 fixes graph or escalates |

---

## Blocking Conditions

Any of the following conditions **immediately blocks** Gate 3 and requires resolution before resubmission:

### Blocking Condition 1: XL Task in Plan
- **Symptom:** Any task with `estimated_complexity: "XL"`
- **Rule:** DR001 — XL tasks exceed dev agent context budget
- **Resolution:** Split into 2+ tasks; re-validate atomicity
- **Status:** RETURNED_FOR_REVISION

### Blocking Condition 2: Circular Dependency
- **Symptom:** `has_cycles: true` in dependency graph
- **Rule:** DR002 — circular dependencies make topological sort impossible
- **Resolution:** Identify cycle, break at weakest link, or escalate to Tech Lead
- **Status:** BLOCKED_AMBIGUOUS_DEPENDENCY

### Blocking Condition 3: Missing file_path on Any Task
- **Symptom:** A task object has no `file_path` or `file_path: null`
- **Rule:** DR004 — dev agents cannot work without knowing which file to edit
- **Resolution:** Add exact file path or reject the task if scope is unclear
- **Status:** RETURNED_FOR_REVISION

### Blocking Condition 4: Missing Acceptance Criteria on Any Task
- **Symptom:** A task has `acceptance_criteria: []` or undefined
- **Rule:** P4 — every task must be verifiable
- **Resolution:** Derive criteria from PRD or Architecture.md; add to task
- **Status:** RETURNED_FOR_REVISION

### Blocking Condition 5: Uncovered PRD Acceptance Criterion
- **Symptom:** Coverage matrix shows one or more PRD criteria with no covering task
- **Rule:** DR003 — all PRD requirements must be implemented
- **Resolution:** Add covering tasks or escalate if criterion conflicts with architecture
- **Status:** RETURNED_FOR_REVISION or BLOCKED_PENDING_HUMAN if conflict

### Blocking Condition 6: Missing Test Requirements on Any Task
- **Symptom:** A task has `test_requirements` undefined or all fields false/null
- **Rule:** P7 — tests are tasks, not afterthoughts
- **Resolution:** Assign unit/integration/E2E requirements based on task type
- **Status:** RETURNED_FOR_REVISION

### Blocking Condition 7: Missing Security Requirements on Sensitive Task
- **Symptom:** A task touching user input, auth, or sensitive data has incomplete `security_requirements`
- **Rule:** P6, DR007, DR008 — security baked in, not bolted on
- **Resolution:** Populate security_requirements per task type; apply DR007–DR012
- **Status:** RETURNED_FOR_REVISION

### Blocking Condition 8: Out-of-Scope Task
- **Symptom:** A task references a file, endpoint, or component not mentioned in Architecture.md
- **Rule:** P8 — the plan protects the architecture
- **Resolution:** Remove the task or escalate if it represents a gap in the architecture
- **Status:** BLOCKED_SCOPE_EXCEEDED

### Blocking Condition 9: Topological Inconsistency
- **Symptom:** Implementation_Sequence.md order contradicts the topological sort
- **Rule:** P5 — implementation order follows the dependency graph
- **Resolution:** Re-run implementation-sequencing-skill with correct topological order
- **Status:** RETURNED_FOR_REVISION

### Blocking Condition 10: Missing Handoff Package
- **Symptom:** No JSON handoff package matching handoff_schema.json
- **Rule:** Pipeline contract requirement
- **Resolution:** Generate handoff package before submission
- **Status:** BLOCKED_MISSING_ARTIFACT

---

## Non-Blocking Warnings (RETURNED_FOR_REVISION with lower priority)

| Warning | Description | Recommended Action |
|---------|-------------|-------------------|
| L task without context_summary | Large task lacks helper context | Add context_summary (≤ 200 words) per DR011 |
| task with depends_on chain > 5 | Long chain increases context load | Annotate with intermediate checkpoints |
| Missing function_signatures on M task | Dev agent must invent API | Pre-specify function signatures where possible |
| No parallel tracks identified | May indicate over-sequential plan | Review for parallelization opportunities |

---

## Exit Criteria Checklist

Before submitting to Gate 3, Agente03 must verify all of the following:

**Completeness:**
- [ ] All architectural components from Architecture.md are covered by ≥1 task
- [ ] All API endpoints from API_Contract.json are covered by tasks
- [ ] All DB tables/models from schema are covered by migration + model tasks
- [ ] All PRD acceptance criteria appear in the coverage matrix

**Atomicity:**
- [ ] Every task has a single `file_path`
- [ ] Every task has a title that describes exactly one action in ≤ 8 words
- [ ] No task has `estimated_complexity: "XL"`
- [ ] All L tasks have a `context_summary`

**Dependency Graph:**
- [ ] `has_cycles: false` in dependency_graph
- [ ] Topological sort is computed and valid
- [ ] Every `depends_on` reference points to an existing task_id
- [ ] Parallel tracks are identified

**Acceptance Criteria:**
- [ ] Every task has `acceptance_criteria` with ≥1 item
- [ ] Coverage matrix shows 100% PRD criterion coverage
- [ ] `uncovered_criteria` list is empty

**Security:**
- [ ] Every task touching user input has `input_validation_required: true`
- [ ] Every task modifying sensitive data has `audit_log_required: true`
- [ ] Every cron task notes `guardCron()` as first call
- [ ] Every public endpoint is explicitly documented as intentionally public

**Testing:**
- [ ] Every task has `test_requirements` defined
- [ ] Backend logic tasks have `unit_required: true`
- [ ] Server Action tasks have `integration_required: true`
- [ ] User-facing flows have `e2e_required: true`
- [ ] Vitest is specified for unit/integration; Playwright for E2E

**Artifacts:**
- [ ] Execution_Plan.json validates against schemas/execution_plan.schema.json
- [ ] Task_Backlog.md produced
- [ ] Dependency_Graph.md with Mermaid chart produced
- [ ] Task_Handoff_Packages.md produced
- [ ] Handoff Package JSON produced and matches handoff_schema.json

---

## When to Escalate to Human

Gate 3 escalation to human (via Agente00_TechLead) is required when:

1. A PRD requirement cannot be implemented with the approved architecture — conflict requires product/architecture decision
2. The total scope of the plan significantly exceeds what was discussed at Gate 2 — business decision required
3. A security requirement cannot be satisfied without a tool or pattern not in the Golden Path — ADR required before planning
4. The plan was returned from Gate 3 more than twice with the same blocking condition — systemic issue requires senior review
5. A dependency cycle exists that cannot be broken without changing the architecture — architectural decision required
