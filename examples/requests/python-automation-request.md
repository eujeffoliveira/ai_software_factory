# Example Request — Python Automation

**Arquétipo:** `automation_script`
**Golden Model:** Python Automation (Python 3.12+)

---

## Como usar com Claude Code

```
@techlead Este projeto é uma automação Python para consultar a API do ERP,
extrair os pedidos do dia anterior e gerar um relatório CSV consolidado
que é enviado por email para o time financeiro.

Classifique como automation_script e conduza o fluxo usando o Golden Model Python Automation.

Requisitos:
- Execução diária às 07:00
- Deve ter --dry-run
- Deve registrar logs estruturados
- Deve evitar duplicidade (idempotência por data)
- Deve validar payloads da API do ERP
- Deve gerar runbook
- Deve ter testes com pytest
```

```
@engineer Planeje a implementação da automação de relatório de pedidos.
Arquétipo: automation_script. Stack: Python 3.12, uv, Typer, Pydantic v2, httpx, tenacity, structlog, pytest.
Gere as tarefas atômicas necessárias.
```

```
@qa Valide esta automação usando os gates do arquétipo automation_script.
Gates: A0 (classificação), A1 (design), A2 (implementação), A3 (QA), A4 (segurança), A5 (operacional).
Checklists disponíveis em: checklists/automation/
```

```
@devsecops Revise a automação de relatório de pedidos para:
- Segredos hardcoded
- Logs sem PII
- Permissões mínimas nas credenciais da API do ERP
- LGPD: dados financeiros de clientes
```

```
@dataengineer Revise a estratégia de idempotência e integração com a API do ERP.
A automação deve processar pedidos do dia anterior sem duplicar registros.
Valide o contrato de Input/Output e o plano de checkpoints.
```
