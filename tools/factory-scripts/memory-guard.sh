#!/bin/bash
# memory-guard.sh — Verifica se eh seguro spawnar mais agents Claude
# Exit codes: 0=safe, 1=warn, 2=critical
#
# Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/scripts

set -uo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# 1. Limite de processos Claude CLI
CLAUDE_COUNT=$(ps aux | awk '$11 ~ /\/claude$/ || $11 == "claude"' | wc -l | tr -d ' ')
MAX_CLAUDE=12

if [ "$CLAUDE_COUNT" -ge "$MAX_CLAUDE" ]; then
  echo -e "${RED}BLOCKED: $CLAUDE_COUNT sessoes Claude ativas (max: $MAX_CLAUDE)${NC}"
  echo "Feche terminais/sessoes antes de spawnar novos agents."
  ps aux | awk '$11 ~ /\/claude$/ || $11 == "claude" {printf "  PID %-8s %d MB RSS\n", $2, $6/1024}'
  exit 2
fi

# 2. Limite de processos Node (MCPs + tools)
NODE_COUNT=$(pgrep -f "node" 2>/dev/null | wc -l | tr -d ' ')
MAX_NODE=30

if [ "$NODE_COUNT" -ge "$MAX_NODE" ]; then
  echo -e "${RED}WARNING: $NODE_COUNT processos Node (max: $MAX_NODE)${NC}"
  echo "Considere fechar MCPs nao utilizados."
fi

# 3. Memoria disponivel
PRESSURE_STATUS="unknown"
PRESSURE_DISPLAY="N/A"

if command -v vm_stat &>/dev/null; then
  # macOS
  FREE_PAGES=$(vm_stat | grep "Pages free" | awk '{print $3}' | tr -d '.')
  INACTIVE_PAGES=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
  TOTAL_FREE_MB=$(( (FREE_PAGES + INACTIVE_PAGES) * 4096 / 1024 / 1024 ))
  PRESSURE_DISPLAY="${TOTAL_FREE_MB}MB free"
  if [ "$TOTAL_FREE_MB" -gt 8000 ]; then PRESSURE_STATUS="normal"
  elif [ "$TOTAL_FREE_MB" -gt 4000 ]; then PRESSURE_STATUS="warn"
  else PRESSURE_STATUS="critical"; fi
elif command -v free &>/dev/null; then
  # Linux
  FREE_MB=$(free -m | awk '/^Mem/ {print $7}')
  PRESSURE_DISPLAY="${FREE_MB}MB available"
  if [ "$FREE_MB" -gt 4000 ]; then PRESSURE_STATUS="normal"
  elif [ "$FREE_MB" -gt 1000 ]; then PRESSURE_STATUS="warn"
  else PRESSURE_STATUS="critical"; fi
fi

echo "================================"
echo "  MEMORY GUARD — Resource Check"
echo "================================"
echo ""
echo "Memory:           $PRESSURE_DISPLAY ($PRESSURE_STATUS)"
echo "Claude processes: $CLAUDE_COUNT / $MAX_CLAUDE"
echo "Node processes:   $NODE_COUNT / $MAX_NODE"
echo ""

case "$PRESSURE_STATUS" in
  "normal")
    echo -e "${GREEN}STATUS: SAFE${NC}"
    exit 0
    ;;
  "warn")
    echo -e "${YELLOW}STATUS: WARN — evitar novos agents${NC}"
    exit 1
    ;;
  "critical"|*)
    echo -e "${RED}STATUS: CRITICAL — NAO spawnar agents!${NC}"
    exit 2
    ;;
esac
