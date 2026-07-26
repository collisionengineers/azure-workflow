[CmdletBinding()]
param(
    [string]$PluginPath = (Split-Path -Parent $PSScriptRoot),
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

function Add-ErrorMessage { param([string]$Message) $script:errors.Add($Message) }
function Require-File {
    param([string]$Root, [string]$RelativePath)
    if (-not (Test-Path -LiteralPath (Join-Path $Root $RelativePath) -PathType Leaf)) {
        Add-ErrorMessage "Missing file: $($RelativePath.Replace('\', '/'))"
    }
}

try {
    $root = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $PluginPath).Path)
    $manifestPath = Join-Path $root '.codex-plugin\plugin.json'
    $mcpPath = Join-Path $root '.mcp.json'
    Require-File $root '.codex-plugin\plugin.json'
    Require-File $root '.mcp.json'

    if (Test-Path -LiteralPath $manifestPath) {
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
        if ($manifest.name -ne 'azure-workflow') { Add-ErrorMessage 'Manifest name must be azure-workflow.' }
        if ($manifest.version -notmatch '^0\.1\.0-alpha\.1(?:\+[0-9A-Za-z.-]+)?$') { Add-ErrorMessage 'Manifest version must be 0.1.0-alpha.1 with optional build metadata.' }
        if ($manifest.skills -ne './skills/') { Add-ErrorMessage 'Manifest skills path must be ./skills/.' }
        if ($manifest.mcpServers -ne './.mcp.json') { Add-ErrorMessage 'Manifest MCP path must be ./.mcp.json.' }
        if (@($manifest.interface.defaultPrompt).Count -ne 3) { Add-ErrorMessage 'Manifest must expose exactly three lifecycle starter prompts.' }
        foreach ($forbiddenProperty in @('hooks', 'apps', 'license')) {
            if ($manifest.PSObject.Properties.Name -contains $forbiddenProperty) { Add-ErrorMessage "Forbidden manifest property: $forbiddenProperty" }
        }
    }

    if (Test-Path -LiteralPath $mcpPath) {
        $mcp = Get-Content -LiteralPath $mcpPath -Raw | ConvertFrom-Json
        $serverNames = @($mcp.mcpServers.PSObject.Properties.Name | Sort-Object)
        if (($serverNames -join ',') -ne 'azure,microsoft-learn') { Add-ErrorMessage 'MCP inventory must contain exactly azure and microsoft-learn.' }
        if ($mcp.mcpServers.azure.command -ne 'npx') { Add-ErrorMessage 'Azure MCP must use npx.' }
        if (@($mcp.mcpServers.azure.args) -notcontains '@azure/mcp@3.0.0-beta.29') { Add-ErrorMessage 'Azure MCP package must be pinned to 3.0.0-beta.29.' }
        if ($mcp.mcpServers.azure.env.AZURE_MCP_COLLECT_TELEMETRY -ne 'false') { Add-ErrorMessage 'Azure MCP telemetry must be disabled.' }
        if ($mcp.mcpServers.'microsoft-learn'.type -ne 'http' -or $mcp.mcpServers.'microsoft-learn'.url -ne 'https://learn.microsoft.com/api/mcp') { Add-ErrorMessage 'Microsoft Learn MCP registration is invalid.' }
    }

    $expectedSkills = @(
        'deliver-azure-repository-change',
        'explain-repository',
        'onboard-azure-repository',
        'operate-azure-repository',
        'plan-azure-repository-change',
        'review-repository-pull-request'
    )
    $skillsRoot = Join-Path $root 'skills'
    $actualSkills = if (Test-Path -LiteralPath $skillsRoot) {
        @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Select-Object -ExpandProperty Name | Sort-Object)
    } else { @() }
    if (($actualSkills -join ',') -ne ($expectedSkills -join ',')) { Add-ErrorMessage 'Plugin must contain exactly the six approved skill directories.' }

    foreach ($skill in $expectedSkills) {
        $skillRoot = Join-Path $skillsRoot $skill
        Require-File $skillRoot 'SKILL.md'
        Require-File $skillRoot 'agents\openai.yaml'
        if (Test-Path -LiteralPath (Join-Path $skillRoot 'SKILL.md')) {
            $body = Get-Content -LiteralPath (Join-Path $skillRoot 'SKILL.md') -Raw
            if ($body -notmatch "(?ms)^---\s*\r?\nname:\s*$([regex]::Escape($skill))\s*\r?\ndescription:\s*.+?\r?\n---") { Add-ErrorMessage "$skill has invalid frontmatter." }
        }
        if (Test-Path -LiteralPath (Join-Path $skillRoot 'agents\openai.yaml')) {
            $agentYaml = Get-Content -LiteralPath (Join-Path $skillRoot 'agents\openai.yaml') -Raw
            if ($agentYaml -notmatch [regex]::Escape("`$$skill")) { Add-ErrorMessage "$skill default prompt must name `$$skill." }
            if ($agentYaml -notmatch '(?m)^\s*value:\s*"microsoft-learn"\s*$') { Add-ErrorMessage "$skill must declare the Microsoft Learn dependency." }
            $hasAzureDependency = $agentYaml -match '(?m)^\s*value:\s*"azure"\s*$'
            if ($skill -eq 'operate-azure-repository' -and -not $hasAzureDependency) { Add-ErrorMessage 'operate-azure-repository must declare the Azure MCP dependency.' }
            if ($skill -ne 'operate-azure-repository' -and $hasAzureDependency) { Add-ErrorMessage "$skill must not declare direct Azure MCP mutation tooling." }
        }
    }

    foreach ($relative in @('references\dotnet-projects.md', 'references\risk-scaling.md', 'references\versioning-and-release-stages.md')) { Require-File $root $relative }
    foreach ($consumer in @('onboard-azure-repository', 'plan-azure-repository-change', 'deliver-azure-repository-change', 'explain-repository', 'review-repository-pull-request')) {
        $body = Get-Content -LiteralPath (Join-Path $skillsRoot "$consumer\SKILL.md") -Raw
        if ($body -notmatch '\.\./\.\./references/dotnet-projects\.md') { Add-ErrorMessage "$consumer must link the shared .NET profile directly." }
    }

    $requiredBySkill = @{
        'onboard-azure-repository' = @('authority-and-conflicts.md', 'documentation-conversion.md', 'feature-catalog-conversion.md', 'github-onboarding.md', 'repository-policy-profile.md', 'repository-standard.md', 'ui-design-system.md')
        'plan-azure-repository-change' = @('change-planning.md', 'documentation-lifecycle.md', 'github-planning.md', 'ui-ux-planning.md')
        'deliver-azure-repository-change' = @('documentation-maintenance.md', 'git-and-pr.md', 'github-delivery.md', 'implementation-quality.md', 'pr-review-remediation.md', 'repository-modes.md', 'testing-and-ci.md', 'ui-ux-delivery.md')
        'explain-repository' = @('code-and-system-explanation.md', 'github-feedback-explanation.md')
        'review-repository-pull-request' = @('pr-evidence-collection.md', 'review-contract.md')
        'operate-azure-repository' = @('azure-evidence.md', 'azure-safety-and-approval.md', 'iac-and-drift.md')
    }
    foreach ($skill in $requiredBySkill.Keys) {
        $skillRoot = Join-Path $skillsRoot $skill
        foreach ($reference in $requiredBySkill[$skill]) { Require-File $skillRoot "references\$reference" }
        $referenceRoot = Join-Path $skillRoot 'references'
        $actualReferences = if (Test-Path -LiteralPath $referenceRoot) { @(Get-ChildItem -LiteralPath $referenceRoot -File | Select-Object -ExpandProperty Name | Sort-Object) } else { @() }
        $expectedReferences = @($requiredBySkill[$skill] | Sort-Object)
        if (($actualReferences -join ',') -ne ($expectedReferences -join ',')) { Add-ErrorMessage "$skill has an unexpected or missing reference file." }
        if (Test-Path -LiteralPath (Join-Path $skillRoot 'scripts')) { Add-ErrorMessage "$skill must not contain a skill-local scripts directory." }
    }

    $expectedOnboardingAssets = @(
        'assets/repository/AGENTS.md.template',
        'assets/repository/agent-mistakes.md.template',
        'assets/repository/architecture.md.template',
        'assets/repository/design/README.md.template',
        'assets/repository/design/assets/fonts/README.md.template',
        'assets/repository/design/assets/icons/README.md.template',
        'assets/repository/design/brand/imagery.md.template',
        'assets/repository/design/brand/logos/README.md.template',
        'assets/repository/design/brand/style.md.template',
        'assets/repository/design/components/index.md.template',
        'assets/repository/design/foundations/accessibility.md.template',
        'assets/repository/design/foundations/colour.md.template',
        'assets/repository/design/foundations/motion.md.template',
        'assets/repository/design/foundations/spacing-and-layout.md.template',
        'assets/repository/design/foundations/typography.md.template',
        'assets/repository/design/patterns/index.md.template',
        'assets/repository/design/references/README.md.template',
        'assets/repository/design/tokens/README.md.template',
        'assets/repository/docs-index.md.template',
        'assets/repository/issue-forms/bug.yml',
        'assets/repository/issue-forms/config.yml',
        'assets/repository/issue-forms/decision.yml',
        'assets/repository/issue-forms/feature.yml',
        'assets/repository/issue-forms/task.yml',
        'assets/repository/operations.md.template',
        'assets/repository/product-index.md.template',
        'assets/repository/pull-request-template.md',
        'assets/repository/roadmap.md.template'
    ) | Sort-Object
    $onboardingRoot = Join-Path $skillsRoot 'onboard-azure-repository'
    $actualOnboardingAssets = @(Get-ChildItem -LiteralPath (Join-Path $onboardingRoot 'assets') -Recurse -File | ForEach-Object { [System.IO.Path]::GetRelativePath($onboardingRoot, $_.FullName).Replace('\', '/') } | Sort-Object)
    if (($actualOnboardingAssets -join ',') -ne ($expectedOnboardingAssets -join ',')) { Add-ErrorMessage 'Onboarding assets do not match the approved neutral asset tree.' }

    $planRoot = Join-Path $skillsRoot 'plan-azure-repository-change'
    $actualPlanAssets = @(Get-ChildItem -LiteralPath (Join-Path $planRoot 'assets') -Recurse -File | ForEach-Object { [System.IO.Path]::GetRelativePath($planRoot, $_.FullName).Replace('\', '/') })
    if (($actualPlanAssets -join ',') -ne 'assets/change-record-template.md') { Add-ErrorMessage 'Planning must own exactly one change-record asset.' }
    foreach ($skill in @('deliver-azure-repository-change', 'explain-repository', 'review-repository-pull-request', 'operate-azure-repository')) {
        if (Test-Path -LiteralPath (Join-Path $skillsRoot "$skill\assets")) { Add-ErrorMessage "$skill must not contain an assets directory." }
    }

    foreach ($forbidden in @('hooks.json', '.app.json')) {
        if (Test-Path -LiteralPath (Join-Path $root $forbidden)) { Add-ErrorMessage "Forbidden plugin surface: $forbidden" }
    }

    $scriptFiles = @(Get-ChildItem -LiteralPath (Join-Path $root 'scripts') -File -Filter *.ps1)
    $expectedScripts = @('Get-AzureWorkflowPullRequestEvidence.ps1', 'New-AzureWorkflowChange.ps1', 'Test-AzureWorkflowPlugin.ps1', 'Test-AzureWorkflowRepository.ps1') | Sort-Object
    $actualScripts = @($scriptFiles | Select-Object -ExpandProperty Name | Sort-Object)
    if (($actualScripts -join ',') -ne ($expectedScripts -join ',')) { Add-ErrorMessage 'Plugin scripts do not match the approved four-helper surface.' }
    foreach ($scriptFile in $scriptFiles) {
        $tokens = $null
        $parseErrors = $null
        [void][System.Management.Automation.Language.Parser]::ParseFile($scriptFile.FullName, [ref]$tokens, [ref]$parseErrors)
        foreach ($parseError in @($parseErrors)) { Add-ErrorMessage "$($scriptFile.Name): $($parseError.Message)" }
    }

    $scanFiles = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object { $_.Extension -in @('.md', '.json', '.yaml', '.yml', '.ps1') }
    foreach ($file in $scanFiles) {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        $unfinishedMarker = 'TO' + 'DO'
        if ($content -match "(?i)\b$unfinishedMarker\b") { Add-ErrorMessage "Unfinished marker remains in $($file.FullName.Substring($root.Length + 1).Replace('\', '/'))." }
        if ($content -match '(?i)(?:[A-Z]:\\Users\\[^\\\s]+|\\\\[^\\\s]+\\[^\\\s]+)') { Add-ErrorMessage "Workstation-specific path found in $($file.FullName.Substring($root.Length + 1).Replace('\', '/'))." }
        $caseStudyPattern = '(?i)collision' + 'spike|collision' + 'capture'
        if ($content -match $caseStudyPattern) { Add-ErrorMessage "Case-study product leakage found in $($file.FullName.Substring($root.Length + 1).Replace('\', '/'))." }
    }

    $result = [ordered]@{
        valid = $errors.Count -eq 0
        plugin_path = '.'
        errors = @($errors)
        warnings = @($warnings)
        counts = [ordered]@{ skills = $actualSkills.Count; scripts = $scriptFiles.Count }
    }
    if ($Json) { $result | ConvertTo-Json -Depth 8 -Compress } else {
        "Plugin package: $(if ($result.valid) { 'PASS' } else { 'FAIL' })"
        "Skills: $($actualSkills.Count)"
        foreach ($message in $errors) { "ERROR: $message" }
        foreach ($message in $warnings) { "WARNING: $message" }
    }
    if ($errors.Count -gt 0) { exit 1 }
    exit 0
}
catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 2
}
