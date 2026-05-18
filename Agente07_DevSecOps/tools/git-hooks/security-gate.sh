#!/bin/bash
# security-gate.sh — PreToolUse: Security gate entry point
# Delega para bash-guards.sh e secret-scan.sh conforme o evento.
#
# Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/hooks
# Uso: configure como hook PreToolUse no .claude/hooks.json do projeto

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Delegar para bash-guards para validacao de comandos perigosos
if [ -f "$SCRIPT_DIR/bash-guards.sh" ]; then
  bash "$SCRIPT_DIR/bash-guards.sh"
  EXIT_CODE=$?
  [ $EXIT_CODE -ne 0 ] && exit $EXIT_CODE
fi

exit 0
