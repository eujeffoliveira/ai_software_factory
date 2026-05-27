# Automation Brief

**Projeto:** [Nome do script/automação]
**Arquétipo:** `automation_script`
**Data:** [YYYY-MM-DD]
**Responsável:** [Nome]
**Versão:** 1.0

---

## Objetivo

[Descreva em 2–3 frases o que esta automação faz e por que existe.]

**Resultado esperado:**
[O que deve existir/acontecer após a execução bem-sucedida?]

---

## Gatilho

- [ ] Manual (execução sob demanda)
- [ ] Agendado (cron) — Frequência: `[cron expression]` — Ex: `0 6 * * 1-5` (seg–sex às 6h)
- [ ] Evento (webhook, fila)
- [ ] Dependência de outro job

**Detalhes do gatilho:**
[Quem aciona, quando, como.]

---

## Frequência e Janela de Execução

| Campo | Valor |
|-------|-------|
| Frequência | [Ex: diário, semanal, sob demanda] |
| Cron expression | [Ex: `0 6 * * 1-5`] |
| Janela esperada | [Ex: 5–10 minutos] |
| Timeout máximo | [Ex: 30 minutos] |
| Tolerância a atraso | [Ex: até 1 hora] |

---

## Entradas

| Campo | Tipo | Origem | Obrigatório | Descrição |
|-------|------|--------|:-----------:|-----------|
| [campo] | [tipo] | [origem] | [S/N] | [descrição] |

**Fontes de entrada:**
- [ ] Arquivo (CSV, JSON, XLSX) — Caminho: `[path]`
- [ ] API externa — Endpoint: `[url]`
- [ ] Banco de dados — Tabela/query: `[detalhes]`
- [ ] Variáveis de ambiente / configuração
- [ ] Argumentos CLI

---

## Saídas

| Campo | Tipo | Destino | Descrição |
|-------|------|---------|-----------|
| [campo] | [tipo] | [destino] | [descrição] |

**Destinos de saída:**
- [ ] Arquivo (CSV, JSON, XLSX) — Caminho: `[path]`
- [ ] API externa — Endpoint: `[url]`
- [ ] Banco de dados — Tabela: `[nome]`
- [ ] E-mail / notificação
- [ ] Log apenas (sem persistência)

---

## Sistemas Envolvidos

| Sistema | Papel | Credencial necessária | Ambiente |
|---------|-------|----------------------|---------|
| [sistema] | [fonte/destino/ambos] | [variável de env] | [prod/staging/dev] |

---

## Volume Esperado

| Métrica | Valor estimado |
|---------|---------------|
| Registros processados por execução | [Ex: ~5.000] |
| Tamanho dos dados | [Ex: ~10 MB] |
| Pico esperado | [Ex: fim de mês] |

---

## Riscos

| Risco | Probabilidade | Impacto | Mitigação |
|-------|:---:|:---:|-----------|
| API externa indisponível | Média | Alto | Retry com backoff + alerta |
| Dados malformados na entrada | Baixa | Médio | Validação Pydantic na entrada |
| [outro risco] | [prob] | [impacto] | [mitigação] |

---

## Critérios de Sucesso

- [ ] [Critério mensurável 1 — ex: todos os registros processados sem erro]
- [ ] [Critério mensurável 2 — ex: arquivo de saída gerado em < 5 minutos]
- [ ] Run log registrado com status `success`
