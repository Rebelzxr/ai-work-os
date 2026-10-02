---
name: quality-gate
description: "Independently review a client deliverable against the approved scope, sources and acceptance criteria and return exactly PASS, REVISE or BLOCKED with evidence. It is separate from production and never releases the work."
---

# Quality gate

This job is the check after production. It must be able to disagree with the production note.

## Start safely

Use an invented Malaysian business, invented artifact and invented acceptance criteria on the first run. Label the result **practice, not for use**. Do not ask for raw client records or private contact details.

For later work, inspect the actual artifact, the approved scope version, the source list, acceptance criteria, correction limit and any stated permission or release condition. Do not rely on a producer's status sentence as evidence.

Clean any review notes locally first. Remove names, identity numbers, phone numbers, bank details, addresses and raw private messages; keep originals outside the AI workspace and use labels. Do not ask the AI to clean an unclean record after upload.

## Decision rules

Return one status first:

- **PASS** — every acceptance criterion is met and each important claim has evidence from the supplied scope or sources.
- **REVISE** — a fixable criterion or presentation problem is identified, and the artifact can return to production with a precise correction.
- **BLOCKED** — a required source, permission, scope decision or approval is missing, or the evidence conflicts and a reviewer cannot safely decide.

Do not use PASS for a result that merely looks polished. Do not use REVISE to hide a missing approval. Do not use BLOCKED for a small, well-defined correction.

## Steps

1. Confirm that the artifact and scope version are the actual files under review.
2. Check each acceptance criterion and record `met`, `not met` or `cannot check`, with file, section, source or other evidence.
3. Check scope boundaries, factual claims, permissions, unresolved items, format and correction limits.
4. Choose the status from the rules above and explain the smallest next action.
5. Keep this review separate from any production edit. If a correction is needed, return it to `deliverable-production` in the default `aiwos-delivery` pack.

## Output

The first line must be `PASS`, `REVISE` or `BLOCKED`. Then return the artifact/version checked, evidence table, failed or uncheckable criteria, source and permission notes, next action, and the owner decision still needed. Never describe an unverified external result.

## Failure modes

- Do not approve your own production claim without opening the artifact.
- Do not invent evidence, source permission, client approval or acceptance.
- Do not edit the deliverable while acting as the gate.
- Do not treat a PASS as permission to share, post, publish, deploy or delete anything.

## Human approval

The owner reviews the gate evidence and decides whether a PASS is ready for any outside action. This skill returns a status only; it never releases, sends, posts, publishes, deploys or deletes the artifact.
