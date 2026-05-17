# Risk Register — [Project Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Architect:** Agente02_SoftwareArchitect

---

## Summary

| Classification | Count | Blocking Gate 2 |
|----------------|-------|-----------------|
| CRITICAL | 0 | 0 |
| HIGH | 0 | 0 |
| MEDIUM | 0 | 0 |
| LOW | 0 | 0 |

---

## Risks

### RISK-001

**Classification:** [CRITICAL | HIGH | MEDIUM | LOW]  
**Category:** [security | data-protection | architecture | migration | performance | compliance | operational | dependency | cost]  
**Description:** [Clear description of what the risk is and how it could materialize]  
**Trigger condition:** [What would cause this risk to become an actual problem]  
**Mitigation:** [Concrete mitigation strategy — or "ESCALATED — requires human approval" for unmitigable CRITICAL]  
**Responsible:** [Agente02_SoftwareArchitect | Agente07_DevSecOps | Tech Lead | Human]  
**Status:** OPEN | MITIGATED | ACCEPTED | ESCALATED | RESOLVED  
**Blocks Gate 2:** Yes (CRITICAL unmitigated) | No  
**ADR reference:** [ADR-NNN if addressed by ADR]

---

### RISK-002

**Classification:** MEDIUM  
**Category:** migration  
**Description:** Initial schema migration adds a NOT NULL column to an existing table. If data backfill fails, column addition cannot complete.  
**Trigger condition:** Backfill query times out or encounters unexpected data.  
**Mitigation:** Use phased migration — Phase 1: add nullable column; Phase 2: backfill; Phase 3: add NOT NULL constraint.  
**Responsible:** Agente02_SoftwareArchitect (design) + Agente08_DevOps (execution)  
**Status:** MITIGATED  
**Blocks Gate 2:** No

---

## Escalated Risks (requiring human decision)

| RISK-ID | Description | Escalated to | Decision needed by |
|---------|-------------|-------------|-------------------|
| — | — | — | — |

---

## Risk Review Notes

[Any context about risk identification process, what was considered and ruled out, scope limitations]
