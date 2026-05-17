# Task Backlog
## Project: [Project Name]
## Plan ID: [plan-id]
## Architecture Version: [arch-version] | PRD Version: [prd-version]
## Generated: [ISO 8601 timestamp]

---

## Summary

| Metric | Value |
|--------|-------|
| Total Tasks | [N] |
| Backend Tasks | [N] |
| Frontend Tasks | [N] |
| Database Tasks | [N] |
| Infrastructure Tasks | [N] |
| Testing Tasks | [N] |
| Security Tasks | [N] |
| Config Tasks | [N] |
| XL Tasks | 0 (Gate 3 requires 0) |
| Critical Path Length | [N] tasks |

---

## All Tasks — Summary Table

| Task ID | Title | Type | Layer | Complexity | Depends On | Status |
|---------|-------|------|-------|-----------|------------|--------|
| TASK-001 | [title] | database | infrastructure | S | — | pending |
| TASK-002 | [title] | database | infrastructure | S | TASK-001 | pending |
| TASK-003 | [title] | backend | business-logic | M | TASK-001, TASK-002 | pending |
| TASK-004 | [title] | backend | api | M | TASK-002, TASK-003 | pending |
| TASK-005 | [title] | frontend | presentation | M | TASK-003 | pending |
| TASK-006 | [title] | frontend | presentation | S | TASK-005 | pending |
| TASK-007 | [title] | testing | testing | M | TASK-003, TASK-004 | pending |
| TASK-008 | [title] | testing | testing | M | TASK-005, TASK-006 | pending |

---

## Database Tasks

### TASK-001 — [title]

- **File:** `[file_path]`
- **Complexity:** S
- **Depends on:** —
- **Description:** [description]
- **Acceptance Criteria:**
  - [ ] [criterion 1]
  - [ ] [criterion 2]

### TASK-002 — [title]

- **File:** `[file_path]`
- **Complexity:** S
- **Depends on:** TASK-001
- **Description:** [description]
- **Acceptance Criteria:**
  - [ ] [criterion 1]
  - [ ] [criterion 2]

---

## Backend Tasks

### TASK-003 — [title]

- **File:** `[file_path]`
- **Complexity:** M
- **Depends on:** TASK-001, TASK-002
- **Description:** [description]
- **Function Signatures:**
  - `[function signature]`
- **Acceptance Criteria:**
  - [ ] [criterion 1]
  - [ ] [criterion 2]
  - [ ] [criterion 3]
- **Security:** auth_required: [true/false] | input_validation: [true/false] | audit_log: [true/false]
- **Tests:** unit: [Vitest] | integration: [Vitest] | e2e: [false]

### TASK-004 — [title]

- **File:** `[file_path]`
- **Complexity:** M
- **Depends on:** TASK-002, TASK-003
- **Description:** [description]
- **Function Signatures:**
  - `[function signature]`
- **Acceptance Criteria:**
  - [ ] [criterion 1]
  - [ ] [criterion 2]
- **Security:** auth_required: [true/false] | input_validation: [true/false] | audit_log: [true/false]
- **Tests:** unit: [Vitest] | integration: [Vitest] | e2e: [false]

---

## Frontend Tasks

### TASK-005 — [title]

- **File:** `[file_path]`
- **Complexity:** M
- **Depends on:** TASK-003
- **Description:** [description]
- **Function Signatures:**
  - `[function signature]`
- **Acceptance Criteria:**
  - [ ] [criterion 1]
  - [ ] [criterion 2]
- **Security:** auth_required: [true/false] | authorization_level: [authenticated]
- **Tests:** unit: [false] | integration: [false] | e2e: [Playwright]

### TASK-006 — [title]

- **File:** `[file_path]`
- **Complexity:** S
- **Depends on:** TASK-005
- **Description:** [description]
- **Acceptance Criteria:**
  - [ ] [criterion 1]
  - [ ] [criterion 2]
- **Tests:** unit: [false] | integration: [false] | e2e: [Playwright]

---

## Infrastructure Tasks

_Add infrastructure tasks here if applicable (env setup, proxy.ts, guardCron, lib/env.ts)._

---

## Testing Tasks

### TASK-007 — [title]

- **File:** `[test file path]`
- **Complexity:** M
- **Depends on:** TASK-003, TASK-004
- **Description:** [description]
- **Test Type:** [unit / integration]
- **Tool:** Vitest
- **Coverage Target:** [N]%

### TASK-008 — [title]

- **File:** `[test file path]`
- **Complexity:** M
- **Depends on:** TASK-005, TASK-006
- **Description:** [description]
- **Test Type:** E2E
- **Tool:** Playwright
- **Flow:** [user flow description]

---

## Critical Path

```
TASK-001 → TASK-002 → TASK-003 → TASK-004 → [end]
```

**Critical Path Length:** [N] tasks

---

## Parallel Tracks

| Track | Tasks | Can Run Parallel With |
|-------|-------|----------------------|
| Backend Track | TASK-003, TASK-004 | Frontend development after TASK-003 complete |
| Frontend Track | TASK-005, TASK-006 | Testing track setup |
| Testing Track | TASK-007, TASK-008 | Each other after respective dependencies |

---

## Notes

[Any notes for the dev team about this backlog — ordering considerations, risks, parallelism recommendations.]
