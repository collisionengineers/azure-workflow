# Code and system explanation

## Evidence trace

Start from the user/operator trigger and follow the real call path through routing, policy/configuration owner, storage/external boundary, output, and failure/recovery. Read tests as examples/evidence, not automatic production truth. Use relative paths and relevant lines.

Classify statements as current, intended, proposed, or unknown. Explain divergences explicitly.

## Plain-language layers

1. Direct answer in one or two sentences.
2. Short cause-and-effect sequence.
3. Ownership: where rules/data/configuration live and why.
4. Failure/recovery and limitations.
5. Technical detail only as needed, defining terms once.
6. Evidence and one next action.

Use analogies sparingly and never instead of evidence. Avoid framework tours, acronym dumps, file-by-file narration, or pretending certainty. For architecture, focus on boundaries and flow. For failures, separate symptom, likely cause, proven cause, impact, and next evidence.

When orienting a non-coder, state what matters now versus later and present one manageable next step. Do not create persistent organizer artifacts.
