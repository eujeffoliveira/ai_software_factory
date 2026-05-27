# Handoff to QA

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Gate de destino:** A3 (Automation QA)
**Data:** [YYYY-MM-DD]

---

## Resumo do que foi implementado

[Descreva em 3–5 frases o que foi implementado, o que o script faz e como funciona.]

---

## Como configurar o ambiente de teste

```bash
git clone [repo]
cd nome-do-projeto
uv sync

# Configurar .env para testes
cp .env.example .env.test
# Preencher com credenciais de ambiente de staging/sandbox
```

---

## Como executar

```bash
# Normal
uv run python -m nome_do_projeto run

# Dry-run
uv run python -m nome_do_projeto run --dry-run

# Testes automatizados
uv run pytest -v
```

---

## O que testar

| Cenário | Como testar | Critério de aprovação |
|---------|------------|----------------------|
| Happy path | `uv run pytest tests/test_happy_path.py` | Exit 0, output esperado |
| Dry-run | `python -m nome run --dry-run` | Zero efeitos no destino |
| Idempotência | Executar 2x | Mesmo estado após 2 execuções |
| API down | Usar `respx_mock` ou desligar VPN | Retry 3x + exit 1 com log |
| Config inválida | Remover `API_KEY` do env | Exit 1 com mensagem clara |

---

## Artefatos de referência

- [ ] `Automation_Brief.md` — objetivo e contexto
- [ ] `Automation_Design.md` — fluxo e módulos
- [ ] `Input_Output_Contract.md` — schemas
- [ ] `Idempotency_Plan.md` — estratégia
- [ ] `Error_Handling_Plan.md` — erros esperados
- [ ] `Observability_Log_Spec.md` — eventos de log

---

## Riscos e pontos de atenção

| Risco | Mitigação |
|-------|-----------|
| [risco conhecido] | [o que foi feito] |

---

## Contato do implementador

[Nome] — [slack/email]
