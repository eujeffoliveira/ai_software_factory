#!/bin/bash
# =============================================================================
# validate-framework.sh — Valida a estrutura da ai_software_factory
# Verifica que todos os 11 agentes (Agente00-Agente10) têm os arquivos obrigatórios.
#
# Uso: bash tools/factory-scripts/validate-framework.sh
# Adaptado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/scripts
# =============================================================================

set -euo pipefail
shopt -s nullglob

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ERRORS=0
WARNINGS=0

error() { echo "ERROR: $1"; ERRORS=$((ERRORS+1)); }
warn()  { echo "WARN:  $1"; WARNINGS=$((WARNINGS+1)); }
ok()    { echo "OK:    $1"; }

echo "=== ai_software_factory — Framework Validation ==="
echo "Root: $REPO_ROOT"
echo ""

# Arquivos obrigatorios por agente
REQUIRED_AGENT_FILES=(
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills_manifest.md
  quality_gate.md
  handoff_schema.json
  failure_modes.md
)

# Arquivos obrigatorios na pasta knowledge/
REQUIRED_KNOWLEDGE_FILES=(
  principles.md
  heuristics.md
  decision_rules.md
  knowledge_cards.md
  source_map.json
)

# Arquivos obrigatorios por skill
REQUIRED_SKILL_FILES=(
  skill.md
  input.schema.json
  output.schema.json
  checklist.md
)

AGENT_COUNT=0
TOTAL_SKILLS=0

echo "--- Agents ---"
for agent_dir in "$REPO_ROOT"/Agente[0-9][0-9]_*/; do
  [[ -d "$agent_dir" ]] || continue
  agent=$(basename "$agent_dir")
  AGENT_COUNT=$((AGENT_COUNT+1))

  # Verificar arquivos obrigatorios do agente
  for f in "${REQUIRED_AGENT_FILES[@]}"; do
    [[ -f "${agent_dir}${f}" ]] || error "$agent: missing $f"
  done

  # Verificar knowledge/
  for f in "${REQUIRED_KNOWLEDGE_FILES[@]}"; do
    [[ -f "${agent_dir}knowledge/${f}" ]] || error "$agent/knowledge: missing $f"
  done

  # Verificar skills
  SKILL_COUNT=0
  for skill_dir in "${agent_dir}skills"/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill=$(basename "$skill_dir")
    SKILL_COUNT=$((SKILL_COUNT+1))
    TOTAL_SKILLS=$((TOTAL_SKILLS+1))

    for f in "${REQUIRED_SKILL_FILES[@]}"; do
      [[ -f "${skill_dir}${f}" ]] || error "$agent/skills/$skill: missing $f"
    done

    # Exemplos são recomendados, não obrigatorios
    [[ -f "${skill_dir}examples/good_output.md" ]] || warn "$agent/skills/$skill: missing examples/good_output.md"
    [[ -f "${skill_dir}examples/bad_output.md" ]]  || warn "$agent/skills/$skill: missing examples/bad_output.md"
  done

  ok "$agent ($SKILL_COUNT skills)"
done

echo ""
echo "--- Tools (optional) ---"
TOOLS_COUNT=0
for agent_dir in "$REPO_ROOT"/Agente[0-9][0-9]_*/; do
  [[ -d "${agent_dir}tools/" ]] && TOOLS_COUNT=$((TOOLS_COUNT+1))
done
ok "Agents with tools/ folder: $TOOLS_COUNT"

echo ""
echo "--- Root tools/ ---"
[[ -d "$REPO_ROOT/tools/" ]] && ok "tools/ exists" || warn "tools/ not found"
[[ -d "$REPO_ROOT/bibliography/" ]] && ok "bibliography/ exists" || warn "bibliography/ not found (optional)"

echo ""
echo "=== Summary ==="
echo "Agents:       $AGENT_COUNT / 11 expected"
echo "Total skills: $TOTAL_SKILLS"
echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "RESULT: FAIL ($ERRORS errors, $WARNINGS warnings)"
  exit 1
elif [[ $WARNINGS -gt 0 ]]; then
  echo "RESULT: PASS with warnings ($WARNINGS warnings)"
  exit 0
else
  echo "RESULT: PASS (all checks green)"
  exit 0
fi
