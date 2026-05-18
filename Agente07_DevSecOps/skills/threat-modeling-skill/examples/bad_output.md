# Bad Output — Threat Modeling Skill

See `Agente07_DevSecOps/examples/bad_threat_model.md` for the full annotated bad example.

**Key quality failures:**
- Only 2 of 6 STRIDE categories covered (Tampering, Repudiation, DoS, Elevation missing)
- No trust boundaries defined
- No asset classification
- Threats are category descriptions, not specific attack vectors
- Mitigations are assumptions ("we use NextAuth"), not verified code references
- No open threats section
