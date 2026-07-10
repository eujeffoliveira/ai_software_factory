# analysis-question-framing-skill

## Purpose

Convert a vague analytics request into a scoped `Analysis_Brief.md` that can be reviewed, answered, or returned for missing context.

## Trigger

Use this skill when the request includes words such as analysis, insight, KPI, dashboard, trend, funnel, cohort, retention, churn, conversion, revenue, adoption, or performance and the decision frame is incomplete.

## Inputs

- Business question or stakeholder request
- Product context or PRD excerpt
- Available data sources, if known
- Existing metrics, if known
- Constraints, assumptions, and deadlines

## Output

Produce an analysis brief with:

- Decision supported
- Business question
- Population and exclusions
- Time window
- Comparison baseline
- Candidate metrics
- Available data context
- Assumptions and limitations
- Open questions routed to an owner

## Procedure

1. Restate the request as a decision.
2. Identify population, time window, and comparison baseline.
3. List available data sources and unknowns.
4. Draft candidate metrics and mark definition status.
5. Separate assumptions from open questions.
6. Mark blocking questions.
7. Run `checklist.md`.

## Knowledge Access Policy

This skill may consult only `Agente11_DataAnalyst/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, or another agent folder directly.

## Failure Handling

If the decision, population, or available data context is missing, return a scoped gap list instead of inventing the answer.
