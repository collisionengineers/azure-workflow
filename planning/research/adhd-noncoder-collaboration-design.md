# ADHD and non-coder collaboration design

## User need

The workflow must work for a user who can understand architecture and technical consequences when they are explained, but does not write code, may arrive with an unstructured idea dump, and benefits from low cognitive load, explicit order, and one obvious next action.

The design should support that user without being patronizing, hiding important truth, or creating a second organization system.

## Skill admission decision

No seventh “organizer,” “ADHD,” or “project coach” skill is justified.

- “Explain this, orient me, and tell me the next sensible action” is a read-only understanding outcome with the same evidence and stopping boundary as `explain-repository`.
- “Turn this idea into a decision-complete plan” already belongs to planning.
- “Organize and persist repository/GitHub state” is a mutation owned by onboarding or delivery.
- “Judge whether this PR is correct” remains review.

Splitting these into another skill would introduce ambiguous triggers and force the user to understand plugin internals before asking for help. The plugin should absorb that organizational burden.

## Placement

| Need | Owner | Why it belongs there |
| --- | --- | --- |
| Plain-English feature/architecture/feedback explanation | `explain-repository` core and its two existing references | This is the skill's standalone read-only endpoint |
| “Where are we?” and “What should I do next?” orientation | `explain-repository` core | It synthesizes current repository/GitHub evidence without mutating or manufacturing work |
| Layered answer, recommendation first, optional depth, one question | `explain-repository` core | This should shape every explanation, not hide in an optional reference |
| One material question at a time and accepted decisions not re-asked | planning skill/workflow | Planning owns decision elicitation and `update_plan` state |
| Durable product/architecture/operations navigation | `README.md` and `docs/index.md` | These are stable human entry points; a skill response cannot replace repository navigation |
| Live order, dependencies, owner, status, release, and priority | GitHub Issue/Project/milestone | GitHub already owns live work and avoids a drifting `NEXT.md` or Markdown task board |
| Small Now set and no issue-per-idea flood | roadmap/capability/GitHub conversion rules | Organization requires controlling activation, not merely reformatting a giant list |
| One bounded implementation and concise handoff | delivery | Delivery owns execution state, PR evidence, and the next human action |
| Findings-first verdict plus one clear response | pull-request review | Review owns the verdict and can translate it into one next action without taking that action |
| Always-on communication behavior | generated root `AGENTS.md` | Every lifecycle skill should reduce decision burden even when explanation is not invoked |

## Explain-repository contract

The skill accepts read-only prompts such as:

- “I do not code—explain how this feature works.”
- “Where are we with this project?”
- “I am overwhelmed. What matters now?”
- “What should I do next, and why?”
- “Translate this review comment and tell me what decision I actually need to make.”

It returns the smallest useful layered answer:

```text
short answer / current position
          |
          v
one small map or sequence
          |
          v
what matters now + what can wait
          |
          v
one recommended next action and why
          |
          `--> one decision question only when evidence cannot select safely
```

The recommendation must derive from current authority, GitHub state, dependencies, risk, and the user's stated goal. It is not persisted, presented as a human decision, or expanded into a speculative backlog. If no action is required, say so directly.

Use technical terms when they are necessary, define them once, and put deeper mechanics after the plain-English result. Do not equate “non-coder” with lack of judgment. Preserve architecture, failure, security, cost, migration, and uncertainty consequences in understandable language.

No third explanation reference is added. Low-cognitive-load orientation is core behavior rather than a conditional specialist domain, and its detailed evidence routes already divide correctly between `code-and-system-explanation.md` and `github-feedback-explanation.md`. Another reference would split a small universal contract and increase the chance it is not loaded.

## Durable organization contract

```text
README.md ------------------------ human starting point
docs/index.md -------------------- where durable truth lives
docs/product + capabilities ------ complete intended scope
docs/roadmap.md ------------------ small Now/Next/Later outcomes
GitHub Project/Issues ------------ live order, blockers, owner, status
docs/changes/<one change>.md ------ current bounded plan/evidence
explain-repository --------------- current plain-English synthesis
```

Do not add `NEXT.md`, `TODO.md`, a generated daily dashboard, duplicate Markdown status tables, an “ADHD mode” state file, or a second priority field. Those artifacts initially feel helpful but drift and make the user decide which list to trust.

When asked what to do next, prefer:

1. finish or unblock the single current `In progress` change;
2. respond to an `In review` item when a human decision/action is actually waiting;
3. resolve a blocking Decision for an activated Now outcome; then

4. choose among unblocked `Ready` items already allocated to Now, using recorded priority, release/dependency order, and the user's stated outcome.

Do not auto-activate Triage, Next, Later, or unallocated ideas. If two candidates remain materially tied, recommend a default and ask one concrete choice.

## Workflow communication rules

Every owning workflow should:

- lead with the outcome/current position, not a tool diary;
- keep one `update_plan` step in progress and show a short `done / now / next / waiting` summary when useful;
- ask one blocking material question at a time, state why it matters, and recommend a default;
- accept settled answers and not repeatedly reopen them without new evidence;
- avoid asking the user to choose filenames, framework wiring, test mechanics, or other inspectable implementation details;
- distinguish “you need to decide” from “the agent can determine this”; and
- finish with one next human action, or explicitly say that the workflow is waiting/complete and no action is required.

This behavior is low-cognitive-load by default and can be made more detailed on request. It does not require the user to disclose or label ADHD.

## Acceptance consequences

- Fresh-thread explanation tests cover non-coder feature explanation, broad project orientation, review-comment translation, and one next-action recommendation.
- Broad idea dumps route to planning, which organizes them before asking one material question rather than emitting a questionnaire or giant plan.
- Onboarding produces one obvious README/docs route and a small human-confirmed activated work set.
- Delivery reports done/current/next/waiting plainly and never makes the user infer the next action from raw CI/PR output.
- No new skill, state store, `NEXT.md`, dashboard generator, Project field, hook, or reference is added.
