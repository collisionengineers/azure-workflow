[CmdletBinding()]
param(
    [ValidateSet('Auto', 'Docs', 'Full')]
    [string]$Scope = 'Full',
    [string]$BaseRef,
    [string]$HeadRef = 'HEAD'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$pluginRoot = Join-Path $repositoryRoot 'plugins\azure-workflow'
$failures = [System.Collections.Generic.List[string]]::new()

function Invoke-Checked {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][scriptblock]$Action
    )

    "CHECK: $Name"
    & $Action
    if ($LASTEXITCODE -ne 0) { $script:failures.Add("$Name exited with code $LASTEXITCODE") }
}

function Test-DocsOnlyPath {
    param([Parameter(Mandatory)][string]$Path)

    $normalized = $Path.Replace('\', '/')
    return $normalized -in @('AGENTS.md', 'README.md', '.github/pull_request_template.md') -or
        $normalized.StartsWith('docs/', [System.StringComparison]::OrdinalIgnoreCase) -or
        $normalized.StartsWith('.github/ISSUE_TEMPLATE/', [System.StringComparison]::OrdinalIgnoreCase)
}

function Get-NonPortablePathKind {
    param([Parameter(Mandatory)][string]$Content)

    if ($Content -match '(?<![A-Za-z0-9+.-])[A-Za-z]:[\\/]') { return 'drive-root path' }
    if ($Content -match '(?<![\\])\\\\[^\\/\s]+[\\/][^\\/\s]+') { return 'UNC path' }
    $userHomePattern = '(?i)(?:\$(?:env:USERPROFILE|HOME)|\$\{HOME\}|%(?:USERPROFILE|HOMEDRIVE|HOMEPATH)%|~[\\/])'
    if ($Content -match $userHomePattern) { return 'user-home path' }
    $unixHomePattern = '(?:/' + 'home/|/' + 'Users/)[^/\s]+/'
    if ($Content -cmatch $unixHomePattern) { return 'user-home path' }
    return $null
}

try {
    Push-Location -LiteralPath $repositoryRoot
    try {
        $changedPaths = @()
        if (-not [string]::IsNullOrWhiteSpace($BaseRef)) {
            $diffOutput = & git diff --name-only "$BaseRef...$HeadRef" -- 2>&1
            if ($LASTEXITCODE -eq 0) { $changedPaths = @($diffOutput | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) }
            elseif ($Scope -eq 'Auto') {
                $Scope = 'Full'
                $BaseRef = $null
                'Auto classification fell back to Full without a comparison because the requested refs could not be resolved.'
            }
            else { throw "Could not compare $BaseRef...$HeadRef`: $($diffOutput -join [Environment]::NewLine)" }
        } elseif ($Scope -eq 'Auto') {
            $Scope = 'Full'
            'Auto classification fell back to Full because BaseRef was not supplied.'
        }

        if ($Scope -eq 'Auto') {
            $nonDocs = @($changedPaths | Where-Object { -not (Test-DocsOnlyPath $_) })
            $Scope = if ($nonDocs.Count -eq 0) { 'Docs' } else { 'Full' }
        }
        if ($Scope -eq 'Docs' -and $changedPaths.Count -gt 0) {
            $nonDocs = @($changedPaths | Where-Object { -not (Test-DocsOnlyPath $_) })
            if ($nonDocs.Count -gt 0) { throw "Docs scope contains non-document paths: $($nonDocs -join ', ')" }
        }

        "Selected scope: $Scope"
        if ($changedPaths.Count -gt 0) {
            'Changed paths:'
            $changedPaths | ForEach-Object { "- $($_.Replace('\', '/'))" }
        }

        $repositoryValidator = Join-Path $pluginRoot 'scripts\Test-AzureWorkflowRepository.ps1'
        Invoke-Checked 'Repository standard' {
            if ([string]::IsNullOrWhiteSpace($BaseRef)) {
                & $repositoryValidator -RepositoryPath $repositoryRoot
            } else {
                & $repositoryValidator -RepositoryPath $repositoryRoot -BaseRef $BaseRef
            }
        }

        Invoke-Checked 'Git diff whitespace' {
            if ([string]::IsNullOrWhiteSpace($BaseRef)) { & git diff --check }
            else { & git diff --check "$BaseRef...$HeadRef" }
        }

        "CHECK: Markdown links and fences"
        $markdownRoots = @('AGENTS.md', 'README.md', 'docs', 'plugins\azure-workflow\skills', 'plugins\azure-workflow\references')
        $markdownFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
        foreach ($relative in $markdownRoots) {
            $path = Join-Path $repositoryRoot $relative
            if (Test-Path -LiteralPath $path -PathType Leaf) { $markdownFiles.Add((Get-Item -LiteralPath $path)) }
            elseif (Test-Path -LiteralPath $path -PathType Container) {
                foreach ($file in Get-ChildItem -LiteralPath $path -Recurse -File -Filter *.md) { $markdownFiles.Add($file) }
            }
        }
        foreach ($file in $markdownFiles) {
            $content = Get-Content -LiteralPath $file.FullName -Raw
            if (([regex]::Matches($content, '(?m)^```').Count % 2) -ne 0) { $failures.Add("Unbalanced code fence: $([System.IO.Path]::GetRelativePath($repositoryRoot, $file.FullName).Replace('\', '/'))") }
            foreach ($match in [regex]::Matches($content, '\[[^\]]+\]\(([^)]+)\)')) {
                $target = $match.Groups[1].Value.Trim().Trim('<', '>')
                if ($target -match '^(?:https?:|mailto:|#)' -or $file.Name.EndsWith('.template')) { continue }
                $pathPart = [uri]::UnescapeDataString(($target -split '#', 2)[0])
                if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
                $resolved = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
                if (-not $resolved.StartsWith(($repositoryRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar), [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $resolved)) {
                    $failures.Add("Broken or escaping link in $([System.IO.Path]::GetRelativePath($repositoryRoot, $file.FullName).Replace('\', '/')): $target")
                }
            }
        }

        "CHECK: Path portability"
        $scanRoots = @('AGENTS.md', 'README.md', 'docs', 'plugins', 'scripts', 'tests', '.github', '.agents')
        foreach ($relative in $scanRoots) {
            $path = Join-Path $repositoryRoot $relative
            $files = if (Test-Path -LiteralPath $path -PathType Leaf) { @(Get-Item -LiteralPath $path) } elseif (Test-Path -LiteralPath $path -PathType Container) { @(Get-ChildItem -LiteralPath $path -Recurse -File) } else { @() }
            foreach ($file in $files) {
                if ($file.Extension -notin @('.md', '.json', '.yaml', '.yml', '.ps1', '.template', '.toml')) { continue }
                $content = Get-Content -LiteralPath $file.FullName -Raw
                $pathKind = Get-NonPortablePathKind -Content $content
                if ($null -ne $pathKind) {
                    $failures.Add("Workstation-specific $pathKind`: $([System.IO.Path]::GetRelativePath($repositoryRoot, $file.FullName).Replace('\', '/'))")
                }
            }
        }

        if ($Scope -eq 'Full') {
            Invoke-Checked 'Plugin package contract' { & (Join-Path $pluginRoot 'scripts\Test-AzureWorkflowPlugin.ps1') -PluginPath $pluginRoot }

            foreach ($test in @('Test-RepositoryStandard.ps1', 'Test-PullRequestEvidence.ps1', 'Test-PluginPackage.ps1')) {
                $testPath = Join-Path $repositoryRoot "tests\$test"
                if (Test-Path -LiteralPath $testPath) { Invoke-Checked $test { & $testPath } }
                else { $failures.Add("Missing test script: tests/$test") }
            }

            $codexRoot = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) { Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex' } else { $env:CODEX_HOME }
            $pluginValidator = Join-Path $codexRoot 'skills\.system\plugin-creator\scripts\validate_plugin.py'
            if (Test-Path -LiteralPath $pluginValidator -PathType Leaf) { Invoke-Checked 'Official plugin validation' { & python $pluginValidator $pluginRoot } }
            else { 'WARNING: plugin-creator validator is unavailable.' }

            $skillValidator = Join-Path $codexRoot 'skills\.system\skill-creator\scripts\quick_validate.py'
            if (Test-Path -LiteralPath $skillValidator -PathType Leaf) {
                foreach ($skill in Get-ChildItem -LiteralPath (Join-Path $pluginRoot 'skills') -Directory | Sort-Object Name) {
                    Invoke-Checked "Skill validation: $($skill.Name)" { & python $skillValidator $skill.FullName }
                }
            } else { 'WARNING: skill-creator validator is unavailable.' }
        }

        if ($failures.Count -gt 0) {
            foreach ($failure in $failures) { "FAIL: $failure" }
            exit 1
        }
        "Repository check: PASS ($Scope)"
        exit 0
    }
    finally { Pop-Location }
}
catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 2
}
