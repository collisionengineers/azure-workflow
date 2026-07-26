# Translator and educator workflow placement

Decision date: 2026-07-26

## User need

The plugin must support standalone requests such as:

- “How does this feature actually work?”
- “What does this architecture term mean here?”
- “Explain this pull-request comment in plain English.”
- “What is this reviewer asking me to change, and why?”
- “What does this failing check mean for the product?”
- “What is implemented now versus only planned?”

The intended endpoint is understanding. It is not automatically a plan, implementation, correctness verdict, GitHub response, or documentation change.

## Placement alternatives

| Option | Benefit | Failure | Decision |
| --- | --- | --- | --- |
| Global plain-language rule only | Improves every agent response without another skill | Does not define evidence collection, current/intended separation, PR-thread handling, or a read-only stop | Keep as supporting style rule, not the whole workflow |
| Put it inside PR review | Reuses PR evidence | Feature/architecture explanations do not require a PR; translating one comment would trigger an unnecessary full review verdict | Reject |
| Put it inside planning | Planning already interviews and explains decisions | “Help me understand” would imply a change record, decision-making, and possibly a plan PR | Reject |
| Duplicate an explanation section in every skill | Each workflow can explain its own work | Rules drift, activation remains unclear, and a standalone explanation still has no owner | Reject |
| Add `explain-repository` | One clear trigger, read-only boundary, evidence contract, and handoff to other goals | Adds one skill to the package | Select |

## Public-skill test

| Test | Result |
| --- | --- |
| Standalone user outcome | Yes. A user can ask to understand a feature, term, failure, PR, or review comment and want nothing changed. |
| Distinct authorization/stopping boundary | Yes. Repository/Git/GitHub/official-source reads are allowed; tracked files, comments, issue state, PR state, Azure state, and code are not changed. The workflow stops after the explanation. |
| Distinct success criterion | Yes. The result is an accurate, plain-language, evidence-linked explanation that distinguishes current, intended, proposed, and unknown facts—not a plan, patch, or review verdict. |

The skill count becomes six. This is not symmetry-driven expansion: explanation is an observed standalone request that otherwise falls between planning and review.

## Exact boundary between neighboring skills

| User request | Route | Reason |
| --- | --- | --- |
| “What does this review comment mean?” | `explain-repository` | Understanding only |
| “Is this review comment technically correct?” | `review-repository-pull-request` | Requires an independent correctness verdict |
| “Fix/address this review comment” | `deliver-azure-repository-change` | Authorizes repository and GitHub remediation |
| “Plan how we should address this” | `plan-azure-repository-change` | Decision-complete plan endpoint |
| “How does feature X work today?” | `explain-repository` | Current behavior explanation |
| “Design/change feature X” | Plan or deliver | Changes intended or implemented behavior |
| “Why is the live Azure resource behaving this way?” | `operate-azure-repository` | Outcome depends on current external state |
| “What does this Azure/.NET concept or Microsoft recommendation mean?” | `explain-repository`, with the Learn guidance gate | Educational endpoint using current official evidence when material |
| “Write this explanation into repository documentation” | `deliver-azure-repository-change` | Persistent repository mutation |

Existing skills still explain their own decisions in plain language. They do not invoke `explain-repository` for routine communication. The public skill activates when explanation itself is the requested endpoint.

## Exact package shape

```text
skills/explain-repository/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
`-- references/
    |-- code-and-system-explanation.md
    `-- github-feedback-explanation.md
```

There is no skill-local `scripts/` or `assets/` folder and no new MCP, hook, app, database, state file, template, or generated explainer document.

The skill may conditionally load the existing plugin-root `references/dotnet-projects.md`. It uses repository-native reads and `git`/`gh` for evidence. Microsoft Learn is called only under the central current-guidance gate. If actual Azure state is necessary, the request routes to the read-only path of `operate-azure-repository`; explanation does not bypass Azure scope resolution.

## Explanation modes

```text
request to understand
        |
        +--> feature/code/data flow ------> trace real entry point and callers
        |
        +--> architecture/term -----------> define it in repository context
        |
        +--> PR/comment/check ------------> retrieve exact item and surrounding evidence
        |
        `--> current vs intended ---------> separate code, product authority, plan, and guidance
```

These are modes inside one goal, not separate skills. Their authorization and endpoint are identical.

## Plain-language contract

An explanation:

1. Starts with the direct answer in ordinary language.
2. States what the user or operator experiences before implementation detail.
3. Uses the minimum technical detail needed to remain accurate and defines unavoidable terms on first use.
4. Uses a small ASCII flow when three or more stages or owners would otherwise be hard to follow.
5. Distinguishes:
   - **current:** proven by code/configuration/callers/tests or observed external state;
   - **intended:** stated by current product/operator authority;
   - **proposed:** present only in an open plan/PR/comment;
   - **external guidance:** current official platform evidence; and
   - **unknown:** not established by available evidence.
6. Explains why the matter affects behavior, cost, risk, maintainability, or user experience.
7. Links the smallest decisive evidence rather than dumping files or reproducing documentation.
8. States the next decision/action only when one genuinely exists. It does not manufacture a task to make the answer look actionable.

Analogies may support an explanation but never replace the real mechanism. “Simple” must not mean materially incomplete, patronizing, or falsely certain.

## PR and review-comment translation

For one GitHub comment or review thread, the skill retrieves:

- the exact PR and comment/thread identity;
- the relevant diff hunk and current file context;
- preceding/following thread replies and resolution/outdated state;
- the linked request/change record only when needed to interpret intent; and
- current check evidence only when the comment concerns a check.

It then separates:

```text
what the reviewer literally observed
             |
what can go wrong in product terms
             |
what outcome the reviewer is requesting
             |
whether the request is mandatory, optional, ambiguous, or scope-expanding
             |
what evidence would show it is resolved
```

Classification explains the request; it is not a substitute for the review skill's independent technical verdict. If the user asks whether the comment is right, route to review.

## Persistence decision

The default output exists only in the conversation. Automatically writing explainers into the repository would create another documentation surface and drift burden.

If the explanation exposes missing durable product, architecture, or operations truth, say which canonical document lacks it. Update that document only through an explicit delivery request. Do not create an `explainers/`, `education/`, `wiki/`, or generated FAQ directory by default.

## Acceptance implications

Fresh-thread scenarios must prove:

- feature explanation selects only `explain-repository` and makes no changes;
- an exact PR-comment explanation does not produce a full PR verdict;
- “is this comment correct?” selects review;
- “fix this comment” selects delivery;
- current/intended/proposed facts are visibly separated;
- a current Microsoft guidance question calls Learn and records compact official evidence;
- a repository-owned business-rule explanation does not call Learn ceremonially;
- a live-Azure-state question routes to operate rather than guessing from documentation;
- a request to persist the explanation routes to delivery; and
- no explainer document, GitHub comment, thread resolution, or other mutation occurs during explanation.
