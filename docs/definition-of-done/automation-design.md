# Definition of Done — Automation_Design.md

## Overview

The Automation Design document specifies the architecture and operational contract for scripts in the `automation_script` archetype. It covers the Python stack (uv + Typer + Pydantic v2 + structlog), the operational safety requirements (dry-run mode, idempotency, retries), secrets management, and test coverage. This document is produced jointly by the Software Architect (architectural decisions) and the Software Engineer (task decomposition) and replaces Architecture.md for this archetype.

## Owner Agent

- **Primary:** `@architect` (Agente02_SoftwareArchitect) for design decisions
- **Primary:** `@engineer` (Agente03_SoftwareEngineer) for task breakdown
- **Archetype:** `automation_script` only
- **Gate:** Gate 2 (architecture review) + Gate 3 (execution plan review)

## Required Fields / Sections

### Stack Compliance (Golden Model: automation_script)
- [ ] Python version declared: 3.12 or higher
- [ ] Package manager: `uv` — no `pip`, `pipenv`, or `poetry` in the project
- [ ] `pyproject.toml` exists and defines all dependencies
- [ ] CLI framework: `Typer` — no `argparse`, `click`, or `fire`
- [ ] Data validation: `Pydantic v2` — not v1, not dataclasses, not TypedDict for external data
- [ ] Structured logging: `structlog` — no `logging.basicConfig`, no `print()` as logging
- [ ] Test runner: `pytest` with `pytest-cov`
- [ ] Any deviation from the above requires an approved ADR

### Entry Point and CLI Design
- [ ] Entry point is a Typer app (`app = typer.Typer()`)
- [ ] `--dry-run` flag is defined as a Typer option on every command that modifies external state
- [ ] `--dry-run` mode logs all actions that would be taken but makes no writes to external systems or databases
- [ ] `--dry-run` output is clearly labeled (e.g., `[DRY RUN]` prefix in log lines)
- [ ] Help text is defined for every command and every option (`help="..."`)
- [ ] Exit codes are documented: 0 = success, 1 = general failure, 2 = invalid input, 3 = partial failure (if applicable)
- [ ] `--version` flag returns the script version

### Idempotency Guarantees
- [ ] Idempotency strategy is documented for every command that writes data
- [ ] The specific idempotency key is named (e.g., `external_id`, `record_hash`, `processed_at`)
- [ ] Upsert or existence-check pattern is specified — `create` without an existence check is not acceptable
- [ ] Running the script twice on the same input produces the same result as running it once (documented as a test case)
- [ ] Any operation that cannot be made fully idempotent is documented with its failure mode and the mitigation

### Structured Logging (structlog)
- [ ] `structlog` is configured at startup (processor chain defined)
- [ ] Log output format is JSON in production mode, colored console in development mode
- [ ] Every significant operation logs: operation name, entity ID, status (started/completed/failed)
- [ ] Error logs include: exception type, exception message, affected entity ID, and operation name
- [ ] `[DRY RUN]` prefix is added to all log lines when dry-run mode is active
- [ ] No `print()` statements used for operational output — all output goes through `structlog`
- [ ] Sensitive data (passwords, API keys, PII) is not written to logs

### Retry Strategy (tenacity)
- [ ] `tenacity` is listed as a dependency if any external I/O is performed
- [ ] Retry decorator (`@retry`) is applied to all functions making network calls or external API calls
- [ ] Retry configuration specifies: max attempts, wait strategy (exponential backoff recommended), and which exception types trigger a retry
- [ ] Non-retriable errors (e.g., 400 Bad Request, 401 Unauthorized, 403 Forbidden) are excluded from retry logic
- [ ] Retry attempts are logged at WARNING level with attempt number and delay
- [ ] Final failure after all retries is logged at ERROR level with full context

### Secrets Management
- [ ] Zero hardcoded credentials in source files or `pyproject.toml`
- [ ] Secrets are loaded from environment variables using Pydantic v2 `BaseSettings`
- [ ] `Settings` class validates all required secrets at startup using Pydantic validators
- [ ] Missing required secrets cause an immediate startup failure with a clear error message (not a runtime error deep in execution)
- [ ] `.env` file support is documented and `.env` is in `.gitignore`
- [ ] Secret names are documented with descriptions and examples (no actual values)
- [ ] Secret rotation procedure does not require code changes

### Error Handling
- [ ] Every external I/O call is wrapped in try/except
- [ ] Exceptions are caught at the appropriate level — not swallowed silently
- [ ] Error handling distinguishes between: transient failures (retry), permanent failures (log and skip), and fatal failures (abort with non-zero exit)
- [ ] `partial` exit code (code 3 or documented equivalent) is used when some records succeed and some fail
- [ ] Final run summary is always printed: total processed, succeeded, failed, skipped

### Test Coverage
- [ ] `pytest` test files exist for all core business logic functions
- [ ] `--dry-run` behavior is tested: confirm no external writes occur
- [ ] Idempotency is tested: run core logic twice on the same fixture, assert no duplicates
- [ ] Retry behavior is tested using mocked failures
- [ ] Secrets validation is tested: missing secret causes startup failure with expected message
- [ ] Test coverage is >= 80% (measured with `pytest-cov`)
- [ ] Tests do not make real network calls — external dependencies are mocked with `pytest-mock` or `responses`

### Operational Runbook Reference
- [ ] A `README.md` or `USAGE.md` documents how to run the script
- [ ] All CLI commands, options, and flags are documented with examples
- [ ] Prerequisite setup steps are documented (virtualenv, environment variables)
- [ ] Common failure scenarios and their resolutions are documented
- [ ] `--dry-run` is documented as the recommended first run for any new environment

### Handoff Package
- [ ] `required_next_agent` set to `"Agente04_DevBackend"` or the appropriate implementation agent
- [ ] `gate_ready` set to `true`
- [ ] `dry_run_verified` set to `true`
- [ ] `idempotency_strategy` populated for each command
- [ ] `stack_compliance` confirmed as `true`
- [ ] `open_questions` confirms no blocking items

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| Stack compliance | Read `pyproject.toml`; every dependency must match the Golden Model (`uv`, `typer`, `pydantic>=2.0`, `structlog`, `tenacity`, `pytest`) |
| Dry-run mode implemented | Run with `--dry-run`; confirm no writes to external systems; confirm log output contains `[DRY RUN]` labels |
| Idempotency guaranteed | Run core logic twice on the same test data; assert record count is identical after second run |
| No hardcoded secrets | Search entire codebase for known secret patterns; count must be zero |
| Pydantic Settings validates secrets | Remove a required env var; confirm startup fails with a clear error message, not an AttributeError mid-execution |
| Structured logging is JSON | Set `ENV=production` and run; confirm log output is valid JSON, not plain text |
| Retry logic tested | Read test for the external I/O function; confirm mock failure → retry → success scenario is covered |
| Coverage >= 80% | Run `pytest --cov`; overall percentage must be >= 80% |

## Related Gates

- **Prerequisite:** Gate 1 approved (PRD.md must specify `project_archetype: automation_script`)
- **This gate covers:** Gate 2 (architecture) and Gate 3 (execution plan) for the automation_script archetype
- **Unblocks:** Gate 4 — QA Review

## Failure Examples

- **FAIL:** The script uses `click` as the CLI framework instead of `Typer`. This is a Golden Model deviation with no ADR. Gate 2 cannot be approved.
- **FAIL:** `STRIPE_API_KEY = "sk_live_abc123def456"` appears in `config.py`. This is a hardcoded secret and a security violation.
- **FAIL:** The `--dry-run` flag is defined but the function body does not branch on it — writes happen regardless. The flag is decorative, not functional.
- **FAIL:** The sync function uses `INSERT INTO records ...` without checking if the record already exists. Running the script twice will create duplicates.
- **FAIL:** Network errors are caught with `except Exception: pass`. Errors are silently swallowed — the script reports success even when operations fail.
- **FAIL:** `print()` is used throughout for output. Log lines are not structured, cannot be parsed by a log aggregator, and have no log level.
- **FAIL:** Test coverage is 61%. The 80% threshold is not met.

## When to Block

Return with `BLOCKED_MISSING_DRY_RUN` (custom status for this archetype) when:
- `--dry-run` flag is absent from any command that writes to external state
- `--dry-run` is implemented but does not prevent writes

Return `RETURNED_FOR_REVISION` when:
- Stack deviates from the Golden Model without an approved ADR
- Secrets are hardcoded or not validated at startup
- Idempotency strategy is not documented for any write command
- Retry logic is absent for external I/O calls
- Test coverage is below 80%

Issue `APPROVED` only when every checkbox in this document is checked, dry-run mode is verified functional, idempotency is tested, and test coverage is >= 80%.
