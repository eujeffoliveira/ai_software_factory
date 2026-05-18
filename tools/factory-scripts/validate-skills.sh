#!/usr/bin/env bash
# validate-skills.sh — Valida estrutura de skills em todos os 11 agentes
# Verifica os 6 arquivos obrigatorios + sections do skill.md
#
# Uso: bash tools/factory-scripts/validate-skills.sh [--verbose]
# Adaptado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/scripts

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VERBOSE=false
ERRORS=0
WARNINGS=0
TOTAL=0

[[ "${1:-}" == "--verbose" ]] && VERBOSE=true

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log_error() { echo -e "${RED}ERROR${NC} [$1]: $2"; ((ERRORS++)); }
log_warn()  { echo -e "${YELLOW}WARN${NC}  [$1]: $2"; ((WARNINGS++)); }
log_ok()    { $VERBOSE && echo -e "${GREEN}OK${NC}    [$1]: $2" || true; }

echo "=== Skill Validator — ai_software_factory ==="
echo "Root: $REPO_ROOT"
echo ""

for agent_dir in "$REPO_ROOT"/Agente[0-9][0-9]_*/; do
  [[ -d "$agent_dir" ]] || continue
  agent=$(basename "$agent_dir")
  skills_dir="${agent_dir}skills/"
  [[ -d "$skills_dir" ]] || continue

  for skill_dir in "$skills_dir"*/; do
    [[ -d "$skill_dir" ]] || continue
    skill=$(basename "$skill_dir")
    skill_id="$agent/$skill"
    ((TOTAL++)) || true

    # 6 arquivos obrigatorios (CLAUDE.md: "Each skill requires exactly 6 files")
    for f in skill.md input.schema.json output.schema.json checklist.md; do
      [[ -f "$skill_dir$f" ]] || log_error "$skill_id" "Missing required file: $f"
    done
    [[ -f "${skill_dir}examples/good_output.md" ]] || log_warn "$skill_id" "Missing examples/good_output.md"
    [[ -f "${skill_dir}examples/bad_output.md" ]]  || log_warn "$skill_id" "Missing examples/bad_output.md"

    # Verificar secoes obrigatorias no skill.md
    if [[ -f "${skill_dir}skill.md" ]]; then
      skill_content=$(cat "${skill_dir}skill.md")

      for section in "## Purpose" "## When to Use" "## Inputs" "## Outputs"; do
        echo "$skill_content" | grep -q "$section" || log_warn "$skill_id" "skill.md missing section: $section"
      done

      # Knowledge Access Policy (build/runtime isolation rule)
      echo "$skill_content" | grep -q "Knowledge Access Policy\|Runtime Knowledge Policy" || \
        log_warn "$skill_id" "skill.md missing '## Knowledge Access Policy' section"

      # Tamanho sanity check
      size=$(wc -c < "${skill_dir}skill.md")
      [[ $size -lt 100 ]] && log_warn "$skill_id" "skill.md suspiciously small (${size} bytes)"
      [[ $size -gt 50000 ]] && log_warn "$skill_id" "skill.md very large (${size} bytes) — consider splitting"

      log_ok "$skill_id" "validated (${size} bytes)"
    fi

    # Verificar input.schema.json valido
    if [[ -f "${skill_dir}input.schema.json" ]]; then
      python3 -c "import json,sys; json.load(open('${skill_dir}input.schema.json'))" 2>/dev/null || \
        log_error "$skill_id" "input.schema.json is not valid JSON"
    fi

    # Verificar output.schema.json valido
    if [[ -f "${skill_dir}output.schema.json" ]]; then
      python3 -c "import json,sys; json.load(open('${skill_dir}output.schema.json'))" 2>/dev/null || \
        log_error "$skill_id" "output.schema.json is not valid JSON"
    fi
  done
done

echo ""
echo "=== Summary ==="
echo -e "Skills scanned: ${CYAN}${TOTAL}${NC}"
echo -e "Errors:         ${RED}${ERRORS}${NC}"
echo -e "Warnings:       ${YELLOW}${WARNINGS}${NC}"

if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
  echo -e "${GREEN}All skills valid!${NC}"
  exit 0
elif [[ $ERRORS -eq 0 ]]; then
  echo -e "${YELLOW}Warnings only — skills functional but could improve${NC}"
  exit 0
else
  echo -e "${RED}Errors found — some skills may not work correctly${NC}"
  exit 1
fi
