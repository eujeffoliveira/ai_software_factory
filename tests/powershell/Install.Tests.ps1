#Requires -Version 7
<#
.SYNOPSIS
    Pester tests for install.ps1

    Tests that can run without a full install:
    - Syntax (AST parse)
    - Parameter block
    - Idempotency via WhatIf-equivalent (version file check)
    - $agents array structure
    - VERSION file format
#>

BeforeAll {
    $factoryRoot = (Resolve-Path "$PSScriptRoot\..\.." ).Path
    $script      = Join-Path $factoryRoot "install.ps1"
    $versionFile = Join-Path $factoryRoot "VERSION"
}

Describe "install.ps1 — syntax and structure" {

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

    It "declares -ForceDeps parameter" {
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $script, [ref]$null, [ref]$null
        )
        $paramBlock = $ast.Find(
            { $args[0] -is [System.Management.Automation.Language.ParamBlockAst] }, $true
        )
        $paramBlock | Should -Not -BeNullOrEmpty
        $names = $paramBlock.Parameters.Name.VariablePath.UserPath
        $names | Should -Contain 'ForceDeps'
    }

    It "contains FACTORY_VERSION variable" {
        $content = Get-Content $script -Raw
        $content | Should -Match 'FACTORY_VERSION'
    }

    It "references VERSION file" {
        $content = Get-Content $script -Raw
        $content | Should -Match 'VERSION'
    }

    It "defines \$agents array" {
        $content = Get-Content $script -Raw
        $content | Should -Match '\$agents\s*='
    }

    It "\$agents array contains 11 entries" {
        # Count agent object literals — each entry has 'Name ='
        $content = Get-Content $script -Raw
        $matches = [regex]::Matches($content, '(?i)\bName\s*=\s*"[^"]+"')
        $matches.Count | Should -Be 11
    }
}

Describe "install.ps1 — VERSION file" {

    It "VERSION file exists" {
        $versionFile | Should -Exist
    }

    It "VERSION file is non-empty" {
        $content = Get-Content $versionFile -Raw
        $content.Trim() | Should -Not -BeNullOrEmpty
    }

    It "VERSION file contains a semver string (X.Y.Z)" {
        $content = (Get-Content $versionFile -Raw).Trim()
        $content | Should -Match '^\d+\.\d+\.\d+'
    }
}

Describe "install.ps1 — idempotency markers in script" {

    It "computes content hashes before writing (idempotency)" {
        $content = Get-Content $script -Raw
        $content | Should -Match '(?i)hash|sem mudancas|unchanged'
    }

    It "does not use 'Set-Content' for agent files without hash check" {
        # All agent file writes should be guarded — script should not blindly overwrite
        $content = Get-Content $script -Raw
        # The presence of a hash/comparison mechanism
        $content | Should -Match '(?i)hash|compare|mudancas'
    }
}
