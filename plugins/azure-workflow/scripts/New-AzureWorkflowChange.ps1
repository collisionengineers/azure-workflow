[CmdletBinding()]
param(
    [string]$RepositoryPath = '.',
    [Parameter(Mandatory)]
    [ValidatePattern('^[a-z0-9]+(?:-[a-z0-9]+)*$')]
    [string]$Slug,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Title,
    [ValidateSet('onboarding', 'feature', 'fix', 'documentation', 'operations')]
    [string]$Type = 'feature',
    [ValidateSet('active', 'planned')]
    [string]$Status = 'active',
    [string]$Issue = 'none'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-ValidationFailure {
    param([Parameter(Mandatory)][string]$Message)

    Write-Error -Message $Message -ErrorAction Continue
    exit 1
}

function Assert-NoReparseTraversal {
    param(
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string]$RelativePath
    )

    $current = $Root
    foreach ($segment in @($RelativePath -split '[\\/]')) {
        if ([string]::IsNullOrWhiteSpace($segment)) { continue }
        $current = Join-Path $current $segment
        $item = Get-Item -LiteralPath $current -Force -ErrorAction Stop
        if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
            Write-ValidationFailure "Refusing change-record path through reparse point: $($RelativePath.Replace('\\', '/'))"
        }
    }
}

function Get-DeclaredRepositoryMode {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Owner
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Write-ValidationFailure "Required repository-mode authority does not exist: $Owner"
    }
    $content = Get-Content -LiteralPath $Path -Raw
    $matches = [regex]::Matches($content, '(?m)^(?:-\s*)?Repository mode:\s*(?:`(?<quoted>development|released)`|(?<plain>development|released))\.?\s*$')
    if ($matches.Count -ne 1) {
        Write-ValidationFailure "$Owner must declare exactly one Repository mode: development or released."
    }
    $quotedMode = $matches[0].Groups['quoted'].Value
    return $(if ([string]::IsNullOrWhiteSpace($quotedMode)) { $matches[0].Groups['plain'].Value } else { $quotedMode })
}

try {
    $normalizedTitle = $Title.Trim()
    if ([string]::IsNullOrWhiteSpace($normalizedTitle) -or $normalizedTitle -match '[\r\n]') {
        Write-ValidationFailure 'Title must contain non-whitespace text on one line.'
    }

    $normalizedIssue = $Issue.Trim()
    if ([string]::IsNullOrWhiteSpace($normalizedIssue) -or $normalizedIssue -match '[\r\n]') {
        Write-ValidationFailure 'Issue must be none, pending, or one absolute HTTPS URL.'
    }
    if ($normalizedIssue -cnotin @('none', 'pending')) {
        $issueUri = $null
        if (-not [System.Uri]::TryCreate($normalizedIssue, [System.UriKind]::Absolute, [ref]$issueUri) -or $issueUri.Scheme -cne 'https') {
            Write-ValidationFailure 'Issue must be none, pending, or one absolute HTTPS URL.'
        }
    }

    $resolvedRepository = Resolve-Path -LiteralPath $RepositoryPath -ErrorAction Stop
    $repositoryRoot = [System.IO.Path]::GetFullPath($resolvedRepository.Path)
    $changesDirectory = Join-Path $repositoryRoot 'docs\changes'

    if (-not (Test-Path -LiteralPath $changesDirectory -PathType Container)) {
        Write-ValidationFailure "Required directory does not exist: docs/changes"
    }

    Assert-NoReparseTraversal -Root $repositoryRoot -RelativePath 'docs\changes'

    $resolvedChanges = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $changesDirectory).Path)
    $rootPrefix = $repositoryRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
    if (-not $resolvedChanges.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-ValidationFailure 'The change-record directory resolves outside the selected repository.'
    }

    $templatePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'skills\plan-azure-repository-change\assets\change-record-template.md'
    if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
        Write-ValidationFailure 'The packaged change-record template is missing.'
    }

    $productMode = Get-DeclaredRepositoryMode -Path (Join-Path $repositoryRoot 'docs\product\index.md') -Owner 'docs/product/index.md'
    $agentMode = Get-DeclaredRepositoryMode -Path (Join-Path $repositoryRoot 'AGENTS.md') -Owner 'AGENTS.md'
    if ($productMode -cne $agentMode) {
        Write-ValidationFailure 'AGENTS.md and docs/product/index.md declare different repository modes.'
    }

    $utcDate = [DateTime]::UtcNow.ToString('yyyy-MM-dd')
    $fileName = "$utcDate-$Slug.md"
    $targetPath = Join-Path $resolvedChanges $fileName
    $resolvedTarget = [System.IO.Path]::GetFullPath($targetPath)

    if (-not $resolvedTarget.StartsWith(($resolvedChanges.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar), [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-ValidationFailure 'The generated change-record path resolves outside docs/changes.'
    }
    if (Test-Path -LiteralPath $resolvedTarget) {
        Write-ValidationFailure "Change record already exists: docs/changes/$fileName"
    }

    $baseline = 'unknown'
    $gitOutput = & git -C $repositoryRoot rev-parse --verify HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace(($gitOutput -join ''))) {
        $baseline = ($gitOutput -join '').Trim()
    }

    $content = Get-Content -LiteralPath $templatePath -Raw
    $replacements = [ordered]@{
        '{{TITLE}}' = $normalizedTitle
        '{{DATE}}' = $utcDate
        '{{SLUG}}' = $Slug
        '{{TYPE}}' = $Type
        '{{STATUS}}' = $Status
        '{{ISSUE}}' = $normalizedIssue
        '{{BASELINE}}' = $baseline
        '{{MODE}}' = $productMode
    }
    foreach ($entry in $replacements.GetEnumerator()) {
        $content = $content.Replace([string]$entry.Key, [string]$entry.Value)
    }

    # Recheck immediately before an atomic create so an existing record is never replaced.
    Assert-NoReparseTraversal -Root $repositoryRoot -RelativePath 'docs\changes'
    $stream = [System.IO.FileStream]::new($resolvedTarget, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    try {
        $writer = [System.IO.StreamWriter]::new($stream, [System.Text.UTF8Encoding]::new($false))
        try { $writer.Write($content) }
        finally { $writer.Dispose() }
    }
    finally {
        if ($null -ne $stream) { $stream.Dispose() }
    }

    [ordered]@{
        path = "docs/changes/$fileName"
        slug = $Slug
        type = $Type
        status = $Status
        mode = $productMode
    } | ConvertTo-Json -Compress
    exit 0
}
catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 2
}
