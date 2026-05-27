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
- Minimum 4 test cases. Required cases depend on whether the function requires authentication:
  - **Auth-required** (Server Actions, protected Route Handlers): unauthenticated, invalid input, success path, error path
  - **Public endpoint / pure function** (no session): invalid input, success path, error path, plus one additional domain-specific edge case (e.g., rate-limit exceeded, external dependency unavailable). Add a comment `// public endpoint — no auth test` to justify omission.

## Procedure

1. **Create test file** at appropriate location
2. **Import** function under test, mocked dependencies
3. **Add `vi.mock()`** for `@/lib/auth` (if auth-required), DAL modules, `@/lib/audit`, external clients
4. **Create mock session** object (skip if public endpoint)
5. **Add `beforeEach`** with `vi.clearAllMocks()` and default auth mock (if auth-required)
6. **Write test case 1** — if auth-required: unauthenticated (`auth()` returns null, verify throws/returns 401, verify DAL not called); if public: invalid input (empty/missing/wrong type, verify throws/returns 400)
7. **Write test case 2: invalid input** (auth-required) or **success path** (public) — match the shifted order above
8. **Write test case 3: success path** — valid input, DAL mock returns result, verify return value and auditLog called (if applicable)
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
- MUST mock `@/lib/auth` for auth-required functions
- Minimum 4 test cases; public endpoints and pure functions omit the auth null test and must add a domain-specific edge case in its place — justify the omission with an inline comment

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
