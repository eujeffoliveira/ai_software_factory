#Requires -Version 7
<#
.SYNOPSIS
    Pester tests for link-roo.ps1

    Tests that can run without a full install:
    - Syntax (AST parse)
    - No FACTORY_ROOT → exit 1 (child process)
    - Missing roo/ files → exit 1
    - Valid copy: .roomodes and .clinerules copied to target directory (uses $TestDrive)
#>

BeforeAll {
    $factoryRoot = (Resolve-Path "$PSScriptRoot\..\.." ).Path
    $script      = Join-Path $factoryRoot "link-roo.ps1"
}

Describe "link-roo.ps1 — syntax and structure" {

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

    It "references .roomodes file" {
        $content = Get-Content $script -Raw
        $content | Should -Match '\.roomodes'
    }

    It "references .clinerules file" {
        $content = Get-Content $script -Raw
        $content | Should -Match '\.clinerules'
    }

    It "exits with error when no files are found in roo/" {
        $content = Get-Content $script -Raw
        $content | Should -Match '(?i)(exit\s+1|Write-Error)'
    }
}

Describe "link-roo.ps1 — exit code behavior (child process)" {

    It "exits 1 when FACTORY_ROOT is not set" {
        $result = pwsh -NonInteractive -Command "
            Remove-Item Env:FACTORY_ROOT -ErrorAction SilentlyContinue
            & '$script'
        " 2>&1
        $LASTEXITCODE | Should -Be 1
    }

    It "exits 1 when FACTORY_ROOT is set but roo/ directory has no files" {
        $fakeRoot = Join-Path $TestDrive "fake-factory-roo"
        New-Item -ItemType Directory -Path $fakeRoot -Force | Out-Null
        # Create roo/ dir but leave it empty (no .roomodes or .clinerules)
        New-Item -ItemType Directory -Path (Join-Path $fakeRoot "roo") -Force | Out-Null

        $result = pwsh -NonInteractive -Command "
            `$env:FACTORY_ROOT = '$fakeRoot'
            Set-Location '$TestDrive'
            & '$script'
        " 2>&1
        $LASTEXITCODE | Should -Be 1
    }
}

Describe "link-roo.ps1 — successful copy (uses TestDrive)" {

    It "copies .roomodes and .clinerules to current directory when both exist" {
        $fakeRoot = Join-Path $TestDrive "fake-factory-roo2"
        $rooDir   = Join-Path $fakeRoot "roo"
        New-Item -ItemType Directory -Path $rooDir -Force | Out-Null
        Set-Content (Join-Path $rooDir ".roomodes")   '{"customModes":[]}' -Encoding UTF8
        Set-Content (Join-Path $rooDir ".clinerules") '# factory rules'    -Encoding UTF8

        $targetDir = Join-Path $TestDrive "my-roo-project"
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

        $result = pwsh -NonInteractive -Command "
            `$env:FACTORY_ROOT = '$fakeRoot'
            Set-Location '$targetDir'
            & '$script'
        " 2>&1
        $LASTEXITCODE | Should -Be 0

        (Join-Path $targetDir ".roomodes")   | Should -Exist
        (Join-Path $targetDir ".clinerules") | Should -Exist
    }

    It "creates backups when target files already exist" {
        $fakeRoot = Join-Path $TestDrive "fake-factory-roo3"
        $rooDir   = Join-Path $fakeRoot "roo"
        New-Item -ItemType Directory -Path $rooDir -Force | Out-Null
        Set-Content (Join-Path $rooDir ".roomodes")   '{"customModes":[]}' -Encoding UTF8
        Set-Content (Join-Path $rooDir ".clinerules") '# factory rules'    -Encoding UTF8

        $targetDir = Join-Path $TestDrive "my-roo-project2"
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        # Pre-existing files
        Set-Content (Join-Path $targetDir ".roomodes")   '{"old":true}' -Encoding UTF8
        Set-Content (Join-Path $targetDir ".clinerules") '# old rules'  -Encoding UTF8

        $result = pwsh -NonInteractive -Command "
            `$env:FACTORY_ROOT = '$fakeRoot'
            Set-Location '$targetDir'
            & '$script'
        " 2>&1 | Out-String

        # Backup files should exist for at least one of the two files
        $bakFiles = Get-ChildItem $targetDir -Filter "*.bak*"
        $bakFiles.Count | Should -BeGreaterThan 0
    }

    It "copies only .roomodes when .clinerules is absent (partial roo/)" {
        $fakeRoot = Join-Path $TestDrive "fake-factory-roo4"
        $rooDir   = Join-Path $fakeRoot "roo"
        New-Item -ItemType Directory -Path $rooDir -Force | Out-Null
        Set-Content (Join-Path $rooDir ".roomodes") '{"customModes":[]}' -Encoding UTF8
        # .clinerules intentionally absent

        $targetDir = Join-Path $TestDrive "my-roo-project3"
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

        $result = pwsh -NonInteractive -Command "
            `$env:FACTORY_ROOT = '$fakeRoot'
            Set-Location '$targetDir'
            & '$script'
        " 2>&1
        # Should succeed (at least one file found and copied)
        $LASTEXITCODE | Should -Be 0
        (Join-Path $targetDir ".roomodes") | Should -Exist
    }
}
