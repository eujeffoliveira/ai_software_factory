# Agente08_DevOps — Git Hook Scripts

Claude Code lifecycle hooks for DevOps pipeline protection and parallel agent coordination.

## Files

| Script | Hook Type | Trigger | Behavior |
|--------|-----------|---------|---------|
| `branch-guard.sh` | PreToolUse | Bash (git) | Blocks direct commits/pushes to protected branches |
| `parallel-agent-guard.sh` | PreToolUse | Bash/Write | Locking mechanism to prevent parallel agent conflicts |
| `parallel-agent-guard-cleanup.sh` | PostToolUse | Any | Releases locks after tool completes |

## Installation

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": "bash Agente08_DevOps/tools/git-hooks/branch-guard.sh"},
          {"type": "command", "command": "bash Agente08_DevOps/tools/git-hooks/parallel-agent-guard.sh"}
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash|Write|Edit",
        "hooks": [{"type": "command", "command": "bash Agente08_DevOps/tools/git-hooks/parallel-agent-guard-cleanup.sh"}]
      }
    ]
  }
}
```

## Hook Behaviors

### branch-guard.sh
Blocks (exit 2):
- `git commit` directly on main/master/develop
- `git push` directly to main/master/develop

Forces developers to use feature branches and PRs.

### parallel-agent-guard.sh
Implements file-based locking in `/tmp/claude-git-locks/` and `/tmp/claude-write-locks/`:
- **Git operations**: 30-second locks
- **File edits**: 10-second locks
- Lock files include PID and timestamp for ownership tracking
- Expired locks (stale) are automatically cleaned up

Prevents race conditions when multiple Claude Code agents run simultaneously.

### parallel-agent-guard-cleanup.sh
PostToolUse cleanup:
- Removes locks created by the current process (PPID matching)
- Does NOT remove locks owned by other processes
- Runs silently (exit 0 always)

## Lock Directory

Locks are stored in `/tmp/claude-git-locks/` and `/tmp/claude-write-locks/`. These are cleaned on reboot automatically. To manually clear stale locks:

```bash
rm -rf /tmp/claude-git-locks/ /tmp/claude-write-locks/
```
