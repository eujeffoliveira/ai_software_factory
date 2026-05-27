# Rubric — Automation Script Archetype

## Purpose

This rubric evaluates whether an agent's response for an `automation_script` archetype project correctly applies the Python automation Golden Model. Use this rubric alongside the agent-specific rubric (techlead_rubric, architect_rubric, etc.) when the project is classified as `automation_script`.

## Scoring Guide

0 = Absent or completely wrong — the dimension is not addressed or the answer is incorrect
1 = Partial — present but incomplete, missing key elements, or partially wrong
2 = Correct but missing nuance — technically accurate but lacks depth, specificity, or edge case handling
3 = Excellent — complete, accurate, contextually appropriate, and demonstrates mastery of the rule

---

## Dimensions

### 1. Correct Stack Selection
**Weight:** HIGH

**Score 3:** Recommends the complete automation_script Golden Model stack: Python 3.12+ (not 3.10 or 3.11), uv for dependency management (not pip, poetry, or pipenv), Typer for CLI interface (not argparse or click), Pydantic v2 for data validation (not marshmallow, attrs, or dataclasses alone), structlog for logging, pytest for tests. No web framework components (FastAPI, Flask, Django, Next.js) present. No ORMs (SQLAlchemy, Prisma, Django ORM) unless a DB connection is specifically required.

**Score 2:** Core stack correct (Python, Typer, Pydantic, structlog, pytest). One component is missing or uses a near-equivalent (e.g., uses standard logging instead of structlog, or uses poetry instead of uv). No web framework contamination.

**Score 1:** Python and Typer present. Pydantic present. But uv not mentioned (default pip used). structlog absent. Shows correct direction without full Golden Model adherence.

**Score 0:** Web framework components present (FastAPI, Flask, Next.js). Or recommends pandas/Polars without a data processing justification. Or uses a non-Python language without ADR. Or recommends an ORM without database access being part of the task.

---

### 2. Dry-Run Flag
**Weight:** HIGH

**Score 3:** `--dry-run` flag is a first-class feature with explicit behavior: when enabled, the script shows exactly what it WOULD do (log all planned changes) but makes no actual writes to databases, files, or external APIs. Dry-run output is as informative as a real run. The flag is implemented via Typer (not ad-hoc argparse). Dry-run mode is tested with a specific pytest test case.

**Score 2:** `--dry-run` flag present and described. Implementation uses Typer. But dry-run output specification is vague ("shows what would happen") without specifying the level of detail. Or dry-run is not tested.

**Score 1:** `--dry-run` flag mentioned as a requirement acknowledgment. But no implementation details — just "we'll add a --dry-run flag." Or flag is described but not implemented via Typer.

**Score 0:** `--dry-run` not mentioned even when the task specification explicitly requires it. Or dry-run is described as "not needed for this script type."

---

### 3. Idempotency
**Weight:** HIGH

**Score 3:** Explicit idempotency strategy defined: the script can be run N times and the result is the same as running it once. For database operations: uses upsert (INSERT ... ON CONFLICT DO UPDATE) instead of INSERT. For file operations: checks existence before creating. For API calls: uses idempotency keys where supported. Idempotency is validated by a pytest test that runs the script twice and asserts identical state.

**Score 2:** Idempotency addressed conceptually. Upsert pattern or existence check mentioned. But not all operations are idempotent (e.g., database writes use upsert but file writes use plain CREATE which fails on re-run).

**Score 1:** Idempotency mentioned as a goal. But no specific implementation pattern described. "We'll make sure it's idempotent" without specifics.

**Score 0:** Idempotency not mentioned even when the task specification explicitly requires it. Or script design clearly creates duplicates on re-run (e.g., INSERT without conflict handling, unconditional file creation).

---

### 4. Retry Strategy
**Weight:** MEDIUM

**Score 3:** External API calls and database operations include retry logic with exponential backoff. Uses tenacity (the Golden Model library for retries) with: `@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=4, max=60))`. Permanent errors (400, authentication failures) are not retried. Transient errors (500, timeout, connection reset) are retried. Dead-letter logging for records that fail all retries.

**Score 2:** Retry logic present using tenacity. Exponential backoff configured. But no distinction between permanent and transient errors — retries all failures including 400 (Bad Request) which will never succeed.

**Score 1:** Retry logic mentioned. tenacity imported. But configuration is minimal (e.g., `@retry` with no parameters — default behavior). Or retries only the top-level function call, not individual API calls.

**Score 0:** No retry strategy. Script fails on first transient error. Or uses `time.sleep` + loop instead of tenacity.

---

### 5. Structured Logging
**Weight:** MEDIUM

**Score 3:** structlog is used throughout — not print statements, not standard logging. Each log event includes context fields: timestamp, log level, script name, operation, record ID (where applicable), outcome (success/failure). Run summary is logged as a structured JSON event at the end: records processed, records modified, records failed, duration. Log levels are used correctly (DEBUG for trace, INFO for operations, WARNING for non-fatal issues, ERROR for failures that were handled, CRITICAL for abort conditions).

**Score 2:** structlog used. Context fields present. Log levels used correctly. But run summary not emitted as a structured event, or some operations still use print statements.

**Score 1:** structlog imported and used for some events. But most logging is print statements or standard logging. Context fields inconsistent.

**Score 0:** All logging via print statements. Or no logging at all. Or logging framework is not structlog (standard logging or loguru without justification).

---

### 6. Test Coverage for Automation-Specific Behavior
**Weight:** HIGH

**Score 3:** pytest tests cover all four automation-specific scenarios: (a) dry-run mode produces correct output and makes no changes, (b) idempotency — second run produces the same state as first run, (c) retry — transient failure is retried and succeeds on second attempt, (d) error handling — permanent failure is logged and script exits with non-zero code while processing remaining records. Tests use mocking for external dependencies (httpx.Client, database connection).

**Score 2:** Three of four automation-specific test scenarios present. Missing one scenario (usually the idempotency or retry test). External dependencies mocked.

**Score 1:** Basic happy-path tests present. One or two automation-specific tests. But dry-run and idempotency are not specifically tested — only implicit coverage from happy-path tests.

**Score 0:** No tests. Or tests exist but only test the happy path without any automation-specific scenario coverage.

---

## Aggregate Score Interpretation

**Maximum score:** 18 (6 dimensions x 3)

| Total Score | Interpretation |
|-------------|----------------|
| 16–18 | Excellent — automation script design is production-ready |
| 13–15 | Good — minor gaps in one dimension; ready for review with noted caveats |
| 9–12 | Acceptable — notable gaps in at least one HIGH dimension; revision needed before Gate 3 |
| 5–8 | Poor — multiple HIGH dimensions failing; script design is incorrect |
| 0–4 | Failing — wrong stack or missing critical features (dry-run, idempotency); start over |

**Critical failures (override the score):** A score of 0 on Stack Selection (web framework components present in an automation script) means the agent has failed the fundamental archetype classification and produced irrelevant output. This is a Gate A0 failure that should be escalated to Tech Lead for re-classification before any further evaluation. A score of 0 on both Dry-Run and Idempotency when the task explicitly required them means the two most important operational safety features are absent — the script could corrupt data in production on re-run.
