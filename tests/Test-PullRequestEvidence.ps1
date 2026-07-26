[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$fixtureRoot = Join-Path $PSScriptRoot 'fixtures\pull-request-evidence'
$collectorPath = Join-Path $repositoryRoot 'plugins\azure-workflow\scripts\Get-AzureWorkflowPullRequestEvidence.ps1'
$failures = [System.Collections.Generic.List[string]]::new()

$tokens = $null
$parseErrors = $null
[void][System.Management.Automation.Language.Parser]::ParseFile($collectorPath, [ref]$tokens, [ref]$parseErrors)
foreach ($error in @($parseErrors)) { $failures.Add("Collector parse error: $($error.Message)") }

$collector = Get-Content -LiteralPath $collectorPath -Raw
foreach ($required in @('/files', '/commits', '/reviews', '/comments', '/issues/', '/check-runs', '/statuses/', 'reviewThreads', 'comments(first: 100', 'fingerprint', 'cat-file', 'Get-Snapshot', 'changed_files', 'commit_inventory_incomplete', 'file_inventory_incomplete')) {
    if ($collector -notmatch [regex]::Escape($required)) { $failures.Add("Collector contract marker missing: $required") }
}
if ([regex]::Matches($collector, 'Get-Snapshot -Repository').Count -lt 2) { $failures.Add('Collector must take two complete snapshots for stability comparison.') }

. $collectorPath

function Test-CappedInventory {
    param(
        [Parameter(Mandatory)][int]$ExpectedCount,
        [Parameter(Mandatory)][int]$EndpointLimit,
        [Parameter(Mandatory)][int]$AvailableCount,
        [Parameter(Mandatory)][bool]$ExpectedComplete,
        [Parameter(Mandatory)][string]$Name
    )

    $request = {
        param([string[]]$Arguments)
        $uri = $Arguments[-1]
        $page = [int]([regex]::Match($uri, '[?&]page=(\d+)').Groups[1].Value)
        $start = ($page - 1) * 100
        $remaining = [Math]::Max(0, $AvailableCount - $start)
        $count = [Math]::Min(100, $remaining)
        return @($(for ($index = 0; $index -lt $count; $index++) { [pscustomobject]@{ sha = "$Name-$($start + $index)" } }))
    }.GetNewClosure()

    $observed = Get-CappedRestArray -Endpoint 'fixture' -ExpectedCount $ExpectedCount -EndpointLimit $EndpointLimit -RequestJson $request
    if ([bool]$observed.complete -ne $ExpectedComplete) { $failures.Add("Capped inventory result mismatch: $Name") }
    if ($observed.collected_count -ne [Math]::Min($AvailableCount, $EndpointLimit)) { $failures.Add("Capped inventory count mismatch: $Name") }
}

Test-CappedInventory -ExpectedCount 201 -EndpointLimit 250 -AvailableCount 201 -ExpectedComplete $true -Name 'complete-commits'
Test-CappedInventory -ExpectedCount 251 -EndpointLimit 250 -AvailableCount 250 -ExpectedComplete $false -Name 'capped-commits'
Test-CappedInventory -ExpectedCount 3001 -EndpointLimit 3000 -AvailableCount 3000 -ExpectedComplete $false -Name 'capped-files'

$partialFailureObserved = $false
try {
    $failingRequest = {
        param([string[]]$Arguments)
        $uri = $Arguments[-1]
        if ($uri -match 'page=2') { throw 'fixture partial API failure' }
        return @(1..100 | ForEach-Object { [pscustomobject]@{ sha = "partial-$_" } })
    }
    [void](Get-CappedRestArray -Endpoint 'fixture' -ExpectedCount 150 -EndpointLimit 250 -RequestJson $failingRequest)
}
catch {
    $partialFailureObserved = $_.Exception.Message -match 'fixture partial API failure'
}
if (-not $partialFailureObserved) { $failures.Add('Partial API failure must block capped inventory collection.') }

$originalInvokeGhJson = (Get-Item -LiteralPath Function:\Invoke-GhJson).ScriptBlock
function Invoke-GhJson {
    param([Parameter(Mandatory)][string[]]$Arguments)
    return [pscustomobject]@{ id = 1 }
}
try {
    $singleItemPage = @(Get-RestArray -Endpoint 'fixture')
    if ($singleItemPage.Count -ne 1 -or $singleItemPage[0].id -ne 1) { $failures.Add('Generic REST pagination must accept a one-item scalar response under strict mode.') }
}
finally {
    Set-Item -LiteralPath Function:\Invoke-GhJson -Value $originalInvokeGhJson
}

$optionalPropertySnapshot = [pscustomobject]@{
    base_oid = 'base'
    head_oid = 'head'
    pr_updated_at = '2026-07-26T00:00:00Z'
    checks = @()
    statuses = @()
    review_decision = $null
    review_requests = @([pscustomobject]@{ id = 1; login = 'reviewer'; type = 'User' })
    files = @([pscustomobject]@{ filename = 'file.ps1'; status = 'added'; sha = 'sha' })
    commits = @([pscustomobject]@{ sha = 'commit' })
    reviews = @()
    issue_comments = @()
    inline_comments = @()
    review_threads = @()
    inventory = [pscustomobject]@{
        files = [pscustomobject]@{ expected_count = 1; collected_count = 1; endpoint_limit = 3000; complete = $true }
        commits = [pscustomobject]@{ expected_count = 1; collected_count = 1; endpoint_limit = 250; complete = $true }
    }
}
$optionalPropertyFingerprint = Get-EvidenceFingerprint -Snapshot $optionalPropertySnapshot
if ($optionalPropertyFingerprint -notmatch '^[0-9a-f]{64}$') { $failures.Add('Evidence fingerprint must tolerate absent optional GitHub properties.') }

$originalInvokeGhJson = (Get-Item -LiteralPath Function:\Invoke-GhJson).ScriptBlock
function Invoke-GhJson {
    param([Parameter(Mandatory)][string[]]$Arguments)

    $threadId = @($Arguments | Where-Object { $_ -like 'threadId=*' })
    if ($threadId.Count -gt 0) {
        return [pscustomobject]@{
            data = [pscustomobject]@{
                node = [pscustomobject]@{
                    comments = [pscustomobject]@{
                        nodes = @([pscustomobject]@{ id = 'comment-101'; updatedAt = '2026-07-26T00:00:00Z'; author = [pscustomobject]@{ login = 'reviewer' }; outdated = $false; body = 'reply' })
                        pageInfo = [pscustomobject]@{ hasNextPage = $false; endCursor = $null }
                    }
                }
            }
        }
    }

    $after = @($Arguments | Where-Object { $_ -like 'after=*' })
    if ($after -contains 'after=thread-page-1') {
        return [pscustomobject]@{
            data = [pscustomobject]@{
                repository = [pscustomobject]@{
                    pullRequest = [pscustomobject]@{
                        reviewThreads = [pscustomobject]@{
                            nodes = @([pscustomobject]@{
                                id = 'thread-2'; isResolved = $true; path = 'second.ps1'; line = 2; originalLine = 2; startLine = $null; diffSide = 'RIGHT'; startDiffSide = $null
                                viewerCanReply = $true; viewerCanResolve = $false; viewerCanUnresolve = $true; resolvedBy = [pscustomobject]@{ login = 'reviewer' }
                                comments = [pscustomobject]@{ nodes = @(); pageInfo = [pscustomobject]@{ hasNextPage = $false; endCursor = $null } }
                            })
                            pageInfo = [pscustomobject]@{ hasNextPage = $false; endCursor = $null }
                        }
                    }
                }
            }
        }
    }

    $initialComments = @(for ($index = 1; $index -le 100; $index++) {
        [pscustomobject]@{ id = "comment-$index"; updatedAt = '2026-07-26T00:00:00Z'; author = [pscustomobject]@{ login = 'reviewer' }; outdated = $false; body = "comment $index" }
    })
    return [pscustomobject]@{
        data = [pscustomobject]@{
            repository = [pscustomobject]@{
                pullRequest = [pscustomobject]@{
                    reviewThreads = [pscustomobject]@{
                        nodes = @([pscustomobject]@{
                            id = 'thread-1'; isResolved = $false; path = 'first.ps1'; line = 1; originalLine = 1; startLine = $null; diffSide = 'RIGHT'; startDiffSide = $null
                            viewerCanReply = $true; viewerCanResolve = $true; viewerCanUnresolve = $false; resolvedBy = $null
                            comments = [pscustomobject]@{ nodes = $initialComments; pageInfo = [pscustomobject]@{ hasNextPage = $true; endCursor = 'comment-page-1' } }
                        })
                        pageInfo = [pscustomobject]@{ hasNextPage = $true; endCursor = 'thread-page-1' }
                    }
                }
            }
        }
    }
}
try {
    $threadFixture = @(Get-ReviewThreads -Owner 'owner' -Name 'repo' -Number 1)
    if ($threadFixture.Count -ne 2) { $failures.Add('Nested thread fixture did not exhaust thread pages.') }
    if (@($threadFixture[0].comments).Count -ne 101) { $failures.Add('Nested thread fixture did not exhaust comment pages.') }
}
finally {
    Set-Item -LiteralPath Function:\Invoke-GhJson -Value $originalInvokeGhJson
}

foreach ($fixtureFile in Get-ChildItem -LiteralPath $fixtureRoot -File -Filter *.json) {
    $fixture = Get-Content -LiteralPath $fixtureFile.FullName -Raw | ConvertFrom-Json
    $headStable = $fixture.start.head_oid -eq $fixture.end.head_oid -and $fixture.start.base_oid -eq $fixture.end.base_oid
    $evidenceStable = $fixture.start.fingerprint -eq $fixture.end.fingerprint
    $observedValid = $headStable -and $evidenceStable -and [bool]$fixture.pagination_complete
    if ($observedValid -ne [bool]$fixture.expected_valid) { $failures.Add("Fixture expectation mismatch: $($fixtureFile.Name)") }
    if ($fixture.expected_reason -eq 'unresolved_threads' -and @($fixture.review_threads | Where-Object { -not $_.is_resolved }).Count -eq 0) { $failures.Add("Fixture lacks unresolved thread: $($fixtureFile.Name)") }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}
'Pull-request evidence contract tests: PASS'
exit 0
