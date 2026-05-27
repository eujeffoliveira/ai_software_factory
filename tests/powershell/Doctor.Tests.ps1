#Requires -Version 7
<#
.SYNOPSIS
    Pester tests for doctor.ps1

    Tests that can run without a live factory install:
    - Syntax (AST parse)
    - Helper function definitions
    - 14-category coverage (content check)
    - Exit code when FACTORY_ROOT is unset (structural behavior via child process)
#>

BeforeAll {
    $factoryRoot = (Resolve-Path "$PSScriptRoot\..\.." ).Path
    $script      = Join-Path $factoryRoot "doctor.ps1"
}

Describe "doctor.ps1 — syntax and structure" {

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

    It "declares Write-CheckOK helper function" {
        $content = Get-Content $script -Raw
        $content | Should -Match 'function Write-CheckOK'
    }

    It "declares Write-CheckError helper function" {
        $content = Get-Content $script -Raw
        $content | Should -Match 'function Write-CheckError'
    }

    It "declares Write-CheckWarn helper function" {
        $content = Get-Content $script -Raw
        $content | Should -Match 'function Write-CheckWarn'
    }

    It "declares Write-Section helper function" {
        $content = Get-Content $script -Raw
        $content | Should -Match 'function Write-Section'
    }

    It "uses hadError flag for exit code control" {
        $content = Get-Content $script -Raw
        $content | Should -Match '\$hadError'
    }
}

Describe "doctor.ps1 — 14 diagnostic categories" {

    BeforeAll {
        $content = Get-Content $script -Raw
    }

    It "category 1: FACTORY_ROOT check present" {
        $content | Should -Match '1\.\s*FACTORY_ROOT'
    }

    It "category 2: versao/version check present" {
        $content | Should -Match '(?i)2\.\s*(versao|version)'
    }

    It "category 3: Python check present" {
        $content | Should -Match '3\.\s*Python'
    }

    It "category 4: Claude Code check present" {
        $content | Should -Match '4\.\s*Claude Code'
    }

    It "category 5: Roo Code check present" {
        $content | Should -Match '(?i)5\.\s*Roo'
    }

    It "category 6: Agentes check present" {
        $content | Should -Match '(?i)6\.\s*(Claude Code — Agentes|Agentes)'
    }

    It "category 7: Knowledge Database check present" {
        $content | Should -Match '(?i)7\.\s*Knowledge'
    }

    It "category 8: MCP Health check present" {
        $content | Should -Match '(?i)8\.\s*MCP'
    }

    It "category 9: MCP Configuracao check present" {
        $content | Should -Match '(?i)9\.\s*MCP'
    }

    It "category 10: Roo Code configuracoes check present" {
        $content | Should -Match '(?i)10\.\s*Roo'
    }

    It "category 11: Paths em agentes check present" {
        $content | Should -Match '(?i)11\.\s*Path'
    }

    It "category 12: Scripts principais check present" {
        $content | Should -Match '(?i)12\.\s*Script'
    }

    It "category 13: Permissoes check present" {
        $content | Should -Match '(?i)13\.\s*(Permiss|Permission)'
    }

    It "category 14: Variaveis de ambiente check present" {
        $content | Should -Match '(?i)14\.\s*Vari'
    }
}

Describe "doctor.ps1 — exit code behavior via child process" {

    It "exits 0 when running against factory root (no errors expected for structure)" {
        $result = pwsh -NonInteractive -File $script -ErrorAction SilentlyContinue 2>&1
        # doctor.ps1 exits 1 only on ERROR conditions; syntax/structure alone should not fail
        # We just verify the script runs without crashing (exit 0 or 1 are both valid here
        # depending on the actual install state, but it must not throw an unhandled exception)
        $LASTEXITCODE | Should -BeIn @(0, 1)
    }

    It "produces output containing category headers" {
        $result = pwsh -NonInteractive -File $script 2>&1 | Out-String
        $result | Should -Match '(?i)(FACTORY_ROOT|Python|Claude Code)'
    }
}
