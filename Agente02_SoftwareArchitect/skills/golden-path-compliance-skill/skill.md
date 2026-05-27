# golden-path-compliance-skill

## Purpose

Validate a draft architecture against the Golden Model to identify all deviations that require an ADR, and produce a compliance report.

## When to Use

- After completing `Architecture.md` draft
- Before submitting to Gate 2
- When evaluating a technology change proposal

## Inputs

- Draft `Architecture.md`
- `context_view.md` (§1 Golden Path, §3 Rule Levels, §12 Anti-Patterns)
- `agent_config.json` (`adr_required_for` list)
- `checklists/golden_path_compliance_checklist.md`

## Outputs

- Compliance report appended to `Architecture_Decisions.md`
- List of required ADRs (if any)
- `COMPLIANT` or `REQUIRES_ADR` classification per decision

## Procedure

1. **Framework check** — Does Architecture.md use Next.js 16 App Router? proxy.ts? If not: flag for ADR.
2. **Database check** — PostgreSQL on Supabase via Prisma 7? If not: flag for ADR.
3. **Auth check** — NextAuth v5 + Google OAuth? If not: flag for ADR.
4. **Deploy check** — Vercel? If not: flag for ADR.
5. **Pattern check** — For each component in Architecture.md, verify against anti-patterns list (context_view.md §12).
6. **Additional services check** — Any service beyond the monorepo? If yes: flag for ADR.
7. **Migration check** — Is `prisma migrate deploy` the stated migration tool for staging/prod? If not: flag for ADR.
8. **Compile report** — For each deviation: state what deviates, which Golden Path item is affected, and whether an ADR is required based on `agent_config.json#adr_required_for`. A deviation triggers an ADR if and only if the violated item appears in the `adr_required_for` list. Do not add or remove ADR requirements based on judgment — use the list as the authority.
9. **Set golden_path_status** — FULLY_COMPLIANT, COMPLIANT_WITH_ADRS, or NON_COMPLIANT_PENDING_ADRS.

## Quality Gate

Compliance scan is complete when:
- Every item in `golden_path_compliance_checklist.md` is checked
- Every deviation has a corresponding ADR request
- `golden_path_status` is set correctly in Architecture.md header

## Failure Modes

- **False compliance:** Marking a deviation as compliant → Always re-check against `agent_config.json#adr_required_for`
- **Partial scan:** Checking technology stack only, not patterns → Must also check anti-patterns

## RAG Policy

Allowed at runtime: `architecture_reference_full` (context_view.md), `decision_rules_index` (knowledge/decision_rules.md)

## Knowledge Access Policy

Runtime reads: `Agente02_SoftwareArchitect/context_view.md`, `Agente02_SoftwareArchitect/knowledge/decision_rules.md`  
Blocked: `context/`, `lib/`, raw PDFs
