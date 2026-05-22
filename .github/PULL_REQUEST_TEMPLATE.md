## Resumo

<!-- Descreva a mudança em 1-3 frases. -->

## Tipo de mudança

- [ ] Código / script / ferramenta
- [ ] Documentação / prompt / template / playbook / knowledge
- [ ] MCP / RAG
- [ ] Agente
- [ ] Skill
- [ ] Golden Model
- [ ] Testes
- [ ] Governança / licença

## Licenciamento

- [ ] Código, scripts e ferramentas seguem Apache-2.0
- [ ] Docs, prompts, templates, playbooks e knowledge seguem CC BY 4.0
- [ ] Não incluí conteúdo de terceiros sem permissão
- [ ] Não incluí secrets, tokens, API keys ou credenciais

## Validações

- [ ] `.\doctor.ps1` executado — sem ERRORs
- [ ] `.\test-mcp.ps1` executado — todos os checks passaram
- [ ] `.\install.ps1` executado, quando aplicável
- [ ] Validadores e testes aplicáveis foram rodados
- [ ] README ou docs atualizados, se necessário
- [ ] `source_map.json` atualizado, se adicionei knowledge

## Impacto em agentes

- [ ] Não altera agentes
- [ ] Altera agentes — requer rodar `.\install.ps1`

## Impacto em MCP / RAG

- [ ] Não altera MCP / RAG
- [ ] Altera knowledge ou indexação — requer rodar `.\update-knowledge.ps1`

## Checklist final

- [ ] Mudança é idempotente quando aplicável
- [ ] Sem caminhos pessoais hardcoded
- [ ] Sem credenciais ou dados sensíveis
- [ ] Documentação coerente com scripts e agentes existentes
