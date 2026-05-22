#Requires -Version 7
<#
.SYNOPSIS
    Pester tests for link-mcp.ps1

    Tests that can run without a full install:
    - Syntax (AST parse)
    - No FACTORY_ROOT → exit 1 (child process)
    - Missing .mcp.json → exit 1 (child process with fake FACTORY_ROOT)
    - Valid copy: .mcp.json copied to target directory (uses $TestDrive)
#>

BeforeAll {
    $factoryRoot = (Resolve-Path "$PSScriptRoot\..\.." ).Path
    $script      = Join-Path $factoryRoot "link-mcp.ps1"
}

Describe "link-mcp.ps1 — syntax and structure" {

    It "script file exists" {
        $script | Should -Exist
    }

    It "parses without syntax errors" {
        $errors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile(
            $script, [ref]$null, [ref]$errors
        )
        $errors | Should -BeNullOrEmpty
    }

    It "references FACTORY_ROOT environment variable" {
        $content = Get-Content $script -Raw
        $content | Should -Match 'FACTORY_ROOT'
    }

    It "references .mcp.json source file" {
        $content = Get-Content $script -Raw
        $content | Should -Match '\.mcp\.json'
    }

    It "exits with error message when FACTORY_ROOT is missing" {
        $content = Get-Content $script -Raw
        $content | Should -Match '(?i)(exit\s+1|Write-Error)'
    }
}

Describe "link-mcp.ps1 — exit code behavior (child process)" {

    It "exits 1 when FACTORY_ROOT is not set" {
        $result = pwsh -NonInteractive -Command "
            Remove-Item Env:FACTORY_ROOT -ErrorAction SilentlyContinue
            & '$script'
        " 2>&1
        $LASTEXITCODE | Should -Be 1
    }

    It "exits 1 when FACTORY_ROOT is set but .mcp.json does not exist" {
        $fakeRoot = Join-Path $TestDrive "fake-factory"
        New-Item -ItemType Directory -Path $fakeRoot -Force | Out-Null
        # .mcp.json intentionally NOT created

        $result = pwsh -NonInteractive -Command "
            `$env:FACTORY_ROOT = '$fakeRoot'
            Set-Location '$TestDrive'
            & '$script'
        " 2>&1
        $LASTEXITCODE | Should -Be 1
    }
}

Describe "link-mcp.ps1 — successful copy (uses TestDrive)" {

    It "copies .mcp.json to current directory when FACTORY_ROOT and source exist" {
        # Set up a fake factory with .mcp.json
        $fakeRoot = Join-Path $TestDrive "fake-factory"
        New-Item -ItemType Directory -Path $fakeRoot -Force | Out-Null
        $sourceMcp = Join-Path $fakeRoot ".mcp.json"
        Set-Content $sourceMcp '{"mcpServers":{"knowledge":{}}}' -Encoding UTF8

        # Target directory: a separate temp folder
        $targetDir = Join-Path $TestDrive "my-project"
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

        $result = pwsh -NonInteractive -Command "
            `$env:FACTORY_ROOT = '$fakeRoot'
            Set-Location '$targetDir'
            & '$script'
        " 2>&1
        $LASTEXITCODE | Should -Be 0

        $targetMcp = Join-Path $targetDir ".mcp.json"
        $targetMcp | Should -Exist
    }

    It "creates a backup when .mcp.json already exists in target directory" {
        $fakeRoot = Join-Path $TestDrive "fake-factory2"
        New-Item -ItemType Directory -Path $fakeRoot -Force | Out-Null
        Set-Content (Join-Path $fakeRoot ".mcp.json") '{"mcpServers":{"knowledge":{}}}' -Encoding UTF8

        $targetDir = Join-Path $TestDrive "my-project2"
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        # Pre-existing .mcp.json in target
        Set-Content (Join-Path $targetDir ".mcp.json") '{"old":"config"}' -Encoding UTF8

        $result = pwsh -NonInteractive -Command "
            `$env:FACTORY_ROOT = '$fakeRoot'
            Set-Location '$targetDir'
            & '$script'
        " 2>&1 | Out-String

        # A .bak file should have been created
        $bakFiles = Get-ChildItem $targetDir -Filter "*.bak*"
        $bakFiles.Count | Should -BeGreaterThan 0
    }
}
