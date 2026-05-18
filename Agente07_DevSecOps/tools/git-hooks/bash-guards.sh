#!/bin/bash
# bash-guards.sh — PreToolUse(Bash): Block dangerous CLI patterns
# BLOCKING (exit 2)
#
# Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/hooks
# Adaptado: removidos guards especificos de projetos externos (TOTVS SQL)
# Uso: configure como hook PreToolUse(Bash) no .claude/hooks.json do projeto

INPUT="${CLAUDE_TOOL_INPUT:-}"

# Bloquear deploy direto sem CI/CD
[[ "$INPUT" == *"vercel --prod"* ]] && echo "BLOCKED: Use CI/CD pipeline instead of direct vercel --prod" && exit 2

# Bloquear force push
[[ "$INPUT" == *"--force"* ]] && [[ "$INPUT" == *"git push"* ]] && echo "BLOCKED: Force push is dangerous. Use PR instead." && exit 2

# Bloquear bypass de hooks
[[ "$INPUT" == *"--no-verify"* ]] && echo "BLOCKED: --no-verify bypasses safety hooks." && exit 2

# Bloquear operacoes git destrutivas
if [[ "$INPUT" == *"git rebase -i"* ]]; then
  echo "BLOCKED: git rebase -i is interactive and destructive. Use merge instead." && exit 2
fi
if [[ "$INPUT" == *"git checkout -- ."* ]] || [[ "$INPUT" == *"git checkout -- \*"* ]]; then
  echo "BLOCKED: git checkout -- . discards all unstaged changes. Commit first." && exit 2
fi
if [[ "$INPUT" == *"git restore ."* ]]; then
  echo "BLOCKED: git restore . discards changes. Commit or branch first." && exit 2
fi
if [[ "$INPUT" == *"git clean -f"* ]]; then
  echo "BLOCKED: git clean -f permanently deletes untracked files." && exit 2
fi

# Bloquear reset hard sem branch de seguranca
if [[ "$INPUT" == *"git reset --hard"* ]] && [[ "$INPUT" != *"HEAD~1"* ]]; then
  echo "BLOCKED: git reset --hard can destroy work. Create a backup branch first: git branch backup-$(date +%Y%m%d)" && exit 2
fi

# Aviso para git stash (nao bloqueante) — preferir WIP commits
if [[ "$INPUT" == *"git stash"* ]] && \
   [[ "$INPUT" != *"git stash list"* ]] && \
   [[ "$INPUT" != *"git stash show"* ]] && \
   [[ "$INPUT" != *"git stash pop"* ]]; then
  echo "WARNING: git stash can lose work. Prefer WIP commits. Proceeding..." >&2
fi

exit 0
