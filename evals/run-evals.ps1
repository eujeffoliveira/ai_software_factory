#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Human-in-the-loop evaluation harness for the AI Software Factory agents.

.DESCRIPTION
    Lists test cases from evals/cases/, presents each prompt for manual execution
    in Claude Code, collects the agent's response from the user, checks it against
    expected_contains and must_not_contain criteria, prompts for a PASS/FAIL/PARTIAL
    score, and writes results to evals/results/<timestamp>-results.json.

    No API access required — evaluation is performed manually by a human who runs
    the prompts in Claude Code and pastes the responses here.

.PARAMETER CaseName
    Run a single case by name. Partial match is supported (e.g., "python" matches
    "python_automation_classification"). If omitted, all cases are run.

.PARAMETER RubricName
    Load a specific rubric from evals/rubrics/ for scoring guidance.
    Displays the rubric dimensions before each response is scored.
    Example: "techlead_rubric" loads evals/rubrics/techlead_rubric.md.

.PARAMETER OutputDir
    Directory to write result files. Defaults to evals/results/.

.PARAMETER NonInteractive
    Skip the response paste step and record results as SKIPPED.
    Useful for dry-run listing of available cases.

.EXAMPLE
    .\evals\run-evals.ps1
    Run all cases interactively.

.EXAMPLE
    .\evals\run-evals.ps1 -CaseName python
    Run only the python_automation_classification case.

.EXAMPLE
    .\evals\run-evals.ps1 -CaseName security -RubricName devsecops_rubric
    Run the security_review case with the devsecops rubric shown for guidance.

.EXAMPLE
    .\evals\run-evals.ps1 -NonInteractive
    List all available cases without running them.
#>

[CmdletBinding()]
param(
    [string]$CaseName = "",
    [string]$RubricName = "",
    [string]$OutputDir = "",
    [switch]$NonInteractive
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Resolve paths -----------------------------------------------------------

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$EvalsDir  = $ScriptDir
$CasesDir  = Join-Path $EvalsDir "cases"
$RubricsDir = Join-Path $EvalsDir "rubrics"

if ($OutputDir -eq "") {
    $OutputDir = Join-Path $EvalsDir "results"
}

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# --- Helper functions --------------------------------------------------------

function Write-Banner {
    param([string]$Text, [string]$Color = "Cyan")
    $line = "=" * 72
    Write-Host "`n$line" -ForegroundColor $Color
    Write-Host "  $Text" -ForegroundColor $Color
    Write-Host "$line`n" -ForegroundColor $Color
}

function Write-Section {
    param([string]$Text, [string]$Color = "Yellow")
    $line = "-" * 60
    Write-Host "`n$line" -ForegroundColor DarkGray
    Write-Host "  $Text" -ForegroundColor $Color
    Write-Host "$line" -ForegroundColor DarkGray
}

function Write-Label {
    param([string]$Label, [string]$Value, [string]$LabelColor = "White", [string]$ValueColor = "Gray")
    Write-Host "  $Label" -ForegroundColor $LabelColor -NoNewline
    Write-Host " $Value" -ForegroundColor $ValueColor
}

function Read-MultilineInput {
    param([string]$Prompt)
    Write-Host "`n$Prompt" -ForegroundColor Cyan
    Write-Host "  (Paste the agent response. When done, enter a line with only: END)" -ForegroundColor DarkGray
    Write-Host ""
    $lines = @()
    while ($true) {
        $line = Read-Host
        if ($line -eq "END") { break }
        $lines += $line
    }
    return $lines -join "`n"
}

function Get-CriteriaResult {
    param(
        [string]$Response,
        [string[]]$ExpectedContains,
        [string[]]$MustNotContain
    )

    $passed  = @()
    $failed  = @()
    $blocked = @()

    foreach ($term in $ExpectedContains) {
        if ($Response -match [regex]::Escape($term)) {
            $passed += $term
        } else {
            $failed += $term
        }
    }

    foreach ($term in $MustNotContain) {
        if ($Response -match [regex]::Escape($term)) {
            $blocked += $term
        }
    }

    return @{
        passed_contains  = $passed
        failed_contains  = $failed
        found_forbidden  = $blocked
        auto_pass        = ($failed.Count -eq 0 -and $blocked.Count -eq 0)
        auto_fail        = ($blocked.Count -gt 0)
    }
}

function Show-RubricSummary {
    param([string]$RubricPath)

    if (-not (Test-Path $RubricPath)) {
        Write-Host "  [Rubric file not found: $RubricPath]" -ForegroundColor DarkYellow
        return
    }

    $content = Get-Content $RubricPath -Raw
    # Extract dimension headers (lines starting with "### ")
    $dimensionLines = $content -split "`n" | Where-Object { $_ -match "^### " }

    Write-Host "`n  Rubric dimensions to evaluate:" -ForegroundColor Cyan
    $i = 1
    foreach ($dim in $dimensionLines) {
        $dimName = $dim -replace "^### \d+\. ", "" -replace "^### ", ""
        Write-Host "    $i. $dimName" -ForegroundColor Gray
        $i++
    }
    Write-Host ""
}

function Load-Cases {
    param([string]$FilterName)

    $caseFiles = Get-ChildItem -Path $CasesDir -Filter "*.json" | Sort-Object Name

    if ($FilterName -ne "") {
        $caseFiles = $caseFiles | Where-Object { $_.BaseName -like "*$FilterName*" }
    }

    if ($caseFiles.Count -eq 0) {
        $msg = if ($FilterName -ne "") { "No cases matched '$FilterName'" } else { "No case files found in $CasesDir" }
        Write-Host "`n  $msg" -ForegroundColor Red
        exit 1
    }

    $cases = @()
    foreach ($file in $caseFiles) {
        try {
            $data = Get-Content $file.FullName -Raw | ConvertFrom-Json
            $data | Add-Member -NotePropertyName "_file" -NotePropertyValue $file.FullName
            $cases += $data
        } catch {
            Write-Host "  [WARNING] Could not parse $($file.Name): $_" -ForegroundColor Yellow
        }
    }

    return $cases
}

# --- Main execution ----------------------------------------------------------

Write-Banner "AI SOFTWARE FACTORY — Evaluation Harness" "Cyan"
Write-Host "  Cases directory : $CasesDir" -ForegroundColor DarkGray
Write-Host "  Rubrics directory: $RubricsDir" -ForegroundColor DarkGray
Write-Host "  Output directory: $OutputDir" -ForegroundColor DarkGray

# Load cases
$cases = Load-Cases -FilterName $CaseName

Write-Host "`n  Found $($cases.Count) case(s) to run." -ForegroundColor White

if ($NonInteractive) {
    Write-Banner "Available Cases (Non-Interactive Mode)" "Yellow"
    $i = 1
    foreach ($case in $cases) {
        Write-Host "  $i. $($case.name)" -ForegroundColor Cyan
        Write-Host "     Agent   : $($case.agent)" -ForegroundColor Gray
        Write-Host "     Archetype: $($case.archetype)" -ForegroundColor Gray
        Write-Host "     Gate    : $($case.gate)" -ForegroundColor Gray
        Write-Host "     Rubric  : $($case.rubric)" -ForegroundColor Gray
        Write-Host ""
        $i++
    }
    exit 0
}

# Load rubric override if specified
$rubricOverridePath = ""
if ($RubricName -ne "") {
    $rubricOverridePath = Join-Path $RubricsDir "$RubricName.md"
    if (-not (Test-Path $rubricOverridePath)) {
        Write-Host "  [WARNING] Rubric not found: $rubricOverridePath — rubric guidance will be skipped." -ForegroundColor Yellow
        $rubricOverridePath = ""
    }
}

# Initialize results structure
$timestamp    = Get-Date -Format "yyyyMMdd-HHmmss"
$resultsFile  = Join-Path $OutputDir "$timestamp-results.json"
$sessionStart = Get-Date -Format "o"

$results = @{
    session_start  = $sessionStart
    evaluator      = $env:USERNAME
    cases_run      = 0
    cases_passed   = 0
    cases_failed   = 0
    cases_partial  = 0
    cases_skipped  = 0
    case_results   = @()
}

# --- Run each case -----------------------------------------------------------

$caseIndex = 0
foreach ($case in $cases) {
    $caseIndex++

    Write-Banner "CASE $caseIndex of $($cases.Count): $($case.name)" "Magenta"

    # Case metadata
    Write-Label "Agent    :" "@$($case.agent)" "White" "Cyan"
    Write-Label "Archetype:" "$($case.archetype)" "White" "Gray"
    Write-Label "Gate     :" "$($case.gate)" "White" "Gray"
    Write-Label "Rubric   :" "$($case.rubric)" "White" "Gray"

    if ($case.PSObject.Properties['description']) {
        Write-Host "`n  Description:" -ForegroundColor White
        Write-Host "  $($case.description)" -ForegroundColor DarkGray
    }

    # Notes
    if ($case.PSObject.Properties['notes'] -and $case.notes -ne "") {
        Write-Host "`n  Evaluation notes:" -ForegroundColor Yellow
        # Word-wrap the notes at 68 chars
        $noteWords = $case.notes -split ' '
        $line = "  "
        foreach ($word in $noteWords) {
            if (($line.Length + $word.Length + 1) -gt 72) {
                Write-Host $line -ForegroundColor DarkYellow
                $line = "  $word "
            } else {
                $line += "$word "
            }
        }
        if ($line.Trim() -ne "") { Write-Host $line -ForegroundColor DarkYellow }
    }

    # Show prompt
    Write-Section "PROMPT TO SEND TO AGENT" "Cyan"
    Write-Host ""
    Write-Host $case.prompt -ForegroundColor White
    Write-Host ""

    # Show rubric if available
    $rubricPath = $rubricOverridePath
    if ($rubricPath -eq "" -and $case.PSObject.Properties['rubric'] -and $case.rubric -ne "") {
        $rubricPath = Join-Path $RubricsDir "$($case.rubric).md"
    }
    if ($rubricPath -ne "") {
        Show-RubricSummary -RubricPath $rubricPath
    }

    # Instruction to evaluator
    Write-Host "  ACTION REQUIRED:" -ForegroundColor Green
    Write-Host "  1. Copy the prompt above." -ForegroundColor White
    Write-Host "  2. In Claude Code, start a new session or message directed at: @$($case.agent)" -ForegroundColor White
    Write-Host "  3. Paste the prompt and send it." -ForegroundColor White
    Write-Host "  4. Copy the agent's complete response." -ForegroundColor White
    Write-Host "  5. Return here and paste the response." -ForegroundColor White
    Write-Host ""

    $skipResponse = $false
    $confirm = Read-Host "  Ready to paste response? [Y=yes / S=skip this case / Q=quit]"
    if ($confirm -eq "Q" -or $confirm -eq "q") {
        Write-Host "`n  Evaluation session ended by evaluator." -ForegroundColor Yellow
        break
    }
    if ($confirm -eq "S" -or $confirm -eq "s") {
        $skipResponse = $true
    }

    $agentResponse = ""
    $criteriaResult = @{}
    $score = "SKIPPED"

    if (-not $skipResponse) {
        # Collect response
        $agentResponse = Read-MultilineInput "Paste the agent response (end with a line containing only: END)"

        # Auto-check criteria
        $expectedContains = @()
        $mustNotContain   = @()

        if ($case.PSObject.Properties['expected_contains']) {
            $expectedContains = @($case.expected_contains)
        }
        if ($case.PSObject.Properties['must_not_contain']) {
            $mustNotContain = @($case.must_not_contain)
        }

        $criteriaResult = Get-CriteriaResult `
            -Response $agentResponse `
            -ExpectedContains $expectedContains `
            -MustNotContain $mustNotContain

        # Show auto-check results
        Write-Section "AUTOMATED CRITERIA CHECK" "Yellow"

        if ($criteriaResult.passed_contains.Count -gt 0) {
            Write-Host "`n  FOUND (expected_contains):" -ForegroundColor Green
            foreach ($term in $criteriaResult.passed_contains) {
                Write-Host "    [+] $term" -ForegroundColor Green
            }
        }

        if ($criteriaResult.failed_contains.Count -gt 0) {
            Write-Host "`n  MISSING (expected_contains):" -ForegroundColor Red
            foreach ($term in $criteriaResult.failed_contains) {
                Write-Host "    [-] $term" -ForegroundColor Red
            }
        }

        if ($criteriaResult.found_forbidden.Count -gt 0) {
            Write-Host "`n  FORBIDDEN TERMS FOUND (must_not_contain):" -ForegroundColor Red
            foreach ($term in $criteriaResult.found_forbidden) {
                Write-Host "    [!] $term" -ForegroundColor Red
            }
        }

        if ($criteriaResult.auto_pass) {
            Write-Host "`n  Auto-check: ALL CRITERIA MET" -ForegroundColor Green
        } elseif ($criteriaResult.auto_fail) {
            Write-Host "`n  Auto-check: FORBIDDEN TERMS PRESENT — likely FAIL" -ForegroundColor Red
        } else {
            Write-Host "`n  Auto-check: SOME EXPECTED TERMS MISSING — review needed" -ForegroundColor Yellow
        }

        # Human score
        Write-Host ""
        Write-Host "  Based on the criteria check and rubric dimensions, enter your score:" -ForegroundColor Cyan
        Write-Host "    PASS    = All criteria met, response demonstrates expected behavior" -ForegroundColor Green
        Write-Host "    PARTIAL = Some criteria met, some missing, or rubric score is borderline" -ForegroundColor Yellow
        Write-Host "    FAIL    = Critical criteria missing, forbidden terms present, or fundamentally wrong" -ForegroundColor Red
        Write-Host ""

        $validScores = @("PASS", "PARTIAL", "FAIL", "pass", "partial", "fail", "p", "f")
        do {
            $scoreInput = Read-Host "  Score [PASS/PARTIAL/FAIL]"
            $scoreInput = $scoreInput.ToUpper().Trim()
            if ($scoreInput -eq "P") { $scoreInput = "PASS" }
            if ($scoreInput -eq "F") { $scoreInput = "FAIL" }
        } while ($scoreInput -notin @("PASS", "PARTIAL", "FAIL"))

        $score = $scoreInput

        # Optional notes
        $evalNotes = Read-Host "  Optional evaluator notes (press Enter to skip)"
    }

    # Record result
    $caseResult = @{
        name             = $case.name
        agent            = $case.agent
        archetype        = $case.archetype
        gate             = $case.gate
        score            = $score
        timestamp        = (Get-Date -Format "o")
        auto_check       = $criteriaResult
        response_length  = $agentResponse.Length
        evaluator_notes  = if ($skipResponse) { "case skipped by evaluator" } else { $evalNotes }
    }
    $results.case_results += $caseResult
    $results.cases_run++

    switch ($score) {
        "PASS"    { $results.cases_passed++ }
        "FAIL"    { $results.cases_failed++ }
        "PARTIAL" { $results.cases_partial++ }
        "SKIPPED" { $results.cases_skipped++ }
    }

    # Live summary line
    $scoreColor = switch ($score) {
        "PASS"    { "Green" }
        "FAIL"    { "Red" }
        "PARTIAL" { "Yellow" }
        default   { "Gray" }
    }
    Write-Host "`n  Result recorded: " -NoNewline -ForegroundColor White
    Write-Host $score -ForegroundColor $scoreColor
}

# --- Final summary -----------------------------------------------------------

Write-Banner "EVALUATION COMPLETE — SUMMARY" "Cyan"

$total = $results.cases_run
Write-Host "  Cases evaluated : $total" -ForegroundColor White
Write-Host "  PASS            : $($results.cases_passed)" -ForegroundColor Green
Write-Host "  FAIL            : $($results.cases_failed)" -ForegroundColor Red
Write-Host "  PARTIAL         : $($results.cases_partial)" -ForegroundColor Yellow
Write-Host "  SKIPPED         : $($results.cases_skipped)" -ForegroundColor Gray

if ($total -gt 0) {
    $passRate = [math]::Round(($results.cases_passed / $total) * 100, 1)
    Write-Host ""
    Write-Host "  Pass rate       : $passRate%" -ForegroundColor $(if ($passRate -ge 80) { "Green" } elseif ($passRate -ge 60) { "Yellow" } else { "Red" })
}

# Case-by-case recap
if ($results.case_results.Count -gt 0) {
    Write-Section "Case Results" "White"
    foreach ($r in $results.case_results) {
        $scoreColor = switch ($r.score) {
            "PASS"    { "Green" }
            "FAIL"    { "Red" }
            "PARTIAL" { "Yellow" }
            default   { "Gray" }
        }
        Write-Host "  [$($r.score.PadRight(7))] $($r.name)" -ForegroundColor $scoreColor
    }
}

# Save results
$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $resultsFile -Encoding UTF8

Write-Host ""
Write-Host "  Results saved to:" -ForegroundColor White
Write-Host "  $resultsFile" -ForegroundColor Cyan
Write-Host ""

# Exit code: 0 if all passed, 1 if any failed
if ($results.cases_failed -gt 0) {
    exit 1
} else {
    exit 0
}
