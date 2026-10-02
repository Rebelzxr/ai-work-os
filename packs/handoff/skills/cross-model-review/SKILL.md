---
name: cross-model-review
description: "Give a different model only an artifact and its evidence for a read-only PASS or FIX review."
---

# Cross-model review

Ask a different model to review an artifact without giving it the producer's chat history. The reviewer receives the artifact, the relevant evidence and the acceptance criteria, then returns a reasoned `PASS` or `FIX`. The producer never approves its own work.

## Read first

- Read the core [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) skill in the default `aiwos-core` pack. This dependency is not optional in the default setup.
- Read the packet or brief that defines the artifact's acceptance criteria.
- Read [docs/multi-agent.md](../../../../docs/multi-agent.md) for the one-writer and privacy rules.

## Review packet

Prepare a small review packet containing:

- the exact artifact path or a cleaned copy;
- the acceptance criteria and the source paths needed to judge them;
- fresh test commands and their raw result lines;
- known limits or unresolved questions;
- the instruction that the reviewer is read-only and must not alter the workspace.

Do not include private history, secrets, tokens, unrelated files or the producer's explanation of why the result should pass.

## Reviewer prompt

Use this shape with a model that is different from the producer:

```text
You are a read-only reviewer. Judge the supplied artifact against the supplied acceptance criteria and evidence. Do not edit files and do not infer missing proof.

Return exactly:
VERDICT: PASS or FIX
REASONS: [numbered reasons tied to the criteria]
EVIDENCE CHECK: [what the supplied output proves and what it does not]
FIXES: [specific changes, or NONE]
NEXT CHECK: [one command or inspection]
```

## Procedure

1. Confirm that the reviewer is a different model or provider from the producer.
2. Give it the review packet only, using an approved local route. Do not give it write access.
3. Read the returned reasons and compare them with the artifact yourself.
4. Treat `FIX` as a blocked handoff until the named issue is repaired and checked. Treat `PASS` as a review result, not as permission for an external action.
5. Save the review result beside the job evidence without overwriting the producer's receipt.

## Return shape

Return the review packet path, reviewer identity as a model label only, verdict, reasons, evidence gap and next check. Do not reveal private prompts or credentials.

## Human approval

A person approves the choice of reviewer and where the review packet is provided. A review never grants permission to send, post, publish, deploy, pay or delete.

## Shared foundation

Use the core [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) and [job-packet](../../../core/skills/job-packet/SKILL.md) skills in the default `aiwos-core` pack for proof language and acceptance criteria. These dependencies are not optional in the default setup; this skill adds the independent, read-only review boundary.
