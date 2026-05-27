# Skill: secure-code-remediation-skill

## Purpose

Produce `Remediation_Guide.md` with specific, actionable fix guidance for every non-LOW finding in the security audit. Provides exact file paths, wrong code patterns, correct code patterns, and ordered remediation steps.

## When to Use

Any BLOCKED or RETURNED gate decision — mandatory companion to the gate block. Never run for APPROVED decisions.

## Inputs

- All findings (SEC-NNN) from all skills, classified by severity
- File paths and code snippets from security findings
- `Agente07_DevSecOps/templates/Remediation_Guide.md`

## Outputs

- `Remediation_Guide.md` — per-finding remediation with exact code patterns
- Systemic recommendations section if DR015 applies (same vulnerability in 3+ places)

## Constraints

- This skill provides guidance — it does NOT write the actual code fixes
- Every CRITICAL and HIGH finding must have a remediation item
- Every remediation item must include: wrong_pattern (exact code), correct_pattern (exact replacement)
- Systemic recommendations must be included when DR015 applies

## Steps

1. For each CRITICAL and HIGH finding: extract exact file path, line, and code snippet
2. Write the "wrong pattern" from the actual code
3. Write the "correct pattern" using Golden Path conventions — source patterns exclusively from `Agente07_DevSecOps/context_view.md` Section 4 (Golden Path security patterns); do not invent patterns from training data
4. List any additional steps (secret rotation, schema change, etc.)
5. Check if any vulnerability class appears in 3+ locations (DR015) — add systemic section
6. Produce `Remediation_Guide.md` following `templates/Remediation_Guide.md`
7. Include MEDIUM findings in the guide (optional but recommended)

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR014, DR015
- `Agente07_DevSecOps/knowledge/heuristics.md` → H15
- `Agente07_DevSecOps/context_view.md` → Section 4 (Golden Path security patterns)
- `Agente07_DevSecOps/templates/Remediation_Guide.md`

Do NOT access `context/` or `lib/` at runtime.
