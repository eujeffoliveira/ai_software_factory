#!/bin/bash
# =============================================================================
# agent-metrics.sh — Dashboard de métricas de invocação dos agentes
# Lê logs do SubagentStop e scorecard JSONL.
#
# Uso: bash tools/factory-scripts/agent-metrics.sh
#
# Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/scripts
# =============================================================================

LOG="/tmp/claude-agent-log.txt"
SCORECARD="$HOME/.claude/metrics/agent-scorecard.jsonl"

echo "=== Agent Scorecard — ai_software_factory ==="
echo ""

# --- SubagentStop log (basico) ---
if [ -f "$LOG" ]; then
  TOTAL=$(wc -l < "$LOG" | tr -d ' ')
  echo "Total invocations (SubagentStop log): $TOTAL"
  echo ""

  echo "By hour:"
  awk -F'[][]' '{print $2}' "$LOG" | cut -d: -f1 | sort | uniq -c | sort -rn
  echo ""

  echo "Session activity (first → last):"
  FIRST=$(head -1 "$LOG" | awk -F'[][]' '{print $2}')
  LAST=$(tail -1 "$LOG" | awk -F'[][]' '{print $2}')
  echo "  First: $FIRST | Last: $LAST"
  echo ""

  echo "Last 10 entries:"
  tail -10 "$LOG"
  echo ""
else
  echo "No SubagentStop log at $LOG"
  echo ""
fi

# --- Scorecard JSONL (detalhado) ---
if [ -f "$SCORECARD" ]; then
  echo "=== Detailed Scorecard (JSONL) ==="
  echo ""

  echo "Top 10 agents by invocations:"
  python3 -c "
import json, sys
from collections import Counter, defaultdict

agents = Counter()
durations = defaultdict(list)
successes = Counter()
failures = Counter()

with open('$SCORECARD') as f:
    for line in f:
        try:
            d = json.loads(line.strip())
            name = d.get('agent', 'unknown')
            agents[name] += 1
            if 'duration_ms' in d:
                durations[name].append(d['duration_ms'])
            if d.get('success', True):
                successes[name] += 1
            else:
                failures[name] += 1
        except:
            continue

print(f'  Total entries: {sum(agents.values())}')
print()
for name, count in agents.most_common(10):
    avg_dur = ''
    if durations[name]:
        avg_ms = sum(durations[name]) / len(durations[name])
        avg_dur = f' | avg: {avg_ms/1000:.1f}s'
    success_rate = ''
    total = successes[name] + failures[name]
    if total > 0:
        rate = successes[name] / total * 100
        success_rate = f' | success: {rate:.0f}%'
    print(f'  {count:>4}x  {name}{avg_dur}{success_rate}')
" 2>/dev/null
  echo ""
else
  echo "No scorecard at $SCORECARD"
  echo ""
  echo "Para registrar metricas, adicione ao hook PostToolUse(SubagentStop):"
  echo '  {"agent":"agente06-qaengineer","duration_ms":45000,"success":true,"timestamp":"2026-01-01T10:00:00Z"}'
  mkdir -p "$(dirname "$SCORECARD")"
fi

echo "Para resetar: rm $LOG && rm $SCORECARD"
