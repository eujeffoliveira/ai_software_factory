# Support

## Where to get help

**Bugs and unexpected behavior** — open a [GitHub Issue](https://github.com/eujeffoliveira/ai_software_factory/issues/new/choose) and select the appropriate template:

| Issue type | Template to use |
|---|---|
| Installation problem | `bug_report.yml` |
| MCP server not working | `mcp_problem.yml` |
| Agent behaving incorrectly | `agent_behavior.yml` |
| Documentation unclear or wrong | `documentation.yml` |
| New feature or improvement | `feature_request.yml` |

**Questions and discussion** — use [GitHub Discussions](https://github.com/eujeffoliveira/ai_software_factory/discussions) for usage questions, ideas, and general conversation.

Issue templates live in [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/) and are loaded automatically by GitHub when you click **New Issue**.

---

## Before opening an issue

Run the built-in diagnostics and attach the output to your report. This speeds up triage significantly.

### 1. Run the factory doctor

```powershell
.\doctor.ps1
```

Copy the full output. The doctor checks 14 categories including environment variables, agent files, MCP configuration, knowledge database, and Python dependencies.

### 2. Run the MCP health check

```powershell
.\test-mcp.ps1
```

Copy the full output. This runs 7 checks against the MCP Knowledge Search server and reports pass/fail for each.

### 3. Check the factory version

```powershell
Get-Content VERSION
```

Or check `knowledge-config.json` for the `factory_version` field (generated after install).

---

## Information to include in your report

| Field | How to get it |
|---|---|
| Factory version | `Get-Content VERSION` |
| OS and version | `(Get-WmiObject Win32_OperatingSystem).Caption` on Windows; `uname -a` on Linux/macOS |
| Python version | `python --version` |
| Claude Code version | `claude --version` |
| `doctor.ps1` output | Full terminal output |
| `test-mcp.ps1` output | Full terminal output |
| Steps to reproduce | Exact commands or agent invocations |
| Expected vs actual behavior | Describe clearly |

---

## Common issues

| Symptom | First thing to try |
|---|---|
| Agent not found in Claude Code | Re-run `.\install.ps1` |
| MCP search returns no results | Run `.\update-knowledge.ps1`, then `.\test-mcp.ps1` |
| `doctor.ps1` shows ERROR on `FACTORY_ROOT` | Re-run `.\install.ps1` to set the env var |
| Python import errors in MCP | Run `.\install.ps1 -ForceDeps` |
| Roo Code modes not appearing | Run `.\link-roo.ps1` from within the target project |

See `docs/TROUBLESHOOTING.md` for a full problem/fix reference.

---

## Security issues

Do not open a public issue for security-related problems. Follow the process described in `SECURITY.md`.
