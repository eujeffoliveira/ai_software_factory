# vitest-generation-skill

## Purpose

Generates Vitest test files for Server Actions, Route Handlers, and service functions when they are identified as missing during QA review. Produces test files conforming to the Golden Path patterns: 4 minimum test cases, proper mocking, behavior-based assertions.

## When to Use

- Missing test files identified during Gate 4 review and the pipeline has authorized QA to generate them
- The Dev agent has been notified of the gap but the resubmission is taking too long to unblock the pipeline
- Always SECONDARY to returning the gap to the Dev agent — QA generating tests is a pipeline exception, not the default path

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `function_name` | The Server Action or function name | Yes |
| `file_path` | Source file path to be tested | Yes |
| `function_signature` | Full TypeScript signature of the function | Yes |
| `mock_dependencies` | List of module paths that need vi.mock() | Yes |
| `acceptance_criteria` | AC-NNN(s) this function satisfies | Yes |
| `input_schema` | Zod schema or valid/invalid input examples | Yes |

## Outputs

- Vitest test file at `[source-path]/__tests__/[file].test.ts`
- Minimum 4 test cases: unauthenticated, invalid input, success, error path
- Test names in behavior-describing format (not "test 1", not "works")

## Procedure

1. Parse the function signature to understand inputs and outputs
2. Identify the mock boundary: auth, DAL modules, audit log, external clients
3. Create mock session object with generic identifiers
4. Write test case 1: `auth()` returns null → function returns `{ error: "Unauthorized" }` → DAL NOT called
5. Write test case 2: valid session, invalid input (empty/missing/wrong type) → validation error → DAL NOT called
6. Write test case 3: valid session, valid input, DAL mock returns result → success + auditLog called with correct params
7. Write test case 4: valid session, valid input, DAL throws → generic error returned (no DB details exposed)
8. Add `beforeEach(() => vi.clearAllMocks())` to the suite

## Constraints

- MUST use Vitest (`describe`, `it`, `expect`, `vi`) — never Jest syntax
- MUST mock `next-auth` for auth scenarios
- MUST NOT call real DB, real auth, or real external services
- MUST test behavior (return values, side effects) not implementation internals
- Minimum 4 test cases — never fewer
- Test names must describe the behavior being verified using the pattern `"[condition] → [expected outcome]"` (e.g., `"auth returns null → returns Unauthorized error without calling DAL"`, `"valid input, DAL throws → returns generic error without DB details"`)
- Mock boundary always includes: `@/lib/auth`, all DAL imports, `@/lib/audit`, any external client module; never mock the function under test itself

## Architecture Compliance

- Uses `vi.mock()` for all external dependencies at module boundary
- Uses `vi.clearAllMocks()` in `beforeEach`
- Imports function under test directly (`import { fn } from "@/features/..."`)
- Follows `templates/Vitest_Test_Template.ts` structure

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/templates/Vitest_Test_Template.ts`, and project input artifacts.
