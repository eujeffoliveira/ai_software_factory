# Automation Design

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Versão:** 1.0
**Referência:** `Automation_Brief.md`

---

## Fluxo de Execução

```
[Descreva o fluxo com numeração ou diagrama ASCII]

1. Startup — valida configuração e variáveis de ambiente
2. Leitura — busca dados da fonte
3. Validação — valida schema de entrada com Pydantic
4. Processamento — transforma/processa os dados
5. Validação de saída — valida resultado
6. Escrita — persiste no destino
7. Log de execução — registra run_id, status, contagens
8. Notificação (se aplicável)
```

---

## Módulos

| Módulo | Arquivo | Responsabilidade |
|--------|---------|-----------------|
| Entrypoint CLI | `src/nome/main.py` | Comandos Typer, flags, `--dry-run` |
| Config | `src/nome/config.py` | pydantic-settings, validação no startup |
| Models | `src/nome/models.py` | Schemas Pydantic de I/O |
| Serviço principal | `src/nome/services/[domínio].py` | Lógica de negócio |
| Integração externa | `src/nome/integrations/[api].py` | Cliente HTTP com retry |
| Utilitários | `src/nome/utils/logging.py` | Logger estruturado |
| Utilitários | `src/nome/utils/run_log.py` | Registro de execução |

---

## Estrutura do Projeto

```
nome-do-projeto/
├── pyproject.toml
├── .env.example
├── README.md
├── src/
│   └── nome_do_projeto/
│       ├── __init__.py
│       ├── main.py
│       ├── config.py
│       ├── models.py
│       ├── services/
│       │   └── [dominio].py
│       ├── integrations/
│       │   └── [api_externa].py
│       └── utils/
│           ├── logging.py
│           └── run_log.py
└── tests/
    ├── conftest.py
    ├── test_main.py
    └── services/
        └── test_[dominio].py
```

---

## Dependências

```toml
# pyproject.toml — [tool.uv.dependencies] ou [tool.poetry.dependencies]
python = ">=3.12"
typer = ">=0.12"
pydantic = ">=2.0"
pydantic-settings = ">=2.0"
httpx = ">=0.27"
tenacity = ">=8.0"
structlog = ">=24.0"
```

---

## Estratégia de Execução

**Modo normal:**
```bash
python -m nome_do_projeto run --config .env
```

**Dry-run:**
```bash
python -m nome_do_projeto run --dry-run
```

**Com argumentos:**
```bash
python -m nome_do_projeto run --date 2024-01-15 --limit 1000
```

---

## Limites e Premissas

| Item | Valor/Decisão |
|------|--------------|
| Timeout por chamada externa | [Ex: 30 segundos] |
| Máximo de retries | [Ex: 3] |
| Backoff | [Ex: exponencial 1s, 2s, 4s] |
| Tamanho de lote | [Ex: 100 registros por request] |
| Paralelismo | [Ex: sequencial / N workers] |

---

## Decisões de Design

| Decisão | Alternativa considerada | Razão |
|---------|------------------------|-------|
| [decisão] | [alternativa] | [razão] |
