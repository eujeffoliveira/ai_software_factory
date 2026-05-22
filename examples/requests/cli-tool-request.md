# Example Request — CLI Tool

**Arquétipo:** `cli_tool`
**Golden Model:** CLI Tool (Python + Typer)

---

## Como usar com Claude Code

```
@techlead Preciso de uma ferramenta CLI para ajudar o time de DevOps a
gerenciar deployments no Vercel: listar projetos, ver status de deployments,
fazer rollback para uma versão anterior, e ativar/desativar aliases de domínio.

Classifique como cli_tool e planeje a implementação.
```

```
@engineer Planeje a CLI de gerenciamento Vercel.
Stack: Python 3.12, Typer, httpx (Vercel API), Rich (output), pydantic-settings, pytest.
Comandos: projects list, deployments list --project, deployment rollback, alias set/unset.
Cada comando: --dry-run quando destrutivo, --output json para uso em scripts.
```

```
@qa Valide a CLI:
- Cada comando testado com CliRunner do Typer
- Exit codes corretos (0=sucesso, 1=erro de uso, 2=erro de execução)
- --dry-run não chama API Vercel
- --help completo para cada comando
- Empacotável: `pip install .` + `vercel-tool --help` funciona
```
