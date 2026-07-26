[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$RepositoryPath,
    [string]$BaseRef,
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

function Add-Finding { param([string]$Message) $script:errors.Add($Message) }
function Add-WarningMessage { param([string]$Message) $script:warnings.Add($Message) }
function Get-RelativeDisplay {
    param([string]$Root, [string]$Path)
    return [System.IO.Path]::GetRelativePath($Root, $Path).Replace('\', '/')
}
function Require-File {
    param([string]$Root, [string]$RelativePath)
    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Add-Finding "Missing file: $($RelativePath.Replace('\', '/'))" }
}
function Require-Headings {
    param([string]$Root, [string]$RelativePath, [string[]]$Headings)
    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return }
    $content = Get-Content -LiteralPath $path -Raw
    foreach ($heading in $Headings) {
        if ($content -notmatch "(?m)^$([regex]::Escape($heading))\s*$") { Add-Finding "$($RelativePath.Replace('\', '/')) is missing heading: $heading" }
    }
}

try {
    $root = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $RepositoryPath).Path)
    $requiredFiles = @(
        'AGENTS.md',
        'docs\index.md',
        'docs\product\index.md',
        'docs\roadmap.md',
        'docs\architecture.md',
        'docs\operations.md',
        'docs\agent-mistakes.md',
        '.github\ISSUE_TEMPLATE\feature.yml',
        '.github\ISSUE_TEMPLATE\bug.yml',
        '.github\ISSUE_TEMPLATE\task.yml',
        '.github\ISSUE_TEMPLATE\decision.yml',
        '.github\ISSUE_TEMPLATE\config.yml',
        '.github\pull_request_template.md'
    )
    foreach ($relative in $requiredFiles) { Require-File $root $relative }

    Require-Headings $root 'docs\index.md' @('## Start here', '## Authority order', '## Source roles and mutation rules', '## Document ownership', '## Drift prevention')
    Require-Headings $root 'docs\product\index.md' @('## Purpose and problem', '## Users and outcomes', '## Success measures', '## Scope', '## Requirements and invariants', '## Quality constraints', '## Supported contracts', '## Limitations', '## Open decisions')
    Require-Headings $root 'docs\roadmap.md' @('## Now', '## Next', '## Later', '## Not planned')
    Require-Headings $root 'docs\architecture.md' @('## System context', '## Components and ownership', '## Entry points and callers', '## Data and integrations', '## Rule and configuration ownership', '## Source roles and generated material', '## Failure and recovery', '## Deployment topology', '## Architecture boundaries')
    Require-Headings $root 'docs\operations.md' @('## Supported environment and prerequisites', '## Canonical verification', '## Local run, build, and test', '## Deploy', '## Configuration and secrets boundary', '## Monitoring and diagnosis', '## Recovery', '## GitHub work taxonomy', '## Supported platforms and release operations')
    Require-Headings $root 'docs\agent-mistakes.md' @('## Purpose', '## What to record', '## What not to record', '## Incident template', '## Entries')

    $agentsPath = Join-Path $root 'AGENTS.md'
    if (Test-Path -LiteralPath $agentsPath) {
        $agents = Get-Content -LiteralPath $agentsPath -Raw
        foreach ($requiredPhrase in @('PowerShell 7', 'docs/index.md', '$onboard-azure-repository', '$plan-azure-repository-change', '$deliver-azure-repository-change', '$explain-repository', '$review-repository-pull-request', '$operate-azure-repository', 'docs/agent-mistakes.md', 'repository-provided', 'PII', 'relative paths')) {
            if ($agents -notmatch [regex]::Escape($requiredPhrase)) { Add-Finding "AGENTS.md is missing required route/policy: $requiredPhrase" }
        }
        if ($agents -match '(?i)operator-notes.+(?:always|key source of truth|authoritative)' -and (Get-Content -LiteralPath (Join-Path $root 'docs\index.md') -Raw) -notmatch '(?i)operator-notes') {
            Add-Finding 'AGENTS.md declares operator-notes authority without a docs/index.md source-role entry.'
        }
    }

    $productPath = Join-Path $root 'docs\product\index.md'
    if (Test-Path -LiteralPath $productPath) {
        $product = Get-Content -LiteralPath $productPath -Raw
        foreach ($field in @('Repository mode:', 'Maturity stage:', 'Version scheme:', 'Current version:', 'Release authority:', 'Visual UI:')) {
            if ($product -notmatch "(?m)^-\s+$([regex]::Escape($field))") { Add-Finding "docs/product/index.md is missing field: $field" }
        }
        if ($product -notmatch '(?m)^- Repository mode:\s*`?(development|released)`?\s*$') { Add-Finding 'Repository mode must be development or released.' }
        if ($product -notmatch '(?m)^- Visual UI:\s*`?(present|absent)`?\s*$') { Add-Finding 'Visual UI must be present or absent.' }
        $visualUiPresent = $product -match '(?m)^- Visual UI:\s*`?present`?\s*$'
        if ($visualUiPresent) {
            foreach ($designFile in @('design\README.md', 'design\brand\style.md', 'design\foundations\colour.md', 'design\foundations\typography.md', 'design\foundations\spacing-and-layout.md', 'design\foundations\motion.md', 'design\foundations\accessibility.md', 'design\tokens\README.md', 'design\components\index.md', 'design\patterns\index.md')) { Require-File $root $designFile }
        }
    }

    $roadmapPath = Join-Path $root 'docs\roadmap.md'
    if (Test-Path -LiteralPath $roadmapPath) {
        $roadmap = Get-Content -LiteralPath $roadmapPath -Raw
        $horizonHeadings = @([regex]::Matches($roadmap, '(?m)^##\s+(.+?)\s*$') | ForEach-Object { $_.Groups[1].Value })
        $unexpected = @($horizonHeadings | Where-Object { $_ -notin @('Now', 'Next', 'Later', 'Not planned') })
        foreach ($heading in $unexpected) { Add-Finding "Unexpected roadmap horizon: $heading" }
        if ($roadmap -match '(?i)\bV[1-9][0-9]*\+?\b') { Add-Finding 'Roadmap contains a vague V1/V2-style release allocation.' }
    }

    $changeRoot = Join-Path $root 'docs\changes'
    $changeRecords = if (Test-Path -LiteralPath $changeRoot) { @(Get-ChildItem -LiteralPath $changeRoot -File -Filter *.md) } else { @() }
    foreach ($record in $changeRecords) {
        if ($record.Name -notmatch '^\d{4}-\d{2}-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*\.md$') { Add-Finding "Invalid change-record filename: $($record.Name)" }
        $recordContent = Get-Content -LiteralPath $record.FullName -Raw
        foreach ($key in @('id:', 'type:', 'status:', 'risk:', 'created:', 'updated:', 'issue:', 'pull_request:', 'baseline:', 'target_release:', 'roadmap_horizon:', 'mode:')) {
            if ($recordContent -notmatch "(?m)^$([regex]::Escape($key))") { Add-Finding "$($record.Name) is missing metadata: $key" }
        }
        if ($recordContent -notmatch '(?m)^status:\s*(active|blocked|planned|ready|superseded)\s*$') { Add-Finding "$($record.Name) has an invalid status." }
        foreach ($heading in @('## Summary', '## Scope', '## Authorities, current state, and constraints', '## Acceptance criteria', '## Plan', '## Data, failure, and recovery', '## UI/UX contract', '## Azure impact', '## Decisions and conflicts', '## Implementation', '## Verification', '## Independent review', '## Documentation and work tracking', '## Outcome', '## Blocker or follow-ups')) {
            if ($recordContent -notmatch "(?m)^$([regex]::Escape($heading))\s*$") { Add-Finding "$($record.Name) is missing heading: $heading" }
        }
        if ($recordContent -notmatch '(?m)^- Documentation impact declared before implementation:\s*\S') { Add-Finding "$($record.Name) lacks a documentation-impact declaration." }
    }

    $mistakePath = Join-Path $root 'docs\agent-mistakes.md'
    if (Test-Path -LiteralPath $mistakePath) {
        $mistakes = (Get-Content -LiteralPath $mistakePath -Raw) -replace "`r`n", "`n"
        $ids = @([regex]::Matches($mistakes, '(?m)^###\s+(AM-\d{8}-\d{3}):') | ForEach-Object { $_.Groups[1].Value })
        if (@($ids | Sort-Object -Unique).Count -ne $ids.Count) { Add-Finding 'docs/agent-mistakes.md contains duplicate incident IDs.' }
        if (-not [string]::IsNullOrWhiteSpace($BaseRef)) {
            $blobSpec = "${BaseRef}:docs/agent-mistakes.md"
            $baseMistakes = & git -C $root show $blobSpec 2>$null
            if ($LASTEXITCODE -eq 0) {
                $baseText = (($baseMistakes -join "`n") + "`n") -replace "`r`n", "`n"
                if (-not $mistakes.StartsWith($baseText, [System.StringComparison]::Ordinal)) { Add-Finding 'docs/agent-mistakes.md changed existing history instead of appending.' }
            } else { Add-WarningMessage "Append-history proof unavailable for BaseRef $BaseRef." }
        } else { Add-WarningMessage 'Agent mistake-log append history was not checked because BaseRef was not supplied.' }
    }

    $markdownFiles = @(Get-ChildItem -LiteralPath (Join-Path $root 'docs') -Recurse -File -Filter *.md) + @(Get-Item -LiteralPath $agentsPath -ErrorAction SilentlyContinue)
    if (Test-Path -LiteralPath (Join-Path $root 'design')) { $markdownFiles += @(Get-ChildItem -LiteralPath (Join-Path $root 'design') -Recurse -File -Filter *.md) }
    foreach ($file in $markdownFiles) {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        foreach ($match in [regex]::Matches($content, '\[[^\]]+\]\(([^)]+)\)')) {
            $target = $match.Groups[1].Value.Trim().Trim('<', '>')
            if ($target -match '^(?:https?:|mailto:|#)') { continue }
            $pathPart = [uri]::UnescapeDataString(($target -split '#', 2)[0])
            if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
            $resolved = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
            if (-not $resolved.StartsWith(($root.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar), [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $resolved)) {
                Add-Finding "Broken or escaping link in $(Get-RelativeDisplay $root $file.FullName): $target"
            }
        }
    }

    $kindMap = @{ 'feature.yml' = 'type:feature'; 'bug.yml' = 'type:bug'; 'task.yml' = 'type:task'; 'decision.yml' = 'type:decision' }
    foreach ($entry in $kindMap.GetEnumerator()) {
        $formPath = Join-Path $root ".github\ISSUE_TEMPLATE\$($entry.Key)"
        if (Test-Path -LiteralPath $formPath) {
            $form = Get-Content -LiteralPath $formPath -Raw
            $kinds = @([regex]::Matches($form, '(?m)^\s*-\s*["'']?(type:(?:feature|bug|task|decision))["'']?\s*$') | ForEach-Object { $_.Groups[1].Value })
            if ($kinds.Count -ne 1 -or $kinds[0] -ne $entry.Value) { Add-Finding "$($entry.Key) must declare exactly kind $($entry.Value)." }
            if ($form -notmatch '(?m)^name:\s*\S' -or $form -notmatch '(?m)^description:\s*\S' -or $form -notmatch '(?m)^body:\s*$') { Add-Finding "$($entry.Key) does not have the required issue-form structure." }
        }
    }

    foreach ($forbidden in @('.repoplugin', 'NEXT.md')) {
        if (Test-Path -LiteralPath (Join-Path $root $forbidden)) { Add-Finding "Forbidden legacy/state path remains: $forbidden" }
    }

    $documentCount = @(Get-ChildItem -LiteralPath (Join-Path $root 'docs') -Recurse -File -Filter *.md -ErrorAction SilentlyContinue).Count
    $result = [ordered]@{
        valid = $errors.Count -eq 0
        repository_path = '.'
        errors = @($errors)
        warnings = @($warnings)
        counts = [ordered]@{ documents = $documentCount; change_records = @($changeRecords).Count; warnings = $warnings.Count }
    }
    if ($Json) { $result | ConvertTo-Json -Depth 8 -Compress } else {
        "Repository standard: $(if ($result.valid) { 'PASS' } else { 'FAIL' })"
        'Checked: .'
        "Documents: $documentCount"
        "Change records: $(@($changeRecords).Count)"
        "Warnings: $($warnings.Count)"
        foreach ($message in $errors) { "ERROR: $message" }
        foreach ($message in $warnings) { "WARNING: $message" }
    }
    if ($errors.Count -gt 0) { exit 1 }
    exit 0
}
catch {
    [Console]::Error.WriteLine("$($_.Exception.Message) (line $($_.InvocationInfo.ScriptLineNumber))")
    exit 2
}
