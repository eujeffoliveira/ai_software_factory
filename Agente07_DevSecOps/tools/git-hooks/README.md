# Agente07_DevSecOps — Git Hook Scripts

Claude Code lifecycle hooks that enforce security policies during agent tool use.

## Files

| Script | Hook Type | Trigger | Behavior |
|--------|-----------|---------|---------|
| `security-gate.sh` | PreToolUse | Any tool call | Entry point — delegates to bash-guards.sh |
| `bash-guards.sh` | PreToolUse | Bash tool | Blocks destructive git commands |
| `config-guard.sh` | PreToolUse | Write tool | Blocks writes to protected config files |
| `secret-scan.sh` | PostToolUse | Edit/Write | Advisory scan for hardcoded credentials |

## Installation

Add to `.claude/settings.json` in your project root:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{"type": "command", "command": "bash Agente07_DevSecOps/tools/git-hooks/bash-guards.sh"}]
      },
      {
        "matcher": "Write",
        "hooks": [{"type": "command", "command": "bash Agente07_DevSecOps/tools/git-hooks/config-guard.sh"}]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{"type": "command", "command": "bash Agente07_DevSecOps/tools/git-hooks/secret-scan.sh"}]
      }
    ]
  }
}
```

## Hook Behaviors

### bash-guards.sh
Blocks these patterns (exit 2 = hard block):
- `git push --force` / `git push -f` on main/master/develop
- `git commit --no-verify` / `-n` flag
- `git rebase -i` (interactive rebase)
- `git clean -f` without explicit user intent
- `git reset --hard` (data loss risk)

### config-guard.sh
Blocks writes to:
- `.env`, `.env.*` files
- `package.json`, `package-lock.json`
- `tsconfig.json`, `vite.config.*`, `next.config.*`
- `playwright.config.*`, `vitest.config.*`
- `vercel.json`, `.github/workflows/**`

### secret-scan.sh
Advisory (exit 0, warns only) — scans for:
- API key patterns (`api_key`, `apiKey`)
- AWS credentials (`AKIA*`)
- Passwords in code (`password = "..."`)
- Database connection strings with credentials
- JWT secrets

## Exit Codes
- `0` = allow
- `1` = warn (hook feedback shown but execution continues)
- `2` = block (execution prevented)
