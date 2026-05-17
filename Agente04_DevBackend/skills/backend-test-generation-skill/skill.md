# backend-test-generation-skill

## Purpose

Generates Vitest unit tests for Server Actions, Route Handlers, and DAL functions. Tests are part of the Definition of Done — not optional additions. Minimum 4 test cases per function.

## When to Use

- After implementing any Server Action (required)
- After implementing any Route Handler (required)
- After implementing complex DAL functions or service methods
- As the last step before submitting to Gate 4

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `function_name` | The implemented function | Yes |
| `file_path` | Source file path | Yes |
| `mock_dependencies` | List of modules to mock | Yes |
| `test_cases` | 4+ scenarios from acceptance criteria | Yes |

## Outputs

- Vitest test file at `[source-path]/[file].test.ts` or `__tests__/[domain]/[file].test.ts`
- Minimum 4 test cases: unauthenticated, invalid input, success path, error path

## Procedure

1. **Create test file** at appropriate location
2. **Import** function under test, mocked dependencies
3. **Add `vi.mock()`** for `@/lib/auth`, DAL modules, `@/lib/audit`, external clients
4. **Create mock session** object
5. **Add `beforeEach`** with `vi.clearAllMocks()` and default auth mock
6. **Write test case 1: unauthenticated** — `auth()` returns null, verify throws/returns 401, verify DAL not called
7. **Write test case 2: invalid input** — empty/missing/wrong type, verify throws/returns 400
8. **Write test case 3: success path** — valid input, DAL mock returns result, verify return value and auditLog called
9. **Write test case 4: error path** — DAL throws, verify generic error returned (not raw DB error)

## Quality Gate

Gate 4 checks: `checklists/backend_test_checklist.md`

## Failure Modes

- Only happy-path test — auth/validation bugs undetected
- No mocks — slow tests that hit real DB
- No auth null test — auth bypass vulnerabilities undetected
- `console.error` assertion count checked instead of behavior

## RAG Collections Permitted

- `backend_engineering`
- `nodejs_patterns`

## Architecture Compliance

- MUST use Vitest (`describe`, `it`, `expect`, `vi`)
- MUST mock `@/lib/auth` for auth scenarios
- Minimum 4 test cases — no exceptions

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
