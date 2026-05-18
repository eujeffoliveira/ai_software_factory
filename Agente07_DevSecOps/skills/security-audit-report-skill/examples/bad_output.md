# Bad Output — Security Audit Report Skill

See `Agente07_DevSecOps/examples/bad_security_audit.md` for the annotated bad example.

**Key quality failures:**
- APPROVED issued despite CRITICAL findings not checked
- No OWASP table (only 4 categories mentioned)
- No file references in any section
- "Security looks fine" is not a gate decision rationale
- Handoff Package missing — no gate_ready field
