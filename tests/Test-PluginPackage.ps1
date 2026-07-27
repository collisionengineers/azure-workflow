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
    $validManifest = Get-Content -LiteralPath $manifestPath -Raw
    $invalidManifest = [regex]::Replace($validManifest, '"version"\s*:\s*"[^"]+"', '"version": "0.1.0"', 1)
    [System.IO.File]::WriteAllText($manifestPath, $invalidManifest, [System.Text.UTF8Encoding]::new($false))
    & $validator -PluginPath $mutant | Out-Null
    Assert-ExitCode 1 'invalid release version mutation'
    [System.IO.File]::WriteAllText($manifestPath, $validManifest, [System.Text.UTF8Encoding]::new($false))

    $portableReferencePath = Join-Path $mutant 'references\risk-scaling.md'
    $savedPortableReference = Get-Content -LiteralPath $portableReferencePath -Raw
    $driveRootExample = 'Z:' + [System.IO.Path]::DirectorySeparatorChar + 'private' + [System.IO.Path]::DirectorySeparatorChar + 'file.md'
    [System.IO.File]::WriteAllText($portableReferencePath, ($savedPortableReference.TrimEnd() + "`n`n$driveRootExample`n"), [System.Text.UTF8Encoding]::new($false))
    & $validator -PluginPath $mutant | Out-Null
    Assert-ExitCode 1 'plugin drive-root path mutation'
    [System.IO.File]::WriteAllText($portableReferencePath, $savedPortableReference, [System.Text.UTF8Encoding]::new($false))

    $recordRepository = Join-Path $tempRoot 'record-repository'
    New-Item -ItemType Directory -Path (Join-Path $recordRepository 'docs\changes') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $recordRepository 'docs\product') -Force | Out-Null
    $recordAgentsPath = Join-Path $recordRepository 'AGENTS.md'
    $recordProductPath = Join-Path $recordRepository 'docs\product\index.md'
    [System.IO.File]::WriteAllText($recordAgentsPath, "# Repository`n`nRepository mode: ``released```n", [System.Text.UTF8Encoding]::new($false))
    [System.IO.File]::WriteAllText($recordProductPath, "# Product`n`n- Repository mode: ``released```n", [System.Text.UTF8Encoding]::new($false))
    $recordCreator = Join-Path $pluginRoot 'scripts\New-AzureWorkflowChange.ps1'
    $recordJson = & $recordCreator -RepositoryPath $recordRepository -Slug 'helper-contract' -Title 'Helper contract' -Type 'documentation' -Status 'planned' -Issue 'none'
    Assert-ExitCode 0 'change-record creation'
    $recordResult = $recordJson | ConvertFrom-Json
    if ($recordResult.path -notmatch '^docs/changes/\d{4}-\d{2}-\d{2}-helper-contract\.md$') { $failures.Add('Change-record creator did not emit a portable repository-relative path.') }
    $createdRecord = Join-Path $recordRepository ($recordResult.path.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $createdRecord -PathType Leaf)) { $failures.Add('Change-record creator did not create the declared file.') }
    $createdRecordContent = Get-Content -LiteralPath $createdRecord -Raw
    if ($recordResult.mode -cne 'released' -or $createdRecordContent -cnotmatch '(?m)^mode: released\s*$') { $failures.Add('Change-record creator did not derive released mode from repository policy.') }
    & $recordCreator -RepositoryPath $recordRepository -Slug 'helper-contract' -Title 'Helper contract' -Type 'documentation' -Status 'planned' -Issue 'none' 2>$null | Out-Null
    Assert-ExitCode 1 'change-record overwrite refusal'

    [System.IO.File]::WriteAllText($recordProductPath, "# Product`n`n- Repository mode: ``development```n", [System.Text.UTF8Encoding]::new($false))
    & $recordCreator -RepositoryPath $recordRepository -Slug 'mode-conflict' -Title 'Mode conflict' -Type 'documentation' -Status 'planned' -Issue 'none' 2>$null | Out-Null
    Assert-ExitCode 1 'change-record repository-mode conflict refusal'
    [System.IO.File]::WriteAllText($recordProductPath, "# Product`n`n- Repository mode: ``released```n", [System.Text.UTF8Encoding]::new($false))

    $invalidIssueRecord = Join-Path $recordRepository ("docs\changes\$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))-invalid-issue.md")
    & $recordCreator -RepositoryPath $recordRepository -Slug 'invalid-issue' -Title 'Invalid issue' -Type 'documentation' -Status 'planned' -Issue 'not-a-url' 2>$null | Out-Null
    Assert-ExitCode 1 'change-record invalid issue refusal'
    if (Test-Path -LiteralPath $invalidIssueRecord) { $failures.Add('Change-record creator wrote a file for an invalid issue value.') }

    $invalidTitleRecord = Join-Path $recordRepository ("docs\changes\$([DateTime]::UtcNow.ToString('yyyy-MM-dd'))-invalid-title.md")
    & $recordCreator -RepositoryPath $recordRepository -Slug 'invalid-title' -Title " `n " -Type 'documentation' -Status 'planned' -Issue 'none' 2>$null | Out-Null
    Assert-ExitCode 1 'change-record invalid title refusal'
    if (Test-Path -LiteralPath $invalidTitleRecord) { $failures.Add('Change-record creator wrote a file for an invalid title value.') }

    $junctionRepository = Join-Path $tempRoot 'junction-repository'
    $junctionDocs = Join-Path $junctionRepository 'docs'
    $outsideChanges = Join-Path $tempRoot 'outside-changes'
    New-Item -ItemType Directory -Path $junctionDocs -Force | Out-Null
    New-Item -ItemType Directory -Path $outsideChanges -Force | Out-Null
    $junctionPath = Join-Path $junctionDocs 'changes'
    New-Item -ItemType Junction -Path $junctionPath -Target $outsideChanges | Out-Null
    & $recordCreator -RepositoryPath $junctionRepository -Slug 'junction-escape' -Title 'Junction escape' -Type 'documentation' -Status 'planned' -Issue 'none' 2>$null | Out-Null
    Assert-ExitCode 1 'change-record junction refusal'
    if (@(Get-ChildItem -LiteralPath $outsideChanges -File).Count -ne 0) { $failures.Add('Change-record creator wrote through a junction outside the repository.') }
    Remove-Item -LiteralPath $junctionPath -Force
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
