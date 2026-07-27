[CmdletBinding()]
param(
    [string]$RepositoryPath = '.',
    [Parameter(Mandatory)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$PullRequest,
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-GhJson {
    param([Parameter(Mandatory)][string[]]$Arguments)

    $output = & gh @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) { throw "gh $($Arguments -join ' ') failed: $($output -join [Environment]::NewLine)" }
    $text = ($output -join [Environment]::NewLine)
    if ([string]::IsNullOrWhiteSpace($text)) { return $null }
    return ($text | ConvertFrom-Json -Depth 100)
}

function Get-StableEvidenceKey {
    param(
        [Parameter(Mandatory)]$Item,
        [Parameter(Mandatory)][string]$EvidenceClass,
        [Parameter(Mandatory)][string[]]$KeyProperties
    )

    foreach ($propertyName in $KeyProperties) {
        $property = $Item.PSObject.Properties[$propertyName]
        if ($null -ne $property -and $null -ne $property.Value -and -not [string]::IsNullOrWhiteSpace([string]$property.Value)) {
            return "${propertyName}:$($property.Value)"
        }
    }
    throw "$EvidenceClass item lacks a stable identifier ($($KeyProperties -join ', '))."
}

function Select-UniqueEvidenceItems {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Items,
        [Parameter(Mandatory)][string]$EvidenceClass,
        [Parameter(Mandatory)][string[]]$KeyProperties
    )

    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $unique = [System.Collections.Generic.List[object]]::new()
    foreach ($item in @($Items)) {
        if ($null -eq $item) { continue }
        $key = Get-StableEvidenceKey -Item $item -EvidenceClass $EvidenceClass -KeyProperties $KeyProperties
        if ($seen.Add($key)) { $unique.Add($item) }
    }
    return @($unique)
}

function Get-RestArray {
    param(
        [Parameter(Mandatory)][string]$Endpoint,
        [string]$Property,
        [string[]]$KeyProperties = @('id'),
        [scriptblock]$RequestJson = { param([string[]]$Arguments) Invoke-GhJson -Arguments $Arguments }
    )

    $items = [System.Collections.Generic.List[object]]::new()
    for ($page = 1; $page -le 1000; $page++) {
        $separator = if ($Endpoint.Contains('?')) { '&' } else { '?' }
        $response = & $RequestJson -Arguments @('api', "$Endpoint${separator}per_page=100&page=$page")
        $pageItems = if ([string]::IsNullOrWhiteSpace($Property)) { @($response) } else { @($response.$Property) }
        foreach ($item in @($pageItems)) { if ($null -ne $item) { $items.Add($item) } }
        if (@($pageItems).Count -lt 100) { return @(Select-UniqueEvidenceItems -Items @($items) -EvidenceClass $Endpoint -KeyProperties $KeyProperties) }
    }
    throw "Pagination did not terminate for $Endpoint"
}

function Get-CountedRestArray {
    param(
        [Parameter(Mandatory)][string]$Endpoint,
        [Parameter(Mandatory)][string]$Property,
        [Parameter(Mandatory)][string[]]$KeyProperties,
        [scriptblock]$RequestJson = { param([string[]]$Arguments) Invoke-GhJson -Arguments $Arguments }
    )

    $items = [System.Collections.Generic.List[object]]::new()
    $expectedCount = $null
    $retrievedCount = 0
    $pageCount = 0
    for ($page = 1; $page -le 1000; $page++) {
        $separator = if ($Endpoint.Contains('?')) { '&' } else { '?' }
        $response = & $RequestJson -Arguments @('api', "$Endpoint${separator}per_page=100&page=$page")
        $totalCountProperty = $response.PSObject.Properties['total_count']
        if ($null -eq $totalCountProperty -or $null -eq $totalCountProperty.Value) { throw "$Endpoint response lacks total_count." }
        $pageExpectedCount = [int]$totalCountProperty.Value
        if ($null -eq $expectedCount) { $expectedCount = $pageExpectedCount }
        elseif ($expectedCount -ne $pageExpectedCount) { throw "$Endpoint total_count changed during pagination." }

        $propertyValue = Get-OptionalPropertyValue -InputObject $response -Name $Property
        $pageItems = @($propertyValue | Where-Object { $null -ne $_ })
        foreach ($item in $pageItems) { $items.Add($item) }
        $retrievedCount += $pageItems.Count
        $pageCount = $page
        if ($retrievedCount -ge $expectedCount -or $pageItems.Count -lt 100) { break }
    }

    $uniqueItems = @(Select-UniqueEvidenceItems -Items @($items) -EvidenceClass $Endpoint -KeyProperties $KeyProperties)
    return [pscustomobject][ordered]@{
        items = $uniqueItems
        expected_count = [int]$expectedCount
        collected_count = $uniqueItems.Count
        page_count = $pageCount
        complete = $uniqueItems.Count -eq [int]$expectedCount
    }
}

function Get-RequestedReviewers {
    param(
        [Parameter(Mandatory)][string]$Endpoint,
        [scriptblock]$RequestJson = { param([string[]]$Arguments) Invoke-GhJson -Arguments $Arguments }
    )

    $users = [System.Collections.Generic.List[object]]::new()
    $teams = [System.Collections.Generic.List[object]]::new()
    for ($page = 1; $page -le 1000; $page++) {
        $separator = if ($Endpoint.Contains('?')) { '&' } else { '?' }
        $response = & $RequestJson -Arguments @('api', "$Endpoint${separator}per_page=100&page=$page")
        $pageUsers = @(Get-OptionalPropertyValue -InputObject $response -Name 'users' | Where-Object { $null -ne $_ })
        $pageTeams = @(Get-OptionalPropertyValue -InputObject $response -Name 'teams' | Where-Object { $null -ne $_ })
        foreach ($user in $pageUsers) { $users.Add($user) }
        foreach ($team in $pageTeams) { $teams.Add($team) }
        if (($pageUsers.Count + $pageTeams.Count) -lt 100) {
            $uniqueUsers = @(Select-UniqueEvidenceItems -Items @($users) -EvidenceClass 'requested user reviewer' -KeyProperties @('node_id', 'id', 'login'))
            $uniqueTeams = @(Select-UniqueEvidenceItems -Items @($teams) -EvidenceClass 'requested team reviewer' -KeyProperties @('node_id', 'id', 'slug'))
            return [pscustomobject][ordered]@{
                items = @($uniqueUsers + $uniqueTeams)
                user_count = $uniqueUsers.Count
                team_count = $uniqueTeams.Count
                page_count = $page
                complete = $true
            }
        }
    }
    throw "Pagination did not terminate for $Endpoint"
}

function Get-CappedRestArray {
    param(
        [Parameter(Mandatory)][string]$Endpoint,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)][int]$ExpectedCount,
        [Parameter(Mandatory)][ValidateRange(1, [int]::MaxValue)][int]$EndpointLimit,
        [Parameter(Mandatory)][string[]]$KeyProperties,
        [scriptblock]$RequestJson = { param([string[]]$Arguments) Invoke-GhJson -Arguments $Arguments }
    )

    $items = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $retrievedCount = 0
    $page = 1
    $requestLimit = [Math]::Min($ExpectedCount, $EndpointLimit)
    while ($retrievedCount -lt $requestLimit) {
        $response = & $RequestJson -Arguments @('api', "${Endpoint}?per_page=100&page=$page")
        $pageItems = @($response)
        foreach ($item in $pageItems) {
            if ($null -eq $item -or $retrievedCount -ge $EndpointLimit) { continue }
            $retrievedCount++
            $key = Get-StableEvidenceKey -Item $item -EvidenceClass $Endpoint -KeyProperties $KeyProperties
            if ($seen.Add($key)) { $items.Add($item) }
        }
        if ($pageItems.Count -lt 100) { break }
        $page++
    }

    return [pscustomobject][ordered]@{
        items = @($items)
        expected_count = $ExpectedCount
        collected_count = $items.Count
        endpoint_limit = $EndpointLimit
        complete = $items.Count -eq $ExpectedCount
    }
}

function Get-StringHash {
    param([AllowNull()][string]$Text)

    if ($null -eq $Text) { $Text = '' }
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $hash = [System.Security.Cryptography.SHA256]::HashData($bytes)
    return [Convert]::ToHexString($hash).ToLowerInvariant()
}

function Get-OptionalPropertyValue {
    param(
        [AllowNull()]$InputObject,
        [Parameter(Mandatory)][string]$Name
    )

    if ($null -eq $InputObject) { return $null }
    $property = $InputObject.PSObject.Properties[$Name]
    if ($null -eq $property) { return $null }
    return $property.Value
}

function Get-ReviewThreads {
    param(
        [Parameter(Mandatory)][string]$Owner,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][int]$Number
    )

    $threadQuery = @'
query($owner: String!, $name: String!, $number: Int!, $after: String) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      reviewThreads(first: 100, after: $after) {
        nodes {
          id
          isResolved
          path
          line
          originalLine
          startLine
          diffSide
          startDiffSide
          viewerCanReply
          viewerCanResolve
          viewerCanUnresolve
          resolvedBy { login }
          comments(first: 100) {
            nodes {
              id
              databaseId
              body
              createdAt
              updatedAt
              url
              path
              line
              originalLine
              outdated
              author { login }
            }
            pageInfo { hasNextPage endCursor }
          }
        }
        pageInfo { hasNextPage endCursor }
      }
    }
  }
}
'@
    $commentQuery = @'
query($threadId: ID!, $after: String) {
  node(id: $threadId) {
    ... on PullRequestReviewThread {
      comments(first: 100, after: $after) {
        nodes {
          id
          databaseId
          body
          createdAt
          updatedAt
          url
          path
          line
          originalLine
          outdated
          author { login }
        }
        pageInfo { hasNextPage endCursor }
      }
    }
  }
}
'@

    $threads = [System.Collections.Generic.List[object]]::new()
    $threadIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $cursor = $null
    do {
        $arguments = @('api', 'graphql', '-f', "query=$threadQuery", '-F', "owner=$Owner", '-F', "name=$Name", '-F', "number=$Number")
        if ($null -ne $cursor) { $arguments += @('-F', "after=$cursor") }
        $response = Invoke-GhJson -Arguments $arguments
        $connection = $response.data.repository.pullRequest.reviewThreads
        foreach ($thread in @($connection.nodes)) {
            $comments = [System.Collections.Generic.List[object]]::new()
            foreach ($comment in @($thread.comments.nodes)) { if ($null -ne $comment) { $comments.Add($comment) } }
            $commentPage = $thread.comments.pageInfo
            while ($commentPage.hasNextPage) {
                $commentResponse = Invoke-GhJson -Arguments @('api', 'graphql', '-f', "query=$commentQuery", '-F', "threadId=$($thread.id)", '-F', "after=$($commentPage.endCursor)")
                $commentConnection = $commentResponse.data.node.comments
                foreach ($comment in @($commentConnection.nodes)) { if ($null -ne $comment) { $comments.Add($comment) } }
                $commentPage = $commentConnection.pageInfo
            }
            $uniqueComments = @(Select-UniqueEvidenceItems -Items @($comments) -EvidenceClass "review thread $($thread.id) comments" -KeyProperties @('id', 'databaseId'))
            $isOutdated = @($uniqueComments | Where-Object { $_.outdated }).Count -gt 0
            $resolvedBy = if ($null -ne $thread.resolvedBy) { $thread.resolvedBy.login } else { $null }
            $threadKey = Get-StableEvidenceKey -Item $thread -EvidenceClass 'review thread' -KeyProperties @('id')
            if (-not $threadIds.Add($threadKey)) { continue }
            $threads.Add([pscustomobject][ordered]@{
                id = $thread.id
                is_resolved = [bool]$thread.isResolved
                is_outdated = $isOutdated
                path = $thread.path
                line = $thread.line
                original_line = $thread.originalLine
                start_line = $thread.startLine
                diff_side = $thread.diffSide
                start_diff_side = $thread.startDiffSide
                viewer_can_reply = [bool]$thread.viewerCanReply
                viewer_can_resolve = [bool]$thread.viewerCanResolve
                viewer_can_unresolve = [bool]$thread.viewerCanUnresolve
                resolved_by = $resolvedBy
                comments = $uniqueComments
            })
        }
        $cursor = $connection.pageInfo.endCursor
        $hasNextPage = [bool]$connection.pageInfo.hasNextPage
    } while ($hasNextPage)
    return @($threads)
}

function Get-EvidenceFingerprint {
    param([Parameter(Mandatory)]$Snapshot)

    $checks = @($Snapshot.checks | ForEach-Object { [ordered]@{ id = Get-OptionalPropertyValue $_ 'id'; name = Get-OptionalPropertyValue $_ 'name'; status = Get-OptionalPropertyValue $_ 'status'; conclusion = Get-OptionalPropertyValue $_ 'conclusion'; completed_at = Get-OptionalPropertyValue $_ 'completed_at'; url = Get-OptionalPropertyValue $_ 'details_url' } } | Sort-Object id, name)
    $statuses = @($Snapshot.statuses | ForEach-Object { [ordered]@{ id = Get-OptionalPropertyValue $_ 'id'; context = Get-OptionalPropertyValue $_ 'context'; state = Get-OptionalPropertyValue $_ 'state'; updated_at = Get-OptionalPropertyValue $_ 'updated_at'; url = Get-OptionalPropertyValue $_ 'target_url' } } | Sort-Object id, context)
    $reviews = @($Snapshot.reviews | ForEach-Object { $user = Get-OptionalPropertyValue $_ 'user'; [ordered]@{ id = Get-OptionalPropertyValue $_ 'id'; state = Get-OptionalPropertyValue $_ 'state'; submitted_at = Get-OptionalPropertyValue $_ 'submitted_at'; author = Get-OptionalPropertyValue $user 'login'; body_hash = Get-StringHash (Get-OptionalPropertyValue $_ 'body') } } | Sort-Object id)
    $issueComments = @($Snapshot.issue_comments | ForEach-Object { $user = Get-OptionalPropertyValue $_ 'user'; [ordered]@{ id = Get-OptionalPropertyValue $_ 'id'; updated_at = Get-OptionalPropertyValue $_ 'updated_at'; author = Get-OptionalPropertyValue $user 'login'; body_hash = Get-StringHash (Get-OptionalPropertyValue $_ 'body') } } | Sort-Object id)
    $inlineComments = @($Snapshot.inline_comments | ForEach-Object { $user = Get-OptionalPropertyValue $_ 'user'; [ordered]@{ id = Get-OptionalPropertyValue $_ 'id'; updated_at = Get-OptionalPropertyValue $_ 'updated_at'; author = Get-OptionalPropertyValue $user 'login'; path = Get-OptionalPropertyValue $_ 'path'; line = Get-OptionalPropertyValue $_ 'line'; body_hash = Get-StringHash (Get-OptionalPropertyValue $_ 'body') } } | Sort-Object id)
    $threads = @($Snapshot.review_threads | ForEach-Object {
        [ordered]@{
            id = $_.id
            is_resolved = $_.is_resolved
            is_outdated = $_.is_outdated
            path = $_.path
            line = $_.line
            comments = @($_.comments | ForEach-Object { $author = Get-OptionalPropertyValue $_ 'author'; [ordered]@{ id = Get-OptionalPropertyValue $_ 'id'; updated_at = Get-OptionalPropertyValue $_ 'updatedAt'; author = Get-OptionalPropertyValue $author 'login'; outdated = Get-OptionalPropertyValue $_ 'outdated'; body_hash = Get-StringHash (Get-OptionalPropertyValue $_ 'body') } } | Sort-Object id)
        }
    } | Sort-Object id)
    $requests = @($Snapshot.review_requests | ForEach-Object { [ordered]@{ id = Get-OptionalPropertyValue $_ 'id'; login = Get-OptionalPropertyValue $_ 'login'; slug = Get-OptionalPropertyValue $_ 'slug'; type = Get-OptionalPropertyValue $_ 'type' } } | Sort-Object id, login, slug)
    $files = @($Snapshot.files | ForEach-Object { [ordered]@{ filename = Get-OptionalPropertyValue $_ 'filename'; previous_filename = Get-OptionalPropertyValue $_ 'previous_filename'; status = Get-OptionalPropertyValue $_ 'status'; sha = Get-OptionalPropertyValue $_ 'sha' } } | Sort-Object filename, previous_filename)
    $commits = @($Snapshot.commits | ForEach-Object { [ordered]@{ sha = Get-OptionalPropertyValue $_ 'sha' } } | Sort-Object sha)

    $projection = [ordered]@{
        base_oid = $Snapshot.base_oid
        head_oid = $Snapshot.head_oid
        updated_at = $Snapshot.pr_updated_at
        checks = $checks
        statuses = $statuses
        review_decision = $Snapshot.review_decision
        review_requests = $requests
        check_inventory = $Snapshot.inventory.checks
        review_request_inventory = $Snapshot.inventory.review_requests
        file_inventory = $Snapshot.inventory.files
        commit_inventory = $Snapshot.inventory.commits
        files = $files
        commits = $commits
        reviews = $reviews
        issue_comments = $issueComments
        inline_comments = $inlineComments
        review_threads = $threads
    }
    return Get-StringHash ($projection | ConvertTo-Json -Depth 30 -Compress)
}

function Get-Snapshot {
    param(
        [Parameter(Mandatory)][string]$Repository,
        [Parameter(Mandatory)][int]$Number
    )

    $parts = $Repository.Split('/', 2)
    $pr = Invoke-GhJson -Arguments @('api', "repos/$Repository/pulls/$Number")
    $fileInventory = Get-CappedRestArray -Endpoint "repos/$Repository/pulls/$Number/files" -ExpectedCount ([int]$pr.changed_files) -EndpointLimit 3000 -KeyProperties @('filename')
    $commitInventory = Get-CappedRestArray -Endpoint "repos/$Repository/pulls/$Number/commits" -ExpectedCount ([int]$pr.commits) -EndpointLimit 250 -KeyProperties @('sha')
    $files = @($fileInventory.items)
    $commits = @($commitInventory.items)
    $reviews = Get-RestArray -Endpoint "repos/$Repository/pulls/$Number/reviews" -KeyProperties @('id', 'node_id')
    $inlineComments = Get-RestArray -Endpoint "repos/$Repository/pulls/$Number/comments" -KeyProperties @('id', 'node_id')
    $issueComments = Get-RestArray -Endpoint "repos/$Repository/issues/$Number/comments" -KeyProperties @('id', 'node_id')
    $checkInventory = Get-CountedRestArray -Endpoint "repos/$Repository/commits/$($pr.head.sha)/check-runs?filter=all" -Property 'check_runs' -KeyProperties @('id', 'node_id')
    $checks = @($checkInventory.items)
    $statuses = Get-RestArray -Endpoint "repos/$Repository/statuses/$($pr.head.sha)" -KeyProperties @('id', 'node_id')
    $reviewRequestInventory = Get-RequestedReviewers -Endpoint "repos/$Repository/pulls/$Number/requested_reviewers"
    $reviewRequests = @($reviewRequestInventory.items)
    $reviewState = Invoke-GhJson -Arguments @('pr', 'view', "$Number", '--repo', $Repository, '--json', 'reviewDecision')
    $threads = Get-ReviewThreads -Owner $parts[0] -Name $parts[1] -Number $Number

    $snapshot = [pscustomobject][ordered]@{
        repository = $Repository
        pull_request = $Number
        url = $pr.html_url
        state = $pr.state
        is_draft = [bool]$pr.draft
        author = $pr.user.login
        base_ref = $pr.base.ref
        base_oid = $pr.base.sha
        head_ref = $pr.head.ref
        head_oid = $pr.head.sha
        pr_updated_at = $pr.updated_at
        review_decision = $reviewState.reviewDecision
        review_requests = $reviewRequests
        checks = $checks
        statuses = $statuses
        files = $files
        commits = $commits
        reviews = $reviews
        issue_comments = $issueComments
        inline_comments = $inlineComments
        review_threads = $threads
        inventory = [pscustomobject][ordered]@{
            checks = [pscustomobject][ordered]@{
                expected_count = $checkInventory.expected_count
                collected_count = $checkInventory.collected_count
                page_count = $checkInventory.page_count
                complete = $checkInventory.complete
            }
            review_requests = [pscustomobject][ordered]@{
                user_count = $reviewRequestInventory.user_count
                team_count = $reviewRequestInventory.team_count
                page_count = $reviewRequestInventory.page_count
                complete = $reviewRequestInventory.complete
            }
            files = [pscustomobject][ordered]@{
                expected_count = $fileInventory.expected_count
                collected_count = $fileInventory.collected_count
                endpoint_limit = $fileInventory.endpoint_limit
                complete = $fileInventory.complete
            }
            commits = [pscustomobject][ordered]@{
                expected_count = $commitInventory.expected_count
                collected_count = $commitInventory.collected_count
                endpoint_limit = $commitInventory.endpoint_limit
                complete = $commitInventory.complete
            }
        }
    }
    $snapshot | Add-Member -NotePropertyName fingerprint -NotePropertyValue (Get-EvidenceFingerprint -Snapshot $snapshot)
    return $snapshot
}

function Invoke-AzureWorkflowPullRequestEvidence {
    $phase = 'invocation'
    try {
    $resolvedRepository = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $RepositoryPath).Path)
    $gitRootOutput = & git -C $resolvedRepository rev-parse --show-toplevel 2>&1
    if ($LASTEXITCODE -ne 0) { throw "Not a Git repository: $($gitRootOutput -join [Environment]::NewLine)" }
    $gitRoot = [System.IO.Path]::GetFullPath(($gitRootOutput -join '').Trim())
    if ($null -eq (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'GitHub CLI (gh) is required.' }

    Push-Location -LiteralPath $gitRoot
    try {
        $repoOutput = & gh repo view --json nameWithOwner --jq .nameWithOwner 2>&1
        $repoExitCode = $LASTEXITCODE
    }
    finally { Pop-Location }
    if ($repoExitCode -ne 0) { throw "Could not resolve GitHub repository: $($repoOutput -join [Environment]::NewLine)" }
    $repository = ($repoOutput -join '').Trim()

    $phase = 'evidence'
    $startedAt = [DateTime]::UtcNow.ToString('o')
    $first = Get-Snapshot -Repository $repository -Number $PullRequest
    $second = Get-Snapshot -Repository $repository -Number $PullRequest
    $completedAt = [DateTime]::UtcNow.ToString('o')

    $stableHead = $first.base_oid -eq $second.base_oid -and $first.head_oid -eq $second.head_oid -and $first.pr_updated_at -eq $second.pr_updated_at
    $stableEvidence = $first.fingerprint -eq $second.fingerprint
    $paginationComplete = [bool]$first.inventory.files.complete -and [bool]$first.inventory.commits.complete -and [bool]$first.inventory.checks.complete -and [bool]$first.inventory.review_requests.complete -and [bool]$second.inventory.files.complete -and [bool]$second.inventory.commits.complete -and [bool]$second.inventory.checks.complete -and [bool]$second.inventory.review_requests.complete
    $errors = [System.Collections.Generic.List[string]]::new()
    if (-not $stableHead) { $errors.Add('pull_request_changed_during_collection') }
    if (-not $stableEvidence) { $errors.Add('pull_request_evidence_changed_during_collection') }
    if (-not [bool]$second.inventory.commits.complete) { $errors.Add("commit_inventory_incomplete:$($second.inventory.commits.collected_count)/$($second.inventory.commits.expected_count)") }
    if (-not [bool]$second.inventory.files.complete) { $errors.Add("file_inventory_incomplete:$($second.inventory.files.collected_count)/$($second.inventory.files.expected_count)") }
    if (-not [bool]$second.inventory.checks.complete) { $errors.Add("check_inventory_incomplete:$($second.inventory.checks.collected_count)/$($second.inventory.checks.expected_count)") }
    if (-not [bool]$second.inventory.review_requests.complete) { $errors.Add('review_request_inventory_incomplete') }

    $baseObject = & git -C $gitRoot cat-file -e "$($second.base_oid)^{commit}" 2>$null
    $baseAvailable = $LASTEXITCODE -eq 0
    $headObject = & git -C $gitRoot cat-file -e "$($second.head_oid)^{commit}" 2>$null
    $headAvailable = $LASTEXITCODE -eq 0
    if (-not $baseAvailable) { $errors.Add('base_commit_object_missing_locally') }
    if (-not $headAvailable) { $errors.Add('head_commit_object_missing_locally') }

    $result = [ordered]@{
        valid = $errors.Count -eq 0
        repository = $repository
        pull_request = $PullRequest
        url = $second.url
        state = $second.state
        is_draft = $second.is_draft
        author = $second.author
        base_ref = $second.base_ref
        base_oid = $second.base_oid
        head_ref = $second.head_ref
        head_oid = $second.head_oid
        head_stable = $stableHead
        snapshot_started_at = $startedAt
        snapshot_completed_at = $completedAt
        pr_updated_at = $second.pr_updated_at
        snapshot_fingerprint = $second.fingerprint
        feedback_stable = $stableEvidence
        checks_stable = $stableEvidence
        review_decision = $second.review_decision
        review_requests = @($second.review_requests)
        checks = @($second.checks)
        statuses = @($second.statuses)
        files = @($second.files)
        commits = @($second.commits)
        reviews = @($second.reviews)
        issue_comments = @($second.issue_comments)
        inline_comments = @($second.inline_comments)
        review_threads = @($second.review_threads)
        inventory = $second.inventory
        counts = [ordered]@{
            files = @($second.files).Count
            commits = @($second.commits).Count
            checks = @($second.checks).Count + @($second.statuses).Count
            reviews = @($second.reviews).Count
            issue_comments = @($second.issue_comments).Count
            inline_comments = @($second.inline_comments).Count
            review_threads = @($second.review_threads).Count
        }
        pagination_complete = $paginationComplete
        local_objects_available = $baseAvailable -and $headAvailable
        errors = @($errors)
        warnings = @()
    }
    if ($Json) { $result | ConvertTo-Json -Depth 100 -Compress } else { $result | ConvertTo-Json -Depth 100 }
    if ($errors.Count -gt 0) { exit 1 }
    exit 0
    }
    catch {
    $result = [ordered]@{
        valid = $false
        pull_request = $PullRequest
        errors = @($_.Exception.Message)
        warnings = @()
    }
    if ($Json) { $result | ConvertTo-Json -Depth 8 -Compress } else { $result | ConvertTo-Json -Depth 8 }
    if ($phase -eq 'evidence') { exit 1 }
    exit 2
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-AzureWorkflowPullRequestEvidence
}
