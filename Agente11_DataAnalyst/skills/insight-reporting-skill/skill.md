# insight-reporting-skill

## Purpose

Convert metric definitions and evidence into decision-ready findings, confidence labels, recommendations, risks, and handoff notes.

## Trigger

Use this skill after analysis framing, metric definition, and EDA have enough evidence to support findings or explain why evidence is insufficient.

## Inputs

- Analysis brief
- Metric catalog
- EDA report or data quality review
- Findings and supporting evidence
- Open questions and risks

## Output

Produce `Insight_Report.md` and the insight portion of the Analysis Handoff Package.

## Procedure

1. Summarize the answer in one paragraph.
2. For each finding, state evidence, metric refs, confidence, caveats, recommendation, owner, and validation step.
3. Separate observations from causal claims.
4. Convert unresolved uncertainty into open questions or risks.
5. Run `checklist.md`.

## Knowledge Access Policy

This skill may consult only `Agente11_DataAnalyst/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, or another agent folder directly.

## Failure Handling

If evidence is insufficient, produce an insight report with `insufficient_evidence` findings and recommend the next data or experiment needed.
