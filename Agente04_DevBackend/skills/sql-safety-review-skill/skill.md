# sql-safety-review-skill

## Purpose

Reviews backend code files for SQL injection vulnerabilities, unsafe data access patterns, and N+1 query issues. Must be run before every Gate 4 submission for any code that touches the database.

## When to Use

- Before every Gate 4 submission (mandatory)
- When reviewing any DAL file
- When code uses `prisma.$queryRaw` or `prisma.$executeRaw`
- When code processes user input that will be used in DB queries

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `files_to_review` | Array of backend source file paths | Yes |

## Outputs

- SQL safety report with:
  - `risk_level`: LOW / MEDIUM / HIGH / CRITICAL
  - `findings`: array of { file, line, issue, fix }
  - `sql_injection_safe`: boolean
  - `uses_only_parameterized`: boolean
  - `gate_4_status`: `"PASS"` (no HIGH/CRITICAL findings) or `"BLOCKED"` (one or more HIGH/CRITICAL findings present)

## Procedure

1. Validate each path in `files_to_review`: if a file does not exist or is outside the project source tree, add a finding `{ file, line: null, issue: "file_not_found — cannot be scanned", fix: "verify path and re-run" }` with `risk_level: CRITICAL` and continue to the next file. Do not abort the entire review.
2. Scan each file for string concatenation in queries
3. Scan for template literal interpolation with `$queryRaw` (without `Prisma.sql`)
4. Scan for `$queryRawUnsafe` — always a critical issue
5. Scan for unvalidated user input reaching DB operations
6. Scan for N+1 patterns (DAL call inside a loop)
7. Assign risk level: CRITICAL (injection possible), HIGH (unsafe raw SQL), MEDIUM (N+1), LOW (style)
8. Produce findings with specific file/line/issue/fix; set `gate_4_status = "BLOCKED"` if any finding is HIGH or CRITICAL, otherwise `"PASS"`

## Quality Gate

HIGH or CRITICAL findings block Gate 4 submission.

## Failure Modes

- Missed `$queryRawUnsafe` usage
- Template literal SQL without `Prisma.sql` tag — looks safe but is not parameterized

## RAG Collections Permitted

- `backend_engineering`
- `data_intensive_applications`
- `architecture_reference_backend_view`

## Architecture Compliance

- Any CRITICAL or HIGH finding blocks Gate 4
- All `$queryRaw` must use `Prisma.sql` template tag

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
