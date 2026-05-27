# Idempotency Plan

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Versão:** 1.0

---

## Chave de Idempotência

**Chave primária de idempotência:** `[campo ou combinação de campos que identifica unicamente um registro processado]`

Exemplo: `f"{source_id}:{reference_date}"`

---

## Estratégia

### Como Detectar Processamento Anterior

```python
# Exemplo: tabela de controle no banco
CREATE TABLE processed_records (
    idempotency_key VARCHAR PRIMARY KEY,
    processed_at    TIMESTAMP NOT NULL,
    run_id          VARCHAR   NOT NULL,
    status          VARCHAR   NOT NULL  -- 'success', 'error'
);

# Antes de processar:
def is_already_processed(key: str) -> bool:
    return db.query("SELECT 1 FROM processed_records WHERE idempotency_key = ?", key)
```

Alternativas:
- [ ] Tabela de controle no banco local (SQLite)
- [ ] Arquivo de estado (JSON/CSV local)
- [ ] Campo `processed_at` na tabela de destino
- [ ] Deduplicação por hash do payload
- [ ] API de destino idempotente por natureza (UPSERT/PUT com ID)

---

## Comportamento em Reprocessamento

| Situação | Comportamento |
|----------|--------------|
| Registro já processado com sucesso | Skip — log `[SKIP] already processed: {key}` |
| Registro processado com erro | Reprocessar (tentar novamente) |
| Execução interrompida no meio | Retomar a partir do último checkpoint |
| Dados de origem mudaram | [definir se reprocessar ou não] |

---

## Checkpoints

```python
# Exemplo de checkpoint por lote
def process_batch(records: list[Record], checkpoint_file: Path):
    processed = load_checkpoint(checkpoint_file)  # set de keys já processadas
    
    for record in records:
        key = f"{record.id}:{record.date}"
        if key in processed:
            continue
        
        process_record(record)
        save_checkpoint(checkpoint_file, key)
```

---

## Teste de Idempotência

```bash
# Executar duas vezes — resultado deve ser igual
python -m nome run --date 2024-01-15
python -m nome run --date 2024-01-15

# Verificar que o segundo run não duplicou dados
```

**Critério de aprovação:** Executar 2x produz exatamente o mesmo estado final que executar 1x.
