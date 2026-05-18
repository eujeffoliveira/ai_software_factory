#!/bin/bash
# =============================================================================
# pre_commit_governance.sh — Pre-commit governance hook for predictive pipelines
# Runs all predictive-rigor checks before allowing a commit to proceed.
#
# Usage: Install as .git/hooks/pre-commit or call from Claude Code hook
# Exit codes: 0=PASS (commit allowed), 1=WARN (commit with warning), 2=FAIL (blocked)
# =============================================================================

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TOOLS_DIR="${REPO_ROOT}/tools/predictive-rigor/scripts"
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

log_error() { echo -e "${RED}FAIL${NC}  $1"; ERRORS=$((ERRORS+1)); }
log_warn()  { echo -e "${YELLOW}WARN${NC}  $1"; WARNINGS=$((WARNINGS+1)); }
log_ok()    { echo -e "${GREEN}OK${NC}    $1"; }

echo "=== Predictive Governance Pre-Commit Check ==="
echo ""

# 1. Check for PFC file if model code is being committed
STAGED_PY=$(git diff --cached --name-only 2>/dev/null | grep -E '\.(py)$' | grep -E 'model|train|pipeline' || true)
if [ -n "$STAGED_PY" ]; then
  PFC_FILES=$(find "${REPO_ROOT}" -name "PFC*.json" -o -name "*pfc*.json" 2>/dev/null | head -5)
  if [ -z "$PFC_FILES" ]; then
    log_warn "Model code staged but no PFC contract found. Register PFC before committing analysis results."
  else
    log_ok "PFC contract found: $(echo "$PFC_FILES" | head -1 | xargs basename)"
  fi
fi

# 2. Check for hardcoded credentials in data scripts
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || true)
for f in $STAGED_FILES; do
  [ -f "$f" ] || continue
  if grep -qE '(password|secret|api_key|apikey)\s*=\s*["\x27][^"\x27]+["\x27]' "$f" 2>/dev/null; then
    log_error "Possible hardcoded credential in: $f"
  fi
done

# 3. Check for negative shifts in Python files (look-ahead FAIL-01)
for f in $STAGED_FILES; do
  [[ "$f" == *.py ]] || continue
  [ -f "$f" ] || continue
  if grep -qE '\.shift\(-[0-9]+\)' "$f" 2>/dev/null; then
    log_error "Look-ahead bias detected in $f: .shift(-N) uses future data"
  fi
  if grep -qE 'rolling\(.*center\s*=\s*True' "$f" 2>/dev/null; then
    log_error "Look-ahead bias detected in $f: rolling(center=True) uses future data"
  fi
  if grep -qE 'train_test_split' "$f" 2>/dev/null && ! grep -qE 'shuffle\s*=\s*False|TimeSeriesSplit' "$f" 2>/dev/null; then
    log_warn "Random train_test_split in $f — verify temporal split is used for time-series data"
  fi
done

# 4. Check for baseline parity report if model results are committed
STAGED_REPORTS=$(git diff --cached --name-only 2>/dev/null | grep -E '(report|results).*\.(json|md)$' || true)
if [ -n "$STAGED_REPORTS" ]; then
  BASELINE_REPORTS=$(find "${REPO_ROOT}" -name "baseline_parity_report.json" 2>/dev/null | head -1)
  if [ -z "$BASELINE_REPORTS" ]; then
    log_warn "Model results staged but no baseline_parity_report.json found. Run baseline_parity.py first."
  else
    # Check if baseline parity passed
    PARITY_OVERALL=$(python3 -c "import json; d=json.load(open('${BASELINE_REPORTS}')); print(d.get('overall','UNKNOWN'))" 2>/dev/null || echo "UNKNOWN")
    if [ "$PARITY_OVERALL" = "PASS" ]; then
      log_ok "Baseline parity: PASS"
    elif [ "$PARITY_OVERALL" = "FAIL" ]; then
      log_error "Baseline parity: FAIL — model does not beat required baselines"
    else
      log_warn "Baseline parity: status unknown (${PARITY_OVERALL})"
    fi
  fi
fi

# 5. Check for LAIG report if new features are being added
STAGED_FEATURE_CODE=$(git diff --cached --name-only 2>/dev/null | grep -E 'features?\.py|engineering\.py|transform' || true)
if [ -n "$STAGED_FEATURE_CODE" ]; then
  LAIG_REPORT=$(find "${REPO_ROOT}" -name "laig_report.json" 2>/dev/null | head -1)
  if [ -z "$LAIG_REPORT" ]; then
    log_warn "Feature engineering changes staged but no laig_report.json. Run laig_scan.py."
  else
    LAIG_OVERALL=$(python3 -c "import json; d=json.load(open('${LAIG_REPORT}')); print(d.get('overall','UNKNOWN'))" 2>/dev/null || echo "UNKNOWN")
    if [ "$LAIG_OVERALL" = "PASS" ]; then
      log_ok "LAIG scan: PASS"
    elif [ "$LAIG_OVERALL" = "FAIL" ]; then
      log_error "LAIG scan: FAIL — look-ahead bias detected in features"
    else
      log_warn "LAIG scan: ${LAIG_OVERALL}"
    fi
  fi
fi

# 6. Check sunk cost guard if epoch metrics are being updated
STAGED_METRICS=$(git diff --cached --name-only 2>/dev/null | grep -E 'metrics.*history|epoch.*log' || true)
if [ -n "$STAGED_METRICS" ]; then
  SUNK_REPORT=$(find "${REPO_ROOT}" -name "sunk_cost_report.json" 2>/dev/null | head -1)
  if [ -n "$SUNK_REPORT" ]; then
    SUNK_VERDICT=$(python3 -c "import json; d=json.load(open('${SUNK_REPORT}')); print(d.get('verdict','UNKNOWN'))" 2>/dev/null || echo "UNKNOWN")
    if [ "$SUNK_VERDICT" = "STOP" ]; then
      log_error "Sunk cost guard: STOP — model shows no improvement. Document pivot decision first."
    elif [ "$SUNK_VERDICT" = "WARN" ]; then
      log_warn "Sunk cost guard: WARN — model on plateau. Consider pivot."
    else
      log_ok "Sunk cost guard: ${SUNK_VERDICT}"
    fi
  fi
fi

echo ""
echo "=== Governance Summary ==="
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo -e "${RED}BLOCKED: $ERRORS governance error(s). Fix before committing.${NC}"
  exit 2
elif [ "$WARNINGS" -gt 0 ]; then
  echo -e "${YELLOW}PASS WITH WARNINGS: $WARNINGS warning(s). Proceeding.${NC}"
  exit 0
else
  echo -e "${GREEN}PASS: All governance checks cleared.${NC}"
  exit 0
fi
