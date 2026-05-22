# Checklist — Operational Readiness

**Arquétipo:** `automation_script`
**Gate:** A5 (Operational Readiness)

## Documentação

- [ ] `README.md` com instalação, configuração e uso
- [ ] `Runbook.md` completo (ver template)
- [ ] `.env.example` com todas as variáveis documentadas
- [ ] Comentários nos parâmetros CLI via docstrings do Typer

## Agendamento

- [ ] Frequência de execução definida
- [ ] Cron expression documentada (se aplicável)
- [ ] Sistema de agendamento escolhido e configurado (cron, GitHub Actions, Task Scheduler)
- [ ] Janela de execução documentada (quanto tempo demora)
- [ ] O que acontece se o job atrasar (tolerância documentada)

## Responsabilidade

- [ ] Responsável pelo script identificado (nome + contato)
- [ ] Canal de alerta de falha definido
- [ ] Escalação documentada (o que fazer se o responsável não estiver disponível)

## Plano de Falha

- [ ] Comportamento em falha completa documentado no Runbook
- [ ] Como reprocessar após falha documentado
- [ ] Impacto de não execução documentado (ex: "relatório não gerado; reprocessar até D+1")
- [ ] Alerta automático em caso de falha (email, Slack, monitoramento)

## Observabilidade

- [ ] Run log persistido e revisável
- [ ] Logs estruturados em JSON
- [ ] Duration_ms registrado por execução
- [ ] Taxa de erro monitorável (run log consultável)

## Segurança

- [ ] Checklist de segurança (`secrets.md`) aprovado
- [ ] Credenciais com permissões mínimas
- [ ] Dados pessoais tratados conforme LGPD

## Validação Final

- [ ] Executar em ambiente de staging/sandbox com dados reais (ou mockados representativos)
- [ ] Dry-run testado em produção antes do primeiro run real
- [ ] Resultado do primeiro run validado manualmente
- [ ] Runbook executado por alguém que NÃO é o implementador (validação de clareza)
