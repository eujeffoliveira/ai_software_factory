# Runbook

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Responsável:** [Nome/Time]
**Última atualização:** [YYYY-MM-DD]

---

## Pré-requisitos

- Python 3.12+
- uv instalado: `pip install uv`
- Acesso às variáveis de ambiente (ver `Config_And_Secrets.md`)

---

## Instalação

```bash
git clone [repo]
cd nome-do-projeto
uv sync
cp .env.example .env
# Preencher .env com as credenciais reais
```

---

## Execução

### Normal

```bash
uv run python -m nome_do_projeto run
```

### Dry-run (sem efeitos externos)

```bash
uv run python -m nome_do_projeto run --dry-run
```

### Com parâmetros

```bash
uv run python -m nome_do_projeto run --date 2024-01-15 --limit 500
```

### Ver ajuda

```bash
uv run python -m nome_do_projeto --help
uv run python -m nome_do_projeto run --help
```

---

## Agendamento

| Campo | Valor |
|-------|-------|
| Frequência | [Ex: diário às 06:00] |
| Cron expression | [Ex: `0 6 * * 1-5`] |
| Como agendar | [Ex: GitHub Actions / cron local / Task Scheduler] |
| Exemplo de configuração | [snippet do scheduler] |

---

## Como Reprocessar

```bash
# Reprocessar data específica
uv run python -m nome_do_projeto run --date 2024-01-15 --force-reprocess

# Limpar estado de idempotência e reprocessar tudo
uv run python -m nome_do_projeto reset --date 2024-01-15
uv run python -m nome_do_projeto run --date 2024-01-15
```

---

## Investigação de Falhas

### 1. Ver logs do último run

```bash
# Se log em arquivo:
tail -100 logs/run.log | python -m json.tool

# Se log em banco:
sqlite3 runs.db "SELECT * FROM run_log ORDER BY started_at DESC LIMIT 5"
```

### 2. Verificar configuração

```bash
uv run python -m nome_do_projeto check-config
```

### 3. Testar conectividade com API externa

```bash
uv run python -m nome_do_projeto test-connection
```

### 4. Executar em dry-run para diagnóstico

```bash
uv run python -m nome_do_projeto run --date [data] --dry-run --log-level DEBUG
```

---

## Problemas Comuns

| Problema | Sintoma | Causa provável | Solução |
|---------|---------|----------------|---------|
| `ValidationError on startup` | Script encerra imediatamente | Variável de ambiente ausente | Verificar `.env` e exportar variável |
| `HTTP 401` | Log de `api_call_failed` com status 401 | API Key inválida ou expirada | Renovar credencial em `API_KEY` |
| `TimeoutError` após 3 retries | Log de `api_failed` | API lenta ou indisponível | Aguardar e reexecutar; verificar status da API |
| Script executou mas não processou nada | Log de `processing_started` com `total_input: 0` | Filtro muito restrito ou fonte vazia | Verificar parâmetros e fonte de dados |
| Dados duplicados no destino | Contagem dobrada | Idempotência não funcionando | Ver `Idempotency_Plan.md`; resetar estado e reprocessar |

---

## Como Pausar / Desativar

```bash
# Se agendado via cron — remover linha do crontab
crontab -e

# Se agendado via GitHub Actions — desabilitar workflow na UI
# Settings > Actions > Workflows > [nome] > Disable workflow
```

---

## Contato e Escalação

| Situação | Contato |
|----------|---------|
| Falha operacional | [Nome/time] — [slack/email] |
| Credencial expirada | [admin] |
| Mudança na API externa | [responsável pela integração] |
