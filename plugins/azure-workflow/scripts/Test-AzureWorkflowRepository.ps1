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
function Require-Directory {
    param([string]$Root, [string]$RelativePath)
    $path = Resolve-ExactRelativePath -Root $Root -RelativePath $RelativePath
    if ($null -eq $path -or -not (Test-Path -LiteralPath $path -PathType Container)) {
        $display = $RelativePath.Replace('\', '/')
        if (Test-Path -LiteralPath (Join-Path $Root $RelativePath) -PathType Container) { Add-Finding "Path casing must be exact: $display" }
        else { Add-Finding "Missing directory: $display" }
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
function Test-SemVer {
    param([AllowNull()][string]$Value)
    return $null -ne $Value -and $Value -match '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-(?:0|[1-9]\d*|\d*[A-Za-z-][0-9A-Za-z-]*)(?:\.(?:0|[1-9]\d*|\d*[A-Za-z-][0-9A-Za-z-]*))*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$'
}
function ConvertFrom-SimpleMetadata {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Owner
    )

    $metadata = [ordered]@{}
    foreach ($line in @($Content -split "`r?`n")) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -notmatch '^(?<key>[a-z][a-z_]*):\s*(?<value>.*\S)\s*$') {
            Add-Finding "$Owner has invalid metadata line: $line"
            continue
        }
        $key = $Matches.key
        if ($metadata.Contains($key)) { Add-Finding "$Owner has duplicate metadata: $key"; continue }
        $metadata[$key] = $Matches.value.Trim()
    }
    return $metadata
}
function Test-IsoDate {
    param([AllowNull()][string]$Value)
    $parsed = [datetime]::MinValue
    return $null -ne $Value -and [datetime]::TryParseExact($Value, 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$parsed)
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
    foreach ($relative in @('docs\decisions', 'docs\changes')) { Require-Directory $root $relative }

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
        if ($metadata.Contains('Repository mode') -and $metadata['Repository mode'] -cnotin @('development', 'released')) {
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
        if ($metadata.Contains('Current version') -and -not (Test-SemVer $metadata['Current version'])) {
            Add-Finding 'Current version must be valid Semantic Versioning.'
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

    $capabilityRelativePath = 'docs\product\capabilities.md'
    $capabilityPath = Resolve-ExactRelativePath -Root $root -RelativePath $capabilityRelativePath
    if ($null -eq $capabilityPath -and (Test-Path -LiteralPath (Join-Path $root $capabilityRelativePath) -PathType Leaf)) {
        Add-Finding 'Path casing must be exact: docs/product/capabilities.md'
    }
    if ($null -ne $capabilityPath -and (Test-Path -LiteralPath $capabilityPath -PathType Leaf)) {
        $capabilityContent = (Get-Content -LiteralPath $capabilityPath -Raw) -replace "`r`n", "`n"
        $capabilityLines = @($capabilityContent -split "`n")
        $headerIndex = -1
        for ($index = 0; $index -lt $capabilityLines.Count; $index++) {
            if ($capabilityLines[$index] -ceq '| ID | Outcome | Canonical owner | Target release |') { $headerIndex = $index; break }
        }
        if ($headerIndex -lt 0 -or $headerIndex + 1 -ge $capabilityLines.Count -or $capabilityLines[$headerIndex + 1] -notmatch '^\|\s*-+\s*\|\s*-+\s*\|\s*-+\s*\|\s*-+\s*\|$') {
            Add-Finding 'docs/product/capabilities.md has an invalid capability-table header.'
        } else {
            $capabilityIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
            $capabilityCount = 0
            for ($index = $headerIndex + 2; $index -lt $capabilityLines.Count; $index++) {
                $line = $capabilityLines[$index]
                if ([string]::IsNullOrWhiteSpace($line)) { break }
                if (-not $line.StartsWith('|', [System.StringComparison]::Ordinal)) { break }
                $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
                if ($cells.Count -ne 4) { Add-Finding "Invalid capability row: $line"; continue }
                $capabilityCount++
                $id, $outcome, $ownerCell, $targetRelease = $cells
                if ($id -cnotmatch '^[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)*-\d{3}$') { Add-Finding "Invalid capability ID: $id" }
                elseif (-not $capabilityIds.Add($id)) { Add-Finding "Duplicate capability ID: $id" }
                if ([string]::IsNullOrWhiteSpace($outcome)) { Add-Finding "$id has an empty outcome." }

                $owner = $ownerCell.Trim([char]96)
                if ($owner -match '^\[[^\]]+\]\(([^)]+)\)$') { $owner = $Matches[1] }
                $owner = ($owner.Trim('<', '>') -split '#', 2)[0]
                if ([string]::IsNullOrWhiteSpace($owner) -or $owner -match '^(?:https?:|[A-Za-z]:[\\/]|\\\\|~[\\/])') {
                    Add-Finding "$id must name a repository-relative canonical owner."
                } else {
                    $ownerPath = Resolve-ExactRelativePath -Root $root -RelativePath $owner
                    if ($null -eq $ownerPath -or -not (Test-Path -LiteralPath $ownerPath -PathType Leaf)) { Add-Finding "$id canonical owner does not exist with exact casing: $owner" }
                }
                $targetReleaseValue = $targetRelease.Trim([char]96)
                if ($targetReleaseValue -cne 'unallocated' -and -not (Test-SemVer $targetReleaseValue)) { Add-Finding "$id has an invalid target release: $targetRelease" }
            }
            if ($capabilityCount -eq 0) { Add-Finding 'docs/product/capabilities.md must contain at least one capability row.' }
        }
    }

    $decisionRoot = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\decisions'
    if ($null -ne $decisionRoot -and (Test-Path -LiteralPath $decisionRoot -PathType Container)) {
        foreach ($decision in @(Get-ChildItem -LiteralPath $decisionRoot -File)) {
            if ($decision.Name -cnotmatch '^(?<number>\d{4})-[a-z0-9]+(?:-[a-z0-9]+)*\.md$') { Add-Finding "Invalid ADR filename: $($decision.Name)"; continue }
            $fileNumber = $Matches.number
            $decisionContent = Get-Content -LiteralPath $decision.FullName -Raw
            $titleMatches = [regex]::Matches($decisionContent, '(?m)^# ADR (?<number>\d{4}):\s+\S.+$')
            if ($titleMatches.Count -ne 1 -or $titleMatches[0].Groups['number'].Value -cne $fileNumber) { Add-Finding "$($decision.Name) must contain one matching ADR title." }
            $statuses = @(Get-MetadataValues -Content $decisionContent -Field 'Status' -Bullet)
            if ($statuses.Count -ne 1 -or $statuses[0] -notin @('proposed', 'accepted', 'superseded', 'rejected', 'deprecated')) { Add-Finding "$($decision.Name) has an invalid or duplicate Status." }
            $dates = @(Get-MetadataValues -Content $decisionContent -Field 'Date' -Bullet)
            if ($dates.Count -ne 1 -or -not (Test-IsoDate $dates[0])) { Add-Finding "$($decision.Name) has an invalid or duplicate Date." }
            foreach ($heading in @('## Context', '## Decision', '## Consequences')) {
                if ([regex]::Matches($decisionContent, "(?m)^$([regex]::Escape($heading))\s*$").Count -ne 1) { Add-Finding "$($decision.Name) must contain exactly one $heading section." }
            }
        }
    }

    $changeRoot = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\changes'
    $changeRecords = if ($null -ne $changeRoot -and (Test-Path -LiteralPath $changeRoot -PathType Container)) { @(Get-ChildItem -LiteralPath $changeRoot -File -Filter *.md) } else { @() }
    foreach ($record in $changeRecords) {
        if ($record.Name -cnotmatch '^\d{4}-\d{2}-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*\.md$') { Add-Finding "Invalid change-record filename: $($record.Name)" }
        $recordContent = Get-Content -LiteralPath $record.FullName -Raw
        if ([regex]::Matches($recordContent, '(?m)^# Change:\s+\S.+$').Count -ne 1) { Add-Finding "$($record.Name) must contain exactly one change title." }
        $metadataBlocks = [regex]::Matches($recordContent, '(?ms)^```yaml\s*\r?\n(?<metadata>.*?)\r?\n```\s*$')
        if ($metadataBlocks.Count -ne 1) {
            Add-Finding "$($record.Name) must contain exactly one YAML metadata block."
            $recordMetadata = [ordered]@{}
        } else {
            $recordMetadata = ConvertFrom-SimpleMetadata -Content $metadataBlocks[0].Groups['metadata'].Value -Owner $record.Name
        }

        $requiredRecordKeys = @('id', 'type', 'status', 'risk', 'created', 'updated', 'issue', 'pull_request', 'baseline', 'target_release', 'roadmap_horizon', 'mode', 'supersedes', 'superseded_by')
        foreach ($key in $requiredRecordKeys) {
            if (-not $recordMetadata.Contains($key)) { Add-Finding "$($record.Name) is missing metadata: $key" }
        }
        foreach ($key in @($recordMetadata.Keys)) {
            if ($key -notin $requiredRecordKeys) { Add-Finding "$($record.Name) contains unsupported metadata: $key" }
        }
        if ($recordMetadata.Contains('id') -and "$($recordMetadata.id).md" -cne $record.Name) { Add-Finding "$($record.Name) metadata id must match its filename." }
        if ($recordMetadata.Contains('type') -and $recordMetadata.type -notin @('onboarding', 'feature', 'fix', 'documentation', 'operations')) { Add-Finding "$($record.Name) has an invalid type." }
        if ($recordMetadata.Contains('status') -and $recordMetadata.status -notin @('active', 'blocked', 'planned', 'ready', 'superseded')) { Add-Finding "$($record.Name) has an invalid status." }
        if ($recordMetadata.Contains('risk') -and $recordMetadata.risk -notin @('standard', 'high')) { Add-Finding "$($record.Name) has an invalid risk." }
        if ($recordMetadata.Contains('mode') -and $recordMetadata.mode -notin @('development', 'released')) { Add-Finding "$($record.Name) has an invalid mode." }
        if ($recordMetadata.Contains('created') -and -not (Test-IsoDate $recordMetadata.created)) { Add-Finding "$($record.Name) has an invalid created date." }
        if ($recordMetadata.Contains('updated') -and -not (Test-IsoDate $recordMetadata.updated)) { Add-Finding "$($record.Name) has an invalid updated date." }
        if ($recordMetadata.Contains('created') -and $recordMetadata.Contains('updated') -and (Test-IsoDate $recordMetadata.created) -and (Test-IsoDate $recordMetadata.updated)) {
            if ([datetime]::ParseExact($recordMetadata.updated, 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture) -lt [datetime]::ParseExact($recordMetadata.created, 'yyyy-MM-dd', [System.Globalization.CultureInfo]::InvariantCulture)) { Add-Finding "$($record.Name) updated date precedes created date." }
        }
        foreach ($linkField in @('issue', 'pull_request')) {
            if (-not $recordMetadata.Contains($linkField)) { continue }
            $value = $recordMetadata[$linkField]
            if ($value -notin @('none', 'pending')) {
                $uri = $null
                if (-not [uri]::TryCreate($value, [System.UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -ne 'https') { Add-Finding "$($record.Name) has an invalid $linkField value." }
            }
        }
        if ($recordMetadata.Contains('baseline') -and $recordMetadata.baseline -cne 'unknown' -and $recordMetadata.baseline -cnotmatch '^[0-9a-f]{40}$') { Add-Finding "$($record.Name) has an invalid baseline." }
        if ($recordMetadata.Contains('target_release') -and $recordMetadata.target_release -cne 'unallocated' -and -not (Test-SemVer $recordMetadata.target_release)) { Add-Finding "$($record.Name) has an invalid target release." }
        if ($recordMetadata.Contains('roadmap_horizon') -and $recordMetadata.roadmap_horizon -notin @('Now', 'Next', 'Later', 'Not planned', 'unallocated')) { Add-Finding "$($record.Name) has an invalid roadmap horizon." }
        foreach ($relationField in @('supersedes', 'superseded_by')) {
            if ($recordMetadata.Contains($relationField) -and $recordMetadata[$relationField] -cne 'none' -and $recordMetadata[$relationField] -cnotmatch '^\d{4}-\d{2}-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*$') { Add-Finding "$($record.Name) has an invalid $relationField value." }
        }
        if ($recordMetadata.Contains('status') -and $recordMetadata.status -eq 'superseded' -and $recordMetadata.Contains('superseded_by') -and $recordMetadata.superseded_by -eq 'none') {
            Add-Finding "$($record.Name) is superseded but has no superseded_by record."
        }
        foreach ($heading in @('## Summary', '## Scope', '## Authorities, current state, and constraints', '## Acceptance criteria', '## Plan', '## Data, failure, and recovery', '## UI/UX contract', '## Azure impact', '## Decisions and conflicts', '## Implementation', '## Verification', '## Independent review', '## Documentation and work tracking', '## Outcome', '## Blocker or follow-ups')) {
            if ([regex]::Matches($recordContent, "(?m)^$([regex]::Escape($heading))\s*$").Count -ne 1) { Add-Finding "$($record.Name) must contain exactly one heading: $heading" }
        }
        if ($recordContent -notmatch '(?m)^- Documentation impact declared before implementation:\s*\S') { Add-Finding "$($record.Name) lacks a documentation-impact declaration." }
    }

    $mistakePath = Resolve-ExactRelativePath -Root $root -RelativePath 'docs\agent-mistakes.md'
    if ($null -ne $mistakePath -and (Test-Path -LiteralPath $mistakePath -PathType Leaf)) {
        $mistakes = (Get-Content -LiteralPath $mistakePath -Raw) -replace "`r`n", "`n"
        $templateSection = [regex]::Match($mistakes, '(?ms)^## Incident template\s*\n(?<template>.*?)^## Entries\s*$')
        if (-not $templateSection.Success) {
            Add-Finding 'docs/agent-mistakes.md has an invalid Incident template/Entries boundary.'
        } else {
            $templateCode = [regex]::Match($templateSection.Groups['template'].Value, '(?ms)^```markdown\s*\n(?<body>.*?)\n```\s*$')
            if (-not $templateCode.Success) { Add-Finding 'docs/agent-mistakes.md must contain one fenced Markdown incident template.' }
            else {
                $templateBody = $templateCode.Groups['body'].Value
                if ($templateBody -notmatch '(?m)^### AM-YYYYMMDD-NNN:\s+<short factual title>\s*$') { Add-Finding 'docs/agent-mistakes.md has an invalid incident ID/title template.' }
                foreach ($field in @('Occurred', 'Detected', 'Workflow/package version', 'Change/PR', 'Classification', 'What happened', 'Impact', 'Recovery', 'Why the gate failed', 'Reusable prevention signal', 'Follow-up')) {
                    if ([regex]::Matches($templateBody, "(?m)^- $([regex]::Escape($field)):\s*\S.+$").Count -ne 1) { Add-Finding "docs/agent-mistakes.md incident template must contain exactly one $field field." }
                }
            }
        }

        $entriesMatch = [regex]::Match($mistakes, '(?ms)^## Entries\s*\n(?<entries>.*)\z')
        if (-not $entriesMatch.Success) { Add-Finding 'docs/agent-mistakes.md has no valid Entries body.' }
        else {
            $entries = $entriesMatch.Groups['entries'].Value.Trim()
            $entryMarker = 'Append incidents below; do not edit earlier entries.'
            if (-not $entries.StartsWith($entryMarker, [System.StringComparison]::Ordinal)) { Add-Finding 'docs/agent-mistakes.md is missing its append marker.' }
            $incidentText = if ($entries.Length -gt $entryMarker.Length) { $entries.Substring($entryMarker.Length).Trim() } else { '' }
            $incidentMatches = @([regex]::Matches($incidentText, '(?m)^###\s+(?<id>AM-\d{8}-\d{3}):\s+(?<title>\S.+)$'))
            $allEntryHeadings = @([regex]::Matches($incidentText, '(?m)^###\s+'))
            if ($allEntryHeadings.Count -ne $incidentMatches.Count) { Add-Finding 'docs/agent-mistakes.md contains an invalid incident heading.' }
            for ($index = 0; $index -lt $incidentMatches.Count; $index++) {
                $incident = $incidentMatches[$index]
                $nextIndex = if ($index + 1 -lt $incidentMatches.Count) { $incidentMatches[$index + 1].Index } else { $incidentText.Length }
                $incidentBody = $incidentText.Substring($incident.Index, $nextIndex - $incident.Index)
                $values = [ordered]@{}
                foreach ($field in @('Occurred', 'Detected', 'Workflow/package version', 'Change/PR', 'Classification', 'What happened', 'Impact', 'Recovery', 'Why the gate failed', 'Reusable prevention signal', 'Follow-up')) {
                    $fieldMatches = [regex]::Matches($incidentBody, "(?m)^- $([regex]::Escape($field)):\s*(\S.*)$")
                    if ($fieldMatches.Count -ne 1) { Add-Finding "$($incident.Groups['id'].Value) must contain exactly one non-empty $field field." }
                    else { $values[$field] = $fieldMatches[0].Groups[1].Value.Trim() }
                }
                foreach ($timestampField in @('Occurred', 'Detected')) {
                    if ($values.Contains($timestampField) -and $values[$timestampField] -notmatch '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z$') { Add-Finding "$($incident.Groups['id'].Value) has an invalid UTC $timestampField timestamp." }
                }
                if ($values.Contains('Classification') -and $values['Classification'] -notin @('authority', 'false-evidence', 'scope', 'escaped-defect', 'workflow-gap')) { Add-Finding "$($incident.Groups['id'].Value) has an invalid Classification." }
                if ($values.Contains('Occurred') -and $values['Occurred'] -match '^(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})' -and $incident.Groups['id'].Value.Substring(3, 8) -cne "$($Matches.year)$($Matches.month)$($Matches.day)") { Add-Finding "$($incident.Groups['id'].Value) date does not match Occurred." }
            }
        }
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

    $pullRequestTemplatePath = Resolve-ExactRelativePath -Root $root -RelativePath '.github\pull_request_template.md'
    $pullRequestTemplateFiles = if ($null -ne $pullRequestTemplatePath) { @(Get-Item -LiteralPath $pullRequestTemplatePath -ErrorAction SilentlyContinue) } else { @() }
    $markdownFiles = @(Get-ChildItem -LiteralPath (Join-Path $root 'docs') -Recurse -File -Filter *.md) + @(Get-Item -LiteralPath $agentsPath -ErrorAction SilentlyContinue) + $pullRequestTemplateFiles
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
