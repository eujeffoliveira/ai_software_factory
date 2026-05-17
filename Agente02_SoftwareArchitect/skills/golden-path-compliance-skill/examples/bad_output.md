# Bad Output — golden-path-compliance-skill

❌ Compliance scan declared FULLY_COMPLIANT despite:
- Architecture uses middleware.ts (deviation from Golden Path)
- Architecture proposes MongoDB (deviation — requires ADR)
- Architecture uses `prisma db push` for staging (anti-pattern)

❌ No deviations list produced

❌ Architecture_Decisions.md not updated

Result: Gate 2 Tech Lead review catches the deviations and returns BLOCKED_PENDING_ADR.
