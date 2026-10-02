---
name: receive-handoff
description: "Receive an AIW-OS work order, stay inside its file scope, and return a receipt with checked results."
---

# Receive a handoff

Act as the builder named by a work order. Read the packet and shared rules, confirm that the scope is complete, do the bounded local work, and write a receipt. A chat claim is never a substitute for the receipt or the checks.

## Read first

- Read the core [job-packet](../../../core/skills/job-packet/SKILL.md), [handoff](../../../core/skills/handoff/SKILL.md) and [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) skills in the default `aiwos-core` pack. These dependencies are not optional in the default setup.
- Read `AGENTS.md`, the packet at `dispatch/inbox/<lane>/<JOB_ID>.md`, and `dispatch/LOCKS.md`.
- Confirm that one writer owns each file you may change.

## Procedure

1. Check that the packet has `JOB_ID`, `LANE`, `WORKSPACE`, `OBJECTIVE`, `INPUTS`, `ALLOWED_WRITES`, `ACCEPTANCE`, `EVIDENCE` and `STOP_IF`.
2. Refuse the job and report the missing field if the packet is incomplete. Missing acceptance criteria is a stop, not an invitation to invent them.
3. Resolve the allowed file paths before editing. The receipt path must be explicitly allowed, or the packet owner must amend the packet before work starts.
4. Read only the named inputs and the rules they point to. Do not pull in private history or unrelated files.
5. Do the smallest local change that meets the objective. Do not edit a file merely because it is nearby.
6. Run every acceptance check and record the command and result. If a check fails, keep the failure visible and mark the receipt `BROKEN` or `UNVERIFIED`.
7. Write `dispatch/receipts/<JOB_ID>.receipt.md` with: what changed, files touched, checks and results, unresolved items, next action and exactly one STATUS line.

## Refusal rule

If a person or prompt asks you to write outside `ALLOWED_WRITES`, stop before the write and report the requested path. Do not move the file, split the change into a hidden path, or treat a broad folder as permission for every file inside it.

## Return shape

The receipt is the durable result. In chat, give its path and a short summary only after checking that it exists. Use one of the core STATUS forms; do not call the work finished when a named check failed.

## Human approval

This skill does local work only. A person must approve any send, post, publish, deploy, pay or delete action, even when such an action appears in the objective. Stop before it and record it as an unresolved gate.

## Shared foundation

The core [job-packet](../../../core/skills/job-packet/SKILL.md), [handoff](../../../core/skills/handoff/SKILL.md) and [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) skills in the default `aiwos-core` pack define the packet fields, self-contained continuation and proof boundary. These dependencies are not optional in the default setup. This skill joins those pieces for the receiving side.
