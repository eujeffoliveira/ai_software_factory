# Skill: threat-modeling-skill

## Purpose

Create or validate STRIDE threat models for features involving authentication, authorization, or sensitive data handling. Produces `Threat_Model.md` that covers all six STRIDE categories with specific threats, mitigations, and open threat dispositions.

## When to Use

- **Trigger automatically when:** A feature touches `auth()`, role-based access control, user session handling, or CONFIDENTIAL/RESTRICTED data — AND `Threat_Model.md` is absent or incomplete
- **Trigger when:** An existing `Threat_Model.md` does not cover all six STRIDE categories (S, T, R, I, D, E)
- **Trigger when:** The feature adds new trust boundaries not covered by an existing threat model
- **Skip when:** The feature handles only PUBLIC and INTERNAL data with no auth, no mutations, and no external integrations (e.g., a static content page)

## Inputs

- `Architecture.md` — system design, component relationships, data flows
- `API_Contract.json` — endpoints, auth requirements, request/response shapes
- `prisma/schema.prisma` — data models and relationships
- Implementation files — actual code to verify mitigations are implemented, not just planned
- Existing `Threat_Model.md` (if present — for gap analysis)

## Outputs

- `Threat_Model.md` — complete STRIDE threat model following `templates/Threat_Model.md`
- Finding entries in Security_Audit.md for any STRIDE threats without implemented mitigations
- Structured assessment of open threats for Gate 5 sign-off

## Constraints

- Do NOT skip any of the six STRIDE categories — all must be analyzed
- Do NOT accept "N/A" for Repudiation or Denial of Service without specific justification
- Do NOT mark mitigations as IMPLEMENTED without verifying the actual code — check the referenced file
- If insufficient architecture information exists to model threats accurately, issue `BLOCKED_PENDING_HUMAN`
- Threat model must reflect the current implementation — not the intended design

## Steps

1. **Identify trust boundaries**: From Architecture.md and the feature's data flow, list every point where data crosses a trust boundary (browser → server, server → DB, external API call, cron invocation)
2. **Identify assets**: List all data and functionality worth protecting; classify each asset
3. **For each STRIDE category**: Generate threats for each trust boundary and data store; assess likelihood and impact; identify the specific code mitigation; verify the mitigation is actually implemented
4. **Document open threats**: List any threats without an implemented mitigation; assign disposition (ACCEPTED, ESCALATED, DEFERRED, or MITIGATING_CONTROL_PLANNED)
5. **Produce Threat_Model.md**: Follow the `templates/Threat_Model.md` structure exactly
6. **Feed results to security-audit-report-skill**: Any MISSING mitigations for HIGH/CRITICAL impact threats become Gate 5 findings

## Knowledge Access Policy

At runtime, this skill reads exclusively from:
- `Agente07_DevSecOps/knowledge/principles.md` → P1 (security by design), P9 (STRIDE)
- `Agente07_DevSecOps/knowledge/knowledge_cards.md` → Card 001 (STRIDE), Card 003 (IDOR), Card 009 (data classification)
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR009 (threat model required)
- `Agente07_DevSecOps/templates/Threat_Model.md`
- `Agente07_DevSecOps/schemas/threat_model.schema.json`

Do NOT access `lib/`, `context/`, or any raw bibliography source at runtime.
