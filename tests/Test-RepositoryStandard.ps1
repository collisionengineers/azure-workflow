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
    [System.IO.File]::WriteAllText($recordPath, $savedRecord.Replace('status: active', 'status: imaginary'), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'malformed change record'
    [System.IO.File]::WriteAllText($recordPath, $savedRecord, [System.Text.UTF8Encoding]::new($false))

    $productPath = Join-Path $tempRoot 'docs\product\index.md'
    $savedProduct = Get-Content -LiteralPath $productPath -Raw
    [System.IO.File]::WriteAllText($productPath, $savedProduct.Replace('Visual UI: `absent`', 'Visual UI: `present`'), [System.Text.UTF8Encoding]::new($false))
    & $validator -RepositoryPath $tempRoot | Out-Null
    Assert-ExitCode 1 'visual UI without design authority'
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
