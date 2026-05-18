# Playbook 12: Power User Skills

> **Status:** referencia power-user. Skills uteis mas nao citadas em routing padrao.
> **Motivo da criacao:** diagnostico identificou skills orfas uteis mas invisiveis.

---

## Skills orfas documentadas

### Busca e Informacao
- **buscar-voos**: busca de passagens aereas via Google Flights — uso pessoal do desenvolvedor
- **ag-insights**: metricas de sessao/projeto (tokens gastos, trends, health)

### Analise Proativa
- **ag-advisor**: analise proativa — sugere melhorias sem ser pedido; spawnar em background durante sessao longa
- **ag-adversario**: adversarial review — tenta quebrar o design antes do build; usar ENTRE spec e plan

### Gestao de Sessao
- **ag-rebobinar**: undo estruturado com preview e backup
- **ag-thinkback**: replay de decisoes — "por que decidimos X?"
- **ag-teleportar**: switch inteligente entre projetos (preserva contexto mental)
- **ag-destilar**: comprime documentos grandes mantendo 100% da info; substitui read manual de arquivo gigante
- **ag-retrospectiva**: analise pos-sessao (o que funcionou, o que falhou, lessons learned)

### Meta-skills (criar/melhorar agentes)
- **ag-criar-skill**: criar nova skill seguindo estrutura obrigatoria
- **ag-criar-agente**: criar novo agente seguindo convencoes do factory
- **ag-melhorar-agentes**: refatorar agentes existentes
- **ag-mesa-redonda**: debate multi-agente (PM/Arquiteto/QA/Security) sobre decisao tecnica; output → ADR

### Incorporacao
- **ag-planejar-incorporacao**: roadmap de incorporacao de sistemas externos
- **ag-incorporar-modulo**: execucao de incorporacao modulo a modulo
- **ag-mapear-integracao**: mapeamento de dimensoes de integracao

---

## Quando NAO usar power-user skills

- Para fluxos padrao (build/fix/deploy/test) use os agentes canonicos
- Para expertise on-demand use reference skills
- Para plugins oficiais use canonicals (Vercel, Sentry, Figma, Supabase, etc.)

---

## Meta-fluxo de criacao de novos agents/skills

Se necessario criar nova skill/agent:

1. Verificar se **plugin oficial** ja cobre (Vercel/Sentry/Figma/Supabase)
2. Se nao: **consolidar em agent existente** antes de criar novo
3. Se necessidade clara de nova skill: usar `/ag-criar-skill` ou `/ag-criar-agente`
4. Novo agent/skill DEVE seguir convencoes do factory (6 arquivos obrigatorios por skill)
5. Adicionar ao CLAUDE.md ou rules relevantes para descoberta

---

## Checklist de Adocao

Antes de adotar uma power-user skill:
- [ ] Skill cobre caso de uso claro e nao-trivial?
- [ ] Skill nao duplica agent canonico existente?
- [ ] Documentado onde e quando usar?
- [ ] Testado com pelo menos 3 exemplos reais?
