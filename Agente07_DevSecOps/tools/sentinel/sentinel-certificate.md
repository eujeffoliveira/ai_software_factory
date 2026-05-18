# SENTINEL Security Certificate

## Resumo
- **Projeto**: {{project_name}}
- **Data**: {{date}}
- **SSS Final**: {{sss}}/100
- **Modo**: {{mode}} (DEFENSIVE | HYBRID | OFFENSIVE)
- **Status**: {{status}} (CONVERGED | FORCE_STOP | AUDIT_ONLY)
- **Ciclos**: {{cycles}}
- **Findings**: {{total_findings}} total, {{fixed}} fixed, {{remaining}} pending

---

## Scores por Dimensao

| Dimensao | Score | Status |
|----------|-------|--------|
| S1-SHIELD | {{s1}} | {{s1_status}} |
| S2-GATES  | {{s2}} | {{s2_status}} |
| S3-WALLS  | {{s3}} | {{s3_status}} |
| S4-VAULT  | {{s4}} | {{s4_status}} |
| S5-STRESS | {{s5}} | {{s5_status}} |
| S6-GUARD  | {{s6}} | {{s6_status}} |

**Legenda:**
- S1-SHIELD: Autenticação e autorização
- S2-GATES: Validação de inputs (Zod em todas as boundaries)
- S3-WALLS: Headers de segurança, CORS, CSP
- S4-VAULT: Secrets, env vars, dados sensíveis
- S5-STRESS: Testes de carga (k6), rate limiting
- S6-GUARD: Logging de auditoria, monitoramento

---

## Vulnerabilidades por Severidade

### CRITICAL
{{critical_findings}}

### HIGH
{{high_findings}}

### MEDIUM
{{medium_findings}}

### LOW
{{low_findings}}

---

## Load Test Results (k6)

| Cenario | VUs | p50 | p90 | p95 | p99 | Error Rate | Status |
|---------|-----|-----|-----|-----|-----|------------|--------|
{{load_test_table}}

---

## LGPD Compliance

| Check | Status |
|-------|--------|
| PII mascarado em logs | {{pii_logs}} |
| Audit trail ativo | {{audit_trail}} |
| Export de dados | {{data_export}} |
| Exclusao de dados | {{data_deletion}} |
| Termos de uso | {{terms}} |
| Politica de privacidade | {{privacy_policy}} |

---

## Recomendacoes Priorizadas

{{recommendations}}

---

## Como usar este certificado

1. Execute a auditoria de segurança do Agente07_DevSecOps
2. Preencha cada campo `{{placeholder}}` com os resultados reais
3. O certificado é emitido apenas quando SSS >= 80
4. Attach ao handoff package antes do Gate 5

---

*Gerado por Agente07_DevSecOps em {{timestamp}}*
*Template migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/sentinel*
