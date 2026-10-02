# Quality gate — copy-paste edition

## What to give it

- The actual deliverable file or folder.
- The approved scope version and acceptance criteria.
- The source list, source dates and permission notes.
- The production unresolved list and correction limit.

## The prompt

```text
Review the actual deliverable independently from its production note.

Return exactly one first-line status: PASS, REVISE or BLOCKED. Use PASS only when every acceptance criterion is met and important claims have evidence. Use REVISE for a precise, fixable criterion or presentation problem. Use BLOCKED when a required source, permission, scope decision or approval is missing, or when evidence conflicts.

Then provide: artifact/version checked; an evidence table with met, not met or cannot check for every criterion; scope and source notes; permission notes; failed or uncheckable items; the smallest next action; and the owner decision still needed. Open the actual artifact. Do not edit it, invent evidence, or treat the status as permission for an outside action. Begin with “Practice, not for use” for invented examples.
```

## What you get back

- PASS, REVISE or BLOCKED as the first line.
- Evidence for every acceptance criterion.
- Scope, source and permission findings.
- A precise next action and any owner decision.

## Check before you use it

Confirm that the reviewer opened the actual artifact, that every criterion has evidence, and that a missing approval is BLOCKED rather than quietly assumed. The owner decides what happens after the gate.

## Next job

Return to `deliverable-production` in the default `aiwos-delivery` pack for REVISE, obtain the missing input for BLOCKED, or prepare the owner review for PASS.
