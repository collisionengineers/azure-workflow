[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$pluginRoot = Join-Path $repositoryRoot 'plugins\azure-workflow'
$validator = Join-Path $pluginRoot 'scripts\Test-AzureWorkflowPlugin.ps1'
$failures = [System.Collections.Generic.List[string]]::new()

function Assert-ExitCode {
    param([int]$Expected, [string]$Name)
    if ($LASTEXITCODE -ne $Expected) { $script:failures.Add("$Name expected exit $Expected, observed $LASTEXITCODE") }
}

& $validator -PluginPath $pluginRoot | Out-Host
Assert-ExitCode 0 'valid package'

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("azure-workflow-plugin-test-" + [guid]::NewGuid().ToString('N'))
$resolvedTempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
$resolvedTempRoot = [System.IO.Path]::GetFullPath($tempRoot)
if (-not $resolvedTempRoot.StartsWith($resolvedTempBase, [System.StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing unsafe temporary test path.' }

try {
    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
    Copy-Item -LiteralPath $pluginRoot -Destination (Join-Path $tempRoot 'azure-workflow') -Recurse
    $mutant = Join-Path $tempRoot 'azure-workflow'

    Remove-Item -LiteralPath (Join-Path $mutant 'references\risk-scaling.md') -Force
    & $validator -PluginPath $mutant | Out-Null
    Assert-ExitCode 1 'missing shared reference mutation'

    Copy-Item -LiteralPath (Join-Path $pluginRoot 'references\risk-scaling.md') -Destination (Join-Path $mutant 'references\risk-scaling.md')
    $manifestPath = Join-Path $mutant '.codex-plugin\plugin.json'
    $manifest = Get-Content -LiteralPath $manifestPath -Raw
    $manifest = $manifest.Replace('"version": "0.1.0-alpha.1"', '"version": "0.1.0"')
    [System.IO.File]::WriteAllText($manifestPath, $manifest, [System.Text.UTF8Encoding]::new($false))
    & $validator -PluginPath $mutant | Out-Null
    Assert-ExitCode 1 'invalid release version mutation'

    $recordRepository = Join-Path $tempRoot 'record-repository'
    New-Item -ItemType Directory -Path (Join-Path $recordRepository 'docs\changes') -Force | Out-Null
    $recordCreator = Join-Path $pluginRoot 'scripts\New-AzureWorkflowChange.ps1'
    $recordJson = & $recordCreator -RepositoryPath $recordRepository -Slug 'helper-contract' -Title 'Helper contract' -Type 'documentation' -Status 'planned' -Issue 'none'
    Assert-ExitCode 0 'change-record creation'
    $recordResult = $recordJson | ConvertFrom-Json
    if ($recordResult.path -notmatch '^docs/changes/\d{4}-\d{2}-\d{2}-helper-contract\.md$') { $failures.Add('Change-record creator did not emit a portable repository-relative path.') }
    $createdRecord = Join-Path $recordRepository ($recordResult.path.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $createdRecord -PathType Leaf)) { $failures.Add('Change-record creator did not create the declared file.') }
    & $recordCreator -RepositoryPath $recordRepository -Slug 'helper-contract' -Title 'Helper contract' -Type 'documentation' -Status 'planned' -Issue 'none' 2>$null | Out-Null
    Assert-ExitCode 1 'change-record overwrite refusal'
}
finally {
    if (Test-Path -LiteralPath $resolvedTempRoot) { Remove-Item -LiteralPath $resolvedTempRoot -Recurse -Force }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}
'Plugin package tests: PASS'
exit 0
