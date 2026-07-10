# semantic-modeling-dax-skill

## Purpose

Design or review semantic model requirements, relationships, DAX measures, storage mode, scale settings, Direct Lake behavior, incremental refresh, and model security.

## Trigger

Use this skill when the request mentions semantic model, DAX, CALCULATE, time intelligence, calculation groups, dynamic format strings, field parameters, star schema, Direct Lake, composite models, large models, XMLA, PBIP, or incremental refresh.

## Inputs

- Metric catalog
- Tables, columns, relationships, and grain
- Storage mode constraints
- Security requirements
- Performance or scale requirements

## Output

Produce or enrich `Semantic_Model_Spec.md`.

## Procedure

1. Confirm business domain, decisions, consumers, storage mode, and refresh cadence.
2. Define tables by type: fact, dimension, bridge, helper, or calculation table.
3. Define grain for every table.
4. Review relationships, cardinality, and filter direction.
5. Map measures to metric IDs and DAX patterns.
6. Specify scale/performance settings, Direct Lake fallback, large model, incremental refresh, or aggregations.
7. Specify RLS, CLS, OLS, sensitivity labels, deployment, PBIP/version control, XMLA needs, and downstream dependencies.
8. Run the checklist.

## Knowledge Access Policy

This skill may consult only `Agente11_DataAnalyst/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, external downloads, or another agent folder directly.

## Failure Handling

If metrics, grain, relationships, or storage mode are unclear, return a partial model spec with blocking questions.
