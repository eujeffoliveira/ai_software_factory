# Golden Model — Python Automation (`automation_script`)

**Archetype:** `automation_script`
**Applies to:** Scripts de automação, rotinas operacionais, integrações pontuais, tarefas agendadas, processamento de arquivos, ETL simples/médio, tarefas com leitura/escrita em APIs externas, automações locais ou agendadas.
**Default language:** Python 3.12+
**Does NOT apply to:** Aplicações web com UI, pipelines de dados em escala industrial (use `data_pipeline`).

---

## Stack Obrigatória

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Python 3.12+ |
| Gerenciador de pacotes | uv (preferido) ou Poetry |
| Definição de projeto | `pyproject.toml` |
| CLI | Typer |
| Config / env | pydantic-settings |
| Validação | Pydantic v2 |
| HTTP client | httpx |
| Retry / backoff | tenacity |
| Logs | structlog (preferido) ou logging com JSON handler |
| Testes | pytest |
| Mock HTTP | respx ou pytest-httpx |
| Lint / format | ruff |
| Typecheck | mypy ou pyright |
| Estado local simples | SQLite (via stdlib `sqlite3` ou `sqlmodel`) |
| Dados tabulares | Polars (preferido) ou Pandas |
| Empacotamento | Módulo Python com entrypoint CLI via `pyproject.toml` |
| Secrets | `.env` local + `pydantic-settings` / variáveis de ambiente / secret manager |

---

## Estrutura de Projeto Obrigatória

```
nome-do-projeto/
├── pyproject.toml          # Definição de projeto, deps, entrypoints
├── .env.example            # Template de variáveis — sem valores reais
├── README.md               # Uso, configuração, exemplos
├── src/
│   └── nome_do_projeto/
│       ├── __init__.py
│       ├── main.py         # Entrypoint CLI com Typer
│       ├── config.py       # pydantic-settings com validação no startup
│       ├── models.py       # Modelos Pydantic de I/O
│       ├── services/       # Lógica de negócio por domínio
│       ├── integrations/   # Clientes HTTP para APIs externas
│       └── utils/          # Utilitários (log, retry, helpers)
└── tests/
    ├── conftest.py
    ├── test_main.py
    └── services/
```

---

## Regras Obrigatórias

1. **Idempotência é inegociável.** Todo script que altera dados externos deve tolerar reexecução com o mesmo input produzindo o mesmo resultado. Checkpoints e estado local são bem-vindos.

2. **`--dry-run` em qualquer operação de escrita.** Todo script que escreve em sistema externo, apaga dados ou envia notificações deve suportar `--dry-run` — executa toda a lógica sem efeitos externos.

3. **Run log obrigatório para scripts recorrentes.** Toda execução deve registrar: `run_id`, timestamp de início/fim, status (`success`/`failure`/`partial`), contagens, erros.

4. **Configuração validada no startup.** `config.py` com `pydantic-settings` valida todas as variáveis de ambiente na inicialização. Script falha rápido se configuração estiver incompleta.

5. **Toda resposta externa validada com Pydantic.** Payloads de APIs externas são não-confiáveis. Definir schema Pydantic para cada resposta e validar antes de usar.

6. **Retry com backoff em chamadas externas críticas.** Usar `tenacity` com `retry`, `wait_exponential`, e `stop_after_attempt` para toda chamada de API que pode falhar transitoriamente.

7. **Operações destrutivas exigem confirmação explícita.** Delete, truncate, sobrescrever arquivo — requer flag `--force` ou `--confirm` além do `--dry-run`.

8. **Sem segredos hardcoded.** Zero tolerância. Nenhum token, senha, chave de API, connection string no código.

9. **Sem caminhos absolutos hardcoded.** Usar `pathlib.Path` relativo ao projeto ou configurável via variável de ambiente.

10. **Logs estruturados em JSON.** Usar `structlog` ou `logging` com formatter JSON. Campos obrigatórios: `timestamp`, `level`, `event`, `run_id`.

11. **Erros tratados explicitamente.** Sem `except Exception: pass`. Cada exceção esperada tem tratamento específico. Exceções não esperadas são logadas e relançadas ou terminam o script com exit code != 0.

12. **README ou Runbook de execução.** Todo script tem documentação de como executar, configurar, agendar e investigar falhas.

13. **`.env.example` com todas as variáveis documentadas.** Sem valores reais. Com comentários explicando o que cada variável faz.

14. **Testes mínimos com pytest.** Cobertura mínima: happy path, edge cases, cenários de erro, dry-run, idempotência.

15. **Automações agendadas documentam frequência, responsável e plano de falha.** No Runbook: cron expression, dono, o que fazer se falhar, como reprocessar.

---

## Antipadrões Críticos

| Antipadrão | Consequência |
|-----------|-------------|
| Script monolítico sem funções | Impossível testar, manter ou reusar |
| Script sem `main()` / entrypoint | Não empacotável, não testável |
| Escrita em sistema externo sem `--dry-run` | Efeitos colaterais irreversíveis em desenvolvimento/testes |
| Segredo hardcoded | Comprometimento de credenciais |
| Caminho absoluto fixo (`/home/user/...`) | Não portável, falha em outros ambientes |
| `print()` como única observabilidade | Produção cega, impossível diagnosticar |
| `except Exception: pass` | Falhas silenciosas, dados corrompidos |
| Ausência de retry em API externa instável | Falhas transitórias viram falhas permanentes |
| Ausência de validação de payload externo | Dados malformados corrompem estado interno |
| Ausência de testes | Nenhuma garantia de correção |
| Ausência de runbook | Operação dependente de conhecimento tácito |
| Ausência de idempotência | Duplicação de dados em reprocessamento |
| Ausência de run log | Impossível auditar, investigar ou detectar falhas |
| Sobrescrever dados sem backup ou confirmação | Perda de dados irreversível |

---

## Gates para `automation_script`

### Gate A0 — Project Archetype Classification
- Arquétipo declarado como `automation_script`
- Golden Model `python_automation` selecionado
- Agentes necessários definidos
- Artefatos obrigatórios listados
- Itens não aplicáveis declarados

### Gate A1 — Automation Design Review
- Objetivo claro e mensurável
- Entradas e saídas definidas com schema
- Sistemas externos mapeados
- Idempotência planejada
- `--dry-run` definido quando aplicável
- Frequência/agendamento definido
- Riscos documentados

### Gate A2 — Implementation Readiness
- Estrutura de projeto Python definida (`pyproject.toml`, `src/`, `tests/`, `.env.example`)
- Dependências declaradas no `pyproject.toml`
- Config e secrets mapeados via `pydantic-settings`
- Plano de logs definido (campos obrigatórios)
- Estratégia de retry definida
- Plano de testes definido

### Gate A3 — Automation QA
- `pytest` passa sem warnings
- `ruff check` passa
- `mypy`/`pyright` passa (se configurado)
- `--dry-run` testado e não produz efeitos
- Cenários de erro cobertos (API down, payload malformado, timeout)
- Retry/backoff testado com mock
- Idempotência testada (executar 2x → mesmo resultado)

### Gate A4 — Security & Secrets Review
- Nenhum segredo hardcoded (grep por padrões de token/senha)
- `.env.example` sem valores reais
- Permissões mínimas para credenciais externas
- Logs não vazam dados sensíveis
- Dados pessoais protegidos conforme LGPD

### Gate A5 — Operational Readiness
- Runbook existe e está completo
- Frequência e agendamento documentados
- Responsável identificado
- Procedimento de falha documentado
- Como reprocessar documentado
- Logs revisáveis e estruturados
- Plano de rollback/compensação quando aplicável

---

## Artefatos Obrigatórios

| Artefato | Gate | Descrição |
|----------|------|-----------|
| `Automation_Brief.md` | A1 | Objetivo, gatilho, frequência, entradas, saídas, sistemas, responsável |
| `Automation_Design.md` | A1 | Fluxo, módulos, dependências, estrutura do projeto |
| `Input_Output_Contract.md` | A1 | Schema de entrada e saída com validações |
| `Config_And_Secrets.md` | A2 | Variáveis de ambiente, secrets, permissões |
| `Idempotency_Plan.md` | A2 | Chave de idempotência, checkpoints, comportamento em reprocessamento |
| `Error_Handling_Plan.md` | A2 | Retry, backoff, falhas não recuperáveis, alertas |
| `Observability_Log_Spec.md` | A2 | Eventos de log, campos obrigatórios, run_id |
| `Test_Plan.md` | A2 | Testes unitários, mocks, cenários de erro |
| `Runbook.md` | A5 | Como executar, agendar, reprocessar, investigar |

Templates em: `templates/automation/`
Checklists em: `checklists/automation/`
