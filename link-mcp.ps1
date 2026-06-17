# link-mcp.ps1 — Vincular MCP da factory ao projeto atual
# Uso: & "$env:FACTORY_ROOT\link-mcp.ps1"

$ErrorActionPreference = "Stop"
$FACTORY_PATH = if ($env:FACTORY_ROOT) { $env:FACTORY_ROOT } else { Write-Error "FACTORY_ROOT nao definido."; exit 1 }
$SOURCE_MCP = Join-Path $FACTORY_PATH ".mcp.json"
$TARGET_MCP = Join-Path (Get-Location).Path ".mcp.json"
if (-not (Test-Path $SOURCE_MCP)) { Write-Error ".mcp.json nao encontrado. Execute install.ps1 primeiro."; exit 1 }

function ConvertTo-TomlString([string]$Value) {
    return '"' + $Value.Replace("\", "\\").Replace('"', '\"') + '"'
}

function Set-ManagedBlock([string]$Path, [string]$Begin, [string]$End, [string]$Block) {
    $nl = [Environment]::NewLine
    $existing = if (Test-Path $Path) { Get-Content $Path -Raw -Encoding UTF8 } else { "" }
    $start = $existing.IndexOf($Begin)
    $endIndex = if ($start -ge 0) { $existing.IndexOf($End, $start) } else { -1 }
    if ($start -ge 0 -and $endIndex -ge $start) {
        $endAfter = $endIndex + $End.Length
        while ($endAfter -lt $existing.Length -and ($existing[$endAfter] -eq [char]13 -or $existing[$endAfter] -eq [char]10)) { $endAfter++ }
        return ($existing.Substring(0, $start).TrimEnd() + $nl + $nl + $Block.Trim() + $nl + $existing.Substring($endAfter).TrimStart())
    }
    if ($existing.Trim()) { return $existing.TrimEnd() + $nl + $nl + $Block.Trim() + $nl }
    return $Block.Trim() + $nl
}

if (Test-Path $TARGET_MCP) {
    $bak = "$TARGET_MCP.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $TARGET_MCP $bak; Write-Host "  [BAK] $bak" -ForegroundColor DarkGray
}
Copy-Item $SOURCE_MCP $TARGET_MCP -Force
Write-Host "[OK] .mcp.json vinculado: $(Get-Location)" -ForegroundColor Green

$TARGET_CODEX_DIR = Join-Path (Get-Location).Path ".codex"
$TARGET_CODEX_CONFIG = Join-Path $TARGET_CODEX_DIR "config.toml"
if (-not (Test-Path $TARGET_CODEX_DIR)) { New-Item -ItemType Directory -Path $TARGET_CODEX_DIR -Force | Out-Null }

$begin = "# BEGIN ai_software_factory:codex-mcp"
$end = "# END ai_software_factory:codex-mcp"
$serverPath = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\server.py"
$dbPath = Join-Path $FACTORY_PATH "knowledge.db"
$codexRaw = if (Test-Path $TARGET_CODEX_CONFIG) { Get-Content $TARGET_CODEX_CONFIG -Raw -Encoding UTF8 } else { "" }
$hasUnmanagedKnowledge = ($codexRaw -match "(?m)^\s*\[mcp_servers\.knowledge\]\s*$") -and ($codexRaw -notlike "*$begin*")

if ($hasUnmanagedKnowledge) {
    Write-Host "[WARN] .codex/config.toml ja possui [mcp_servers.knowledge] fora do bloco gerenciado; preservado." -ForegroundColor Yellow
} else {
    $codexBlock = @(
        $begin,
        "[mcp_servers.knowledge]",
        'command = "python"',
        "args = [$(ConvertTo-TomlString $serverPath)]",
        "startup_timeout_sec = 20",
        "tool_timeout_sec = 60",
        "",
        "[mcp_servers.knowledge.env]",
        "KNOWLEDGE_DB = $(ConvertTo-TomlString $dbPath)",
        $end
    ) -join [Environment]::NewLine
    if (Test-Path $TARGET_CODEX_CONFIG) {
        $bak = "$TARGET_CODEX_CONFIG.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $TARGET_CODEX_CONFIG $bak; Write-Host "  [BAK] $bak" -ForegroundColor DarkGray
    }
    $newCodexConfig = Set-ManagedBlock $TARGET_CODEX_CONFIG $begin $end $codexBlock
    Set-Content -Path $TARGET_CODEX_CONFIG -Value $newCodexConfig -Encoding UTF8
    Write-Host "[OK] .codex/config.toml vinculado: $(Get-Location)" -ForegroundColor Green
}

Write-Host "     MCP knowledge search disponivel na proxima sessao Claude Code, Roo/Cline ou Codex."