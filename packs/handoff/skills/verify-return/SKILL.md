---
name: verify-return
description: "Check a returned handoff against actual files and fresh test output before accepting its status."
---

# Verify a returned handoff

Act as the sender after another tool reports a result. Inspect the current workspace, the receipt and the packet. Re-run material checks yourself and accept only what the files and output support.

## Read first

- Read the core [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) skill in the default `aiwos-core` pack. This dependency is not optional in the default setup.
- Read the original packet, the returned receipt and `dispatch/LOCKS.md`.
- Read the shared `AGENTS.md` and the exact acceptance paths named by the packet.

## Procedure

1. Confirm that the receipt has the same `JOB_ID` as the packet and names the exact files changed.
2. Inspect `git status --short` or the workspace's equivalent file listing. Compare every changed path with `ALLOWED_WRITES`; an unlisted change is a failure even if the requested file looks correct.
3. Open the changed files and compare them with the objective and source inputs. Do not accept the other tool's summary as evidence.
4. Re-run each material test or check from the packet. Read the exit code and the relevant result lines. A green test from an older version does not count.
5. Check failure paths named in `STOP_IF`, including missing inputs, unclear facts and a request outside scope.
6. Return one of: `VERIFIED` when the packet and evidence agree, `UNVERIFIED` when proof is missing, or `BROKEN` when the result contradicts acceptance.
7. Record the verification result in the sender's normal job record or receipt location. Do not rewrite the builder's receipt to hide a failure.

## What does not count

- A “done” message without a receipt.
- A receipt that says a test passed when a fresh run fails.
- A changed file with no matching acceptance check.
- A successful local check presented as a live release.

## Return shape

Return the paths inspected, commands rerun, result lines, differences found, any remaining gate and one honest STATUS line. Include a clear next action for `UNVERIFIED` or `BROKEN`.

## Human approval

Verification does not approve a send, post, publish, deploy, pay or delete action. A person keeps that decision even when every local test is green.

## Shared foundation

Use the core [evidence-loop](../../../core/skills/evidence-loop/SKILL.md) and [job-packet](../../../core/skills/job-packet/SKILL.md) skills in the default `aiwos-core` pack for the proof claim and allowed scope. These dependencies are not optional in the default setup; this skill adds the sender-side comparison.
