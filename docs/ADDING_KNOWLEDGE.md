# Adicionando Conhecimento à Factory

## Build-time vs. Runtime

Este é o conceito mais importante da arquitetura:

- **Build-time:** fontes externas (livros, artigos, cursos, playbooks) são lidas **uma vez** para produzir artefatos destilados nos diretórios `knowledge/` dos agentes.
- **Runtime:** agentes leem **apenas** de sua própria pasta `AgenteXX_*/` e do `knowledge.db` via MCP. Eles **nunca** acessam `context/`, `lib/` ou arquivos-fonte brutos.

O subdiretório `knowledge/` de cada agente contém o **output destilado** do processo build-time: princípios, heurísticas, regras de decisão e cartões de conhecimento.

```
Fonte externa (livro, artigo, curso)
  │
  ▼ [processo de destilação - build-time]
  │
  ├─► AgenteXX/knowledge/principles.md
  ├─► AgenteXX/knowledge/heuristics.md
  ├─► AgenteXX/knowledge/decision_rules.md
  ├─► AgenteXX/knowledge/knowledge_cards.md
  └─► AgenteXX/knowledge/source_map.json
  │
  ▼ [install.ps1 ou update-knowledge.ps1]
  │
  ▼ knowledge.db (indexado, disponível via MCP em runtime)
```

## Usando o prompt padrão de destilação

Para adicionar novas fontes de conhecimento, use o prompt padrão em:

```
context/prompts/prompt_padrao_destilacao_conhecimento.md
```

Este é um workflow de 27 passos que guia a IA pelo processo completo de destilação. Para usá-lo:

1. Abra `context/prompts/prompt_padrao_destilacao_conhecimento.md`
2. Copie o conteúdo para uma nova sessão do Claude Code ou Codex
3. Na seção "Fontes novas a processar", liste os caminhos ou descrições das novas fontes
4. Execute a sessão — a IA auditará o repositório e destilará nos artefatos corretos
5. Após a conclusão: execute `.\install.ps1`

O prompt cobre: política de direitos autorais, atualização do `source_map.json`, geração de build report.

## Onde colocar cada tipo de conhecimento

| Tipo de conteúdo | Localização | Exemplo |
|------------------|-------------|---------|
| Princípios operacionais | `AgenteXX/knowledge/principles.md` | `P1: Never skip gates` |
| Heurísticas de decisão | `AgenteXX/knowledge/heuristics.md` | `H1: When in doubt, escalate to human` |
| Regras if-then | `AgenteXX/knowledge/decision_rules.md` | `DR001: IF archetype=web_app THEN use Next.js` |
| Cartões conceituais | `AgenteXX/knowledge/knowledge_cards.md` | `Card 001: INVEST criteria` |
| Playbooks operacionais | `bibliography/playbooks/` | `13_New_Playbook.md` |
| Templates de artefatos | `AgenteXX/templates/` ou `templates/automation/` | `PRD_Template.md` |
| Checklists de operação | `AgenteXX/checklists/` ou `checklists/automation/` | `qa_checklist.md` |
| Schemas JSON | `AgenteXX/schemas/` | `prd_output.schema.json` |
| Playbooks de arquétipo | `bibliography/playbooks/` | Append-only — não editar existentes |

**Regra:** conhecimento **nunca** vai para `tools/`. Ferramentas executáveis vão em `tools/`, conhecimento vai em `knowledge/`.

## Estrutura dos arquivos de knowledge

### principles.md

```markdown
# Princípios — [Nome do Agente]

## P1: [Nome do Princípio]
[Descrição de 1-3 parágrafos. Por que este princípio existe. Quando se aplica.]

**Exemplo de aplicação:**
[Exemplo concreto]

## P2: ...
```

### heuristics.md

```markdown
# Heurísticas — [Nome do Agente]

## H1: [Nome da Heurística]
**Contexto:** [Quando usar esta heurística]
**Regra:** [A heurística em si, de forma acionável]
**Exceções:** [Quando NÃO aplicar]
```

### decision_rules.md

```markdown
# Regras de Decisão — [Nome do Agente]

## DR001: [Nome da Regra]
**Condição:** IF [condição]
**Ação:** THEN [ação]
**Senão:** ELSE [ação alternativa] *(opcional)*
**Rationale:** [Por que esta regra existe]
```

### knowledge_cards.md

```markdown
# Cartões de Conhecimento — [Nome do Agente]

## Card 001: [Conceito]
**Definição:** [O que é]
**Quando usar:** [Contexto de aplicação]
**Exemplo:** [Exemplo concreto]
**Referência:** [Fonte da qual foi destilado]
```

## Atualizar source_map.json

Após adicionar conhecimento, registre a fonte em `AgenteXX/knowledge/source_map.json`:

```json
{
  "sources": [
    {
      "source_id": "livro-engenharia-2026",
      "title": "Software Engineering Principles - 4th Edition",
      "type": "book",
      "distilled_into": [
        "knowledge/principles.md",
        "knowledge/decision_rules.md"
      ],
      "distilled_at": "2026-05-22",
      "distilled_by": "Claude Sonnet 4.6"
    }
  ]
}
```

Tipos válidos: `book`, `article`, `course`, `playbook`, `internal`.

## Quando rodar o quê

| Situação | Comando |
|----------|---------|
| Editou `knowledge/`, `skills/`, `templates/`, `checklists/` | `.\update-knowledge.ps1` |
| Editou `prompt.md` de qualquer agente | `.\install.ps1` |
| Após destilação completa de novo conhecimento | `.\install.ps1` |
| Após adicionar novo agente | `.\install.ps1` |
| Após editar `standards/` ou `bibliography/playbooks/` | `.\update-knowledge.ps1` |

O `install.ps1` é idempotente — rodar duas vezes é seguro. Na segunda execução, todos os itens são reportados como `sem mudancas`.

## Política de direitos autorais

- **Nunca** copie trechos verbatim de obras com copyright — escreva síntese original
- Cite a fonte no campo `source_id` do `source_map.json` e em uma seção `## Referências` no arquivo destilado
- Materiais externos retêm suas licenças originais — o projeto não os relicencia
- Arquivos do diretório `lib/` (livros de referência) são gitignored — não faça commit de livros
- O limite recomendado por arquivo é 500 linhas para melhor desempenho do FTS

## Verificar a indexação

Após rodar `update-knowledge.ps1` ou `install.ps1`, verifique que o conteúdo foi indexado:

```powershell
# Em uma sessão do Claude Code
@techlead search_knowledge("termo do novo conteúdo")
```

Ou diretamente:

```powershell
.\test-mcp.ps1
```

O check 7 ("Document count") deve reportar um número maior que antes da indexação.

## Adicionando um playbook

Os playbooks em `bibliography/playbooks/` são **append-only** — não edite os existentes sem instrução explícita.

Para adicionar um novo playbook:

1. Crie o arquivo com o próximo número disponível: `bibliography/playbooks/13_Nome_Playbook.md`
2. Use o mesmo formato dos existentes (seções com `##`, exemplos práticos, sem copyright)
3. Execute `.\update-knowledge.ps1`
4. Verifique a indexação com `search_knowledge("termo do playbook")`

Não é necessário atualizar nenhuma lista de índice — o ingest.py descobre os arquivos automaticamente.
