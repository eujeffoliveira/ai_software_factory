# Evaluation — AI Software Factory

How to test, evaluate, and prevent regression in agent behavior. The factory does not have automated end-to-end agent testing (no live API in CI), but provides a structured harness for human-in-the-loop and semi-automated evaluation.

---

## Evaluation Suite Overview

| Suite | Location | Type | Run with |
|-------|----------|------|---------|
| Smoke prompts | `tests/agent-smoke-prompts/` | Manual — predefined prompts with expected behavior | Copy-paste to Claude Code |
| Eval cases | `evals/cases/` | Semi-automated — JSON cases with expected_contains/must_not_contain | `.\evals\run-evals.ps1` |
| Rubrics | `evals/rubrics/` | Manual scoring — 0-3 scale per dimension | Used alongside eval cases |
| Factory validators | `tools/factory-validators/` | Automated — structural checks, no agent execution | `python tools/factory-validators/run_all.py` |
| MCP tests | `tools/mcp-knowledge-search/tests/` | Automated — 39 pytest tests | `python -m pytest tools/mcp-knowledge-search/tests/` |

---

## Smoke Prompts

Each file in `tests/agent-smoke-prompts/` contains pre-written prompts with expected behavior, pass/fail signals, and notes on what knowledge should be consulted.

### Available smoke tests

| File | Agent | What it tests |
|------|-------|--------------|
| `techlead.md` | @techlead | Gate A0 classification, gate enforcement, ADR trigger, State Ledger, escalation |
| `architect.md` | @architect | Golden Model compliance, ADR for deviations, security strategy, automation archetype |
| `qa.md` | @qa | Test plan generation, coverage threshold (80%), BDD alignment |
| `devsecops.md` | @devsecops | SQL injection detection, Gate 5 incontornável, secrets policy, LGPD |
| `dataengineer.md` | @dataengineer | Polars+DuckDB+Pandera stack, data quality checks, bronze/silver/gold |
| `dataanalyst.md` | @dataanalyst | Metric definitions, confidence labels, causal guardrails, dashboard specs |
| `automation-script-flow.md` | All | Full flow: classification → PRD → architecture → plan (no web_app stack) |
| `mcp-first.md` | All | MCP search triggered, no hallucinated content, fallback behavior |
| `web-app-flow.md` | All | web_app Golden Model compliance end-to-end |
| `governance-licensing.md` | All | Dual licensing, secrets policy, copyright, Code of Conduct |

### How to run a smoke test

1. Open the smoke test file:
   ```powershell
   code tests/agent-smoke-prompts/techlead.md
   ```
2. Copy the prompt from the file
3. Paste into a Claude Code session
4. Compare the response against "Expected behavior" and "Pass/Fail signals"

---

## Evaluation Cases (evals/cases/)

JSON files with structured test cases for semi-automated evaluation.

### Available cases

| File | Agent | Key discriminator |
|------|-------|-------------------|
| `web_app_architecture.json` | @architect | Next.js 16 stack, 15 expected terms |
| `python_automation.json` | @techlead | automation_script classification, NOT web_app |
| `data_pipeline.json` | @techlead | Polars+DuckDB, NOT pandas+SQLAlchemy |
| `security_review.json` | @devsecops | SQL injection → OWASP A03 → BLOCKED |
| `mcp_first_behavior.json` | @techlead | MCP search called before answering |
| `project_archetype_classification.json` | @techlead | 3 descriptions → correct archetype each |
| `licensing_governance_awareness.json` | @techlead | Apache-2.0 (code) ≠ CC BY 4.0 (docs) |

### Case file format

```json
{
  "name": "case_name",
  "description": "what this tests",
  "agent": "techlead",
  "archetype": "automation_script",
  "gate": "A0",
  "prompt": "the exact prompt to send to the agent",
  "expected_contains": ["string1", "string2"],
  "must_not_contain": ["string1", "string2"],
  "rubric": "rubric_filename",
  "notes": "evaluation notes"
}
```

### Running with the harness

```powershell
# Run all cases interactively
.\evals\run-evals.ps1

# Run a single case
.\evals\run-evals.ps1 -CaseName python

# Run with rubric guidance
.\evals\run-evals.ps1 -CaseName security -RubricName devsecops_rubric

# List all cases without running
.\evals\run-evals.ps1 -NonInteractive
```

Results are saved to `evals/results/<timestamp>-results.json`.

---

## Rubrics

Rubrics in `evals/rubrics/` provide scoring guidance for each agent and topic. Each dimension scores 0-3.

| Rubric | Target | Dimensions | Max score |
|--------|--------|-----------|-----------|
| `techlead_rubric.md` | @techlead | Archetype classification, gate enforcement, State Ledger, ADR, risks, MCP, escalation, delegation | 24 |
| `architect_rubric.md` | @architect | Golden Model compliance, ADR, security strategy, observability, API contract, DB schema, testing | 21 |
| `qa_rubric.md` | @qa | Coverage adequacy, Vitest/Playwright distinction, edge cases, BDD alignment, performance | 15 |
| `devsecops_rubric.md` | @devsecops | OWASP Top 10, threat model, secrets policy, LGPD, Gate 5 blocking | 15 |
| `dataengineer_rubric.md` | @dataengineer | Pipeline archetype selection, Pandera quality, idempotency, bronze/silver/gold | 15 |
| `dataanalyst_rubric.md` | @dataanalyst | Metric definitions, data quality, causality, confidence, recommendations | 15 |
| `automation_script_rubric.md` | Any agent | automation_script stack, dry-run, idempotency, retry, secrets | 18 |
| `mcp_first_rubric.md` | All agents | MCP search triggered, source citation, no hallucination, fallback | 15 |
| `governance_rubric.md` | All agents | Dual licensing, secrets, copyright, governance awareness | 15 |

### Scoring guide

| Score | Meaning |
|-------|---------|
| 3 | Excellent — complete, accurate, specific |
| 2 | Correct but missing nuance |
| 1 | Partial — present but incomplete |
| 0 | Absent or completely wrong |

**Critical failures:** A score of 0 on any HIGH-weight dimension should flag the response as FAIL regardless of aggregate score.

---

## Manual Evaluation

When running a smoke test or eval case manually:

1. **Copy the prompt** from the test file
2. **Send to agent** in Claude Code
3. **Check expected_contains** — each string should appear in the response
4. **Check must_not_contain** — none of these strings should appear
5. **Apply the rubric** if a deep evaluation is needed
6. **Record the result** — PASS / PARTIAL / FAIL with notes

### PASS criteria
- All `expected_contains` items present
- No `must_not_contain` items present
- No hallucinated content (invented artifacts, wrong status codes)

### FAIL criteria
- Any `must_not_contain` item present
- Critical omissions in `expected_contains`
- Fabricated content (agent invented facts not in knowledge base)

### PARTIAL criteria
- Most but not all `expected_contains` present
- Minor inaccuracies without wrong recommendations

---

## Regression Prevention

### After agent file changes

Any time `prompt.md` or `knowledge/` files change:

```powershell
.\install.ps1                    # re-generates all ~/.claude/agents/ files
python tools/factory-validators/run_all.py  # structural validation
```

Then run the affected smoke tests manually.

### After knowledge.db changes

```powershell
.\update-knowledge.ps1           # reindex
.\test-mcp.ps1                   # verify 7 checks pass
```

Run `tests/agent-smoke-prompts/mcp-first.md` to verify MCP behavior.

### Regression test prioritization

When time is limited, these smoke tests are the highest priority:

1. `automation-script-flow.md` — prevents automation → web_app misclassification
2. `techlead.md` → Smoke Test 2 (Gate Enforcement)
3. `devsecops.md` → Smoke Test 2 (Gate 5 incontornável)
4. `mcp-first.md` → Smoke Test 3 (no hallucination)

---

## Creating New Eval Cases

To add a new case:

1. Create `evals/cases/<name>.json` following the format above
2. Add a corresponding entry in `evals/rubrics/` if needed
3. Optionally add a smoke prompt in `tests/agent-smoke-prompts/`
4. Document it in this file under "Available cases"

Good candidates for new cases:
- Regression cases when a real failure is observed
- New archetypes when added to `standards/`
- New agents when added to the factory
- New security patterns (OWASP updates)

---

## CI Integration

Factory validators and MCP tests run automatically in CI (`.github/workflows/validate-factory.yml`). Agent behavior tests are **not** automated in CI because they require a live Claude API session.

For teams that want automated agent evaluation, consider:
- Anthropic Workbench with prompt caching
- Custom eval harness using the Claude API + `expected_contains` checks
- Snapshot testing of agent responses for known prompts

---

## Interpreting Results

| Result | Action |
|--------|--------|
| PASS on all smoke tests | Agent installation is healthy |
| FAIL on archetype classification | Run `.\install.ps1`, check `~/.claude/agents/techlead.md` |
| FAIL on Gate 5 blocking | Reinstall agent, check Gate 5 in `quality_gate.md` |
| FAIL on MCP-first | Run `.\test-mcp.ps1`, check `knowledge.db` exists |
| PARTIAL on Golden Model | Check agent knowledge — might need `.\update-knowledge.ps1` |
