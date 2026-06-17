# Operações — AI Software Factory

Guia de uso do dia-a-dia.

---

## Usar os agentes

### Claude Code

Em qualquer projeto, abra uma sessão Claude Code e chame os agentes com `@nome`:

```
@techlead avalie a arquitetura deste projeto
@qa monte uma estratégia de testes para o módulo de autenticação
@architect revise as decisões técnicas do backend
@devsecops faça uma revisão de segurança baseada no OWASP Top 10
@devbackend implemente o endpoint POST /api/users com validação Zod
@devfrontend crie o componente de formulário de login com Tailwind
@po escreva as user stories para o fluxo de onboarding
@engineer decomponha o épico de busca em tasks
@devops configure o CI/CD no GitHub Actions para Vercel
@uxui proponha o wireframe da tela de dashboard
@dataengineer projete o pipeline de ingestão dos dados de vendas
```

Os agentes funcionam **em qualquer diretório**, sem configuração adicional por projeto.

### Roo Code / Cline

1. Após `.\install.ps1`, execute `.\link-roo.ps1` na raiz do projeto:
   ```powershell
   cd meu-projeto
   & "$env:FACTORY_ROOT\link-roo.ps1"
   ```
2. Reinicie o VS Code / Roo Code
3. Selecione o modo no painel do Roo Code (🏗️ Tech Lead, 📋 Product Owner, etc.)

---

## Atualizar após mudanças

### Atualizar agentes (editou prompt.md ou knowledge)

```powershell
cd $env:FACTORY_ROOT
.\install.ps1
```

O instalador detecta o que mudou e só atualiza o necessário.

### Reindexar o knowledge (editou arquivos .md)

```powershell
cd $env:FACTORY_ROOT
.\update-knowledge.ps1
```

Execute após:
- Editar arquivos em `Agente*/knowledge/`, `Agente*/skills/`, `bibliography/`
- Adicionar novos documentos
- Fazer `git pull` com mudanças nos agentes

### Atualizar após git pull

```powershell
cd $env:FACTORY_ROOT
git pull
.\install.ps1
```

---

## Vincular MCP a um projeto específico

Alguns projetos precisam de `.mcp.json` local (ex: Roo Code sem MCP global):

```powershell
cd meu-projeto
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

Isso copia o `.mcp.json` da factory para o projeto atual.

---

## Diagnóstico

```powershell
# Diagnóstico completo multi-runtime
cd $env:FACTORY_ROOT
.\doctor.ps1

# Health check específico do MCP (7 checks)
.\test-mcp.ps1
```

---

## Versão instalada

```powershell
Get-Content "$env:FACTORY_ROOT\VERSION"
Get-Content "$env:USERPROFILE\.claude\agents\.ai_software_factory_manifest.json" | ConvertFrom-Json | Select-Object factory_version, installed_at
```

---

## Desinstalar

```powershell
cd $env:FACTORY_ROOT

# Preview do que seria removido
.\uninstall.ps1 -WhatIf

# Remover agentes e configs, preservar knowledge.db
.\uninstall.ps1

# Remover tudo (incluindo knowledge.db e logs)
.\uninstall.ps1 -Full
```

Veja mais em [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

---

## Múltiplas factories

Se você mantém mais de uma instância da factory (ex: versão de cliente vs. genérica):

1. Cada instância tem seu próprio `FACTORY_ROOT`
2. O `~/.claude.json` aponta para uma única instância (a última a executar `install.ps1`)
3. Para trocar, execute `install.ps1` da instância desejada
4. Cada projeto pode ter seu próprio `.mcp.json` via `link-mcp.ps1`

---

## FACTORY_ROOT não disponível

Se `$env:FACTORY_ROOT` estiver vazio na sessão atual:

```powershell
# Verificar se está definido como variável de usuário
[System.Environment]::GetEnvironmentVariable("FACTORY_ROOT", "User")

# Se vazio: abra um novo terminal (ou redefina manualmente)
$env:FACTORY_ROOT = "C:\caminho\para\ai_software_factory"
```

Isso acontece quando a sessão foi aberta antes do `install.ps1` definir a variável.
