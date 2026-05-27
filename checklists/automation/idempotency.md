# Checklist — Idempotency

**Arquétipo:** `automation_script`
**Gate:** A2 (Implementation Readiness) + A3 (QA)

## Chave de Idempotência

- [ ] Chave de idempotência definida em `Idempotency_Plan.md`
- [ ] Chave é única por registro e por execução (`record_id + date` ou similar)
- [ ] Chave não muda entre re-execuções do mesmo dado

## Detecção de Processamento Anterior

- [ ] Mecanismo de estado implementado (banco, arquivo, campo no destino)
- [ ] Verificação de estado ocorre ANTES do processamento
- [ ] Registro já processado com sucesso → skip com log
- [ ] Registro processado com erro → reprocessar

## Checkpoint

- [ ] Estado é salvo incrementalmente (não só no final)
- [ ] Execução interrompida pode ser retomada do último checkpoint
- [ ] Checkpoint é atômico (não corrompe estado em caso de crash)

## Comportamento em Reprocessamento

- [ ] Executar 2x com mesmo input → mesmo estado final
- [ ] Não duplica registros no destino
- [ ] Não duplica entradas no run log (mesmo run_id)
- [ ] Dry-run não altera estado de idempotência

## Teste de Idempotência

- [ ] Teste automatizado: executar 2x → verificar que resultado é igual
- [ ] Teste de checkpoint: interromper no meio → retomar → verificar integridade
- [ ] Teste de reprocessamento de erro: registros com erro são tentados novamente
