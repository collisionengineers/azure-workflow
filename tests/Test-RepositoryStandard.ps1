[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$validator = Join-Path $repositoryRoot 'plugins\azure-workflow\scripts\Test-AzureWorkflowRepository.ps1'
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-ExitCode {
    param([int]$Expected, [string]$Name)
    if ($LASTEXITCODE -ne $Expected) { $script:failures.Add("$Name expected exit $Expected, observed $LASTEXITCODE") }
}

& $validator -RepositoryPath $repositoryRoot | Out-Host
Assert-ExitCode 0 'current repository'

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("azure-workflow-repository-test-" + [guid]::NewGuid().ToString('N'))
$resolvedTempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
$resolvedTempRoot = [System.IO.Path]::GetFullPath($tempRoot)
if (-not $resolvedTempRoot.StartsWith($resolvedTempBase, [System.StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing unsafe temporary test path.' }

try {
    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'AGENTS.md') -Destination $tempRoot
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'docs') -Destination (Join-Path $tempRoot 'docs') -Recurse
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'plugins') -Destination (Join-Path $tempRoot 'plugins') -Recurse
    New-Item -ItemType Directory -Path (Join-Path $tempRoot '.github') | Out-Null
    Copy-Item -LiteralPath (Join-Path $repositoryRoot '.github\ISSUE_TEMPLATE') -Destination (Join-Path $tempRoot '.github\ISSUE_TEMPLATE') -Recurse
    Copy-Item -LiteralPath (Join-Path $repositoryRoot '.github\pull_request_template.md') -Destination (Join-Path $tempRoot '.github\pull_request_template.md')

    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 0 'compliant fixture copy'

    $indexPath = Join-Path $tempRoot 'docs\index.md'
    $savedIndex = Get-Content -LiteralPath $indexPath -Raw
    Remove-Item -LiteralPath $indexPath -Force
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'missing authority index'
    [System.IO.File]::WriteAllText($indexPath, $savedIndex, [System.Text.UTF8Encoding]::new($false))

    $recordPath = Join-Path $tempRoot 'docs\changes\2026-07-26-bootstrap-azure-workflow.md'
    $savedRecord = Get-Content -LiteralPath $recordPath -Raw
    $recordMutations = @(
        [pscustomobject]@{ Name = 'change record id'; Pattern = '(?m)^id:\s*\S+\s*$'; Replacement = 'id: 2026-07-26-wrong-id' },
        [pscustomobject]@{ Name = 'change record type'; Pattern = '(?m)^type:\s*\S+\s*$'; Replacement = 'type: imaginary' },
        [pscustomobject]@{ Name = 'change record status'; Pattern = '(?m)^status:\s*\S+\s*$'; Replacement = 'status: imaginary' },
        [pscustomobject]@{ Name = 'change record risk'; Pattern = '(?m)^risk:\s*\S+\s*$'; Replacement = 'risk: low' },
        [pscustomobject]@{ Name = 'change record created date'; Pattern = '(?m)^created:\s*\S+\s*$'; Replacement = 'created: 2026-99-99' },
        [pscustomobject]@{ Name = 'change record chronology'; Pattern = '(?m)^updated:\s*\S+\s*$'; Replacement = 'updated: 2025-01-01' },
        [pscustomobject]@{ Name = 'change record issue'; Pattern = '(?m)^issue:\s*\S+\s*$'; Replacement = 'issue: relative/not-allowed' },
        [pscustomobject]@{ Name = 'change record pull request'; Pattern = '(?m)^pull_request:\s*\S+\s*$'; Replacement = 'pull_request: relative/not-allowed' },
        [pscustomobject]@{ Name = 'change record baseline'; Pattern = '(?m)^baseline:\s*\S+\s*$'; Replacement = 'baseline: abc123' },
        [pscustomobject]@{ Name = 'change record release'; Pattern = '(?m)^target_release:\s*\S+\s*$'; Replacement = 'target_release: V1' },
        [pscustomobject]@{ Name = 'change record horizon'; Pattern = '(?m)^roadmap_horizon:\s*\S.*$'; Replacement = 'roadmap_horizon: Soon' },
        [pscustomobject]@{ Name = 'change record mode'; Pattern = '(?m)^mode:\s*\S+\s*$'; Replacement = 'mode: hybrid' },
        [pscustomobject]@{ Name = 'change record relation'; Pattern = '(?m)^supersedes:\s*\S+\s*$'; Replacement = 'supersedes: invalid relation' }
    )
    foreach ($mutation in $recordMutations) {
        $invalidRecord = [regex]::new($mutation.Pattern).Replace($savedRecord, $mutation.Replacement, 1)
        [System.IO.File]::WriteAllText($recordPath, $invalidRecord, [System.Text.UTF8Encoding]::new($false))
        & $validator -RepositoryPath $tempRoot | Out-Null
        Assert-ExitCode 1 $mutation.Name
    }
    [System.IO.File]::WriteAllText($recordPath, $savedRecord, [System.Text.UTF8Encoding]::new($false))

    $capabilitiesPath = Join-Path $tempRoot 'docs\product\capabilities.md'
    $savedCapabilities = Get-Content -LiteralPath $capabilitiesPath -Raw
    [System.IO.File]::WriteAllText($capabilitiesPath, $savedCapabilities.Replace('AW-CAP-006', 'AW-CAP-005'), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'duplicate capability ID'
    [System.IO.File]::WriteAllText($capabilitiesPath, $savedCapabilities.Replace('`0.1.0-alpha.1`', '`V1`'), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'invalid capability release'
    [System.IO.File]::WriteAllText($capabilitiesPath, $savedCapabilities, [System.Text.UTF8Encoding]::new($false))

    $decisionPath = Join-Path $tempRoot 'docs\decisions\0001-single-plugin-six-skill-architecture.md'
    $savedDecision = Get-Content -LiteralPath $decisionPath -Raw
    [System.IO.File]::WriteAllText($decisionPath, $savedDecision.Replace('## Consequences', '## Results'), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'malformed ADR schema'
    [System.IO.File]::WriteAllText($decisionPath, $savedDecision, [System.Text.UTF8Encoding]::new($false))

    $mistakePath = Join-Path $tempRoot 'docs\agent-mistakes.md'
    $savedMistakes = Get-Content -LiteralPath $mistakePath -Raw
    $malformedIncident = $savedMistakes.TrimEnd() + "`n`n### AM-20260726-001: Missing required evidence`n- Occurred: 2026-07-26T00:00:00Z`n"
    [System.IO.File]::WriteAllText($mistakePath, $malformedIncident, [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'malformed mistake incident'
    [System.IO.File]::WriteAllText($mistakePath, $savedMistakes.Replace('- Follow-up: <issue/change/incident ID or none>', '- Next: <value>'), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'malformed mistake template'
    $validIncident = @'

### AM-20260726-001: Valid fixture incident
- Occurred: 2026-07-26T00:00:00Z
- Detected: 2026-07-26T00:01:00Z
- Workflow/package version: unknown
- Change/PR: none
- Classification: workflow-gap
- What happened: A fixture exercised the incident schema.
- Impact: Test-only validation evidence.
- Recovery: Restored the temporary fixture.
- Why the gate failed: Test fixture only.
- Reusable prevention signal: Keep the schema regression.
- Follow-up: none
'@
    [System.IO.File]::WriteAllText($mistakePath, ($savedMistakes.TrimEnd() + $validIncident + "`n"), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 0 'valid mistake incident'
    [System.IO.File]::WriteAllText($mistakePath, $savedMistakes, [System.Text.UTF8Encoding]::new($false))

    $productPath = Join-Path $tempRoot 'docs\product\index.md'
    $savedProduct = Get-Content -LiteralPath $productPath -Raw
    [System.IO.File]::WriteAllText($productPath, $savedProduct.Replace('Visual UI: `absent`', 'Visual UI: `present`'), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'visual UI without design authority'
    [System.IO.File]::WriteAllText($productPath, $savedProduct, [System.Text.UTF8Encoding]::new($false))

    [System.IO.File]::WriteAllText($productPath, ($savedProduct.TrimEnd() + "`n- Repository mode: `released``n"), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'duplicate conflicting repository modes'
    [System.IO.File]::WriteAllText($productPath, $savedProduct, [System.Text.UTF8Encoding]::new($false))

    $wrongCaseHoldingPath = Join-Path $tempRoot 'docs\index-case-holding.md'
    $wrongCaseIndexPath = Join-Path $tempRoot 'docs\Index.md'
    Move-Item -LiteralPath $indexPath -Destination $wrongCaseHoldingPath
    Move-Item -LiteralPath $wrongCaseHoldingPath -Destination $wrongCaseIndexPath
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'wrong canonical path casing'
    Move-Item -LiteralPath $wrongCaseIndexPath -Destination $wrongCaseHoldingPath
    Move-Item -LiteralPath $wrongCaseHoldingPath -Destination $indexPath

    $featureFormPath = Join-Path $tempRoot '.github\ISSUE_TEMPLATE\feature.yml'
    $savedFeatureForm = Get-Content -LiteralPath $featureFormPath -Raw
    [System.IO.File]::WriteAllText($featureFormPath, '{"name": "broken"', [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'malformed issue form syntax'
    [System.IO.File]::WriteAllText($featureFormPath, '{"name":"Feature","description":"Description","title":"[Feature]: ","labels":["type:feature"],"body":[]}', [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'invalid issue form schema'
    [System.IO.File]::WriteAllText($featureFormPath, $savedFeatureForm, [System.Text.UTF8Encoding]::new($false))

    $harnessRoot = Join-Path $tempRoot 'repo-check-harness'
    New-Item -ItemType Directory -Path (Join-Path $harnessRoot 'scripts') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $harnessRoot 'plugins\azure-workflow\scripts') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $harnessRoot 'tests') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $harnessRoot 'codex-home') -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'scripts\Invoke-RepoCheck.ps1') -Destination (Join-Path $harnessRoot 'scripts\Invoke-RepoCheck.ps1')
    $repositoryStub = @'
param([string]$RepositoryPath, [string]$BaseRef)
if ($PSBoundParameters.ContainsKey('BaseRef')) { exit 1 }
exit 0
'@
    $successStub = "exit 0`n"
    [System.IO.File]::WriteAllText((Join-Path $harnessRoot 'plugins\azure-workflow\scripts\Test-AzureWorkflowRepository.ps1'), $repositoryStub, [System.Text.UTF8Encoding]::new($false))
    [System.IO.File]::WriteAllText((Join-Path $harnessRoot 'plugins\azure-workflow\scripts\Test-AzureWorkflowPlugin.ps1'), $successStub, [System.Text.UTF8Encoding]::new($false))
    foreach ($testName in @('Test-RepositoryStandard.ps1', 'Test-PullRequestEvidence.ps1', 'Test-PluginPackage.ps1')) {
        [System.IO.File]::WriteAllText((Join-Path $harnessRoot "tests\$testName"), $successStub, [System.Text.UTF8Encoding]::new($false))
    }
    [System.IO.File]::WriteAllText((Join-Path $harnessRoot 'README.md'), "# Harness`n", [System.Text.UTF8Encoding]::new($false))
    & git -C $harnessRoot init --initial-branch main 2>$null | Out-Null
    & git -C $harnessRoot config user.name 'Azure Workflow Test' | Out-Null
    & git -C $harnessRoot config user.email 'azure-workflow-test@example.invalid' | Out-Null
    & git -C $harnessRoot add README.md | Out-Null
    & git -C $harnessRoot commit -m 'test harness' 2>$null | Out-Null
    $savedCodexHome = $env:CODEX_HOME
    try {
        $env:CODEX_HOME = Join-Path $harnessRoot 'codex-home'
        & (Join-Path $harnessRoot 'scripts\Invoke-RepoCheck.ps1') -Scope Auto -BaseRef 'missing-comparison-ref' -HeadRef HEAD | Out-Null
        Assert-ExitCode 0 'invalid comparison falls back to unscoped Full validation'

        $harnessReadme = Join-Path $harnessRoot 'README.md'
        $savedHarnessReadme = Get-Content -LiteralPath $harnessReadme -Raw
        $driveRootExample = 'Z:' + [System.IO.Path]::DirectorySeparatorChar + 'outside' + [System.IO.Path]::DirectorySeparatorChar + 'file.md'
        [System.IO.File]::WriteAllText($harnessReadme, "# Harness`n$driveRootExample`n", [System.Text.UTF8Encoding]::new($false))
        & (Join-Path $harnessRoot 'scripts\Invoke-RepoCheck.ps1') -Scope Full | Out-Null
        Assert-ExitCode 1 'drive-root path portability mutation'

        $tildeHomeExample = [char]126 + '/private/file.md'
        [System.IO.File]::WriteAllText($harnessReadme, "# Harness`n$tildeHomeExample`n", [System.Text.UTF8Encoding]::new($false))
        & (Join-Path $harnessRoot 'scripts\Invoke-RepoCheck.ps1') -Scope Full | Out-Null
        Assert-ExitCode 1 'tilde user-home path portability mutation'

        $profileHomeExample = '%' + 'USERPROFILE' + '%\private\file.md'
        [System.IO.File]::WriteAllText($harnessReadme, "# Harness`n$profileHomeExample`n", [System.Text.UTF8Encoding]::new($false))
        & (Join-Path $harnessRoot 'scripts\Invoke-RepoCheck.ps1') -Scope Full | Out-Null
        Assert-ExitCode 1 'profile user-home path portability mutation'
        [System.IO.File]::WriteAllText($harnessReadme, $savedHarnessReadme, [System.Text.UTF8Encoding]::new($false))
    }
    finally {
        if ($null -eq $savedCodexHome) { Remove-Item Env:\CODEX_HOME -ErrorAction SilentlyContinue }
        else { $env:CODEX_HOME = $savedCodexHome }
    }
}
finally {
    if (Test-Path -LiteralPath $resolvedTempRoot) { Remove-Item -LiteralPath $resolvedTempRoot -Recurse -Force }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}
'Repository standard tests: PASS'
exit 0
