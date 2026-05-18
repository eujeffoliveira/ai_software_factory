# Bad Output — Privacy Review Skill

See `Agente07_DevSecOps/examples/bad_privacy_assessment.md` for the annotated bad example.

**Key quality failures:**
- No data classification (just "basic user information")
- Legal basis is "team follows LGPD/GDPR generally" — not evidence
- No consent assessment
- "Data can be deleted if needed" — not verified in Prisma schema
- No third-party DPA check
- COMPLIANT issued without any supporting evidence
