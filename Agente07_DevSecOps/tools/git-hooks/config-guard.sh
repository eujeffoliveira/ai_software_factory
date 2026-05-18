#!/bin/bash
# =============================================================================
# config-guard.sh — PreToolUse(Write): Block Write tool on protected config files
# BLOCKING (exit 2) — forces use of Edit tool for surgical changes.
#
# Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/hooks
# Uso: configure como hook PreToolUse(Write) no .claude/hooks.json do projeto
# =============================================================================

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

[ -z "$FILE_PATH" ] && exit 0

BASENAME=$(basename "$FILE_PATH")
RELPATH="$FILE_PATH"

BLOCKED=false

case "$BASENAME" in
  .env|.env.*)
    BLOCKED=true
    ;;
  .mcp.json)
    BLOCKED=true
    ;;
  package.json)
    BLOCKED=true
    ;;
  package-lock.json)
    BLOCKED=true
    ;;
  tsconfig.json|tsconfig.*.json)
    BLOCKED=true
    ;;
  vite.config.ts|vite.config.js)
    BLOCKED=true
    ;;
  vitest.config.ts|vitest.config.js)
    BLOCKED=true
    ;;
  playwright.config.ts|playwright.config.js)
    BLOCKED=true
    ;;
  vercel.json)
    BLOCKED=true
    ;;
  config.toml)
    if echo "$RELPATH" | grep -q "supabase/config.toml"; then
      BLOCKED=true
    fi
    ;;
esac

if echo "$RELPATH" | grep -qE '\.github/workflows/.*\.ya?ml$'; then
  BLOCKED=true
fi

if [ "$BLOCKED" = true ]; then
  echo "BLOCKED: Use Edit tool for config files, never Write. Read the file first, then make surgical edits." >&2
  echo "Protected file: $BASENAME" >&2
  exit 2
fi

exit 0
