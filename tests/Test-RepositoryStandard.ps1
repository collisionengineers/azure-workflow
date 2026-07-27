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
    $invalidRecord = [regex]::new('(?m)^status:\s*\S+\s*$').Replace($savedRecord, 'status: imaginary', 1)
    [System.IO.File]::WriteAllText($recordPath, $invalidRecord, [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'malformed change record'
    [System.IO.File]::WriteAllText($recordPath, $savedRecord, [System.Text.UTF8Encoding]::new($false))

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
