# Golden Model — Notebook / Analysis (`notebook_analysis`)

**Archetype:** `notebook_analysis`
**Applies to:** Análise exploratória de dados, pesquisa, prototipação, investigações ad-hoc, relatórios analíticos.
**Default stack:** Python + Jupyter.
**Status:** Initial version.

---

## Stack Obrigatória

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Python 3.12+ |
| Ambiente | Jupyter Lab ou Jupyter Notebook |
| Dados tabulares | Polars ou Pandas |
| Visualização | Matplotlib, Seaborn, Plotly |
| Validação de dados | Pydantic v2 ou Great Expectations |
| Versionamento de outputs | DVC (opcional) |
| Ambiente isolado | uv venv ou conda env |
| Lint (se aplicável) | ruff + nbQA |

---

## Regras Obrigatórias

1. **Separação entre exploração e produção** — Notebooks são para análise. Lógica reutilizável vai para módulos Python.
2. **Notebooks não vão para produção diretamente** — Para produção, converter em pipeline (`data_pipeline`) ou script (`automation_script`).
3. **Dados sensíveis nunca commitados** — `.gitignore` para dados brutos e outputs com PII.
4. **Ambiente reproduzível** — `requirements.txt` ou `pyproject.toml` com versões fixadas.
5. **Documentação das fontes de dados** — Origem de cada dataset documentada no notebook.
6. **Outputs versionáveis quando relevante** — Para análises recorrentes, usar DVC ou nomear outputs com timestamp.
7. **Células organizadas logicamente** — Notebook executável do início ao fim sem erros (Restart & Run All deve funcionar).

---

## Regra de Promoção

Se uma análise for executada recorrentemente ou seus resultados alimentarem decisões de produção, ela DEVE ser promovida para:
- `automation_script` — se for um script pontual
- `data_pipeline` — se for processamento recorrente de dados
- `api_service` — se expor resultados via API

Notebooks não são produção.

---

## Antipadrões Críticos

- Dados sensíveis (PII, credenciais) commitados no repositório
- Notebook não reproduzível (depende de estado local manual)
- Lógica complexa não modularizada usada em produção direto do notebook
- Ausência de documentação das fontes de dados
- Notebook com células fora de ordem

---

## Artefatos Obrigatórios

- `Analysis_Brief.md` — objetivo, perguntas a responder, fontes de dados
- `Data_Dictionary.md` — descrição dos campos e datasets usados
- Notebook executável de ponta a ponta (`Restart & Run All` funciona)
