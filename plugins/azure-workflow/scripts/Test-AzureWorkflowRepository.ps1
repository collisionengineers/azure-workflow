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
function Resolve-ExactRelativePath {
    param(
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string]$RelativePath
    )

    $current = $Root
    foreach ($segment in @($RelativePath -split '[\\/]')) {
        if ([string]::IsNullOrWhiteSpace($segment) -or -not (Test-Path -LiteralPath $current -PathType Container)) { return $null }
        $matches = @(Get-ChildItem -LiteralPath $current -Force | Where-Object { $_.Name -ceq $segment })
        if ($matches.Count -ne 1) { return $null }
        $current = $matches[0].FullName
    }
    return $current
}
function Require-File {
    param([string]$Root, [string]$RelativePath)
    $path = Resolve-ExactRelativePath -Root $Root -RelativePath $RelativePath
    if ($null -eq $path -or -not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $display = $RelativePath.Replace('\', '/')
        if (Test-Path -LiteralPath (Join-Path $Root $RelativePath) -PathType Leaf) { Add-Finding "Path casing must be exact: $display" }
        else { Add-Finding "Missing file: $display" }
    }
}
function Require-Headings {
    param([string]$Root, [string]$RelativePath, [string[]]$Headings)
    $path = Resolve-ExactRelativePath -Root $Root -RelativePath $RelativePath
    if ($null -eq $path -or -not (Test-Path -LiteralPath $path -PathType Leaf)) { return }
    $content = Get-Content -LiteralPath $path -Raw
    foreach ($heading in $Headings) {
        if ($content -notmatch "(?m)^$([regex]::Escape($heading))\s*$") { Add-Finding "$($RelativePath.Replace('\', '/')) is missing heading: $heading" }
    }
}
function Get-MetadataValues {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Field,
        [switch]$Bullet
    )

    $prefix = if ($Bullet) { '-\s+' } else { '' }
    return @([regex]::Matches($Content, "(?m)^$prefix$([regex]::Escape($Field)):\s*(.+?)\s*$") | ForEach-Object { $_.Groups[1].Value.Trim().Trim([char]96) })
}
function Get-PropertyValue {
    param(
        [AllowNull()]$InputObject,
        [Parameter(Mandatory)][string]$Name
    )

    if ($null -eq $InputObject) { return $null }
    $property = $InputObject.PSObject.Properties[$Name]
    if ($null -eq $property) { return $null }
    return $property.Value
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

    $agentsPath = Resolve-ExactRelativePath -Root $root -RelativePath 'AGENTS.md'
    if ($null -ne $agentsPath -and (Test-Path -LiteralPath $agentsPath -PathType Leaf)) {
        $agents = Get-Content -LiteralPath $agentsPath -Raw
        foreach ($requiredPhrase in @('PowerShell 7', 'docs/index.md', '$onboard-azure-repository', '$plan-azure-repository-change', '$deliver-azure-repository-change', '$explain-repository', '$review-repository-pull-request', '$operate-azure-repository', 'docs/agent-mistakes.md', 'repository-provided', 'PII', 'relative paths')) {
            if ($agents -notmatch [regex]::Escape($requiredPhrase)) { Add-Finding "AGENTS.md is missing required route/policy: $requiredPhrase" }
        }
        $docsIndexPath = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\index.md'
        if ($agents -match '(?i)operator-notes.+(?:always|key source of truth|authoritative)' -and $null -ne $docsIndexPath -and (Get-Content -LiteralPath $docsIndexPath -Raw) -notmatch '(?i)operator-notes') {
            Add-Finding 'AGENTS.md declares operator-notes authority without a docs/index.md source-role entry.'
        }
    }

    $productPath = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\product\index.md'
    if ($null -ne $productPath -and (Test-Path -LiteralPath $productPath -PathType Leaf)) {
        $product = Get-Content -LiteralPath $productPath -Raw
        $metadata = [ordered]@{}
        foreach ($field in @('Repository mode', 'Maturity stage', 'Version scheme', 'Current version', 'Release authority', 'Visual UI')) {
            $values = @(Get-MetadataValues -Content $product -Field $field -Bullet)
            if ($values.Count -ne 1) { Add-Finding "docs/product/index.md must declare exactly one $field field." }
            else { $metadata[$field] = $values[0] }
        }
        if ($metadata.Contains('Repository mode') -and $metadata['Repository mode'] -notin @('development', 'released')) {
            Add-Finding 'Repository mode must be development or released.'
        }
        if ($metadata.Contains('Maturity stage') -and $metadata['Maturity stage'] -notin @('prototype', 'alpha', 'beta', 'release-candidate', 'stable', 'maintenance', 'retired')) {
            Add-Finding 'Maturity stage is not recognized.'
        }
        if ($metadata.Contains('Repository mode') -and $metadata.Contains('Maturity stage')) {
            $mode = $metadata['Repository mode']
            $maturity = $metadata['Maturity stage']
            if ($maturity -in @('prototype', 'alpha', 'beta', 'release-candidate') -and $mode -ne 'development') { Add-Finding "$maturity maturity requires development repository mode." }
            if ($maturity -in @('stable', 'maintenance', 'retired') -and $mode -ne 'released') { Add-Finding "$maturity maturity requires released repository mode." }
        }
        if ($metadata.Contains('Visual UI') -and $metadata['Visual UI'] -notin @('present', 'absent')) {
            Add-Finding 'Visual UI must be present or absent.'
        }
        $agentModes = @()
        if ($null -ne $agentsPath) {
            $agentModes = @(@(Get-MetadataValues -Content $agents -Field 'Repository mode') + @(Get-MetadataValues -Content $agents -Field 'Repository mode' -Bullet))
        }
        if ($agentModes.Count -ne 1) { Add-Finding 'AGENTS.md must declare exactly one Repository mode field.' }
        elseif ($metadata.Contains('Repository mode') -and $agentModes[0] -cne $metadata['Repository mode']) { Add-Finding 'AGENTS.md and docs/product/index.md declare different repository modes.' }

        $visualUiPresent = $metadata.Contains('Visual UI') -and $metadata['Visual UI'] -eq 'present'
        if ($visualUiPresent) {
            foreach ($designFile in @('design\README.md', 'design\brand\style.md', 'design\foundations\colour.md', 'design\foundations\typography.md', 'design\foundations\spacing-and-layout.md', 'design\foundations\motion.md', 'design\foundations\accessibility.md', 'design\tokens\README.md', 'design\components\index.md', 'design\patterns\index.md')) { Require-File $root $designFile }
        }
    }

    $roadmapPath = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\roadmap.md'
    if ($null -ne $roadmapPath -and (Test-Path -LiteralPath $roadmapPath -PathType Leaf)) {
        $roadmap = Get-Content -LiteralPath $roadmapPath -Raw
        $horizonHeadings = @([regex]::Matches($roadmap, '(?m)^##\s+(.+?)\s*$') | ForEach-Object { $_.Groups[1].Value })
        $unexpected = @($horizonHeadings | Where-Object { $_ -notin @('Now', 'Next', 'Later', 'Not planned') })
        foreach ($heading in $unexpected) { Add-Finding "Unexpected roadmap horizon: $heading" }
        if ($roadmap -match '(?i)\bV[1-9][0-9]*\+?\b') { Add-Finding 'Roadmap contains a vague V1/V2-style release allocation.' }
    }

    $changeRoot = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\changes'
    $changeRecords = if ($null -ne $changeRoot -and (Test-Path -LiteralPath $changeRoot -PathType Container)) { @(Get-ChildItem -LiteralPath $changeRoot -File -Filter *.md) } else { @() }
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

    $mistakePath = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\agent-mistakes.md'
    if ($null -ne $mistakePath -and (Test-Path -LiteralPath $mistakePath -PathType Leaf)) {
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

    # GitHub accepts JSON as the strict JSON subset of YAML. Requiring that subset
    # keeps issue-form parsing deterministic without a workstation YAML module.
    $kindMap = @{ 'feature.yml' = 'type:feature'; 'bug.yml' = 'type:bug'; 'task.yml' = 'type:task'; 'decision.yml' = 'type:decision' }
    foreach ($entry in $kindMap.GetEnumerator()) {
        $relativeFormPath = ".github\ISSUE_TEMPLATE\$($entry.Key)"
        $formPath = Resolve-ExactRelativePath -Root $root -RelativePath $relativeFormPath
        if ($null -ne $formPath -and (Test-Path -LiteralPath $formPath -PathType Leaf)) {
            try { $form = Get-Content -LiteralPath $formPath -Raw | ConvertFrom-Json -Depth 30 -ErrorAction Stop }
            catch {
                Add-Finding "$($entry.Key) is not valid strict issue-form YAML (JSON subset): $($_.Exception.Message)"
                continue
            }

            foreach ($propertyName in @('name', 'description', 'title')) {
                $value = Get-PropertyValue $form $propertyName
                if ($value -isnot [string] -or [string]::IsNullOrWhiteSpace($value)) { Add-Finding "$($entry.Key) requires non-empty $propertyName." }
            }
            $labels = @(Get-PropertyValue $form 'labels')
            if ($labels.Count -ne 1 -or $labels[0] -cne $entry.Value) { Add-Finding "$($entry.Key) must declare exactly kind $($entry.Value)." }

            $body = @(Get-PropertyValue $form 'body')
            if ($body.Count -eq 0) { Add-Finding "$($entry.Key) requires a non-empty body array."; continue }
            $bodyIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
            foreach ($item in $body) {
                $itemType = Get-PropertyValue $item 'type'
                if ($itemType -notin @('markdown', 'textarea', 'input')) { Add-Finding "$($entry.Key) contains unsupported body type: $itemType"; continue }
                $attributes = Get-PropertyValue $item 'attributes'
                if ($null -eq $attributes) { Add-Finding "$($entry.Key) body item $itemType requires attributes."; continue }
                if ($itemType -eq 'markdown') {
                    $value = Get-PropertyValue $attributes 'value'
                    if ($value -isnot [string] -or [string]::IsNullOrWhiteSpace($value)) { Add-Finding "$($entry.Key) markdown item requires a value." }
                    continue
                }

                $id = Get-PropertyValue $item 'id'
                $label = Get-PropertyValue $attributes 'label'
                if ($id -isnot [string] -or $id -notmatch '^[a-zA-Z0-9_-]+$') { Add-Finding "$($entry.Key) $itemType item requires a valid id." }
                elseif (-not $bodyIds.Add($id)) { Add-Finding "$($entry.Key) contains duplicate body id: $id" }
                if ($label -isnot [string] -or [string]::IsNullOrWhiteSpace($label)) { Add-Finding "$($entry.Key) $itemType item requires a label." }
                $validations = Get-PropertyValue $item 'validations'
                if ($null -ne $validations) {
                    $required = Get-PropertyValue $validations 'required'
                    if ($null -ne $required -and $required -isnot [bool]) { Add-Finding "$($entry.Key) validation required must be Boolean for id $id." }
                }
            }
        }
    }

    $configPath = Resolve-ExactRelativePath -Root $root -RelativePath '.github\ISSUE_TEMPLATE\config.yml'
    if ($null -ne $configPath -and (Test-Path -LiteralPath $configPath -PathType Leaf)) {
        try { $issueConfig = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json -Depth 10 -ErrorAction Stop }
        catch { Add-Finding "config.yml is not valid strict issue-form YAML (JSON subset): $($_.Exception.Message)"; $issueConfig = $null }
        if ($null -ne $issueConfig) {
            $blankIssues = Get-PropertyValue $issueConfig 'blank_issues_enabled'
            $contactLinksProperty = $issueConfig.PSObject.Properties['contact_links']
            if ($blankIssues -isnot [bool] -or $blankIssues) { Add-Finding 'config.yml must set blank_issues_enabled to false.' }
            if ($null -eq $contactLinksProperty -or $contactLinksProperty.Value -isnot [System.Collections.IList]) { Add-Finding 'config.yml must declare contact_links as an array.' }
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
