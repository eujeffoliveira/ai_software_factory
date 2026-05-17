# Test Requirements Checklist
## Agente03 Software Engineer / Task Planner
## Version: 1.0.0

Run this checklist on every task before including it in Execution_Plan.json.
Tests are first-class citizens — they are planned, not discovered after the fact. Rule: P7.

---

## Task-Level Checks

### 1. Every Task Has test_requirements Defined
- [ ] The task object contains a `test_requirements` field
- [ ] `test_requirements` is not null, undefined, or empty
- [ ] `test_requirements` has at minimum: `unit_required`, `integration_required`, `e2e_required`

_Failure: Add test_requirements to the task. Gate 3 blocks on missing test requirements._

### 2. S/M Tasks Have unit_required Assessed
- [ ] For every S or M task with a pure function or utility: `unit_required: true`
- [ ] For every S or M task that is a migration or schema-only file: `unit_required: false` (acceptable)
- [ ] For config/infrastructure tasks with no testable logic: `unit_required: false` is documented with a reason

_Rule: Not every task needs unit tests, but every task must have a conscious decision._

### 3. Server Action and Route Handler Tasks Have integration_required: true
- [ ] Every `backend` task that is a Server Action: `integration_required: true`
- [ ] Every `backend` task that is a Route Handler: `integration_required: true`
- [ ] Every `backend` task that reads from or writes to the database: `integration_required: true`
- [ ] Integration tool is specified as `"Vitest"` (const — no other tools)

_Rule: Server Actions and Route Handlers must be verified with real database interactions._

### 4. User-Facing Flows Have e2e_required Assessed
- [ ] Every `frontend` task that represents a page or complete user flow: `e2e_required` is explicitly set (true or false with justification)
- [ ] Every task where the user interacts with a form: `e2e_required: true`
- [ ] Every task where authentication is part of the flow: `e2e_required: true`
- [ ] E2E tool is specified as `"Playwright"` (const — no other tools)
- [ ] When `e2e_required: true`, `e2e_flow_description` is present

_Rule: User-facing flows must be verified end-to-end. Playwright only._

### 5. Coverage Targets Set for Backend Tasks
- [ ] All `backend` tasks with `unit_required: true` have a `unit_coverage_target` set
- [ ] Minimum recommended coverage: 80%
- [ ] Coverage target is a number between 0 and 100

_Advisory: Coverage targets without measurement tooling are advisory but should be set._

### 6. Vitest Specified for Unit/Integration
- [ ] When `unit_required: true`, `unit_tool: "Vitest"` is set
- [ ] When `integration_required: true`, `integration_tool: "Vitest"` is set
- [ ] No other unit/integration test framework is referenced (no Jest, no Mocha)

_Rule: Golden Path mandates Vitest for unit and integration tests._

### 7. Playwright Specified for E2E
- [ ] When `e2e_required: true`, `e2e_tool: "Playwright"` is set
- [ ] No other E2E framework is referenced (no Cypress, no Puppeteer)

_Rule: Golden Path mandates Playwright for E2E tests._

### 8. Mock Requirements Documented
- [ ] For tasks with `unit_required: true`: `mock_requirements` lists what needs to be mocked
- [ ] Prisma client is listed when the task uses database operations
- [ ] NextAuth session is listed when the task requires authentication context
- [ ] External API clients are listed when the task calls third-party services

### 9. Test Data Requirements Noted
- [ ] If the test requires seed data or fixtures, `test_data_requirements` describes them
- [ ] If the test requires a specific database state, setup instructions are noted in `test_notes`

---

## Plan-Level Checks

### 10. Every Task Has At Least One Test Path
After reviewing all tasks:

- [ ] Every task with application logic (backend, frontend, security) has at least one of: unit_required, integration_required, or e2e_required set to true
- [ ] Only pure infrastructure tasks (migrations, env config) may have all test types false
- [ ] Testing tasks (type: testing) exist in the plan for major features

### 11. Testing Tasks Are in the Plan
- [ ] At least one testing task exists for backend logic (Vitest)
- [ ] At least one testing task exists for user-facing flows (Playwright) if UI is included
- [ ] Testing tasks are in Phase 4 of the implementation sequence (or colocated in Phase 2 for TDD)

---

## Runtime Knowledge Policy

This checklist is executed using only local artifacts:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P7)
- `Agente03_SoftwareEngineer/context_view.md` (Golden Path test stack)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` (general task rules)

Never reads: `context/`, `lib/`, `*.pdf`

---

## Result

- **PASS:** All items checked → Test requirements are complete for all tasks
- **FAIL (BLOCKING):** Any task missing `test_requirements` → Add before Gate 3
- **FAIL (ADVISORY):** Coverage targets missing → Add before handoff to dev agents
